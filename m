From: Tahsin Erdogan <tahsin@google.com>
Subject: [PATCH 08/12] e2fsck: add test for ea_inode feature
Date: Mon, 26 Jun 2017 06:43:44 -0700
Message-ID: <20170626134348.1240-8-tahsin@google.com>
References: <20170626134348.1240-1-tahsin@google.com>
Cc: Tahsin Erdogan <tahsin@google.com>
To: Andreas Dilger <adilger@dilger.ca>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f172.google.com ([209.85.192.172]:35883 "EHLO
        mail-pf0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752469AbdFZNoH (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Jun 2017 09:44:07 -0400
Received: by mail-pf0-f172.google.com with SMTP id q86so720891pfl.3
        for <linux-ext4@vger.kernel.org>; Mon, 26 Jun 2017 06:44:07 -0700 (PDT)
In-Reply-To: <20170626134348.1240-1-tahsin@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

f_ea_inode test covers the following scenarios:

- a file that contains old Lustre-style valid ea_inode references
  in inode body and xattr block

- a file that contains new style valid ea_inode references in inode
  body and xattr block

- a file with an extended attribute that references an invalid inode
  number (e_value_inum > s_inodes_count)

- an ea entry with bad e_hash and points to an inode that does not
  have EA_INODE flag set

- an ea entry with bad e_hash but points to a valid ea_inode

- an ea entry with valid e_hash that points to an inode that is
  missing EA_INODE flag

Signed-off-by: Tahsin Erdogan <tahsin@google.com>
---
 tests/f_ea_inode/expect.1 |  31 +++++++++++++++++++++++++++++++
 tests/f_ea_inode/expect.2 |   7 +++++++
 tests/f_ea_inode/image.gz | Bin 0 -> 1389 bytes
 3 files changed, 38 insertions(+)
 create mode 100644 tests/f_ea_inode/expect.1
 create mode 100644 tests/f_ea_inode/expect.2
 create mode 100644 tests/f_ea_inode/image.gz

diff --git a/tests/f_ea_inode/expect.1 b/tests/f_ea_inode/expect.1
new file mode 100644
index 000000000000..aaa0bead9c41
--- /dev/null
+++ b/tests/f_ea_inode/expect.1
@@ -0,0 +1,31 @@
+Pass 1: Checking inodes, blocks, and sizes
+Inode 17 has illegal extended attribute value inode 4008636142.
+Clear? yes
+
+Inode 17, i_blocks is 8, should be 0.  Fix? yes
+
+Inode 18 has illegal extended attribute value inode 19.
+Clear? yes
+
+Inode 18, i_blocks is 8, should be 0.  Fix? yes
+
+Extended attribute in inode 20 has a hash (1145324612) which is invalid
+Clear? yes
+
+Inode 20, i_blocks is 8, should be 0.  Fix? yes
+
+EA inode 19 for parent inode 21 missing EA_INODE flag.
+ Fix? yes
+
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Extended attribute inode 16 ref count is 51, should be 2. Fix? yes
+
+Extended attribute inode 19 ref count is 2, should be 1. Fix? yes
+
+Pass 5: Checking group summary information
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 21/32 files (0.0% non-contiguous), 18/64 blocks
+Exit status is 1
diff --git a/tests/f_ea_inode/expect.2 b/tests/f_ea_inode/expect.2
new file mode 100644
index 000000000000..f9276fba341d
--- /dev/null
+++ b/tests/f_ea_inode/expect.2
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 21/32 files (0.0% non-contiguous), 18/64 blocks
+Exit status is 0
diff --git a/tests/f_ea_inode/image.gz b/tests/f_ea_inode/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..68a397580d2ecca9fa30e33528a286419c757c7e
GIT binary patch
literal 1389
zcmb`F{a4a=6vw~I)`M2G<2*f}kh8Efou#81LrN=CThJmON-@huhNxv?o59zeRx?|&
zGIh?>mQ#-vGQi@LPsem6C8C+4_<;F@CF(>J5x(Eg;D`MIozwl{-q$(zzVG{-doKR^
zvSnR*S~z5r6m!xemL1JJ?F~)zsjt(IIzs=FB#$#l6~$X@*Lm!5K3-+(N7>N&nisek
zfj+a%j}CPTW7Z=#D==>Q9KRal-&cO3V;nl727-S}AnV7DV3uP$FSiA^a#{-3r8qIW
zisbL-jZKC^lA*W8z|-_Uxsz1my(2Jf=}~Gr+4*Zf{V!wp4=F-ic7<NsslKACZ&>3W
zllAVM6f|$l^I{*L9(bz~Z|@L4SQvaltFF8+)~cx>k*y9eQPB8~KciY0=x`Xq(e6Bq
z>)W=S7BRP&X`FlG;#6X@6o(8-^RY0ZI}i8vM?8w>;9ixunqT>pr<R3(3PEQ6Ni5~D
z!rz-*398)KJP3mB3Jy|J=)qRvl1ryB7GPI!@Vm_@%Ogbl{m%}GGyixsh3e|U5MEMA
zsY`fP4(nEnS466N7BAo)fyb35t?N|V4}Pan=AUX*VpJx~!#hcuhJp8mOElo%tXX<7
zGFga4hWAkWSQ^Tif(If*Qg+z%<#8k~q-D|UMA6RLA1xb>7@l?%0e20vvuEBcC6E&Y
zHQBv4fu9x`z4GiSA(`y#391ZocYA-ui}Z2+NV8*idEDr`3vtZkpz_a4uigmC%@ZEN
zKD<3-ce@bGcpEkGLTL_|JBy}B;Ut;4(VX8=Vw|Fw_InHx8_ySBXNXIN)nr9-a~|9U
z9vzs$j4Wyot5i)#nb>7^BY8tG>zF4pkMH(1QfmVvsp+zELkJZmpL5wC0dHlFp5d9x
zUah#?KQ1)WNvNG2y$94NNxWZSSQG(_>OyVM`YA9w(+v9zs~>vG!Gd?}rS)G_P%@=K
zY@l4IP0`fp5ehK?&Gk+FCKqSp{Mzil%R7MMwuU&s-!NJBOtK?$1^>p}O8f*Vd@~*!
zF-+*|%rL*uyaWQQaUR$B{}JTTHn_}UXArqZ<kgx|?RCC-YK-<aEb51gl?gG47jE{1
zkWg1jZw^s`9l^u)_u8iGq6^38Pxu-`UF4M8cJfoAV<JG6XT#NKyARO5xf-r{%B?Rj
z!P6$+v-{98iz6~Ac*Hspi*~T09lFasB$+^wswVp|*1CD9T`eDja}*`y25;|1dxpB>
zV0Z+?6F0FW{tYh0R3|5#JBD6i7|CjBZtZFslhwbR<zLd#2yDJ<HabwcF*mP|qW-;+
zh>jkV_>PyZ?zy!xZ$I~suH|dP>NXYESRXRj-ei=R04xyd!6y)uMr;>X39R5y46OYL
zD!^NcH6~ehT*hV#B!X)SWv0T=@|SWE;rX}_6XU-x#Zl%evwyO2%c|$GS<`K>Z1=*B
z076Dd4nu5Fq&*hDRxYu^9L<s;Rln8*qLBOZT!g%A8U^}kD7rNjk+EhCV2!P?AQ4b3
zQ(GDC3*fW`?oJ5wU#+qVKRi_5a@_2%ZsQbnb4M#wv^J*zU7&8SXJE$Vb1GWE9iP=F
zFPWS6is*R>k;%2W4F|RqOldCE7C1Bb?LmT<%O}Z0hP&B3>W3SDOhsDi3m7Em(jjOu
F^dA(df!qK9

literal 0
HcmV?d00001

-- 
2.13.1.611.g7e3b11ae1-goog
