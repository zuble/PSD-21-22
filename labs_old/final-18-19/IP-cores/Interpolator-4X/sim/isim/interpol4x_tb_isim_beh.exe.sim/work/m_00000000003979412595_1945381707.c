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
static const char *ng0 = "C:/Users/pgs/Documents/psdi/fm/IP-cores/Interpolator-4X/src-verilog/interpol4x_tb.v";
static int ng1[] = {778593656, 0, 1684108385, 0, 1630497134, 0, 1835295092, 0, 774861673, 0, 46, 0};
static int ng2[] = {778593656, 0, 1684108385, 0, 795833716, 0, 1684108385, 0, 796092781, 0, 11822, 0};
static int ng3[] = {0, 0};
static unsigned int ng4[] = {262143U, 262143U};
static int ng5[] = {1, 0};
static const char *ng6 = "Input test signal: %d samples";
static const char *ng7 = "Expected output signal: %d samples";
static unsigned int ng8[] = {0U, 0U};
static int ng9[] = {10, 0};
static int ng10[] = {255, 0};
static int ng11[] = {63, 0};
static const char *ng12 = "No errors found";
static const char *ng13 = "Error %4d at time %8d, output sample index = %3d, read %d != expected %d";
static const char *ng14 = "Too many errors, aborting simulation";



static void Initial_53_0(char *t0)
{
    char t4[8];
    char t15[8];
    char t28[8];
    char *t1;
    char *t2;
    char *t3;
    char *t5;
    char *t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    char *t13;
    char *t14;
    char *t16;
    char *t17;
    char *t18;
    unsigned int t19;
    unsigned int t20;
    unsigned int t21;
    unsigned int t22;
    unsigned int t23;
    char *t24;
    char *t25;
    char *t26;
    char *t27;
    char *t29;

LAB0:    xsi_set_current_line(54, ng0);

LAB2:    xsi_set_current_line(55, ng0);
    t1 = ((char*)((ng1)));
    t2 = (t0 + 2128);
    xsi_vlogfile_readmemh(t1, 168, t2, 0, 0, 0, 0);
    xsi_set_current_line(56, ng0);
    t1 = ((char*)((ng2)));
    t2 = (t0 + 2288);
    xsi_vlogfile_readmemh(t1, 176, t2, 0, 0, 0, 0);
    xsi_set_current_line(63, ng0);
    t1 = ((char*)((ng3)));
    t2 = (t0 + 3248);
    xsi_vlogvar_assign_value(t2, t1, 0, 0, 32);
    xsi_set_current_line(64, ng0);

LAB3:    t1 = (t0 + 2128);
    t2 = (t1 + 56U);
    t3 = *((char **)t2);
    t5 = (t0 + 2128);
    t6 = (t5 + 72U);
    t7 = *((char **)t6);
    t8 = (t0 + 2128);
    t9 = (t8 + 64U);
    t10 = *((char **)t9);
    t11 = (t0 + 3248);
    t12 = (t11 + 56U);
    t13 = *((char **)t12);
    xsi_vlog_generic_get_array_select_value(t4, 18, t3, t7, t10, 2, 1, t13, 32, 1);
    t14 = ((char*)((ng4)));
    memset(t15, 0, 8);
    if (*((unsigned int *)t4) != *((unsigned int *)t14))
        goto LAB5;

LAB4:    t16 = (t4 + 4);
    t17 = (t14 + 4);
    if (*((unsigned int *)t16) != *((unsigned int *)t17))
        goto LAB5;

LAB6:    t18 = (t15 + 4);
    t19 = *((unsigned int *)t18);
    t20 = (~(t19));
    t21 = *((unsigned int *)t15);
    t22 = (t21 & t20);
    t23 = (t22 != 0);
    if (t23 > 0)
        goto LAB7;

LAB8:    xsi_set_current_line(68, ng0);
    t1 = (t0 + 3248);
    t2 = (t1 + 56U);
    t3 = *((char **)t2);
    xsi_vlogfile_write(1, 0, 0, ng6, 2, t0, (char)119, t3, 32);
    xsi_set_current_line(72, ng0);
    t1 = ((char*)((ng3)));
    t2 = (t0 + 3408);
    xsi_vlogvar_assign_value(t2, t1, 0, 0, 32);
    xsi_set_current_line(73, ng0);

LAB10:    t1 = (t0 + 2288);
    t2 = (t1 + 56U);
    t3 = *((char **)t2);
    t5 = (t0 + 2288);
    t6 = (t5 + 72U);
    t7 = *((char **)t6);
    t8 = (t0 + 2288);
    t9 = (t8 + 64U);
    t10 = *((char **)t9);
    t11 = (t0 + 3408);
    t12 = (t11 + 56U);
    t13 = *((char **)t12);
    xsi_vlog_generic_get_array_select_value(t4, 18, t3, t7, t10, 2, 1, t13, 32, 1);
    t14 = ((char*)((ng4)));
    memset(t15, 0, 8);
    if (*((unsigned int *)t4) != *((unsigned int *)t14))
        goto LAB12;

LAB11:    t16 = (t4 + 4);
    t17 = (t14 + 4);
    if (*((unsigned int *)t16) != *((unsigned int *)t17))
        goto LAB12;

LAB13:    t18 = (t15 + 4);
    t19 = *((unsigned int *)t18);
    t20 = (~(t19));
    t21 = *((unsigned int *)t15);
    t22 = (t21 & t20);
    t23 = (t22 != 0);
    if (t23 > 0)
        goto LAB14;

LAB15:    xsi_set_current_line(77, ng0);
    t1 = (t0 + 3408);
    t2 = (t1 + 56U);
    t3 = *((char **)t2);
    xsi_vlogfile_write(1, 0, 0, ng7, 2, t0, (char)119, t3, 32);

LAB1:    return;
LAB5:    *((unsigned int *)t15) = 1;
    goto LAB6;

LAB7:    xsi_set_current_line(65, ng0);

LAB9:    xsi_set_current_line(66, ng0);
    t24 = (t0 + 3248);
    t25 = (t24 + 56U);
    t26 = *((char **)t25);
    t27 = ((char*)((ng5)));
    memset(t28, 0, 8);
    xsi_vlog_signed_add(t28, 32, t26, 32, t27, 32);
    t29 = (t0 + 3248);
    xsi_vlogvar_assign_value(t29, t28, 0, 0, 32);
    goto LAB3;

LAB12:    *((unsigned int *)t15) = 1;
    goto LAB13;

LAB14:    xsi_set_current_line(74, ng0);

LAB16:    xsi_set_current_line(75, ng0);
    t24 = (t0 + 3408);
    t25 = (t24 + 56U);
    t26 = *((char **)t25);
    t27 = ((char*)((ng5)));
    memset(t28, 0, 8);
    xsi_vlog_signed_add(t28, 32, t26, 32, t27, 32);
    t29 = (t0 + 3408);
    xsi_vlogvar_assign_value(t29, t28, 0, 0, 32);
    goto LAB10;

}

