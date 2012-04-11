From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] tests: add new test f_eofblocks
Date: Tue, 10 Apr 2012 23:53:47 -0400
Message-ID: <1334116427-12406-1-git-send-email-tytso@mit.edu>
Cc: adityakali@google.com, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40326 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753011Ab2DKDxu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Apr 2012 23:53:50 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Since we have changed the eofblocks handling in e2fsck (by removing
the need for the EOFBLOCKS_FL flag), we should have a test to check
out how we handle uninitialized and initialized blocks which are exist
beyond i_size, with files that have (and don't have) the EOFBLOCKS_FL.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 tests/f_eofblocks/expect.1 |   13 +++++++++++++
 tests/f_eofblocks/expect.2 |    7 +++++++
 tests/f_eofblocks/image.gz |  Bin 0 -> 1364 bytes
 tests/f_eofblocks/name     |    1 +
 4 files changed, 21 insertions(+)
 create mode 100644 tests/f_eofblocks/expect.1
 create mode 100644 tests/f_eofblocks/expect.2
 create mode 100644 tests/f_eofblocks/image.gz
 create mode 100644 tests/f_eofblocks/name

diff --git a/tests/f_eofblocks/expect.1 b/tests/f_eofblocks/expect.1
new file mode 100644
index 0000000..2e9133e
--- /dev/null
+++ b/tests/f_eofblocks/expect.1
@@ -0,0 +1,13 @@
+Pass 1: Checking inodes, blocks, and sizes
+Inode 30, i_size is 2048, should be 4096.  Fix? yes
+
+Inode 31, i_size is 2048, should be 4096.  Fix? yes
+
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 31/56 files (29.0% non-contiguous), 83/400 blocks
+Exit status is 1
diff --git a/tests/f_eofblocks/expect.2 b/tests/f_eofblocks/expect.2
new file mode 100644
index 0000000..2a2bca5
--- /dev/null
+++ b/tests/f_eofblocks/expect.2
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 31/56 files (29.0% non-contiguous), 83/400 blocks
+Exit status is 0
diff --git a/tests/f_eofblocks/image.gz b/tests/f_eofblocks/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..2586a6a7670ad609ba7e66911a8f7a8f4df96321
GIT binary patch
literal 1364
zc-rmFZ!nt&0LSsDTX9x)bHkO%YDFg^OI56AWUWQ5Yo^xKzpAW9s@g_QQ;VRUZO3dv
zvTTzSC2cYciTG3N)Suv#Y=lci)MAN=i3&}V5FSaMXMMRBd%Ji0y!gHQ-Ve!ib-iyZ
zOWfz2OSzOoMr{5;{Q5lE*X23Qc;=80JicDVN`HkCCcS%%IQrJd3AYLAm#5epaR<8J
zc+)@k@RtJbO+i9i&8P1dqbke1PrRfMRM!g#*{$x?zr^e`($-is{Zz4H^p4iE@wlfk
zMh9qg3~g=1Qsm_4Pp`%){d&U;Y~AWR9^+lA(os1ha;8}S_=)UP(zZxZxb`63Fn|xQ
zs{Wyc%a4k<dVja4!jNVy@z*-C*Pw-*0Q;)WQwr==_}F6m?S|Arc=#TQPZXQyNCDv9
zpL&%iV0vuCYoX!#YnhbBnD#<(zLn3&AT|sMG(TO;i|KHZ7kBkpsT46hBGMfE^}uDd
z_C`5kX>ZmQz)eRU#N0Hw4Hw+g6z%VrOL>Gf8n(~3n{##{kpxnX<ame|i=Qtz_gixQ
zDjfWow%NGR+)d(<dzg@-Hx1XakyVnXFjkrvWTei*ETvarj@Sx7T0)Q3OXofrJMQzE
zL*q-zuwrA+Zn4F3fT~!}D)~TRWSW{@6mbN&unL2+`I0iX632Ec*Je~glD^n^URui&
z!<HCu&!t&`adI*sJE4D@FW~Y39s<!^6EDm^Y?16;O7C{whxn)A-j@8&uKy^4kM7K)
z(+rM@(t)>e=GjLB=9Hpz7@5zN%W&fpL$uy}>bYd*!x55S%9X7vC8@LOXcHv4Xi_iB
z=?n>jkK5r#Hdv)axU(Dhv<gQ~va&km5bO|w5M2#+afnHB-L8!qe@$YDPT_aL=rC5V
zBCNkBFiXX=v57T!|Go>tuR>O+^~Zp_Xt<-&zTgH%2h!<ER`{xP2o1y$pgU#uTO3=q
zawvQi|AY(B3D9DzS?3+?-*-yjLC3;D6wnW4)(5R1nTtFjs{ji(QNa2(>qwdX9LL5`
zw!Y|;T&XA!IB^nsDszOc-}JFaThIW5Pzs!c%4O(wi+#d~m-DM}A<wYxUS>>uURr}5
zkA*d3c7mJ1D3PI21rX|0i%-Z(RNw=V5|o^oLf#Gq^0<QmczEdbxp%o>MCdd4GQ?d@
zW!sFbO8bj<9mkfbG`WH5V7asj4I~ku@5=06oD0c%kS&D<ISkVBHmUAg;OLFX)3pFi
zjya+N61OCC!86FZP<)ABAGv87u1Wvh&I?)reEP@*jqsR#?wfglF$&Rw8*LwD{D#Vf
zlGIECscz%e^{CQLn&lHvuAly%XFgpAC{<%1wN2)N_}_nSNo$JwFpT;T@!o#K-*%5Q
A2LJ#7

literal 0
Hc-jL100001

diff --git a/tests/f_eofblocks/name b/tests/f_eofblocks/name
new file mode 100644
index 0000000..d93adc1
--- /dev/null
+++ b/tests/f_eofblocks/name
@@ -0,0 +1 @@
+blocks after i_size
-- 
1.7.10.rc3

