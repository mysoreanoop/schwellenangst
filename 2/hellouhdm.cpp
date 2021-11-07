#include <functional>
#include <iostream>

#include "surelog.h"

// UHDM
#include <uhdm/ElaboratorListener.h>
#include <uhdm/uhdm.h>
#include <uhdm/vpi_listener.h>

std::string visitref_obj(vpiHandle h) {
	std::string result = vpi_get_str(vpiFullName, h);
	return result;
}

std::string visitpart_sel(vpiHandle h) {
	std::string result = "";
  result += "\t\t";
	vpiHandle par = vpi_handle(vpiParent, h);
	//result += vpi_get_str(vpiFullName, h);
	result += vpi_get_str(vpiFullName, par);
  result += " (";
	vpiHandle lrh = vpi_handle(vpiLeftRange, h);
	//result += "  " +  std::to_string((((const uhdm_handle *)lrh)->type));
	if(((const uhdm_handle *)lrh)->type == UHDM::uhdmoperation) {
		//TODO if width_p is part of range -- tehn it has to be evaluated as expression/operation
	} else if (((const uhdm_handle *)lrh)->type == UHDM::uhdmconstant) {
		s_vpi_value value;
  	vpi_get_value(lrh, &value);
  	if (value.format) {
  	  std::string val = std::to_string(value.value.integer);
  	  result += val;
		} else result += "Format not set!";
	}
	result += ",";
	vpiHandle rrh = vpi_handle(vpiRightRange, h);
	//result += "  " +  std::to_string((((const uhdm_handle *)rrh)->type));
	if(((const uhdm_handle *)rrh)->type == UHDM::uhdmoperation) {
		//TODO if width_p is part of range -- tehn it has to be evaluated as expression/operation
	} else if (((const uhdm_handle *)rrh)->type == UHDM::uhdmconstant) {
		s_vpi_value value;
  	vpi_get_value(rrh, &value);
  	if (value.format) {
  	  std::string val = std::to_string(value.value.integer);
  	  result += val;
		} else result += "Format not set!";
	}
  result += ")";
	vpi_release_handle(rrh);
	vpi_release_handle(lrh);
	return result;
}

std::string visitTernary(vpiHandle h) {
	std::string _result = "";
	_result += "\n\tAM: Ternary operator recognized:\n";
  vpiHandle opi = vpi_iterate(vpiOperand, h);
	int k = 0;
	while (vpiHandle aa = vpi_scan(opi)) {
		_result += "\t\tObject type: ";// (operation/part_select/constant)
		switch(((const uhdm_handle *)aa)->type) {
			case UHDM::uhdmoperation :
			{
				const int n = vpi_get(vpiOpType, aa);
				if(n == 32) {
					_result += "Another Ternary Operation\n";
					_result += visitTernary(aa);
				} else {
					_result += "Some operation with:\n\t\t\t"; //just print it
					vpiHandle sopi = vpi_iterate(vpiOperand, aa);
					while(vpiHandle soph = vpi_scan(sopi)) {
						if(((const uhdm_handle *)aa)->type == UHDM::uhdmpart_select) 
							visitpart_sel(aa);
						else visitref_obj(aa);
						_result += ", ";
					}
					_result += "\n";
				}
				break;
			}
			case UHDM::uhdmref_obj : //just print it
				_result += "Ref_obj ";
				_result += std::string(vpi_get_str(vpiFullName, aa));
				_result += "\n";
				break;
			case UHDM::uhdmpart_select : //fetch the ref_obj and print
				_result += "Part_sel\n";
				_result += visitpart_sel(aa);
				break;
			case UHDM::uhdmconstant : //unlikely to be first element
			{
				_result += "Constant\n";
				//const int c = vpi_get(vpiConstType, aa);
				//_result += std::to_string(c);
				//s_vpi_value value;
  			//vpi_get_value(aa, &value);
  			//if (value.format) {
  			//  std::string val = std::to_string(value.value.scalar); //TODO can be integer also
  			//  _result += val;
				//}
				break;
			}
			default: break;
		}
				
		_result += "\n";
		vpi_release_handle(aa);
	}
	return _result;
}