static void Initial_83_1(char *t0)
{
    char t4[8];
    char *t1;
    char *t2;
    char *t3;
    char *t5;
    char *t6;
    char *t7;
    char *t8;
    unsigned int t9;
    unsigned int t10;
    unsigned int t11;
    unsigned int t12;
    unsigned int t13;
    char *t14;
    char *t15;
    char *t16;
    unsigned int t17;
    unsigned int t18;
    unsigned int t19;
    unsigned int t20;
    unsigned int t21;
    unsigned int t22;
    unsigned int t23;
    unsigned int t24;
    char *t25;

LAB0:    t1 = (t0 + 5216U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(84, ng0);

LAB4:    xsi_set_current_line(85, ng0);
    t2 = ((char*)((ng8)));
    t3 = (t0 + 2448);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(86, ng0);
    t2 = ((char*)((ng8)));
    t3 = (t0 + 2608);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(87, ng0);
    t2 = ((char*)((ng8)));
    t3 = (t0 + 3088);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 18);
    xsi_set_current_line(88, ng0);
    t2 = ((char*)((ng8)));
    t3 = (t0 + 2768);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(89, ng0);
    t2 = ((char*)((ng8)));
    t3 = (t0 + 2928);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(92, ng0);
    t2 = (t0 + 5024);
    xsi_process_wait(t2, 104000LL);
    *((char **)t1) = &&LAB5;

LAB1:    return;
LAB5:    xsi_set_current_line(93, ng0);

LAB6:    xsi_set_current_line(93, ng0);
    t3 = (t0 + 5024);
    xsi_process_wait(t3, 4069LL);
    *((char **)t1) = &&LAB7;
    goto LAB1;

LAB7:    xsi_set_current_line(93, ng0);
    t5 = (t0 + 2448);
    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    memset(t4, 0, 8);
    t8 = (t7 + 4);
    t9 = *((unsigned int *)t8);
    t10 = (~(t9));
    t11 = *((unsigned int *)t7);
    t12 = (t11 & t10);
    t13 = (t12 & 1U);
    if (t13 != 0)
        goto LAB11;

LAB9:    if (*((unsigned int *)t8) == 0)
        goto LAB8;

LAB10:    t14 = (t4 + 4);
    *((unsigned int *)t4) = 1;
    *((unsigned int *)t14) = 1;

LAB11:    t15 = (t4 + 4);
    t16 = (t7 + 4);
    t17 = *((unsigned int *)t7);
    t18 = (~(t17));
    *((unsigned int *)t4) = t18;
    *((unsigned int *)t15) = 0;
    if (*((unsigned int *)t16) != 0)
        goto LAB13;

LAB12:    t23 = *((unsigned int *)t4);
    *((unsigned int *)t4) = (t23 & 1U);
    t24 = *((unsigned int *)t15);
    *((unsigned int *)t15) = (t24 & 1U);
    t25 = (t0 + 2448);
    xsi_vlogvar_assign_value(t25, t4, 0, 0, 1);
    goto LAB6;

LAB8:    *((unsigned int *)t4) = 1;
    goto LAB11;

LAB13:    t19 = *((unsigned int *)t4);
    t20 = *((unsigned int *)t16);
    *((unsigned int *)t4) = (t19 | t20);
    t21 = *((unsigned int *)t15);
    t22 = *((unsigned int *)t16);
    *((unsigned int *)t15) = (t21 | t22);
    goto LAB12;

LAB14:    goto LAB1;

}

