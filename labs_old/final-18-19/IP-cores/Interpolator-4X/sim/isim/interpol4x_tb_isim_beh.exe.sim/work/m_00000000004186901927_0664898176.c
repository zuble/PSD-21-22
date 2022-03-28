/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

/* This file is designed for use with ISim build 0x7708f090 */

#define XSI_HIDE_SYMBOL_SPEC true
#include "xsi.h"
#include <memory.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
static const char *ng0 = "C:/Users/pgs/Documents/psdi/fm/IP-cores/Interpolator-4X/src-verilog/interpol4x.v";
static unsigned int ng1[] = {0U, 0U};
static int ng2[] = {2, 0};
static int ng3[] = {3, 0};
static int ng4[] = {4, 0};



static void Always_42_0(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    unsigned int t6;
    unsigned int t7;
    unsigned int t8;
    unsigned int t9;
    unsigned int t10;
    char *t11;
    char *t12;

LAB0:    t1 = (t0 + 4448U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(42, ng0);
    t2 = (t0 + 5264);
    *((int *)t2) = 1;
    t3 = (t0 + 4480);
    *((char **)t3) = t2;
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(43, ng0);
    t4 = (t0 + 1208U);
    t5 = *((char **)t4);
    t4 = (t5 + 4);
    t6 = *((unsigned int *)t4);
    t7 = (~(t6));
    t8 = *((unsigned int *)t5);
    t9 = (t8 & t7);
    t10 = (t9 != 0);
    if (t10 > 0)
        goto LAB5;

LAB6:    xsi_set_current_line(48, ng0);

LAB9:    xsi_set_current_line(49, ng0);
    t2 = (t0 + 1368U);
    t3 = *((char **)t2);
    t2 = (t3 + 4);
    t6 = *((unsigned int *)t2);
    t7 = (~(t6));
    t8 = *((unsigned int *)t3);
    t9 = (t8 & t7);
    t10 = (t9 != 0);
    if (t10 > 0)
        goto LAB10;

LAB11:
LAB12:
LAB7:    goto LAB2;

LAB5:    xsi_set_current_line(44, ng0);

LAB8:    xsi_set_current_line(45, ng0);
    t11 = ((char*)((ng1)));
    t12 = (t0 + 2248);
    xsi_vlogvar_wait_assign_value(t12, t11, 0, 0, 18, 0LL);
    goto LAB7;

LAB10:    xsi_set_current_line(50, ng0);
    t4 = (t0 + 1688U);
    t5 = *((char **)t4);
    t4 = (t0 + 2248);
    xsi_vlogvar_wait_assign_value(t4, t5, 0, 0, 18, 0LL);
    goto LAB12;

}

static void Always_56_1(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    unsigned int t6;
    unsigned int t7;
    unsigned int t8;
    unsigned int t9;
    unsigned int t10;
    char *t11;
    char *t12;
    unsigned int t13;
    unsigned int t14;
    unsigned int t15;
    unsigned int t16;
    unsigned int t17;
    char *t18;
    char *t19;

LAB0:    t1 = (t0 + 4696U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(56, ng0);
    t2 = (t0 + 5280);
    *((int *)t2) = 1;
    t3 = (t0 + 4728);
    *((char **)t3) = t2;
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(57, ng0);
    t4 = (t0 + 1208U);
    t5 = *((char **)t4);
    t4 = (t5 + 4);
    t6 = *((unsigned int *)t4);
    t7 = (~(t6));
    t8 = *((unsigned int *)t5);
    t9 = (t8 & t7);
    t10 = (t9 != 0);
    if (t10 > 0)
        goto LAB5;

LAB6:    xsi_set_current_line(62, ng0);

LAB9:    xsi_set_current_line(63, ng0);
    t2 = (t0 + 1528U);
    t3 = *((char **)t2);
    t2 = (t3 + 4);
    t6 = *((unsigned int *)t2);
    t7 = (~(t6));
    t8 = *((unsigned int *)t3);
    t9 = (t8 & t7);
    t10 = (t9 != 0);
    if (t10 > 0)
        goto LAB10;

LAB11:
LAB12:
LAB7:    goto LAB2;

LAB5:    xsi_set_current_line(58, ng0);

LAB8:    xsi_set_current_line(59, ng0);
    t11 = ((char*)((ng1)));
    t12 = (t0 + 2408);
    xsi_vlogvar_wait_assign_value(t12, t11, 0, 0, 18, 0LL);
    goto LAB7;

LAB10:    xsi_set_current_line(64, ng0);

LAB13:    xsi_set_current_line(65, ng0);
    t4 = (t0 + 1368U);
    t5 = *((char **)t4);
    t4 = (t5 + 4);
    t13 = *((unsigned int *)t4);
    t14 = (~(t13));
    t15 = *((unsigned int *)t5);
    t16 = (t15 & t14);
    t17 = (t16 != 0);
    if (t17 > 0)
        goto LAB14;

LAB15:    xsi_set_current_line(68, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 2408);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 18, 0LL);

LAB16:    goto LAB12;

LAB14:    xsi_set_current_line(66, ng0);
    t11 = (t0 + 2248);
    t12 = (t11 + 56U);
    t18 = *((char **)t12);
    t19 = (t0 + 2408);
    xsi_vlogvar_wait_assign_value(t19, t18, 0, 0, 18, 0LL);
    goto LAB16;

}

static void Always_77_2(char *t0)
{
    char t13[8];
    char t29[8];
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    unsigned int t6;
    unsigned int t7;
    unsigned int t8;
    unsigned int t9;
    unsigned int t10;
    char *t11;
    char *t12;
    unsigned int t14;
    unsigned int t15;
    unsigned int t16;
    unsigned int t17;
    unsigned int t18;
    unsigned int t19;
    unsigned int t20;
    unsigned int t21;
    unsigned int t22;
    char *t23;
    unsigned int t24;
    unsigned int t25;
    char *t26;
    unsigned int t27;
    char *t28;

LAB0:    t1 = (t0 + 4944U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(77, ng0);
    t2 = (t0 + 5296);
    *((int *)t2) = 1;
    t3 = (t0 + 4976);
    *((char **)t3) = t2;
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(78, ng0);
    t4 = (t0 + 1208U);
    t5 = *((char **)t4);
    t4 = (t5 + 4);
    t6 = *((unsigned int *)t4);
    t7 = (~(t6));
    t8 = *((unsigned int *)t5);
    t9 = (t8 & t7);
    t10 = (t9 != 0);
    if (t10 > 0)
        goto LAB5;

LAB6:    xsi_set_current_line(90, ng0);

LAB9:    xsi_set_current_line(91, ng0);
    t2 = (t0 + 1528U);
    t3 = *((char **)t2);
    t2 = (t3 + 4);
    t6 = *((unsigned int *)t2);
    t7 = (~(t6));
    t8 = *((unsigned int *)t3);
    t9 = (t8 & t7);
    t10 = (t9 != 0);
    if (t10 > 0)
        goto LAB10;

LAB11:
LAB12:
LAB7:    goto LAB2;

LAB5:    xsi_set_current_line(79, ng0);

LAB8:    xsi_set_current_line(80, ng0);
    t11 = ((char*)((ng1)));
    t12 = (t0 + 2568);
    xsi_vlogvar_wait_assign_value(t12, t11, 0, 0, 21, 0LL);
    xsi_set_current_line(81, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 2728);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 21, 0LL);
    xsi_set_current_line(82, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 2888);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 21, 0LL);
    xsi_set_current_line(83, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 3048);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 21, 0LL);
    xsi_set_current_line(84, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 3208);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 21, 0LL);
    xsi_set_current_line(85, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 3368);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 21, 0LL);
    xsi_set_current_line(86, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 3528);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 21, 0LL);
    xsi_set_current_line(87, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 2088);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 18, 0LL);
    goto LAB7;

