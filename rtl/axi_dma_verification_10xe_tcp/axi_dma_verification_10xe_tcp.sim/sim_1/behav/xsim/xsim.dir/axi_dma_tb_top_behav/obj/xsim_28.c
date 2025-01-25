/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                         */
/*  \   \        Copyright (c) 2003-2020 Xilinx, Inc.                 */
/*  /   /        All Right Reserved.                                  */
/* /---/   /\                                                         */
/* \   \  /  \                                                        */
/*  \___\/\___\                                                       */
/**********************************************************************/

#if defined(_WIN32)
 #include "stdio.h"
 #define IKI_DLLESPEC __declspec(dllimport)
#else
 #define IKI_DLLESPEC
#endif
#include "iki.h"
#include <string.h>
#include <math.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
#include "svdpi.h"


#if (defined(_MSC_VER) || defined(__MINGW32__) || defined(__CYGWIN__))
#define DPI_DLLISPEC __declspec(dllimport)
#define DPI_DLLESPEC __declspec(dllexport)
#else
#define DPI_DLLISPEC
#define DPI_DLLESPEC
#endif


extern "C"
{
	DPI_DLLISPEC extern void  DPISetMode(int mode) ;
	DPI_DLLISPEC extern int   DPIGetMode() ; 
	DPI_DLLISPEC extern void  DPIAllocateExportedFunctions(int size) ;
	DPI_DLLISPEC extern void  DPIAddExportedFunction(int index, const char* value) ;
	DPI_DLLISPEC extern void  DPIAllocateSVCallerName(int index, const char* y) ;
	DPI_DLLISPEC extern void  DPISetCallerName(int index, const char* y) ;
	DPI_DLLISPEC extern void  DPISetCallerLine(int index, unsigned int y) ;
	DPI_DLLISPEC extern void  DPISetCallerOffset(int index, int y) ;
	DPI_DLLISPEC extern void  DPIAllocateDPIScopes(int size) ;
	DPI_DLLISPEC extern void  DPISetDPIScopeFunctionName(int index, const char* y) ;
	DPI_DLLISPEC extern void  DPISetDPIScopeHierarchy(int index, const char* y) ;
	DPI_DLLISPEC extern void  DPIRelocateDPIScopeIP(int index, char* IP) ;
	DPI_DLLISPEC extern void  DPIAddDPIScopeAccessibleFunction(int index, unsigned int y) ;
	DPI_DLLISPEC extern void  DPIFlushAll() ;
	DPI_DLLISPEC extern void  DPIVerifyScope() ;
	DPI_DLLISPEC extern char* DPISignalHandle(char* sigHandle, int length) ;
	DPI_DLLISPEC extern char* DPIMalloc(unsigned noOfBytes) ;
	DPI_DLLISPEC extern void  DPITransactionAuto(char* srcValue, unsigned int startIndex, unsigned int endIndex, char* net) ;
	DPI_DLLISPEC extern void  DPIScheduleTransactionBlocking(char* var, char* driver, char* src, unsigned setback, unsigned lenMinusOnne) ;
	DPI_DLLISPEC extern void  DPIMemsetSvToDpi(char* dst, char* src, int numCBytes, int is2state) ;
	DPI_DLLISPEC extern void  DPIMemsetDpiToSv(char* dst, char* src, int numCBytes, int is2state) ;
	DPI_DLLISPEC extern void  DPIMemsetSvLogic1ToDpi(char* dst, char* src) ;
	DPI_DLLISPEC extern void  DPIMemsetDpiToSvLogic1(char* dst, char* src) ;
	DPI_DLLISPEC extern void  DPIMemsetDpiToSvUnpackedLogic(char* dst, char* src, int* numRshift, int* shift) ;
	DPI_DLLISPEC extern void  DPIMemsetDpiToSvUnpackedLogicWithPackedDim(char* dst, char* src, int pckedSz, int* numRshift, int* shift) ;
	DPI_DLLISPEC extern void  DPIMemsetSvToDpiUnpackedLogic(char* dst, char* src, int* numRshift, int* shift) ;
	DPI_DLLISPEC extern void  DPIMemsetSvToDpiUnpackedLogicWithPackedDim(char* dst, char* src, int pckdSz, int* numRshift, int* shift) ;
	DPI_DLLISPEC extern void  DPIMemsetDpiToSvUnpackedBit(char* dst, char* src, int* numRshift, int* shift) ;
	DPI_DLLISPEC extern void  DPIMemsetDpiToSvUnpackedBitWithPackedDim(char* dst, char* src, int pckdSz, int* numRshift, int* shift) ;
	DPI_DLLISPEC extern void  DPIMemsetSvToDpiUnpackedBit(char* dst, char* src, int* numRshift, int* shift) ;
	DPI_DLLISPEC extern void  DPIMemsetSvToDpiUnpackedBitWithPackedDim(char* dst, char* src, int pckdSz, int* numRshift, int* shift) ;
	DPI_DLLISPEC extern void  DPISetFuncName(const char* funcName) ;
	DPI_DLLISPEC extern int   staticScopeCheck(const char* calledFunction) ;
	DPI_DLLISPEC extern void  DPIAllocateSVCallerInfo(int size) ;
	DPI_DLLISPEC extern void* DPICreateContext(int scopeId, char* IP, int callerIdx);
	DPI_DLLISPEC extern void* DPIGetCurrentContext();
	DPI_DLLISPEC extern void  DPISetCurrentContext(void*);
	DPI_DLLISPEC extern void  DPIRemoveContext(void*);
	DPI_DLLISPEC extern int   svGetScopeStaticId();
	DPI_DLLISPEC extern char* svGetScopeIP();
	DPI_DLLISPEC extern unsigned DPIGetUnpackedSizeFromSVOpenArray(svOpenArray*);
	DPI_DLLISPEC extern unsigned DPIGetConstraintSizeFromSVOpenArray(svOpenArray*, int);
	DPI_DLLISPEC extern int   topOffset() ;
	DPI_DLLISPEC extern char* DPIInitializeFunction(char* p, unsigned size, long long offset) ;
	DPI_DLLISPEC extern void  DPIInvokeFunction(char* processPtr, char* SP, void* func, char* IP) ;
	DPI_DLLISPEC extern void  DPIDeleteFunctionInvocation(char* SP) ;
	DPI_DLLISPEC extern void  DPISetTaskScopeId(int scopeId) ;
	DPI_DLLISPEC extern void  DPISetTaskCaller(int index) ;
	DPI_DLLISPEC extern int   DPIGetTaskCaller() ;
	DPI_DLLISPEC extern char* DPIInitializeTask(long long subprogInDPOffset, char* scopePropInIP, unsigned size, char* parentBlock) ;
	DPI_DLLISPEC extern void  DPIInvokeTask(long long subprogInDPOffset, char* SP, void* func, char* IP) ;
	DPI_DLLISPEC extern void  DPIDeleteTaskInvocation(char* SP) ;
	DPI_DLLISPEC extern void* DPICreateTaskContext(int (*wrapper)(char*, char*, char*), char* DP, char* IP, char* SP, size_t stackSz) ;
	DPI_DLLISPEC extern void  DPIRemoveTaskContext(void*) ;
	DPI_DLLISPEC extern void  DPICallCurrentContext() ;
	DPI_DLLISPEC extern void  DPIYieldCurrentContext() ;
	DPI_DLLISPEC extern void* DPIGetCurrentTaskContext() ;
	DPI_DLLISPEC extern int   DPIRunningInNewContext() ;
	DPI_DLLISPEC extern void  DPISetCurrentTaskContext(void* x) ;
}