static void Initial_97_2(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    unsigned int t5;
    unsigned int t6;
    unsigned int t7;
    int t8;
    char *t9;
    char *t10;
    char *t11;

LAB0:    t1 = (t0 + 5464U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(98, ng0);

LAB4:    xsi_set_current_line(99, ng0);
    t2 = (t0 + 5272);
    xsi_process_wait(t2, 200000LL);
    *((char **)t1) = &&LAB5;

LAB1:    return;
LAB5:    xsi_set_current_line(100, ng0);
    t3 = ((char*)((ng5)));
    t4 = (t0 + 2608);
    xsi_vlogvar_assign_value(t4, t3, 0, 0, 1);
    xsi_set_current_line(101, ng0);
    t2 = ((char*)((ng9)));
    t3 = (t2 + 4);
    t5 = *((unsigned int *)t3);
    t6 = (~(t5));
    t7 = *((unsigned int *)t2);
    t8 = (t7 & t6);
    t4 = (t0 + 9220);
    *((int *)t4) = t8;

LAB6:    t9 = (t0 + 9220);
    if (*((int *)t9) > 0)
        goto LAB7;

LAB8:    xsi_set_current_line(103, ng0);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 2608);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    goto LAB1;

LAB7:    xsi_set_current_line(102, ng0);
    t10 = (t0 + 6776);
    *((int *)t10) = 1;
    t11 = (t0 + 5496);
    *((char **)t11) = t10;
    *((char **)t1) = &&LAB9;
    goto LAB1;

LAB9:    t2 = (t0 + 9220);
    t8 = *((int *)t2);
    *((int *)t2) = (t8 - 1);
    goto LAB6;

}