LAB10:    xsi_set_current_line(92, ng0);

LAB13:    xsi_set_current_line(93, ng0);
    t4 = (t0 + 2408);
    t5 = (t4 + 56U);
    t11 = *((char **)t5);
    memcpy(t13, t11, 8);
    t16 = *((unsigned int *)t11);
    t17 = (t16 & 131072U);
    t14 = t17;
    t12 = (t11 + 4);
    t18 = *((unsigned int *)t12);
    t19 = (t18 & 131072U);
    t15 = t19;
    t20 = (t17 != 0);
    if (t20 == 1)
        goto LAB14;

LAB15:    t22 = (t19 != 0);
    if (t22 == 1)
        goto LAB16;

LAB17:    t25 = *((unsigned int *)t13);
    *((unsigned int *)t13) = (t25 & 2097151U);
    t26 = (t13 + 4);
    t27 = *((unsigned int *)t26);
    *((unsigned int *)t26) = (t27 & 2097151U);
    t28 = (t0 + 2568);
    xsi_vlogvar_wait_assign_value(t28, t13, 0, 0, 21, 0LL);
    xsi_set_current_line(94, ng0);
    t2 = (t0 + 2568);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t0 + 2408);
    t11 = (t5 + 56U);
    t12 = *((char **)t11);
    t23 = ((char*)((ng2)));
    memset(t13, 0, 8);
    xsi_vlog_signed_multiply(t13, 32, t12, 18, t23, 32);
    memset(t29, 0, 8);
    xsi_vlog_signed_add(t29, 32, t4, 21, t13, 32);
    t26 = (t0 + 2728);
    xsi_vlogvar_wait_assign_value(t26, t29, 0, 0, 21, 0LL);
    xsi_set_current_line(95, ng0);
    t2 = (t0 + 2728);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t0 + 2408);
    t11 = (t5 + 56U);
    t12 = *((char **)t11);
    t23 = ((char*)((ng3)));
    memset(t13, 0, 8);
    xsi_vlog_signed_multiply(t13, 32, t12, 18, t23, 32);
    memset(t29, 0, 8);
    xsi_vlog_signed_add(t29, 32, t4, 21, t13, 32);
    t26 = (t0 + 2888);
    xsi_vlogvar_wait_assign_value(t26, t29, 0, 0, 21, 0LL);
    xsi_set_current_line(96, ng0);
    t2 = (t0 + 2888);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t0 + 2408);
    t11 = (t5 + 56U);
    t12 = *((char **)t11);
    t23 = ((char*)((ng4)));
    memset(t13, 0, 8);
    xsi_vlog_signed_multiply(t13, 32, t12, 18, t23, 32);
    memset(t29, 0, 8);
    xsi_vlog_signed_add(t29, 32, t4, 21, t13, 32);
    t26 = (t0 + 3048);
    xsi_vlogvar_wait_assign_value(t26, t29, 0, 0, 21, 0LL);
    xsi_set_current_line(97, ng0);
    t2 = (t0 + 3048);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t0 + 2408);
    t11 = (t5 + 56U);
    t12 = *((char **)t11);
    t23 = ((char*)((ng3)));
    memset(t13, 0, 8);
    xsi_vlog_signed_multiply(t13, 32, t12, 18, t23, 32);
    memset(t29, 0, 8);
    xsi_vlog_signed_add(t29, 32, t4, 21, t13, 32);
    t26 = (t0 + 3208);
    xsi_vlogvar_wait_assign_value(t26, t29, 0, 0, 21, 0LL);
    xsi_set_current_line(98, ng0);
    t2 = (t0 + 3208);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t0 + 2408);
    t11 = (t5 + 56U);
    t12 = *((char **)t11);
    t23 = ((char*)((ng2)));
    memset(t13, 0, 8);
    xsi_vlog_signed_multiply(t13, 32, t12, 18, t23, 32);
    memset(t29, 0, 8);
    xsi_vlog_signed_add(t29, 32, t4, 21, t13, 32);
    t26 = (t0 + 3368);
    xsi_vlogvar_wait_assign_value(t26, t29, 0, 0, 21, 0LL);
    xsi_set_current_line(99, ng0);
    t2 = (t0 + 3368);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t0 + 2408);
    t11 = (t5 + 56U);
    t12 = *((char **)t11);
    memset(t13, 0, 8);
    xsi_vlog_signed_add(t13, 21, t4, 21, t12, 18);
    t23 = (t0 + 3528);
    xsi_vlogvar_wait_assign_value(t23, t13, 0, 0, 21, 0LL);
    xsi_set_current_line(100, ng0);
    t2 = (t0 + 3528);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = ((char*)((ng2)));
    memset(t13, 0, 8);
    xsi_vlog_signed_arith_rshift(t13, 21, t4, 21, t5, 32);
    t11 = (t0 + 2088);
    xsi_vlogvar_wait_assign_value(t11, t13, 0, 0, 18, 0LL);
    goto LAB12;

LAB14:    t21 = *((unsigned int *)t13);
    *((unsigned int *)t13) = (t21 | 4294705152U);
    goto LAB15;

LAB16:    t23 = (t13 + 4);
    t24 = *((unsigned int *)t23);
    *((unsigned int *)t23) = (t24 | 4294705152U);
    goto LAB17;

}


extern void work_m_00000000004186901927_0664898176_init()
{
	static char *pe[] = {(void *)Always_42_0,(void *)Always_56_1,(void *)Always_77_2};
	xsi_register_didat("work_m_00000000004186901927_0664898176", "isim/interpol4x_tb_isim_beh.exe.sim/work/m_00000000004186901927_0664898176.didat");
	xsi_register_executes(pe);
}