namespace XILINX_DPI { 

	void dpiInitialize()
	{
		DPIAllocateExportedFunctions(1) ;
		DPIAddExportedFunction(0, "m__uvm_report_dpi") ;
		DPIAllocateDPIScopes(1) ;
		DPISetDPIScopeFunctionName(0, "m__uvm_report_dpi") ;
		DPISetDPIScopeHierarchy(0, "uvm_pkg") ;
		DPIRelocateDPIScopeIP(0, (char*)(0x6e2308)) ;
		DPIAddDPIScopeAccessibleFunction(0, 0) ;
	}

}


extern "C" {
	void iki_initialize_dpi()
	{ XILINX_DPI::dpiInitialize() ; } 
}


extern "C" {

	extern void subprog_m_9f9e278a04d21dea_556ead11_3259(char*, char*, char*);
}


extern "C" {
}


extern "C" {
	DPI_DLLESPEC 
	void m__uvm_report_dpi(int arg0, const char* arg1, const char* arg2, int arg3, const char* arg4, int arg5)
	{
		DPIVerifyScope();
		int functionToCall = staticScopeCheck("m__uvm_report_dpi") ;
		switch(functionToCall)
		{
			case 0:
			{

	{
		DPIFlushAll();
		int staticIndex = 0 ;
		char* IP = NULL ;
		staticIndex = svGetScopeStaticId() ;
		IP = svGetScopeIP();
		int callingProcessOffset = topOffset() ;
		char* SP ;
		void* oldSPcontext = DPIGetCurrentContext();
		SP = DPIInitializeFunction(IP + 498336, 168, 1458680) ;
		char driver0[32] ;
		for(int i = 0 ; i < 32 ; ++i) driver0[i] = 0 ;
		char driver1[32] ;
		for(int i = 0 ; i < 32 ; ++i) driver1[i] = 0 ;
		char driver2[32] ;
		for(int i = 0 ; i < 32 ; ++i) driver2[i] = 0 ;
		char driver3[32] ;
		for(int i = 0 ; i < 32 ; ++i) driver3[i] = 0 ;
		char driver4[32] ;
		for(int i = 0 ; i < 32 ; ++i) driver4[i] = 0 ;
		char driver5[32] ;
		for(int i = 0 ; i < 32 ; ++i) driver5[i] = 0 ;
		char copyArg_0_0[8];
		{
		char* ptrToSP = (char*)copyArg_0_0;
		DPIMemsetDpiToSv( ptrToSP, (char*)(&arg0), 4, 1 );
		ptrToSP = ptrToSP + 8; 
		}
		DPIScheduleTransactionBlocking(IP +497832, driver0, (char*)(&copyArg_0_0), 0, 31) ;
		const char* copyArg_1_1[1] ;
		copyArg_1_1[0] = ( arg1) ;
		DPIScheduleTransactionBlocking(IP +497888, driver1, (char*)(&copyArg_1_1), 0, 31) ;
		const char* copyArg_2_2[1] ;
		copyArg_2_2[0] = ( arg2) ;
		DPIScheduleTransactionBlocking(IP +497944, driver2, (char*)(&copyArg_2_2), 0, 31) ;
		char copyArg_3_3[8];
		{
		char* ptrToSP = (char*)copyArg_3_3;
		DPIMemsetDpiToSv( ptrToSP, (char*)(&arg3), 4, 1 );
		ptrToSP = ptrToSP + 8; 
		}
		DPIScheduleTransactionBlocking(IP +498000, driver3, (char*)(&copyArg_3_3), 0, 31) ;
		const char* copyArg_4_4[1] ;
		copyArg_4_4[0] = ( arg4) ;
		DPIScheduleTransactionBlocking(IP +498056, driver4, (char*)(&copyArg_4_4), 0, 31) ;
		char copyArg_5_5[8];
		{
		char* ptrToSP = (char*)copyArg_5_5;
		DPIMemsetDpiToSv( ptrToSP, (char*)(&arg5), 4, 1 );
		ptrToSP = ptrToSP + 8; 
		}
		DPIScheduleTransactionBlocking(IP +498112, driver5, (char*)(&copyArg_5_5), 0, 31) ;
		char* oldSP = *((char**)(IP + callingProcessOffset + 80)) ; 
		DPIInvokeFunction(IP + callingProcessOffset, SP, (void*)(subprog_m_9f9e278a04d21dea_556ead11_3259), IP) ;
		DPIDeleteFunctionInvocation(SP) ;
		*((char**)(IP + callingProcessOffset + 80)) = oldSP ; 
		DPISetCurrentContext(oldSPcontext);
		DPIFlushAll();
	}
			}
			break ;
			default:
			break ;
		}
	}
}