static void Initial_110_3(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    unsigned int t5;
    unsigned int t6;
    unsigned int t7;
    int t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    unsigned int t13;
    unsigned int t14;

LAB0:    t1 = (t0 + 5712U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(111, ng0);

LAB4:    xsi_set_current_line(112, ng0);
    t2 = (t0 + 5520);
    xsi_process_wait(t2, 1000LL);
    *((char **)t1) = &&LAB5;

LAB1:    return;
LAB5:    xsi_set_current_line(113, ng0);
    t3 = (t0 + 6792);
    *((int *)t3) = 1;
    t4 = (t0 + 5744);
    *((char **)t4) = t3;
    *((char **)t1) = &&LAB6;
    goto LAB1;

LAB6:    xsi_set_current_line(114, ng0);
    t2 = (t0 + 5520);
    xsi_process_wait(t2, 1000LL);
    *((char **)t1) = &&LAB7;
    goto LAB1;

LAB7:    xsi_set_current_line(115, ng0);
    t3 = ((char*)((ng9)));
    t4 = (t3 + 4);
    t5 = *((unsigned int *)t4);
    t6 = (~(t5));
    t7 = *((unsigned int *)t3);
    t8 = (t7 & t6);
    t9 = (t0 + 9224);
    *((int *)t9) = t8;

LAB8:    t10 = (t0 + 9224);
    if (*((int *)t10) > 0)
        goto LAB9;

LAB10:    xsi_set_current_line(117, ng0);
    t2 = (t0 + 5520);
    xsi_process_wait(t2, 1000LL);
    *((char **)t1) = &&LAB12;
    goto LAB1;

LAB9:    xsi_set_current_line(116, ng0);
    t11 = (t0 + 6808);
    *((int *)t11) = 1;
    t12 = (t0 + 5744);
    *((char **)t12) = t11;
    *((char **)t1) = &&LAB11;
    goto LAB1;

LAB11:    t2 = (t0 + 9224);
    t8 = *((int *)t2);
    *((int *)t2) = (t8 - 1);
    goto LAB8;

LAB12:    xsi_set_current_line(118, ng0);

LAB13:    t3 = ((char*)((ng5)));
    t4 = (t3 + 4);
    t5 = *((unsigned int *)t4);
    t6 = (~(t5));
    t7 = *((unsigned int *)t3);
    t13 = (t7 & t6);
    t14 = (t13 != 0);
    if (t14 > 0)
        goto LAB14;

LAB15:    goto LAB1;

LAB14:    xsi_set_current_line(119, ng0);

LAB16:    xsi_set_current_line(120, ng0);
    t9 = ((char*)((ng5)));
    t10 = (t0 + 2768);
    xsi_vlogvar_assign_value(t10, t9, 0, 0, 1);
    xsi_set_current_line(121, ng0);
    t2 = (t0 + 6824);
    *((int *)t2) = 1;
    t3 = (t0 + 5744);
    *((char **)t3) = t2;
    *((char **)t1) = &&LAB17;
    goto LAB1;

LAB17:    xsi_set_current_line(122, ng0);
    t2 = (t0 + 5520);
    xsi_process_wait(t2, 2000LL);
    *((char **)t1) = &&LAB18;
    goto LAB1;

LAB18:    xsi_set_current_line(123, ng0);
    t3 = ((char*)((ng3)));
    t4 = (t0 + 2768);
    xsi_vlogvar_assign_value(t4, t3, 0, 0, 1);
    xsi_set_current_line(124, ng0);
    t2 = ((char*)((ng10)));
    t3 = (t2 + 4);
    t5 = *((unsigned int *)t3);
    t6 = (~(t5));
    t7 = *((unsigned int *)t2);
    t8 = (t7 & t6);
    t4 = (t0 + 9228);
    *((int *)t4) = t8;

LAB19:    t9 = (t0 + 9228);
    if (*((int *)t9) > 0)
        goto LAB20;

LAB21:    goto LAB13;

LAB20:    xsi_set_current_line(125, ng0);
    t10 = (t0 + 6840);
    *((int *)t10) = 1;
    t11 = (t0 + 5744);
    *((char **)t11) = t10;
    *((char **)t1) = &&LAB22;
    goto LAB1;

LAB22:    t2 = (t0 + 9228);
    t8 = *((int *)t2);
    *((int *)t2) = (t8 - 1);
    goto LAB19;

}

static void Always_133_4(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    unsigned int t5;
    unsigned int t6;
    unsigned int t7;
    int t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    unsigned int t13;
    unsigned int t14;

LAB0:    t1 = (t0 + 5960U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(134, ng0);

LAB4:    xsi_set_current_line(135, ng0);
    t2 = (t0 + 5768);
    xsi_process_wait(t2, 1000LL);
    *((char **)t1) = &&LAB5;

LAB1:    return;
LAB5:    xsi_set_current_line(136, ng0);
    t3 = (t0 + 6856);
    *((int *)t3) = 1;
    t4 = (t0 + 5992);
    *((char **)t4) = t3;
    *((char **)t1) = &&LAB6;
    goto LAB1;

LAB6:    xsi_set_current_line(137, ng0);
    t2 = (t0 + 5768);
    xsi_process_wait(t2, 1000LL);
    *((char **)t1) = &&LAB7;
    goto LAB1;

LAB7:    xsi_set_current_line(138, ng0);
    t3 = ((char*)((ng9)));
    t4 = (t3 + 4);
    t5 = *((unsigned int *)t4);
    t6 = (~(t5));
    t7 = *((unsigned int *)t3);
    t8 = (t7 & t6);
    t9 = (t0 + 9232);
    *((int *)t9) = t8;

LAB8:    t10 = (t0 + 9232);
    if (*((int *)t10) > 0)
        goto LAB9;

LAB10:    xsi_set_current_line(140, ng0);
    t2 = (t0 + 5768);
    xsi_process_wait(t2, 1000LL);
    *((char **)t1) = &&LAB12;
    goto LAB1;

LAB9:    xsi_set_current_line(139, ng0);
    t11 = (t0 + 6872);
    *((int *)t11) = 1;
    t12 = (t0 + 5992);
    *((char **)t12) = t11;
    *((char **)t1) = &&LAB11;
    goto LAB1;

LAB11:    t2 = (t0 + 9232);
    t8 = *((int *)t2);
    *((int *)t2) = (t8 - 1);
    goto LAB8;

LAB12:    xsi_set_current_line(141, ng0);

LAB13:    t3 = ((char*)((ng5)));
    t4 = (t3 + 4);
    t5 = *((unsigned int *)t4);
    t6 = (~(t5));
    t7 = *((unsigned int *)t3);
    t13 = (t7 & t6);
    t14 = (t13 != 0);
    if (t14 > 0)
        goto LAB14;

LAB15:    goto LAB2;

LAB14:    xsi_set_current_line(142, ng0);

LAB16:    xsi_set_current_line(143, ng0);
    t9 = ((char*)((ng5)));
    t10 = (t0 + 2928);
    xsi_vlogvar_assign_value(t10, t9, 0, 0, 1);
    xsi_set_current_line(144, ng0);
    t2 = (t0 + 6888);
    *((int *)t2) = 1;
    t3 = (t0 + 5992);
    *((char **)t3) = t2;
    *((char **)t1) = &&LAB17;
    goto LAB1;

LAB17:    xsi_set_current_line(145, ng0);
    t2 = (t0 + 5768);
    xsi_process_wait(t2, 2000LL);
    *((char **)t1) = &&LAB18;
    goto LAB1;

LAB18:    xsi_set_current_line(146, ng0);
    t3 = ((char*)((ng3)));
    t4 = (t0 + 2928);
    xsi_vlogvar_assign_value(t4, t3, 0, 0, 1);
    xsi_set_current_line(147, ng0);
    t2 = ((char*)((ng11)));
    t3 = (t2 + 4);
    t5 = *((unsigned int *)t3);
    t6 = (~(t5));
    t7 = *((unsigned int *)t2);
    t8 = (t7 & t6);
    t4 = (t0 + 9236);
    *((int *)t4) = t8;

LAB19:    t9 = (t0 + 9236);
    if (*((int *)t9) > 0)
        goto LAB20;

LAB21:    goto LAB13;

LAB20:    xsi_set_current_line(148, ng0);
    t10 = (t0 + 6904);
    *((int *)t10) = 1;
    t11 = (t0 + 5992);
    *((char **)t11) = t10;
    *((char **)t1) = &&LAB22;
    goto LAB1;

LAB22:    t2 = (t0 + 9236);
    t8 = *((int *)t2);
    *((int *)t2) = (t8 - 1);
    goto LAB19;

}

static void Initial_159_5(char *t0)
{
    char t8[8];
    char t20[8];
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    char *t9;
    unsigned int t10;
    unsigned int t11;
    unsigned int t12;
    unsigned int t13;
    unsigned int t14;
    char *t15;
    char *t16;
    char *t17;
    char *t18;
    char *t19;
    char *t21;
    char *t22;
    char *t23;
    char *t24;
    char *t25;
    char *t26;
    char *t27;
    char *t28;
    char *t29;
    char *t30;

LAB0:    t1 = (t0 + 6208U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(160, ng0);

LAB4:    xsi_set_current_line(161, ng0);
    xsi_set_current_line(161, ng0);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 3728);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 32);

LAB5:    t2 = (t0 + 3728);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t0 + 3248);
    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    memset(t8, 0, 8);
    xsi_vlog_signed_less(t8, 32, t4, 32, t7, 32);
    t9 = (t8 + 4);
    t10 = *((unsigned int *)t9);
    t11 = (~(t10));
    t12 = *((unsigned int *)t8);
    t13 = (t12 & t11);
    t14 = (t13 != 0);
    if (t14 > 0)
        goto LAB6;

LAB7:    xsi_set_current_line(167, ng0);
    t2 = (t0 + 4048);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = ((char*)((ng3)));
    memset(t8, 0, 8);
    xsi_vlog_signed_equal(t8, 32, t4, 32, t5, 32);
    t6 = (t8 + 4);
    t10 = *((unsigned int *)t6);
    t11 = (~(t10));
    t12 = *((unsigned int *)t8);
    t13 = (t12 & t11);
    t14 = (t13 != 0);
    if (t14 > 0)
        goto LAB10;

LAB11:
LAB12:    xsi_set_current_line(169, ng0);
    xsi_vlog_stop(1);

LAB1:    return;
LAB6:    xsi_set_current_line(162, ng0);

LAB8:    xsi_set_current_line(164, ng0);
    t15 = (t0 + 6920);
    *((int *)t15) = 1;
    t16 = (t0 + 6240);
    *((char **)t16) = t15;
    *((char **)t1) = &&LAB9;
    goto LAB1;

LAB9:    xsi_set_current_line(165, ng0);
    t17 = (t0 + 2128);
    t18 = (t17 + 56U);
    t19 = *((char **)t18);
    t21 = (t0 + 2128);
    t22 = (t21 + 72U);
    t23 = *((char **)t22);
    t24 = (t0 + 2128);
    t25 = (t24 + 64U);
    t26 = *((char **)t25);
    t27 = (t0 + 3728);
    t28 = (t27 + 56U);
    t29 = *((char **)t28);
    xsi_vlog_generic_get_array_select_value(t20, 18, t19, t23, t26, 1, 1, t29, 32, 1);
    t30 = (t0 + 3088);
    xsi_vlogvar_assign_value(t30, t20, 0, 0, 18);
    xsi_set_current_line(161, ng0);
    t2 = (t0 + 3728);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = ((char*)((ng5)));
    memset(t8, 0, 8);
    xsi_vlog_signed_add(t8, 32, t4, 32, t5, 32);
    t6 = (t0 + 3728);
    xsi_vlogvar_assign_value(t6, t8, 0, 0, 32);
    goto LAB5;

LAB10:    xsi_set_current_line(168, ng0);
    xsi_vlogfile_write(1, 0, 0, ng12, 1, t0);
    goto LAB12;

}