int main(int argc, const char** argv) {
  // Read command line, compile a design, use -parse argument
  unsigned int code = 0;
  SURELOG::SymbolTable* symbolTable = new SURELOG::SymbolTable();
  SURELOG::ErrorContainer* errors = new SURELOG::ErrorContainer(symbolTable);
  SURELOG::CommandLineParser* clp =
      new SURELOG::CommandLineParser(errors, symbolTable, false, false);
  clp->noPython();
  clp->setParse(true);
  clp->setwritePpOutput(true);
  clp->setCompile(true);
  clp->setElaborate(true);  // Request Surelog instance tree Elaboration
  // clp->setElabUhdm(true);  // Request UHDM Uniquification/Elaboration
  bool success = clp->parseCommandLine(argc, argv);
  errors->printMessages(clp->muteStdout());
  vpiHandle the_design = 0;
  SURELOG::scompiler* compiler = nullptr;
  if (success && (!clp->help())) {
    compiler = SURELOG::start_compiler(clp);
    the_design = SURELOG::get_uhdm_design(compiler);
    auto stats = errors->getErrorStats();
    code = (!success) | stats.nbFatal | stats.nbSyntax | stats.nbError;
  }

  std::string result;

  // If UHDM is not already elaborated/uniquified (uhdm db was saved by a
  // different process pre-elaboration), then optionally elaborate it:
  if (the_design && (!vpi_get(vpiElaborated, the_design))) {
    std::cout << "UHDM Elaboration...\n";
    UHDM::Serializer serializer;
    UHDM::ElaboratorListener* listener =
        new UHDM::ElaboratorListener(&serializer, true);
    listen_designs({the_design}, listener);
  }

  // Browse the UHDM Data Model using the IEEE VPI API.
  // See third_party/Verilog_Object_Model.pdf

  // Either use the
  // - C IEEE API, (See third_party/UHDM/tests/test_helper.h)
  // - or C++ UHDM API (See third_party/UHDM/headers/*.h)
  // - Listener design pattern (See third_party/UHDM/tests/test_listener.cpp)
  // - Walker design pattern (See third_party/UHDM/src/vpi_visitor.cpp)

  if (the_design) {
    UHDM::design* udesign = nullptr;
    if (vpi_get(vpiType, the_design) == vpiDesign) {
      // C++ top handle from which the entire design can be traversed using the
      // C++ API
      udesign = UhdmDesignFromVpiHandle(the_design);
      result += "Design name (C++): " + udesign->VpiName() + "\n";
    }
    // Example demonstrating the classic VPI API traversal of the folded model
    // of the design Flat non-elaborated module/interface/packages/classes list
    // contains ports/nets/statements (No ranges or sizes here, see elaborated
    // section below)
    result +=
        "Design name (VPI): " + std::string(vpi_get_str(vpiName, the_design)) +
        "\n";
    // Flat Module list:
    result += "Module List:\n";

    vpiHandle mi = vpi_iterate(UHDM::uhdmallModules, the_design);
		while(vpiHandle mh = vpi_scan(mi)) {
			result += "AM: In topmodules -> ";
      std::string defName;
      std::string objectName;
      if (const char* s = vpi_get_str(vpiDefName, mh)) {
        defName = s;
      }
      if (const char* s = vpi_get_str(vpiName, mh)) { 
        if (!defName.empty()) {
          defName += " ";
        }
        objectName = std::string("(") + s + std::string(")");
			}
			result += defName;
			result += objectName;
			result += "\n";

			//Nets:
			if(vpiHandle ni = vpi_iterate(vpiNet, mh)) {
				vpiHandle nh;
				while ((nh = vpi_scan(ni)) != NULL) {
					result += "\tAM: In net -> ";
					int nht = vpi_get(vpiNetType, nh);
					const char *reg = (vpi_get(vpiNetType, nh) == 48 )  ? "Reg  " : "Wire ";
					result += reg;
					result += vpi_get_str(vpiFullName, nh);
					result += "\n";
					vpiHandle ri;
					if(ri = vpi_iterate(vpiRange, nh)) {
    				while (vpiHandle rh = vpi_scan(ri) ) {
      				result += "\t\tAM: Range ";
							vpiHandle lrh = vpi_handle(vpiLeftRange, rh);
							s_vpi_value value;
          	  vpi_get_value(lrh, &value);
          	  if (value.format) {
          	    std::string val = std::to_string(value.value.integer);
          	    result += val;
							} else result += "AM: Range value not found!!!\n";
							result += " ";
							vpiHandle rrh = vpi_handle(vpiRightRange, rh);
          	  vpi_get_value(rrh, &value);
          	  if (value.format) {
          	    std::string val = std::to_string(value.value.integer);
          	    result += val;
							} else result += "AM: Range value not found!!!\n";
							result += "\n";
							vpi_release_handle(rh);
							vpi_release_handle(lrh);
							vpi_release_handle(rrh);
    				}
					} else result += "\t\tAM: Bit\n";
					vpi_release_handle(nh);
				}
				result += "\tAM: No more nets found\n";
			} else result += "AM: nets not found\n";

		//	//ContAssigns:
    //  vpiHandle ai = vpi_iterate(vpiContAssign, mh);
    //  while (vpiHandle ah = vpi_scan(ai)) {
    //    result += "AM: In assign -> " +
    //              std::string(vpi_get_str(vpiFile, ah)) +
    //              ", line:" + std::to_string(vpi_get(vpiLineNo, ah)) + "\n";
		//		//RHS
    //    if(vpiHandle rhs = vpi_handle(vpiRhs, ah)) { 
		//			//Expression
		//			const int n = vpi_get(vpiOpType, rhs);
    //    	if (n == 32) {
		//				result += visitTernary(rhs);
		//				result += "\n";
		//			}
    //    }
		//		vpi_release_handle(ah);
    //  }

			//ProcessStmts:
			vpiHandle pi = vpi_iterate(vpiProcess, mh);
			vpi_release_handle(mh);
		}


		//uhdmallModules
//    vpiHandle modItr = vpi_iterate(UHDM::uhdmallModules, the_design);
//    while (vpiHandle obj_h = vpi_scan(modItr)) {
//			result += "Entered Module Iterator:\n";
//      if (vpi_get(vpiType, obj_h) != vpiModule) {
//        result += "ERROR: this is not a module, it is a: " + std::to_string((int)(vpi_get(vpiType, obj_h)))+ "\n";
//      }
//      std::string defName;
//      std::string objectName;
//      if (const char* s = vpi_get_str(vpiDefName, obj_h)) {
//        defName = s;
//      }
//      if (const char* s = vpi_get_str(vpiName, obj_h)) { 
//        if (!defName.empty()) {
//          defName += " ";
//        }
//        objectName = std::string("(") + s + std::string(")");
//      }
//
//
//			result += "\n\n";
//			vpiHandle  net_iterator,  net_handle;
//			net_iterator = vpi_iterate(vpiNet, obj_h);
//			if  (net_iterator  ==  NULL) 
//				result += "No  nets  found  in  this  module\n";
//			else { 
//				while  (  (net_handle  =  vpi_scan(net_iterator))  !=  NULL  )  {
//					const char *s = (vpi_get(vpiNetType, net_handle) == 48 )  ? "Register" : "Wire";
//					result += "Found a net: " +  std::string(s);
//					result += ", name: ";
//					result += vpi_get_str(vpiFullName, net_handle);
//					//result += ", array?  ";
//					//result += std::to_string(vpi_get(vpiArray, net_handle));
//					//result += ", scalar = ";
//					//result += std::to_string(vpi_get(vpiScalar, net_handle));
//					//result += ", vector = ";
//					//result += std::to_string(vpi_get(vpiVector, net_handle));
//					//result += ", netDeclAssign = ";
//					//result += std::to_string(vpi_get(vpiNetDeclAssign, net_handle));
//					result += ", size = ";
//        	//result += std::to_string(((const uhdm_handle *)net_handle)->type)+ "\n";
//					result += "(before that, current object = ";
//					result += std::to_string((int)(vpi_get(vpiType, net_handle)));
//					result += ") or (";
//					result += std::to_string(((const uhdm_handle *)net_handle)->type);
//					result += ") \n";
//					vpiHandle rah = vpi_iterate(vpiRange, net_handle);
//					//vpiHandle ra = vpi_iterate(vpiRange, rah);
//					if(rah != nullptr) {
//						result += "RANGE OBJECT" + (std::to_string((int)(vpi_get(vpiType, rah))));
//						vpiHandle rangeh = vpi_scan(rah);
//						while( (rangeh) != NULL) {
//							result += "FOUND RANGE OBJECTTTTTTTTTTTTTTTTTTT";	
//							
//						}
// 						//s_vpi_value val = {vpiIntVal};
//    				//vpi_get_value(itrrr, &val);
//    				//result += "RANGE VALUE: " + std::to_string(val.value.integer);
//					} else result += "  No handle to RANGE WTFF!!!";
//					//vpiHandle itr_ = vpi_iterate(vpiRange, itr);
// 					//if (vpiHandle range_obj = vpi_scan(itr_) ) {
//					//	result += "RANGE OBJECT" + (std::to_string((int)(vpi_get(vpiType, range_obj))));
//					//	s_vpi_value value;
//    			//	vpi_get_value(itr, &value);
//    			//	value.format = vpiIntVal;
//    			//	result += std::to_string(value.value.integer);
//    			//}
//					//else {
//					//	result += "No handle!";
//					//}    	
//					const int size = vpi_get(vpiSize, net_handle);
//					if(size == 0) result += "(0)";
//					if(s == "Register") {
//						result += ": ";
//						result += vpi_get_str(vpiFullName, net_handle);
//						result += ", size = ";
//						result += std::to_string(vpi_get(vpiSize, net_handle));
//					}
//					result += "\n";
//				} 
//			}
//			//vpiHandle  arr_it,  arr_handle;
//			//arr_it = vpi_iterate(vpiRegArray, obj_h);
//			//if  (arr_it ==  NULL) 
//			//	result += "No  net arrays  found  in  this  module !!!!!!!!!\n";
//			//else { 
//			//	while  (  (arr_handle  =  vpi_scan(net_iterator))  !=  NULL  )  {
//			//		const char *s = (vpi_get(vpiNetType, arr_handle) == 48 )  ? "Register" : "Wire";
//			//		result += "Found a net: " +  std::string(s);
//			//		if(s == "Register")
//			//			result += vpi_get_str(vpiFullName, arr_handle);
//			//		result += "\n";
//			//	} 
//			//}
//			//vpiHandle if_handle, if_itr;
//			//if_itr = vpi_iterate(vpiCondition, obj_h);	
//			//if (if_itr == NULL) {
//			//	result += "No IF_STATEMENTs found !!";
//			//} else {
//		  //	while (vpiHandle obj = vpi_scan(if_itr) ) {
//			//		std::string fullName;
//			//		if(const char *s = vpi_get_str(vpiFullName, obj)) {
//			//			fullName = s;
//			//		}
//      //		result += "Found an if_statement: " + fullName;
//      //		vpi_release_handle(obj);
//    	//	}
//			//	result += "\n\n";
//			//}
//		
//
//
//      // ...
//      // Iterate thru statements
//      // ...
//      result += "+ module: " + defName + objectName +
//                ", file:" + std::string(vpi_get_str(vpiFile, obj_h)) +
//                ", line:" + std::to_string(vpi_get(vpiLineNo, obj_h));
//
//			result += "\n obj_h handle type: " + std::to_string((int)(((const uhdm_handle *)obj_h)->type)) + "\n";
//      vpiHandle processItr = vpi_iterate(vpiProcess, obj_h);
//      while (vpiHandle sub_h = vpi_scan(processItr)) {
//				//vpiHandle attr = vpi_iterate(vpiAttribute, sub_h);
//				//attr->first //AM -- how to unravel?
//				
//        result += "\n    \\_ process stmt, file:" +
//       						std::to_string(((const uhdm_handle *)sub_h)->type)+ "\n" +
//                  std::string(vpi_get_str(vpiFile, sub_h)) +
//                  ", line:" + std::to_string(vpi_get(vpiLineNo, sub_h)) + 
//									", alwaysType: " + std::to_string(vpi_get(vpiAlwaysType, sub_h));
//				if(vpiHandle stmt = vpi_handle(vpiStmt, sub_h)) {
//					result += "\n     statements found:\n";
//       		result += std::to_string(((const uhdm_handle *)stmt)->type)+ "\n";
//					if(vpiHandle iff = vpi_handle(vpiCondition, stmt)) {
//						result += "\n     edge sensitivity found:\n";
//       			result += std::to_string(((const uhdm_handle *)iff)->type)+ "\n";
//						if (const int n = vpi_get(vpiOpType, iff)) {
//							result += "\n     ops found:\n" + std::to_string(n);
//						} else result += "NO OPS FOUND!";
//					} else result += "NO IFCONDS FOUND!";
//					if(vpiHandle stt = vpi_handle(vpiStmt, stmt)) {
//						result += "\n  inner statements found:\n";
//       			result += std::to_string(((const uhdm_handle *)stt)->type)+ "\n";	
//						//if(vpiHandle sttt = vpi_handle(vpiStmt, stt)) {
//						//	result += "\n  inner inner statements found:\n";
//       			//	result += std::to_string(((const uhdm_handle *)sttt)->type)+ "\n";	
//						//	
//						//} else result += "NO FURTHER inner inner STATEMENTS FOUND\n";
//						if(vpiHandle ifff = vpi_handle(vpiCondition, stt)) {
//							result += "\n ref_obj found:\n";
//       				result += std::to_string(((const uhdm_handle *)ifff)->type)+ "\n";
//							if (const char* s = vpi_get_str(vpiFullName, ifff)) {
//      					result += "Condition reg_obj: ";
//								result += s;
//							} else result += "No conditional variable found";
//							if (vpiHandle shan = vpi_handle(vpiLeftRange, ifff)) {
//      					result += "\nFound left range: ";
//       					result += std::to_string(((const uhdm_handle *)shan)->type)+ "\n";
//								s_vpi_value value;
//    						vpi_get_value(shan, &value);
//    						if (value.format) {
//      						std::string val = std::to_string(value.value.integer);
//									result += "FOUND VALUE = " + val;
//    						} else result += "coudn't find value\n\n\n\n";
//       			//		result += std::to_string(((const uhdm_handle *)shan)->type)+ "\n";
//						//		int con = vpi_get(vpiConstType, shan);
//      			//		result += "\nFound iconstant type: " + std::to_string(con);
//						//		s_vpi_value value;
//    				//		vpi_get_value(shan, &value);
//    				//		if (value.format) {
//      			//			std::string val = std::to_string(value.value.integer);
//						//			result += "FOUND VALUE = " + val;
//    				//		}
//								
//							} else result += "\nno left range found!!";
//							if(vpiHandle rhan = vpi_handle(vpiRightRange, ifff)) {
//								result += "\nRight range: ";
//								s_vpi_value value;
//    						vpi_get_value(rhan, &value);
//    						if (value.format) {
//      						std::string val = std::to_string(value.value.integer);
//									result += "FOUND VALUE = " + val;
//    						} else result += "coudn't find value\n\n\n\n";
//							} else result += "Coundn't find righgt range\n";
//							if (const int n = vpi_get(vpiSize, obj_h))
//								result += "vpiSize: " + std::to_string(n);
//							else result += "\nno size to this one!!";
//							//AM vpiCondition
//							//if(vpiHandle ra = vpi_handle(vpiCondition, ifff)) {
//							//	result += "\n  ra conditions found:\n";
//       				//	result += std::to_string(((const uhdm_handle *)ra)->type)+ "\n";
//							//} else result += "NOOOOOO!!!!";
//							////if (const int n = vpi_get(vpiOpType, ifff)) {
//							////	result += "\n     ops found:\n" + std::to_string(n) + "\n";
//							////	vpiHandle opr = vpi_iterate(vpiOperand,ifff);
//    					////	while (vpiHandle ob = vpi_scan(opr) ) {
//							////		
//							////		result += std::to_string(vpi_get(vpiOpType, opr));
//							////		result += " MORE ";
//							////	}
//							////} else result += "NO IFELSEOPS FOUND!";
//						} else result += "NO IFELSE FOUND!";
//
//						//if(vpiHandle start = vpi_handle(vpiIfElse, stt)) {
//						//	result += "\n   assignment found:\n" ;
//						//} else result += "NO ASSIGN FOUND!";
//						
//						//if (const int n = vpi_get(vpiOpType, stt)) {
//						//	result += "\n   inner ops found:\n" ;
//						//} else result += "NO inner OPS FOUND!";
//
//
//					} else result += "NO FURTHER inner STATEMENTS FOUND\n";
//				} else result += "NO STATEMENT FOUND!";
//        vpi_release_handle(sub_h);
//      }
//      vpi_release_handle(processItr);
//
//      vpiHandle ports = vpi_iterate(vpiPort, obj_h);
//			vpiHandle port;
//			result += "\nPorts of " + std::string(vpi_get_str(vpiDefName, obj_h)) + std::string(vpi_get_str(vpiFullName, obj_h)) + "\n";
//			while ((port = vpi_scan(ports))) {
//        result += "\n";
//        vpiHandle highConn = vpi_handle(vpiHighConn, port);
//        vpiHandle lowConn = vpi_handle(vpiLowConn, port);
//				int x = vpi_get(vpiDirection, port);
//        //int y = getExprValue(highConn, vpiLeftRange);
//				//int z = getExprValue(lowConn, vpiRightRange),
//        result += "direction " + std::to_string(x);
//        //           getExprValue(lowConn, vpiLeftRange), getExprValue(lowConn, vpiRightRange)); 
//
//    	}
//
//      //vpiHandle netItr = vpi_iterate(vpiNet, obj_h);
//      //while (vpiHandle sub_h = vpi_scan(netItr)) {
//			//	std::string net_name = vpi_get_str(vpiFullName, sub_h );
//			//	result += "\nANOOP: " + std::to_string(((const uhdm_handle*)sub_h)->type);
//			//	vpiHandle typeSpec = vpi_handle(vpiTypespec, sub_h);
//			//	vpiHandle par = vpi_handle(vpiParent, sub_h);
//			//	vpiHandle mod = vpi_handle(vpiModule, sub_h);
//			//	//result += "\nANOOP: " + std::to_string(((const uhdm_handle*)mod)->type);
//			//	std::string modd = vpi_get_str(vpiFullName, mod);
//			//	if(vpiHandle highConn = vpi_handle(vpiRightRange, sub_h))
//			//		result += "POSITIVE";
//			//	vpiHandle lowConn = vpi_handle(vpiRightRange, sub_h);
//			//	//vpiHandle scanConn = vpi_iterate(highConn);
//			//	result += "\nANOOP: " + modd;//+ std::to_string(((const uhdm_handle*)scanConn)->type);
//			//	//vpiHandle expr = vpi_iterate(vpiRange, vpi_handle(vpiLowConn, sub_h));
//			//	//int xdim = getExprValue(lowConn, vpiRightRange);
//      //  result += "\n        \\_ net, name: " + net_name + 
//			//						" size: " + std::to_string(getExprValue(lowConn, vpiLeftRange)) +
//			//						//std::to_string(getExprValue(lowConn, vpiRightRange)) +
//			//						" file:" + std::string(vpi_get_str(vpiFile, sub_h)) +
//      //            ", line:" + std::to_string(vpi_get(vpiLineNo, sub_h));
//			//	vpi_release_handle(sub_h);
//			//}
//      //vpi_release_handle(netItr);
//
//      vpiHandle regItr = vpi_iterate(vpiReg, obj_h);
//      while (vpiHandle sub_h = vpi_scan(regItr)) {
//        result += "\n        \\_ reg, file:" +
//                  std::string(vpi_get_str(vpiFile, sub_h)) +
//                  ", line:" + std::to_string(vpi_get(vpiLineNo, sub_h));
//        vpi_release_handle(sub_h);
//      }
//      vpi_release_handle(regItr);
//
//      vpiHandle assignItr = vpi_iterate(vpiContAssign, obj_h);
//      while (vpiHandle sub_h = vpi_scan(assignItr)) {
//        result += "\n    \\_ assign stmt, file:" +
//                  std::string(vpi_get_str(vpiFile, sub_h)) +
//                  ", line:" + std::to_string(vpi_get(vpiLineNo, sub_h));
//				vpiHandle rhs = vpi_handle(vpiRhs, sub_h);
//				if(rhs) result += "\nFOUND RHS of type: " + std::to_string(((const uhdm_handle *)rhs)->type);;
//				if (const int n = vpi_get(vpiOpType, rhs)) result += "\nOperation Type (32 = ternary!)" + std::to_string(n);
//    		vpiHandle opI = vpi_iterate(vpiOperand,rhs);
//    		while (vpiHandle oph = vpi_scan(opI) ) {
//					result += "found operand handle of type: " + std::to_string(((const uhdm_handle *)oph)->type);
//					result += "\n";
//					if(const char *s = vpi_get_str(vpiFullName, oph)) {
//						result += "\nName of condition variable: ";
//						result += s;
//						result += "\n";
//					}
//					//if(vpiHandle ref = vpi_handle(vpiRefObj, oph)) {
//        	//	result += "\n ref_obj found:\n";
//        	//	result += std::to_string(((const uhdm_handle *)ref)->type)+ "\n";
//        	//	if (const char* s = vpi_get_str(vpiFullName, ref)) {
//        	//	  result += "Condition reg_obj: ";
//        	//	  result += s;
//        	//	} else result += "No conditional variable found";
//					//}	 else result += "refobj not found";
//				}
//      }
//      vpi_release_handle(assignItr);
//      // ...
//      // Iterate thru ports
//      // ...
//      result += "\n";
//      vpi_release_handle(obj_h);
//    }
//    vpi_release_handle(modItr);

    // Instance tree:
    // Elaborated Instance tree
    result += "Instance Tree:\n";
    vpiHandle instItr = vpi_iterate(UHDM::uhdmtopModules, the_design);
    while (vpiHandle obj_h = vpi_scan(instItr)) {
      std::function<std::string(vpiHandle, std::string)> inst_visit =
          [&inst_visit](vpiHandle obj_h, std::string margin) {
            std::string res;
            std::string defName;
            std::string objectName;
            if (const char* s = vpi_get_str(vpiDefName, obj_h)) {
              defName = s;
            }
            if (const char* s = vpi_get_str(vpiName, obj_h)) {
              if (!defName.empty()) {
                defName += " ";
              }
              objectName = std::string("(") + s + std::string(")");
            }
            std::string f;
            if (const char* s = vpi_get_str(vpiFile, obj_h)) {
              f = s;
            }
            res += margin + "+ module: " + defName + objectName +
                   ", file:" + f +
                   ", line:" + std::to_string(vpi_get(vpiLineNo, obj_h)) + "\n";

            // Recursive tree traversal
            margin = "  " + margin;
            if (vpi_get(vpiType, obj_h) == vpiModule ||
                vpi_get(vpiType, obj_h) == vpiGenScope) {
              vpiHandle subItr = vpi_iterate(vpiModule, obj_h);
              while (vpiHandle sub_h = vpi_scan(subItr)) {
                res += inst_visit(sub_h, margin);
                vpi_release_handle(sub_h);
              }
              vpi_release_handle(subItr);
            }
            if (vpi_get(vpiType, obj_h) == vpiModule ||
                vpi_get(vpiType, obj_h) == vpiGenScope) {
              vpiHandle subItr = vpi_iterate(vpiGenScopeArray, obj_h);
              while (vpiHandle sub_h = vpi_scan(subItr)) {
                res += inst_visit(sub_h, margin);
                vpi_release_handle(sub_h);
              }
              vpi_release_handle(subItr);
            }
            if (vpi_get(vpiType, obj_h) == vpiGenScopeArray) {
              vpiHandle subItr = vpi_iterate(vpiGenScope, obj_h);
              while (vpiHandle sub_h = vpi_scan(subItr)) {
                res += inst_visit(sub_h, margin);
                vpi_release_handle(sub_h);
              }
              vpi_release_handle(subItr);
            }
            return res;
          };
      result += inst_visit(obj_h, "");
    }
  }
  std::cout << result << std::endl;

  // Do not delete these objects until you are done with UHDM
  SURELOG::shutdown_compiler(compiler);
  delete clp;
  delete symbolTable;
  delete errors;
  return code;
}