static void Always_173_6(char *t0)
{
    char t7[8];
    char t17[8];
    char t27[16];
    char t36[8];
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    char *t13;
    char *t14;
    char *t15;
    char *t16;
    char *t18;
    unsigned int t19;
    unsigned int t20;
    unsigned int t21;
    unsigned int t22;
    unsigned int t23;
    char *t24;
    char *t25;
    char *t26;
    char *t28;
    char *t29;
    char *t30;
    char *t31;
    char *t32;
    char *t33;
    char *t34;
    char *t35;
    char *t37;
    char *t38;
    char *t39;
    char *t40;
    char *t41;
    char *t42;
    char *t43;
    char *t44;
    char *t45;

LAB0:    t1 = (t0 + 6456U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(173, ng0);
    t2 = (t0 + 6936);
    *((int *)t2) = 1;
    t3 = (t0 + 6488);
    *((char **)t3) = t2;
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(174, ng0);

LAB5:    xsi_set_current_line(175, ng0);
    t4 = (t0 + 6952);
    *((int *)t4) = 1;
    t5 = (t0 + 6488);
    *((char **)t5) = t4;
    *((char **)t1) = &&LAB6;
    goto LAB1;

LAB6:    xsi_set_current_line(176, ng0);
    t2 = (t0 + 6264);
    xsi_process_wait(t2, 2000LL);
    *((char **)t1) = &&LAB7;
    goto LAB1;

LAB7:    xsi_set_current_line(177, ng0);
    t3 = (t0 + 1728U);
    t4 = *((char **)t3);
    t3 = (t0 + 2288);
    t5 = (t3 + 56U);
    t6 = *((char **)t5);
    t8 = (t0 + 2288);
    t9 = (t8 + 72U);
    t10 = *((char **)t9);
    t11 = (t0 + 2288);
    t12 = (t11 + 64U);
    t13 = *((char **)t12);
    t14 = (t0 + 3888);
    t15 = (t14 + 56U);
    t16 = *((char **)t15);
    xsi_vlog_generic_get_array_select_value(t7, 18, t6, t10, t13, 1, 1, t16, 32, 1);
    memset(t17, 0, 8);
    xsi_vlog_signed_not_equal(t17, 18, t4, 18, t7, 18);
    t18 = (t17 + 4);
    t19 = *((unsigned int *)t18);
    t20 = (~(t19));
    t21 = *((unsigned int *)t17);
    t22 = (t21 & t20);
    t23 = (t22 != 0);
    if (t23 > 0)
        goto LAB8;

LAB9:
LAB10:    xsi_set_current_line(189, ng0);
    t2 = (t0 + 3888);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = ((char*)((ng5)));
    memset(t7, 0, 8);
    xsi_vlog_signed_add(t7, 32, t4, 32, t5, 32);
    t6 = (t0 + 3888);
    xsi_vlogvar_assign_value(t6, t7, 0, 0, 32);
    goto LAB2;

LAB8:    xsi_set_current_line(178, ng0);

LAB11:    xsi_set_current_line(179, ng0);
    t24 = (t0 + 4048);
    t25 = (t24 + 56U);
    t26 = *((char **)t25);
    t28 = xsi_vlog_time(t27, 1000.0000000000000, 1000.0000000000000);
    t29 = (t0 + 3888);
    t30 = (t29 + 56U);
    t31 = *((char **)t30);
    t32 = (t0 + 1728U);
    t33 = *((char **)t32);
    t32 = (t0 + 2288);
    t34 = (t32 + 56U);
    t35 = *((char **)t34);
    t37 = (t0 + 2288);
    t38 = (t37 + 72U);
    t39 = *((char **)t38);
    t40 = (t0 + 2288);
    t41 = (t40 + 64U);
    t42 = *((char **)t41);
    t43 = (t0 + 3888);
    t44 = (t43 + 56U);
    t45 = *((char **)t44);
    xsi_vlog_generic_get_array_select_value(t36, 18, t35, t39, t42, 1, 1, t45, 32, 1);
    xsi_vlogfile_write(1, 0, 0, ng13, 6, t0, (char)119, t26, 32, (char)118, t27, 64, (char)119, t31, 32, (char)119, t33, 18, (char)119, t36, 18);
    xsi_set_current_line(182, ng0);
    t2 = (t0 + 4048);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = ((char*)((ng5)));
    memset(t7, 0, 8);
    xsi_vlog_signed_add(t7, 32, t4, 32, t5, 32);
    t6 = (t0 + 4048);
    xsi_vlogvar_assign_value(t6, t7, 0, 0, 32);
    xsi_set_current_line(183, ng0);
    t2 = (t0 + 4048);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t0 + 880);
    t6 = *((char **)t5);
    memset(t7, 0, 8);
    xsi_vlog_signed_equal(t7, 32, t4, 32, t6, 32);
    t5 = (t7 + 4);
    t19 = *((unsigned int *)t5);
    t20 = (~(t19));
    t21 = *((unsigned int *)t7);
    t22 = (t21 & t20);
    t23 = (t22 != 0);
    if (t23 > 0)
        goto LAB12;

LAB13:
LAB14:    goto LAB10;

LAB12:    xsi_set_current_line(184, ng0);

LAB15:    xsi_set_current_line(185, ng0);
    xsi_vlogfile_write(1, 0, 0, ng14, 1, t0);
    xsi_set_current_line(186, ng0);
    xsi_vlog_stop(1);
    goto LAB14;

}


extern void work_m_00000000003979412595_1945381707_init()
{
	static char *pe[] = {(void *)Initial_53_0,(void *)Initial_83_1,(void *)Initial_97_2,(void *)Initial_110_3,(void *)Always_133_4,(void *)Initial_159_5,(void *)Always_173_6};
	xsi_register_didat("work_m_00000000003979412595_1945381707", "isim/interpol4x_tb_isim_beh.exe.sim/work/m_00000000003979412595_1945381707.didat");
	xsi_register_executes(pe);
}
