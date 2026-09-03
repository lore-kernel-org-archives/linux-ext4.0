Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65D2B513575
	for <linux-ext4@vger.kernel.org>; Thu,  3 Sep 2026 22:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788472983; cv=none; b=b8ducNX/qKrLzrjrFkDRBSjfC8iEqjwLUQTLIR6XRKEhewKHkuZ6SzlzrtJUuv+aqmmEIPCyPBAIaPXO+hV+ayvwaw0nsNyh6AYlfK4244nxq17p7t0KOV061vmP1NfhcyhEEbnFZg9Yf8CnjlcXwp9VxK31AdjxgGPi5qqN9ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788472983; c=relaxed/simple;
	bh=D+Jx0NvFWIpAf+7wzNxOo2LUitB34CmS9aOrlpsG0vw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=smlaxHua4qhg1xhl0uIjX2yFpUuAVO6q8SzcIy+tsHnE4fZAcXcOivjGJRNSMjDXknif8zZWIfFW8Dz5hq/yZVFqbycRC3ik6vXBQ00RijEFA4RwxD/XnJe0UpF/xoZmvDTEA1uScEBySDA7OzCsUwzyLPHWIgMSqA+KdkjzfBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E88LHEHw; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E88LHEHw"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-49b0dbfbf7bso2850165e9.2
        for <linux-ext4@vger.kernel.org>; Thu, 03 Sep 2026 15:02:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788472977; x=1789077777; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=poTA42jwoCeCB63VFf3Z6kxFqIALzuhJ1m2ctBrtkP4=;
        b=E88LHEHwATGE6frxRWrv1IhKamtXQgrPVdi2E01wiXUR9wgOfdav5B5loi7ImTOg50
         cUaj00ZFgQnxZwGPh/QQISjLthHkOUbkrG+JDqjd2jg/wnVp56w/cMjWi5vSkV13DIZc
         OHtSPi9kucCdjP6BIq3oAKdQCHygkwM1hJ7s6j7SajhTw9Qa0D6GpHF739b1uI3YT0EI
         8ikgZjwvnP0WpmImlTYDKg0kyuKberNCjsXVruexo+tvyy0naIInxkDs9FcsHWauhJrZ
         LAirZt9VJYfN4N7KS4xvttTjwigVH+7x4HuKIALR2/lXLLYoXkgilVY7WuEFZrLUucEc
         Ajsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788472977; x=1789077777;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=poTA42jwoCeCB63VFf3Z6kxFqIALzuhJ1m2ctBrtkP4=;
        b=UqOxBtFgdSf96OJQzfK3dBQFEP95vnDnZD4m0XzYpetHFic41PLaVdOdVbF2txBIq+
         81YhwZ+z8YYSdm8HDXyiHyieH9lQMZiYMenWqQuVv2GGuFkNd4H6/bSmJqU/7IdWf4m3
         99pi44VSZxTWSIO+hHrbe6ivonwPbk4TtfZt6ZfInDu47TF/X4O/fknnPuILBn0wK4XN
         srxzHUUG3NxbaBzirq+TrNJoiCHX++kkHgrvxWlUs5+ppHrjF2q1joRkHo47KlI+hoEJ
         5XWUuBbsvHB37Z78mVbzmJ9aqzytQzbg7euT+IPkGzyu0m2PmTuiRQvPW+Ih8AJZeBH+
         Ahbw==
X-Gm-Message-State: AFuF++kgEDy1E07wrRNfojxOODpHi3S0Lyb7HNmdz9TTy5fcFLFgILk5
	wYSJ+KBNIenqAFoogh5CzVpYhCUHaxyyzasDpsEwiehMKNVFOJRyOgC5ZbfCdFZX
X-Gm-Gg: AYBFou2Ip3lsykvPNhBlroFAakPtiOlEhcV7Fl0YxWHvomvDkus4BCAcUDEF/Z2ww3s
	lrg/feaGiVko2qNOudIz4AE6FzK6jfBcjuf7lwt21ookOtza+0k8upce7lx/6CjCiDsCDtpKZJH
	btBXBOSMKc9ettBb61JTmIIUFym85tolEPPKIU7WHH3jWJnwgwjw2SPLZhoUTLQ2kxAXHVkZVKK
	jibqSBN5EvIHWYeY1D+98xLbqFq6NEq1w8egjEygZ/kHHrEOlo4uuS6sZhOrmsXrBK3M35arZIJ
	Ok+wBpomOwou4Bddnqa31+EVbpM29i+Yx+Uvks3/Nil5insSvX3J3V/TaJJ5TkcZxcAvBoxIB0i
	l6J0IbZRjFm0X+zl3JRzLiw3K+ivlXsS3cG3UHZ6aBwnyIwdl/UDYXG91Qm56CwnTKc9hfoD44W
	MOY0mOAuaAYjnDbazmfJiMdwmmy3dbuwMfXYtZo+pP0b/mT29fF2+q3IsKDLWKN/PDOpU8uIDz0
	kUC065VpPMjvi1Fxx9hSikFw55qy84=
X-Received: by 2002:a05:600c:64c8:b0:495:4d5c:903e with SMTP id 5b1f17b1804b1-49cf81f692bmr18225535e9.7.1788472976937;
        Thu, 03 Sep 2026 15:02:56 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cee3b0af8sm104346975e9.0.2026.09.03.15.02.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 15:02:56 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@whamcloud.com>,
	Pravin Shelar <pravin@clusterfs.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [RESEND v2 12/13] e2fsck: add test suite for dirdata-specific optimization
Date: Thu,  3 Sep 2026 18:01:45 -0400
Message-ID: <20260903220146.19752-13-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260903220146.19752-1-ablagodarenko@thelustrecollective.com>
References: <20260903220146.19752-1-ablagodarenko@thelustrecollective.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Artem Blagodarenko <artem.blagodarenko@gmail.com>

Add comprehensive test for DIRDATA-specific directory optimization scenarios.
This test validates that Lustre File Identifier (LUFID) and Checksum Hash
(CFHASH) fields are correctly preserved during directory optimization and
rehashing operations.

This test ensures:
- dirdata preservation during rehashing
- Proper dirdata field alignment in optimized entries
- No data loss or corruption during rehashing
- Directory structure consistency with extra fields

The test filesystem contains pre-populated DIRDATA entries that stress
the optimization code paths and validate field handling.

Signed-off-by: Andreas Dilger <adilger@whamcloud.com>
Signed-off-by: Pravin Shelar <pravin@clusterfs.com>
Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
---
 tests/f_dirdata_optimize/expect.1 |  10 ++++++++++
 tests/f_dirdata_optimize/expect.2 |   7 +++++++
 tests/f_dirdata_optimize/image.gz | Bin 0 -> 32121 bytes
 tests/f_dirdata_optimize/name     |   1 +
 tests/f_dirdata_optimize/script   |   3 +++
 5 files changed, 21 insertions(+)

diff --git a/tests/f_dirdata_optimize/expect.1 b/tests/f_dirdata_optimize/expect.1
new file mode 100644
index 000000000..52368d33d
--- /dev/null
+++ b/tests/f_dirdata_optimize/expect.1
@@ -0,0 +1,10 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 3A: Optimizing directories
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 102/4096 files (2.9% non-contiguous), 686/2048 blocks
+Exit status is 0
diff --git a/tests/f_dirdata_optimize/expect.2 b/tests/f_dirdata_optimize/expect.2
new file mode 100644
index 000000000..3cf9314e2
--- /dev/null
+++ b/tests/f_dirdata_optimize/expect.2
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 102/4096 files (2.9% non-contiguous), 686/2048 blocks
+Exit status is 0
diff --git a/tests/f_dirdata_optimize/image.gz b/tests/f_dirdata_optimize/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..fcb7f4f866cea3160b77da4998ec69c0817afebd
GIT binary patch
literal 32121
zcmeFZ2~<-_w=Zr>D=I45h)hD-2~<Q>KxWcP3jzX82r@-QL}ZAOc}U_2DwBeM$`EY@
zlqoWXIjBIGgCIl<5FtQ-03n1BGM)1dpx@W`zPr}{-TS}qt@qaYvRIIFs!pA%UAuPe
z{oB6+7PV&0%B~9A6%w94mpt58O!lvJ-r^3cWqTx>p4)P+D(^(b{siHdQ>Qx){wkxb
z74`Vj!A%MEMh3-aD_O0D`{VW(O%@-HJ5W;CVq+~;(rQ^$We~&TO}77fchCO6=DvYE
zOic{Auu`i?tEE!vQ|_7gU1ASTWZapMldHq_>U5C<3i@AW%9pvG5_J|wh8?ixocd)S
zI@!9ntV}EUd62tSW=xFXgYJY;OYX&qk{ylM&ofU)w61D=t#TWvXuT7EnN-&2D<PwG
z%;Mdq64gs+Ii0**@7e1mCukq$t6$T(4s8zdud~#XqbFZwogJMFbVYU)vWr@-wavvu
zdlhC&cK&wu$hH&L46)=#sww9aclSD6M9{rLjf3USnQ9;IIf~6&`{E-x`0a~Vt5$Z*
zzSN&9jW(EpQ;$+kH_IekFRYE<WwH2kjx<hLsQS}hIT0g<cacf_i7(wJiNm)9jt7>?
zmupSrA0A+Vc7a!P-jZb(@*b_K$R5>&f3!<pE{1-;0i)(vAUd&4CD)m>a$#SkvEJ7J
zk=L#3S2XwR3-oVO-=~m3H&E$8=)C7yTTLbR!TUp;y_H5hY^`lt#}eZ8wLNcy-gLZP
z!TIWdt}Zr_h!<RaV;GmP;nW77RmbUCQD(92WYj==h_cgZ%nb+s8*i_BDMY>tOhT1i
zM=F@V-I#=WWANc{>=`x3hR+kbTJ+3TIW`nbTxrp34>7t&oIRARR-6#9t*6&uqjX{H
zPMd<*owg;huPYo#pR+EI4rMu!3S9E&Wm@~`GabG?D2Mj}+f*(qo8NOJJ-O6_I#(93
zP5F{C=}$*e!Ra29bFurj&5CZyk@b$GK~xXw&mg8=VPwFzfJ~?wQkgVY9P1W#frP5o
zpf`5>%GAq^3)nV5F^D};9J@0im;M&hgYw5R^+xwI^^Wu!#424>Fu$Mfqa2yxKpK?D
zqdz#u)H~c}5UY4a*&OGlOj=(W>(&KzZhecMf&YVmZAZQsY=lG2$&ZR$>6cp68&5M7
z$kjuAR$5V{82eA^(M8IuCc^1L^T3|3xvf?=)wXJ>Tndj<c>46kv(#@0m+w_@TjBTO
z;%KQhmhOf6*j7|8oy${V@KPI0N^90CtljG=?(za;j{VR81I$fvnipRPR%7yc;19)F
zoOxvrK83gP#6R!&e@Xaz1%Htm3*7w=JsL0bb&o4kuzU^^Fp$7mtam_Vc0PjdSCyDO
zyEFfv^(+K(?o}X#HHhvQ-(>HV@0=xBtZ?=&0mo*=HhlS1R#kB5d_!>&s+@Sp=jzEA
zA=mfPNr`ArE4OdW&q|ME`b572%5Iqj2v7X2XS*yq*%V9hhsf&0iETvfwqe1ee!jx<
ztAe+`YX-kQs@zUA%|P)*8E&VaGw*8JZHlXG;>uQXBtKq_srG`$m2~Al!@R|hPvPS2
z%DUeWz)6o;*LUK+T|qAl6Ty2Gr9>_t>4!1HKi8xZ*S_ev3=hV?n8FhXTLr!O)`j9Y
zA00FxRQ|vrhRx2PBLy!8054<kt9K`d()EpOeN&CWLD-dunbYqFRJy&v-nM~(%Zp_O
zDdqlO=jNr?<3oj#=gVBB(!pP@JuLObXg<JS6(UTov$iIr6VofIcbv)Fr=HVd&*=o6
z-2X8lo!A}d8#N|t5U^TeTWJ@$=wsNYGz`oq2N#s_k4o{oy4|^APNYF29bN<c^Y%F(
z>k#S59PjyyBL=5wu5f5cm)T&7fB(mPT67X~?~=jYV!3agsbCi8C<B}+Oa&PaHWuog
zlqG|&Nrm8YW##_NF%FnF=~B<cri^eAJ`>jnu{j2>U#5ZtjGr$y;K3Bk0b^XPseLYA
z+NBFNJsPFjL4^0fR%XG!T4Ud)0Ke;sxBF^%>0x^TZVKknd6AfizbOU~NcxKIM%Pp4
zCdXdbpF6BdDrpnjNrcggzhIigU1?On8V(P;e)F;!?rG~Qi@RM3U1z$OegXe5Te~c>
zcOdMzLaewbZAEv-`9>$KxlPhet8z@c%*$|}=l5Sfs+5fj*b=Rjl82q{GSexLeY(Z4
zVI;8SKqFb1-smUZ|2F3Obyr_!YC!&nb;;5vTi5KSkYiLA#C~wMq6T-_trW`L9sd*=
z>4GeIRYy*ZoSDIBHzh>vA3b^F=7c7KPj|gj>5`mT*po;amP<JkCUTaeZn*yFHuE_n
za%O3RY2)+4WkJ^#k+7zrK{>UluCn}$@w3ppHM0n9BX@rE1*s#fXM_Vqq6M7MnSFoe
zSvb&+TdS+5R5@yN2E9kK#)6H{Yi(^98*kpdGi+@9seWY|MXA_Z<SkbAUff%xOG0JA
z2=*V2mzyIb*7`757d~I<$}ZfM(iR{}INU>T1RL@Q?q6<$c3j;!f!297<?FY9EZy-v
zM}o4w6#YB+wCvCk$I4JuX<87pXgKib6B`Gv|4pBHYu|+m3GZ$gW03>Gm*oT@XKXhW
zM5GJ=fN~BE$oo2-_c?Pbl^CQ$h40R}kz+wd*!JV1ehRC*dtF}Q&6*x$RNytdGrq;P
z_MzU|+j<IVla>Kyn`}P38@tnW!=Pely}#+fW1Aiwyti}ZlLyDNFK>#{^Ea0khnd#B
zRttTl`&)-3`pJV`bEeqT`&ZW2_MZ6g$D17+?%vqAdZ)62{GC^Na-VLfM9{;dYgd(R
zdS15Xg8W18;os##<nKp4iThmk>#99<@>?$LKTxl?<<sroqDk)0ZasW<uc>UC{dY^}
z`+J`~%0X?&uMa3w(Y>gcNjK}emx7Y=t@kNY4*G7>cfS%PJzbA}c3XHzM*92F){mya
z@<r@5D)rl1>y27TZVtCd>|eJIS?vFKHdrx=y*|C(FIYwM`|<rBtb!Hr7x%i>AKp(|
zms{r*tc?6_U3K5iAx0-yiS^wjw>~Tw2K#OrelK7_9{2rhcm$cfs>e;Drq0a!qy2(n
z#@A?#uaA&38l{7V-Xz|_FYwEffkSGOAIS@=DhnjT3Z#W>b<8K$f&_L*b6YKK&s|_<
zmD1$QEw!reF{@{enra_&TlfodE~J5L5u?{`uPFXgz1U2t__$%Qxn$}s8PsnpQHKrw
zk}=r1ChPk-{|}ye$}XtY72D;vuQ@LNar5mHe{NSi^x*imir13ue;S4UB^SE$7j%c*
z!xP8gbEFF=8djvnY+3*3zRrVd7#9zAKDoVJ{*m9I^^8k;?W8r%x1^ptjCy?kNu$}u
zn@=K7m&x<xW2{cyIu?C&bHmV?XwyU6_IwC-j#&HbfyJ}v7SyWzI=g3g-jyj*zB@Wc
zGEowlmkfOCtjiP#-_Q3&P*IZ8buMK}yzj1kkqTunE%pkPy8TA?A`dCWeLvm$!MXKQ
zxKYHa;BB@Sx2M<bFuI>rAW!~&!6=f!Ug=u*Th+Z}_PV4YyZxVT=GIzPMNrtQ2kM+0
z?sq%fC9pRR)H_y1^4Pza)R{X(#<AC$)O##!LtHdI^4-e2PBr{K{`8}^uXpkmR?{vk
z)qDyJkAuzZ47{j@`FKDSjd-sV_Fhi-9!4C}6~)45)PRq_h++<pNtk)R|0Iz<b4ORP
zR&vAVH8F!xs@K-R7hWs8cnx`ZzvXo(`gCla>QGU>vC^i_VohDs*aMrf=-*TCoc+8i
zYtY}nUSTZa;=SLuTv}uP>yFL$uhsp&6*U&Cq9?;1d+0hA^XuGE#I7A{#T_t@?Fte%
zj+{BT>D`G>zo*{)aKe0b#Kk@B^#@ZU2lZe(Z~SuLPt^m*wwmow(r-MjVm5er*iHMu
z(O=dbT76tT%IeU@`Wr8QrK1#7FYZviboc;Cw(K|iOY1U+t~=lLLMi8yHav?MFWam;
zc(w126H3XKq+BKwH0axRHw*>4`W@3+ClS1<Xl9d2gSXKg^Fxw;hom`d`K{kkMz`+=
z{}wf~CB5OY(OnPrwsewI@Mf!--&`Bi9Uj>itZyk;sm@k(B`F2VATP<DciS+~U>Hm}
zi%s7|##Y5i&ulmOXb>K4JG0m16Juc|v)~uR<()?c)x%@XcsFeIuGd}IN}W+IrH6@b
z!3rb{*)oBH9-=$_U+-3bjTA4)5(k4sx8ZELjo*<^kA|>Ck;*DF_vETRuQ0jx!0g(3
zg!a+13m;%@9osZE-AcN4zvtTB(rc0PW4B~(?65iZyN#K-|1pnW2e+g?I-s{9>$Q6O
zAG*Kp{PoouQ@tIV9`5;b=jwt7ra^PH&mWlE&K*PUdMPc~vDsoQ63~-slD}2-<j(CA
z#}!u(Zd-3=aQNV_rl<oEgGTE~eEHi_H?|)}Z7w|cTW{mh1G5L$$?b%_My*|U>cOEs
zA03<@q4q>b?3RyfIrxjrp|uGp{ruX*vUO(<%G%QvouimHjD2ghPm*HF*6Px?_C2EB
zFr2PUE0YSMtMo+)4@&UdR8?y4KD!?|bMPvCv(Y2{XHg-~;z;jT#L?I8uS;;amo=lk
zm9AhE#h5X2t&MWHlRR_S^~0H}NA3=>vJMX^GX?{-DZx@X?-jjfjtqRLbco{3n3&W?
zF05hB95VTkwXhyXm&zrr4u2T)^&Wmk$Fe}d>AfuNyOZ~)ps%qkwgjeb<7A!f*ZVlO
zRG^#m{AJiY-Ch(yV@m>c2)$dx)2m0?IIzIrS{c_FGl_+l+ZDTqg8bTb=eOwYGKURh
zx6;6IoYZ=){2|YiMNtjIBXQ09_coE=&HIjcul%Q{^K)NWyyL%qoqrlJ``mNvIJ^^q
zvu??p51Ijc3C$^AW5&JdN7|{!zfB3eosY`4OJo*dY7m5v+su!C4%Xco=Oww7VPM%%
zfl7IlsMw-Ag&R45fK#{k*ut*Aiwo-@85ZNO8n>3bn`J&Xjo77D;frj?7N9`c<WKa2
zaYZ4b`au=aW<;Kgh#Yt$JuO!h4hU$jveQKsBidTYMdzNA&}Bq~9x0S~YJ`-qEl@wZ
zijtiZCH~m;tU?9G>#+qZM}^hGmgK|)nZ~<Az=jyhM6YVqJ&a4H*_py>6Ji?1d1Z9V
zK73^P$)1*$px^y4p_STiwP~v(pW_dY_D^i$7=HmSw|kTxCbR9uoMx-%xJ!<}HZ8)`
zAj7F9{gs_7F}!>>8lTc)m+j2hlG}#4Y7#d$1;hw1n7Vyy40#yF%z~v%;LJ;0jqHpH
z^u9hpJaamCrZQl^T|QUwO*H31A*Q*!RcNSvMZ7Y*ET$ZT>EV+iBa>)xH3$S9=tEZl
z{2GBKx+*-zQ--m7IuD1*jhkgYyg0ob>+OpI-Z&cBWHgt!3WPRi8M{Y>cM&=ud_Zup
z1?iH%@V=w*>)U5zv-~l>K!M}OW9MS9?`Whh^0Nxp@-hNOph&ukZR)|@nrhH+N!&*X
z9iRHz8e-ALOCF8909dxjA~8%|#@XwAHAmtY1-*#tVDJ&$OpVm!#b?X?wGjmNtzQ|8
z;aJqLq3YG7=(hHKdu}l27yG02l&_e3RTzcY$j!UV&v8g!c>M8D?BkW@zK6g7SK~jy
zO1)irdT;8UAWm&N^H_f$<<da2j<jFM+-!+<QcFLndQ_O`B>lXoBDhc5B#wi9`v>LC
zEE^PvSx=NfM9<6E<a7VAvc73vRng8xWM2;w5hJrdv$cCy@u!v5=Ezgbu?28#b2T00
zviAvsBe#y;Jm(l^NfK8cz~9(btxsG9m5I6Gk#;o*I<rKt9eg>Gomw8AksV0lhrLx)
zW+3oX@I)+!LdY8gTpV(^>PEBNoHi5?*-K1gUdoRdnY9!W(s2XWeJ}=V6mY2|O>Jti
z)A!?Bc7MRaPIXNoK8Y&_O2H>0^zDJ5Sb$b=r4noU`pk%<W;OX7AY6%G#|(0ztWs~&
z(W2P0sFzTn8_W0Q@Y{`HA7~2q79Q6{|8eWrkI@CY=(i$16YlMQ{Kw%W4ejs~N0L4i
zJ~sPZOYr{cn_KYRq=t(!N_P@A8Gf~lF1T#kgQ;ZIYgW~L<Fs3ySXqhDuhiGPVECkM
zG|lL4EM0zfej(4^iBM_TW&GlKe!fD?w>B23+}X}PfR+se@%$;(b~;4AfuW2vDLMak
zr}r1#!JfH??JBH4<mD+i23iK@_kh<{8~oM(Y!P-n&!FuaT01p-TkQ=NE?4ZS{|z=>
zmN=Lm=WV?4egbLAR%uZ01?OWeO1t0+Wu5Uj=S>4jn-kHWK3muus=PshKFvg@;hNc5
zZfpZsn;y7uA(h2CXM6iJrHQE@+cW*OI*W*}P5V?ESWi^COX5ohIXfH~n5%kpIM~oe
z;Cf^%Ah|@2N^YQ0gjJ(L5gbisUTYANh%qr3kzHSYaNoHj1MqvFm9YUw1!cVpf>0dZ
z3=Uk^rq9u7Z_bLse7}&S>ZdAnuaF*%8k+3D1fJW5wc{K5Hq!G8N$?i~_(sk%I;+hS
zt)gke?4(V`&Q9GWfh6+x&(R<<2iv`3`Ex5YV0|=r;4lEDb}Y~%hXnN~c<%zZ$xIjX
zRtMepfiB>fAYx1~W6_RMzpPj>W0hM&D_}cRvGr}<ECd`ILTzB{#VTYt&BD~qp!yTH
z$I85`8L*sRD5$pT44go#kQjPThRF2YtG=yTvEt<+<qI|YU55?<TZ|1^=n9<Ep|Ej~
zGhb=b?+7)%!fmfu46B@@Z{q64ydNv47nwmfYu_FAs`u-^px@8@xS(IU@9BZ3GJd$U
zq}kM>oYnVIv;8DmPg<H&2HgtkJn`@qx6U$aKMZ5d&u?UliMzpD-!D0Tb~NrkTz6PY
z(pm`c1Us;|y67kRz@nRP#n`;wjH6aVI)Bhhis=DQ$cmrl(E!es)FsCH#WRf6NA&aT
zXrQX~{(%N5Y4qIS;Ap*w8b(!#8+lIqx)9t7b`S_4irw>;be1i|+Vd-j-9oHWGey$I
z+GZ9P|CF<?YNKoJ6L7+Z0J!aU!EzE{jo5H^7TBvZ0Q$TR1`(BkU0$EsqWG|o+4{tS
zs)K_Jcr<e}b13h0T&EDeUJSt0TfBy`*Cr66J?aHwhqw#$=slz0*rQh*)?0_^JHukQ
z#$Gv9ce6CyD)sBb;FB;{@#*uIg$4OxrhBd!4S<yHMzFmkP1AjMDU5l@D|K_di0J1t
z#lwcprsG~b<s{rJYv+O7S){`uFkiof2qK<d!Jy7$$}Omr6`BFe(#i0>i!Y|o)*U~G
z0a+)lLTtD^(8`Q0#@fY*q=Whe1r8szq-&f*#k&I_QJ9B=B$?rjTmat+N}E3cH|Wf2
zj-+kn$KlxvK+tQEQcv(OvBC_{!efAu+`4%;<Et@Rf1Lr8O&K)Tg1(F<2H1KBE79|%
z5xj4%S{0wz2@u~L==qJ?oC3OA%p><a1F6Hb_p_teka)ED2N5zJ`w1#iN|?ki7L6<x
zftkC67gli)>R?2oF4$`^@3(Fg+{o9>t>P2)n}Fs!eBxPPgE|sGS`>nbclh{(r8ev=
z=I!NL!K+IZ$<~Fe{m;PAr3*yD6`I{a(094Sst|`b2s&LK#<J!{@K+Wkds*W&zKXAT
zq7dN#l`M6FxTgt&g8H}IcKj}3#wrfcW$Cpo@soIsXW;6k<}_^!v0fiUy3NE(BW>8@
z@#2709Bi^k>HL5QZ(E4Ca1ab?St_!N7jJ-?FkNawSG5;^;29VObz;PdM~qMWiph;C
z`LlX<l&IPS_^jg4b}bD)C4Q3TdJyC-x9$@!He5G~&01=m_WTMl{~{37wAea0x=YA~
zUW{8Rs!W(f?tS({60{druudODG|i<3sR@(1TUxPEOZA{$5Obg=D2?D}B1rhVEQp3p
zK<phpGI2??Veyl?vaQ&Z<rk-1!FqfUg)L8`eY{w>ZuEy_QW7R<kZhNWh`XDB={tPd
z@-*gI%u}Iy%fmN@E~G}m+lqW1(4F)5_tFxsV38k0tYxvs?h;CGX(ie($&9zVm$$X`
z$LNDpds+LQfd`i6fMruiJ9`l9hn7JI2fP?B9=OA2Jz4BI77>reeh|U;EDauQF)x%F
zB@)a4S~=^5+l7ZyqzVVCFOVh?At6EagiB)r|A-eyt{eR!F=@44?3;_gkD|}JgmI80
zh)a@yr(eOoya*8YEwz5vVjc(Suz0x_CA);STU)_jmO6;t*93gH!^fUj8VJs&5c~Eb
z0Ly;@%3woi1&hnbC3p7(r0kIilW=Gxag9rpT4XUFx1|+)z1$*qmyj&m3c4*{g~y9u
zui}7ZOC5n(6@oE$_^`)IvqiU<M?f7py7X%BYP=W;JtnjK*wike8nl|cbY@v&2I2b`
zZG)WG!%#?rg5oEMkoMaysTycyF;8@Yu4LPZT#}5ce@Pv-%{rOYU%;%n?8O$$NW;bK
zFAMkDl#S>g-xNp4d#yP;w1FB%xPKGq`qaV4xuAG7^=Ih0?{8;`6;Ht`{}8^kW(#KE
zyMoromy^O!ld^Io3wR6%O<y;HU9&Jb?g+7jsQZ+I)&9~B=0G=J9csiLt*8=3CXWy=
z&O}>%dMP6K_7=Hw(8khp_uX>ho9185BJ-NTrqjdVdmdQU2m(a+HbJ)+h4xhBwICwD
zZ3bJQhO~5MiGofyQsHmZxPXx9S{|_->P_7Kunqnj(^048=M>BGD#J|q9PkhGDHce?
zje_2{DIYw{6NzN7Y8DIde8-uzsvsudQw|4-had64oo<hzvTtT0QQUN>4}>GvVg2W)
znM@j0rjrIf)NkUXC(deUxRtu%a-jVq3-8rp=?(93>(SdOI3JG<$4Mt*M}*+J(^ViG
z!4$A;odfnH?X;~aI}914#oc2800&ZEad41HrNoPHHq8{Ns*Ng8TWY!oCfXL;;u4N+
zJ_PP8y3PP4Ev9KFnsudy!Qhys4UYV?f_c2iUNyjDw#p;JC`-TrpPvo~u&>O3Ad|pe
z@sj!ndwrqPGH75#Gd5S0xn$l!C!JY%UjTDSVBBXq8-F+(|N8SU3H(a}|B}GJB=9c@
z{7VA=Pe~y4#ud9+V&e8zN49g&`DQ;yQ}g<pGVwRBo>5gD$vxza9ep`|dtO1B<OWP_
zZ?#G1<vwK;M--_irDzufD`^_deU6Mwk>el;?hLC75BV^`{5<@?fFd_|;^HhZA9BOi
zc0qMhhvB>TGGv35s~mQM-Be#O$)N%mRf9hU7n+3tQmI}Dek)0FRq}Oh1@EtggO?T~
z-Nk11RD+*7SYSb6l^GD33Dn0ex@wT;(f;5vpv;MEC%(R1E)~xMi{Cgud#VtC*_!+I
z31~hY!Zly=VWv0y^3tR!h`4YZ8Fogj%})S}N@v^hJl9Hgo?$DqqYrBI0SQT+y7!uC
z%wF9Hi*bo6op-9~IFZ<PLW^ivDekpq0&@@5q`{d)yqG&WfJTeM!bS(GLQU;=-1GX#
z$pPk@XFAw)7{HnF4!?yB<w~dz`3DcBSY1XB$4$GcFeMP;<j$J}Q4?TFk|D!I;wzzL
zZ8@Ti!l>zPCNM3RbJa*(#IoUkz$qiT;&W$){ayQF%O>?L^mY3q^pKWk+N~^|1m~=+
zn^##pPkJh4d)>#q`%CLE@m0<7dh}kHqVN4*R(#)LP#E4T^Gaj~rdILBF~0Sa?jX|%
zocNL_3#sG5B*^zHNZA({mIiOVjKcJpA5>rOzd_Y~X!ke~e}bviDX<<FS$Lv79myvd
zWScBaE2i!n?ucjqlOE(r<{Vq?YFtV_scsTA`i7g*C1@_jSUG~0j)=q_`z+>@ex$Es
zP$pN$vp=zi(;13!)I7nw?^(SkPcDlaU+ns#r=?Tyt=Kia2Wd^&>BN%tM7ua5a6Rf>
zp>~e6$3424+=*h>gdU_7Go@27<yn0skM^X8b&?q{9(sjLZS$-)$*b%VBo)`_<Uw_)
zU7@CqP_KeAxX|6$VvMaL(vr!`<fcK@%b_l?te9<{VxV{+z9%S)+fzJ{)MM;fZJful
zV1{*tnmb~D&x5KA_!}2e+S-c;5_>AULTw$f2lIHD0SHH47PqE&0M|o&(F1*z@D#r)
z25vZFce%t(1_(bF0}hT@qde(1+z-XTpN^oTBld6}Jh4YQlbh8gcvXzi%Y!HM;H;VE
zo!k>NT^X!#9z3}RXUjD25)>2zF~u08JmTXX;`1J2Vh=H`XS}BIAu*u`agwQ-!DVGK
zpHw4o(Dy8^eW&1*Bk1Y~VjQtL)z}lvNwG>LkGx^UijLt}d-=+pm<4y#wiPRGQSN_T
zyVX#PKhYfKRMUArq-xUs8$ivnCF9RPGk<Y^42ciN=b!+RAtkWp=^~my%0-!N;lPD2
zzA>=AIQfrX-lQVF8`V-EFakos@Nd(=;}+9$YVM)8MfN?7#90yR2TU|<4Dxor)&qIj
ziu_0qm2iFajCndyL5|MmEkPdaM$in3EZL3NfEba7t60>sxCldA6+QmU5E(|a6RR(m
zTO|-dEh&to!&#;P7I!juw|WK>yDOj|=`Cek1$$$kGhjf&KpmIg?@GFU^O~o%?LApn
zA1|M&Nh2MhB2;jzOWhSTP|pf;k%yBy*~B6nMbIy>dx559b6SWJ+5Q{E@Q-aE`pU>A
z8t9Z=1InU~dvWJZnQv*`radL3E$kbCMKlrJE|xDiK9GA5Cui|UE+8fK>0S$c&Asd)
z3%0}UcNXQp?=7(9e@vZf0p}heKQ{wl)2luZrj@?6-Dj%5pMve4?-vI8sCx{kv|q0-
z2oqC#2K>YJ3ddjN1&F_OEBQJQ_%2?)m1rNHfNI4jjZ`3mNiURi`&>gcPD(L~=cWgU
zA-sOr*MdBMV&`Fv${+~g?(3Dkdd`|Gl??roPCjp~xu@E9b*5ZIOLnH*ecf}`nj4et
ztu-G;R-HSkxdEB`!u7lX>~ff%p%X4&*UpxlVrOiO4dl+<(eLh(qB$E^k2Oz>*CXGh
zyUwb2cUj@H(_I4ty5~gs<=tHzgPbe|;;eD?%bd{A!K#Vz<D8r<InB4}u7&SIL&yJ`
z7<Z4#$&~Zgc$c0|C=Lw;3Ma-_QO?_HI=e#c=5=>P*`Kr3EYFAPa=W`)&O@D@bcEi|
zikKMZ>q7M$T#T!4Saaw8BG}n#*1QW1ZKCF6CFkd*yUxdEj~{no<w6ZZj{|K`XM5~z
zH7E1aUHz@Nb3;y0y}t9t)pPSuCzPO}2l+sCdHGPoEU3;6^YNn5=%lG?>c_B7o-2YZ
zsmq({haIsyiJW3>U_l(C(w~?>U6lI3b4){D;Z^ZO2@|<4C{YD@jOo+guQXJ@1E2mh
ze8Br>7$1O9UAbb#A4U4V1%>BsyDqZz@`PQudhAU5NlT+utry(B)`*E&_9J|7^vz=2
zEW#$3p#Y+sieT*1BHD|`2r5b)hC*O&Kx9p|I4+7{W^Bp8PGqA2a+3vcHvXn7gdaqe
z%+dmx@P<yVE}VZ`M6w^?VX1o{NVi81q&!hWI4iVB$zXs_oqS?^1r&z68MT9i|LO+#
z>T%PhF#yyn-8o-A)mM$Q2TL`?PRBx0NyP`t-8t=Hg3<Y@aaMn&hu1dVA>)&t<NXv0
zk>D}iGoWl-DIg@1?wpinxD&FhlJPnYC}CTUuK(_4y4gMz4{}nqQ(yz8ChAyt%t@c#
zP*#!)Z*Fe7#)H#y#Xa7jTs-u~S^3+((J3agmnt`aa3ou3c)m^(8}gp|rVIq0Z+R#S
zWe09ip19F~(E`05qH(Ir1YMZZ;mADTR_3v3(F{lnJr;DNp>J*Z{vuma2MJqjzdxwA
zZqvZ28Tt2wZaskh15IWlEPg;`EeVs0U}(ZJCi(0N_BaG`9#}%+ba(fXA#l)f2>>J8
z6yhLAEod21YlA>y2$oA*Lc_3D@nSrLhNdmGfwwFqR$K&hAq%MhE_DV8MsLQ?Dg>>r
z!wGvwXsloe>an%!Gud8^K6_J`rS1#YsumkJO-Y~cOP@Mgp<XW5k|lU#Z6Ruviw7T3
z$reZ~@}|&KmSAg%#3F7AJ(vU6pg{(weg0?rSQa7Twh8YV$1A1B<Yu$|x<z@M6@ZY;
zUh>NU7<8!(7lY8B4$&Ma0jVvgYx!wg5dNPn3|sWqVmDpI2j?3?=@E@rkgYD4F&#^F
z$c^E8=~f@<t9ot`GWcZe-yzxmL+JSrnUfc=(5S9qen?;(l!TOLGz(l5#0wno-&@H0
z0wtT2x3{|faEp(H)!$TCjkwWYciE@PYbuixk)o@$muG_jESG%M<va%0VqP6Wub0ya
zi(2yv!qAu1t6`V08-n3&V?_Ayaln2Fa)fq0`vDPUS1&Q|B9O9-nxBmqF9P7MOB#x|
zF2q8q5Z2Qr^wuz8k^<qi5VF0WzN`g5B=cXG@Bf0Pq#HaF;dkEaRZnNOTZY(JUBf#}
zk3QU<i-S~zm)Ae{?FQ$n>PU0)G<Nqt!Q;hjK@yZLNLm^J1oac35iA4YMB^rm=?4*E
zNj_M&cyT4PXoF%zFtHFT{JT`4qy-B?t<Nusgs9epISW0toZP6km=D_8N;C&HwEWPH
zhX21S;Xff6V%A1gkh$j4{3Aw1(V6tF-@d6QReD`s!%BffGWCyD1Cj8j)c=-J_&<~j
zNn(Rbwjug|>q7Z=>(5sCBtY5xaZ;8Xu!t=0hO9Ng@A8^T)vaD`lyBDf4Z6syXF|b=
z?!T{qAhli=l$BauHrRtr7%0!fTT%<6W>XCjN{B2kfSO%GF_Zvv+6l7yg4+I`9YI(Z
z5}|tNW#j!j6l|^Hu#%T_ZZUCk<{-FO^g}namTc#LyUF->lK5e!i~|nx5$0=(?2RaC
ziL<Fm9T0GDt`;#<@UZ^dSK?BZIOX}%e?Oi$wO$yc^7!SH3zWBlQZqkNOIVF2AOW%@
ze=KK=EDN#kAptEXOS2LtVbJy#=`{@2AqIl}p2Qi1azs$ZXy<aW$2(rU6Uq_26)FAS
zq9r`0jOjujWL?9(e_B^t(Fl4uH?wRg;kYZ{H7I4byp@yUC$X<D0+P##x!`!Q93-Ms
zOF|(&zXCcz!@IY%dt)IJ^zaTJbc_)hR&0bV<y-0<|8j*Af@!;in$Vt~uq>1_@nRNq
zb@o07DQ4eW>yoi?qI`U|+Ay%+-dn>J1`KAw(-m>=%kO$XV1r&Uygl_d<kx{p4f&;A
z7ccq0*YvaqK=Q^eD>10#Xfq8GBB8at0#iPPI~`Vq&Cd9%)N1L*L!*F$_r@)Z!xpI(
zd&!<_J?!`M!epWd?C(EUpTSQdjFjiW(+>_#bk;<K{1|7r^$RLoG)Fp1PtZZmL@QW4
ztPB}y-OG-sNtgDWrdGm-$zaExS+H0{I*#TqdfFo**oG1gII(9Idu{zJ;_(4ZaL}Ev
zDQ`sYJh%tUbDH<=4M&hA(1TyIH`xM*{{-^v_;CG4BG^0tljGAsLhc1(=#(HO9=ibt
zD%kO{AzS#^Of$e95jyFxw6&6B_(6%Ytdq&fU}GWW55{)|x%)@)x2YACx=-OCeX7I+
z#A2a`0?+Y<BC<Njz_OBRfVMEgG%ZQU0o9>I-;+a)GzQjZCk8MNsxI}M@)&{}gz>ms
z*3{Z@A^eb9$UxDV8u!VHV7NVmPuU_UNk0Q+e~$+W#i=xf%!u344~r~0LtnuDo=}Vj
zw{>rpr`@9adS`l_sTj~?O?qjxDG7K`WMD)KJkP96-vv#`%hUBVb~h0$!tqDY60%}2
zBc*WjVnMCuleHrV5$SAJSis`ML7!WKL}?l>j5D#p<zbtWZoZ50WTA$sDD0+y^}P3$
zg!1-n@*@U1o%O453w5BLJn6U*JAKwaEL5oBS?$qqTXygjorG9mNLjTgpU6V$pGpTy
z=Vl*yylJr|Pvd-tpMdW4SHVQ7PO5YU59};~?du2f{0;7btU?EPs6~iij0U7+^LaHa
zpmUDbIgU6f3iK3wo<kK01KtEsv98$0V958qMZrz#@)%q98(`Y;;P79OSP=r8hT*Da
z{$l!~xym2_7mdk*Vq+KxSZNY!=I(=2*H{<eNIt{81<uV1Ld;Hr3!R3@1zS+?j%C}Z
zlBE-t3I{d4F#hdm8WGS0>9(pMZ!a9|rZEMBZ{`^QS4kHndFu9|#;_m~$Dg(?Lh`X-
z*F4C)!KA`((&C6!40zR`D8D83#A4L2qT$T8j+=pNs0kBU8rwztt7oqtNzKxJ#`xoH
zh1rb4CC4(cnnngXqR7TsGw>p8=*`?O124|Wkfkq$oWb$?d#A|05DsK(6tWPB51+#8
z+Q%8L8+<V%$|hDHjy=hr!9{w|B}830usw0%A^#!P*SRK%0Ru3Hjr&IJTt6+y_2*E;
z{hH_7f(0J5wAs6G!<x*D3?t0mH`L9^#%g;Rnbb{;`lz(j<fo-`?;fcgi*XCc+&%I!
z!O`i0j*eFPg@6YEj|{Eg+I{OJR@CmD%ey<mYV?a|5f_*EJHfQ*OWlx9IOeC}G*1sl
zx&MGrA!!_Rn54eg=ICf>T24gXyyi1?Qnhp!2xOH$)EL23bXCSeb!x}9U8tFScnTQD
z`VI*F;e^XJ!Xn$6@t*+VJ`9xq55p}8u@e~}aQ`gf{Nh6nmROL~b*{e4<tMQCSXp%@
z^QJNCjJ)0mmifo?g_2^7K^`%^XUfx9Cy#8)(o#<|N$rt)!!0gOf6^nD$vy6gMmdsN
zCPq|<P?Ib0x+L|~(_yF=ttjZqRqiq)Z1Ns)$6l5%|EAN3K1l4Fr-Sr4(LRWGwxS`P
z30Bt_Ck|t;^mOoTA&1n<0<cvZVXktOjDrYL2}*L@tBW)qfzu)n?cyHu^SePOg^#&E
z+!G!DbNh9-@AXjKJq_r4t*7GjuZ6xuH+*70!wOFcLC2hV&_=Nyp#2E&bNWDCKe0sh
zA<&dI0FdgPUaO!$<k-4Pfy;UHP>?me3xoh9d@b{Py&@k!@NdHWc>w1^7t@YFG=UO*
zA=dTT3<uW0eXvBX8W+PNFkoEb2$W&h=4xX8hSY(YRuFdf{{?hIaehW;=ZmzjKV~>{
z7YKn=p1tK^w0ywFNkG`u<&!~GC3p{n*wXrHjK$SqJntB_xfGR52!&cCC};(Fv0~F*
z#8lH~juqmn$$9_r*@D%w1lkhX9fG!lx2J1_5hf?Ce52F^DGHgT-qk@Z`C*}<LA0U}
zufoF?X?-fTKv2N7oM!|)-UEpU#(Em7mAr`woM-i&t;jP@P3+$~ZIem%H7ro+CuA`f
z=VXQT?&(@X!+TQ}+^(cen4a@B`jyYj^&Th9-$vJY-18iq#}z*fU9(TfEK<3<1kgXl
z&lDKFBa5ad=RI`ugk5UsMxsylHS?4dNfubCYDAns;@3+n!+}A#G`T@?A<G{Aeuqt@
zT21+`9&=!9dZfT)rW?CgBd7&83Ex7#I4k-@v(1d8RyCXCBK+~Lyda{34t*Sl4r-PL
zCKp~LCCvil$G+yy^Qot59-ruo(9@ijG}e5|LpNmYo2Eny_tEcL958xUl4y5UD*=p{
zIR4OWugQ<4>R&;I2U~tQ<Uj6@-v^C0I&$*&ICmvN{dC@AWl&c5ary*yr|k)5US*IE
z4MiSB3j@7##FYl1?Ttm@K%bXyV`oFE;vy!?`YWmQ;9E&Ecr7XzGW$5l)0%1eD%{9>
z93$oAME_jow>pgwR?O(87Wz1mrfUEJ>zToeeA;aprty2U#wTx@!mBD5_5#gw+~+RA
zjn_{tWsOa-dJTs~OWTc0g|SzVt)MJ%3U}zFP^NRf$S;qu@iS1GF3xZl!oGINFsH`R
zMS-yq-c@Gekfcnv^h+1FoygogoBFuNBgyw2Qg}JN1cASAuQ_MjLFpyBd61{k^`-1<
zdyo{3SK+bZGW4tBcF=&6dPSJI0fqAxe#@pJ4iUY+qlW0|i6*YqWXeN|>0J|qTZl3Q
z!v(vH?XibQtCIrh<jB*pARHs2yH#Z_i)BUaMdj^P+qb|#+HcvUvt*Ufs^CyGzTA+&
z<xLMDNE5rQg66n$Eb3VjdY`g2h4tzbZ2^or7E<*oL#K2n^~H9E^tRPE{t_eai%7o|
zXEITwHB;t6fLMxV@Wga{;)(=C>j7v|G<3)-&qLLT{QA{b)UO(^1bTPO!d;?A_3kXN
zM0lZqqN$?x#Aq*<b|^smDS-(bys_=*0Nr(nb9k&QS%&%~?<{vpLi1&A^|O}m^bPHb
zulgUCqCX#;+Q<uS`li37&`Z>fL8Lt|O;o1dI4$28I2<ThTIAI@BH5#EsG{bCfBh=l
z`oj)<(Ik2ci}C<p<ku<a>(t=-Ai{kuS;V8P*OPh)W_mTdeC>^5GyRQQ4(X|QoDq~I
zbdhp+{C(9pr3L<r)Sk1Jgf9d%yWFInre=^}{<R=03rUJxXJl(`8d5pLXb;J7TJ0+B
zqXWbuj6MqN@svj)E>g({91DYArhWBw`UcI6#|YagW+A*ZBY>Y`g{I0S%i}05JrMZa
z4W{cUHdAH&QXMOHgUk`p<{oTEXkMd<08*7qp5|<LESZ_HzzM-PB2HCg)J#ROGS2d=
zHA0RV1bH)iyNR#C+ik*m@BU7z6Ga>sF&k*SxsY{{@2bf*_NQ-R!s`UNWmg&bfLEw6
zOb`zyZzZY%m8=)-?OyX-NP#OegE+><;@;|JpDRom3hSeP^#po=L(HEDZMJL}3LzfM
zYoQ%wQfuTp-@!Lxyu?8#A(}UFx8{NV!|%}^s#FN-nZ4OtQY|_Aj=m#Q$C>amDEs#r
zlZqQ-BEx-2UbZ#iHrCC23w@)4nj`s8l=+As)T(Fzj?1>VER$?0&(X#Io@BcXA!~`P
zvuP*l^yAM2THNl_%DFxaOAnbD$$k1Q4!r6dO`?HHP&Cu96I6nTrqG{mompH6m!s+N
zlj94y!SV*+{G*Wr)&M}>zo2~4I!1&DzVh)Wys(A)E@vaGY2N#aP<IG;8`3fw)b3PO
z>^FF)Jw$42?j-F+VAWNjjEc1-Kj>Hurr|5z<WDfP0()h8x+bq%c&88zD-qy}xDSLm
zSJyk@1_csD+~->h(T_?f9%UTy2A+{SQ-<`5^WkgNnb9{?YNI~>0e7ztSz$W>GinuF
zseCb-5zqsCmLa3X!g3oi{}*!tj@em!0G;*LPk0%K!C-33Tnb?9!cL9XthlQE=sw*y
zarP`u_ZUMm+>|}~%Ziu!0Z(&2Fu)X9Gc-V?`?ytQ|6K6DLks@hT%4dm+~D_pSTC*t
zf~dJ^u;Dr}>ATT(w%)C<PqnBO+rOB^nHkw0uMe@e$pvpPoSIbNrMkh+*a5~NQph12
zCP(iDebrF;HAQiiJgRa?KKTPlD)mAE`gm;A!?>W|*GG4e{hUvRx30bPhJLD<AZ?(M
zDH6QZ+o<ZLt0Jux><peDeW(jGH`#dgE!7JK#^;$s$6Y1!$R|j|RJjNv!2LV=Ij1Z+
zxBvBarHOMOv+Q$R*!T&i?vjNZ@^F0(<NZcZSHa&rKA!X$#=Ci3P<9*u(qM{US+cGy
zQe{Q3vYz6jG!Trw(ae*GZsLP1c)<W46IoAFHWh8m>4V*vosuOI3+FdR3fg%vYPH)8
zJ(DAq$^hSR756(4AyX9skk@n*qZAK;pHms|0bK?&%;VJ*RbMcrels21>`Kd+YAns1
zm_LeVeRT~NuQwrM)9|dzWa>etjzcNN{8JM}vM~kQPT_gBV6`c75AbPcvC2`Orzj7o
zvIwoac+G>~#C~k{#(TFpg1F0IUoGFE)4B~f)W_8J(w&x53Rk|hQpm8mjxA%Jk1oa@
zC=K0{8a@Dc?sPVHn*quvonNV;)4!C(HdIXr?YwP6dcCV-BW`o1DMAByA_J!qMd4p-
z=fL1m9C6yj-VUk9Rq1Z5qoiqLF?!YXw$-KTK)-x=Iyjgwm7t6abv>?7rTl49+Js%v
z@-1r0gF(adLfUwItRS88Ih6$me7xtF_`0b_La!o@m;}aMC9+nH)2}ipcpm>cR1`gG
zBxWN!7v`8-iLNL5^1rfPq-DYHg^Md>DF}tX5ClPmdM_QeK@Fz~XL0mQ#1-{8Qq-qE
z;QSlV;R}lJS}X_#i*r{0P}MIvuZ_}2uI)Jjz+>CI=h&vGO5e2-bkJ13f8kZn97-~d
zNfw6d2o_#_-X^_?G^#B?)uAdc$M&*UY>%Gi-nc3#yGx=m&^3x;y`j_2v&s<e{fBvy
zW>oUqIQa1h;Pc^o(~R@2<#XS5BTNFk7G2@!j5!{5vLYs{cYJ;Ccp-G>Rwf&Y6JR2g
z2(?J;$PWC~NaxXqS{$NsyaYP%;FTesE~E*s?O%!(Al~SrJ8Qd}4|}fT4?v_1p<_JQ
zWx)@H5>{?Hv*2*U@#-ZE6Ik^8<t^$Lz`Y?X84`%7!M;F2yESx%<gXzf7!txdD-eT7
zfFsWG&0Fk7!8w!&Yt+W)f7-v5K|=qU<|+OWA>@TDMhKFg;+SIKsv{wb`=!_<b-?4i
z0s5$;trb(jQ~Wb}kjvoKdn!lf;tZ3>iwPL*yL8!hgMRf-Wrh$5wU&8oGCVE~u;1lw
z+LGXtD9MHQmW~&6adNgS_SLE#1O;2kAXu#reG5(G38b-)hk=+k;YEJ{ag;`4HDQXq
zM774ML-lKK#O7K8gv0kPG_j_a=q|C3MpSo=w7#jsfo>tG9j!;ZB&M`fVo4%u<TtR(
zu>=h2+%pf>%ygK;RD4}W0GtQLjZXhJQ3B%cQ3CCMHA>K#2OEHNhyT?`0qbAi!4EpO
zKj`QzfP=Uq35Q>|lkdnvv)5>h2bRv6P^!0YIb43u(XmKIXuUBnFD-2(>K7X*6FvFQ
z+#vtg+g%@rliCbf<0(`^7BPsGp2xn2>H73E=?4MEcdGw$Q4Th2%~>k~F1bJbfQw1b
z%c1!cd*qnqE<ApM1hKJMNonXNANH?UtxsQ)@_4?z0k*cR>98Y6>+`Db5~y?wFn^<u
zEN7m}ot%<lY34EBBo%*d2hzeU2_=z5h18Gz-OSJEunLu?eGym_WXBYzL01Nvo)z+1
zD9M4|?cTQ8xYBzwi-exudZUlGi;JZvcbe=xDMbL^WPC9_)r-J!<xg6|zUNu!utl4a
z)VR-SY5l-tW&l=Dmk^0vXr=(6obO^R<sQRcJe9ZzpTI?o!QO=x;M|1d`MU9$I^E<t
zK_jfc+NehoIs=(8;>%AEM-C~ROvf$=o91q$*!M<q|05nx=a~Uep>yg%OS(+6+@^<%
z!M*q;`{P@m@w2i#uLg7?d*yDq^e^9<v)?^$!kTjbsw>#?4<=7P17@`Qn=6C5sOWdE
zNQUgEmT3ec?@un^zsd!g3zR~RIU@V3y@au0M_5#Xo6{7nn~%K%B><N`#{-^{>1gdM
zq^W^^6_P~pJ#1PpKu(CPvhs3-tsCLYCQcLHm*}X(7<zPsRGNnYRT|XNfXQhl9*lkW
zdR(BaS1=$!r5tXZPutu~;y2K-Ss8>41F`)<NNUY%0?~u@n4^pAD+>%5pU>?#9;cr#
z#WozAvOPg1x0ehU{3)b{&L<~LVK3U+<`S}aZQt}23)zZX#)TKLArZGxzdtu?^gHH=
zyRhgAR_+=Osov^Z-NE|<;Q_{`8CUXTsSU58Foke$R)3y8f4|cJWVZUnPo*5GLl;hY
z<@jRjMftZ$597kl3xc^O2sKyf4TA8Pk$^QTR(ub5_1f8;4i+)t&I)Gw0MY-(QiKVK
z<%VUzy_wNRO|~up3nz}O)Kik&hWFD!_KMm=qLKp-ICtnHKio+aJMo?}>I;66QycmG
z=A>qSJThFI@yaOud*@tfHfqGhFNo)(T&C*qwC_~8vjK9t-A7zq$&+4BfETFP?s9K<
z$yM;JLYJC!b^5dwnRIg`&tEKK>~+Eg-!8OTokw}PIaZ=<j|+a%z}wUpT*FMr_ic=r
z@R))bv->EzDpkf`P~m^rzjfj-+{*hAP^kB4SuMKmhrmwMs=E!99sxU}gW{;NBrf87
zh5H;y(mBawTB&o%*;mf$s3lXBIt8;!0fNZekW12yndYhx)G-@_p86_$t<h31#WylS
z!>blT1Pw>yoEH4h17ju>dT1T_v-;{h+d(pSdyhvMz06GD9LJP_+takKRX2$Is&Aq@
zN!cRjxG9)*bM8^*6J7vjB2K8-&kR5BNIuYihBjYMISM&8ve3I!$b0(_3&>pkae9qD
zx@zfw<219aWb4Y8nOPf?n3LZIifqFNqyt7KF6TQfZ$>ojp!})j18F}_!lijFv-{?U
zNdpi=3HS7q4AYCgcxvkzmh$5O#Bqz!MV?YxuerL{FwwWAJ$WguD$YAq$F_S_?8h1w
zIayI|H94R8o!9!`LR#7h%Beh``I(#yVD7QM8wcW)8on=pEu>(VAL@4Ny7G2s7lApN
z6luM-o7A--T5hjZoLt|x%GcrB+^XZl0#xJPyV;VL!Y6F>*UzU+q-(1$eK%UM{b^j5
zm(nF+yHzvaG#7lyz3@c&Te>mE8##j#hu}!f^hrf_$hJ2A%FGCZSe!`=L+XK>^J<*t
z#bS~ziDbBGbu8q)iu{+nSI()YNSJ@0Kc9OVRpsB~YvdaWwX#!LQ<<vFH<CB)cNOZ5
zdm9ghZZO%1eM5gkmNHdQGoGnw4H<}nyw|~D`Y@*^R!LkXr|fCG5G*#L%E391*DMEl
z&8W6sHpm8F>zfE3LH-PkfLnB=IIhv7;ValkkJmWf4qtmws&cr=t<M<W<(_?laT)Vf
z0uzE;C7W||1|_@?Conc}%G2ngt-Yaj+=`nWg6Lkx{2E3{<2U0MPYLU<!&#8~O!i_Y
z6$6ROT0Px6#wdZDP&g95Z&A&raym&Gvz6{<*F+pgXP2swJ(<f!fLH(KU^5#$&<=6t
zmOfdo=4%)cvt<dh&rO(0wq08r+`@wj3ba3e_7`tVbzp_l`9p#AjNM8&?O?+|TD6Zb
zb^u7PHf@K=laop+)zE!LbiV4FDUzV|ln!Qk(a<%UOU%LFXK6cnhK15{(;$Z*e;S*f
zg-PX%ErKE$?B)PpS}}A0H<b<@!1W#J%8kWT_0`Rx$d)kt03+u!NgtQkGs5{ofueKy
z7&91LfuKGbYy$-bM3r_67_V=RJpp-vXwh(aeTw9YU@?S<K>yweMzo5#E&>(Ys?vW9
zuC~cwb;I4Q3LuQ-q@NxdC=n|iOAWA+mj_`V#~R3`nQ?}}Mo<WpbJHkbrwQV<KIZ#J
zs9#KaVE=EcV_^?KSQ~S&6$1O&0?4YynABjjNz!#*o3sTBf-;vwq{)Tbo6LBjdWPse
z?<!0++5UAL9-bA<fn2c%J6n>CH#Z}Usj~xF!g5)^tKc*h<o`sD7pbQ?2j;N>5xIuz
zq269oq!~B>A7G@Et5AYC<GOk6*~Rn}f0_SlgrAf8pUymG#fyl#9%G^`D3?{T3(QKG
z<*vlvB|*nxn_{9uiy%sH0JP@+Yy}&0zwyDN@j~7B*|wE@xa&@EexQ`}qXP8ql5@}@
zX>u4&4*;9}K<1sFFn0EW7_P%YTM|LtYN77WQ_Js$7C=tdx8*eYmCGcoXb^k+%#mWF
z-oU_6E@7;x6j{Ua&y#~1J{Y*K0mR{WCjI2RGC`+Pg^KY{xBL+sl)E>``=ySLf*tj6
zL_F#7c*D)TY0QrIH_(v5SxorZjxWUxI?DJP{Bc)>hW=&bdtV$#tRAtlBZ1g=Q&C8L
z7ortpUv3p}Ag^8qAYb^wOvyg*>&(A}|22(J-LD*Cjrc>&i-$)c4qCe9?0?s(F~j%@
zt;KX%`dKj_Y~5o55>M>}4Plj&z>)`Dr8B{1K}P=7EKHra7rWxxiK2L7<v$L2^ATbC
zV6W$1vVP@+5LC!|D_#)eUo&S49EOT1Fz8Hp!0*$bVd2dOEKuWh&87ueh+=3ubvjl5
z+BY7NZPyH6pMWLR-ei~Du-Sua^*M7!Rn2{wBE3g^Z_Qa#{;r!{@i#BE&yQe3>j`7S
z9i87ohG<J}ZgkdtKc}!D9v4x9=GC}Ro1YURiyV=Yu3%}2Zog|YCiI$@3o(!zq15Ap
zp}e5_BB<5C{22gMKCLuRFxs$zknAee^-*5~+VYVDXr5%Cw|YOm_+-npavEoAP~d$9
zyDrYh-O#U38FpP#&Eg2P|B17?mm9L-ADm5<zl>AU@@y$7*;$OX?DTYaWoYP!)QR!?
z$VCdIJ4AsbK-@}x;>37{Jw%?YthgSEq4Z6RhonKgO*};B?68Blm97xCk`M7P<)FG3
z9E_{|PjlxA>!A)*B%QM*J2^sJ&<hY3)C;0@9>Ax&&h<cCQ1$GrWM_MbS}B02mFf_`
zGcXT&e~>A6PNW3Y%Z1)wmKhrQnVOv?M>}U+Jv;^RMi*J1VdmX)f8__AhZ?pwHU>u_
zGAI*zAQ0khR%C>RvZ2|s^36$i4Gn`jvB9n@s`3a_H_RStI0&j!_ImDupIOWNfX|@u
zco-hfxSJxJpO#M9mr0oCMes6lFek!fZy~=XT~ZJ~ZV3IG5T~A8M0KFpdN99}Zhfs9
zI*s{BSV&IMK#Nm&zWp#b(h{ei(C%A~>W;8uRv;^?^QA2y6Z4yG1|7VL`vMvU(!u;3
z9RTUGcs$_;8Tk;%ayIk_lx15=Y}a49ex}{FdC-8g5&@lqmgTTsX!!$)bWqdsFi~%B
zmsGR_;=)ca!088hnu)x>BQ}eUy^7NYDoe6KM*Qh$5RvF73JM<mkZgsAj<iF^7Ubg~
zOY)_W_%z6I7+&+A1N8FfMA$!F4DKT|H&F~0bpl}eCgB*>X;jmx?AmzYDl0jX4J{)o
zxq(Wg9C_!?{>zJ?=~(POSm+*Q!xStA10`wGOzG6$0-PIXe&!z1j}jxz4eT|c(wUa=
z|IyyHhBbAiYdTJ~Q>J1^kt#K5wJln(SP@Vl#7e!4h_Q&Ga*2u*F<hi5;gS$-1u6(B
z6+z^Zq9V#IatQ%LvRehB1c+P{2oOz70)!-n5JGNypB-w?Gv~}R=Q;D|{5h;2xvcE$
zY~H=rx4!j#@B8s|CLD8R<~d~jyWK8{ou`1Z*y2Yt%Wl5I-(W<SPH!lE_l4=y>MV`e
z`}@oNf6kk_T5wnEQbve`{cWpX-a3M?K5t&IS(6^hKf~5ZZR@ECt01+Gn-!a}QJ$U$
zwyOoNv!aW}zk8HgU^#D?ENGd}qz5<t=o>;zr5ufR&6J}_tRXFu(mZwOzXT-I28yuA
zaz}V1=wAjTHm;YF&Ky;kppTxJ?f<U-_Ob~{%_XJ83dC<B78^zTeug^lDi18^R{}^N
z+9i_<Im4w0de~nu&<k|6*z9BzW7Z(_k)V(6@u+xc!cbvCI~~^HH_L~}Z^|ruc<E!*
zjZ~0(&>O$N81ROuRazbCUyLpXAyo01#B}$=S`GczKT0w9$gptP&fA}8vaWAs{;K-*
zhU?55^$e^z2aj$P%~!r6DI}&USa*Na3<76X0Z^dC1TKV%`{d3KEC#(ptop|S4F4AK
zz6#R)BaJh$4|rBqe(^<HDr_d7wavW}_WPu8Ozpn;Uj+Bj&V&ZaOrQGNIV(1eMfh_>
zyLmC##<QHq;hfbs^368U&!V#$1gj}MewKT?baKr$RATk`+*g{tYdMyv)V6!G22!1z
zbYdZ=d|NYvR^CjW8d{*T`cA5##E0CpzZZITovw+D+{9Z+d2jgTpCps$15@$rQx`3(
z-Je8yq$r7%?g9Bo^pw=tRWefY!wx<2pGhoN_esk+Iwk)iR_z)Y1HJA?VzMzqt-rZ^
zd*w3I9oC=|QOMCzI-c~D0+qqS@JKy5%P=DxK|0s3_+M+wZDmkZ4*>JNF*)m@3?{_h
z4eFrHxFKpN1HAVN`$R_Ca|Fa9c7v1$xzJz%!gGO0!if(9LtqI+zeIwrpLTt|Be7%m
zspq&CO-ki^5-zl49gPcVjgcUCb>ce0zofAwLg=kaVTubix{V7>)biYF%m+++BUCIF
z$W-%H(<ZV{2ozaOsNDlrQCPK`Eu-49nVLv+G0e*eMi|bMKQ#xvHr)-*%?k=*@e>km
zo)^*8b^?$c7RCfDo0ktrA=azAf|`iK-?yMNcAIZ964gJKw)o0o1>SgHZoNWN5LH4?
zG}d2FzYZU61q9cN(dix_t~xkSJWu{_856ib30(Z+o4R0Q+lqT{Cc?3YayYqh8Vrd~
z?}69o@9aJ;#1`jGzMZoq_@C@-;D^v~AzTn<N{n`1)2^n#36q7%*#0+5+T@S9ATpv6
zvJklmN!p%iioKsp+N5fPtFdIWb-@3SN4ZY~$-dXQP~qFq(rWl-SucoD-V{Bc{k76E
z_@viEA?MPiFCPD{sro*LLNsRm5!K8CLGl=6m$pT%%LqLuYIp|qtYZ%@n9f7`T|dRg
zhBC_>>ypGBw5p7drtlw0n1c|?CFi3b%QswEawph<z1{*K+;$Q_&w+rAmby6%<%{wV
z{D&Uljte2(2bn_1PR7K{7@^+RHz)@@|I?=wLjAbSMOOic%XrZXX@2*$e?Q&g<01l!
z2rMG7h`=HOiwG<tu!z7S0*eUzpCRxQ`;~uWq~gHTP#+K!<azz-re^>gc|4Jz9H&>2
z1dwoito`Z5vA3<z3@}p+{}U4S)s>#Z(kGFBZynbLM*URw`Bx_o<^9s}v%UW{CL<v*
zBqebC`1OxInfcqkB>_aMfWLfG9{c_~54>)Feds~u&P$i}{`vj2Cw3kRaJBj5#=B3u
zTH>h@bIA!P{I@($l-_)of!B47YT{&FV=X#TPl+|nIvdzq->C4BQG-LbH*UceG2PHD
zRk?FJ`Co2hG#_HP5zl^?@U7vT!v7uJnMu#AS<~>x)1kM((FW%n_bcaBeFUj<Fynl9
zS#A@(ZrVooSHD!{<3Ub;Lwo@j<Mw&~G50=ItP>_9w~4*l?jCjX6>R5JOY}zP3)KnX
z-o66crd5$IMSaO$&}1tj`}1@iKEKaFIgPXIo2sHWn#`By0I};OKX;^cSrTG21(awA
z@JBCtvfkHdsKNIKYisa+aK|Ou)<>_W9v_RAcFvBTR?OzAdxu-(Vb(O9i>BY&1=vbV
zK5gPZ6LX8t`j%c>`KN<qa%f>?cJ~24Y)$t-C<@q)PCAt^H~Z2t5SI~w>$lFP93O?w
zn}{!8^Z75^N4lmTzZ}*SRN&f=%EvCiKRExCzs7?Lku_#0?2P6Ru%N)a^wyS<;1Ul{
z+gOQR>2`CECeEzx`0fi*X9oeb1F!Atl4!EBTn^K_=k_#q9<l7{EN%ZDpTzpQ$_yzH
z^l5H(OrOqpoMFT>0jBt~CwfB-p(u(G_T<USY<u_2xFu=jIy3r0c%_>sp1DiAmWv3v
zS-ZI>kbf@(MHSk+%g4?MpKnzNR@@T0f57(ix=@s`s%CP2Uf&SG^%9J-HbS^0P@&~N
ze4Lu2-A>=7@8v)ycPvBiaV2VgPyFa^@7dFbgG%XD5oPxyP^-k=mAb5H72kOm&g)sG
zcH$;3qN>-~O)8gy4~AItDLOMN+5E);zxE(pfN)EoO?Lvb@0eS}rZKH?eylVOn10sZ
zsn|HxxQ#h@IdeuNuP+Z!=G%6@mo%JGunFG+`sZnmhP6}$jDM%9@++HP-anL5ofsYX
z1%0qbox_bCl>38;-%yjohEG&t>E`N0WV>Q%9VNP(hmY7aIAW*sn*$x0<mFO%s;q=I
zHgvB-Auk)QwOh++a*~`*xRk9BjGPsgE*Gp)*dIRuPHqs_5KglM8dIf`I&Jp))rd=B
zjpvpJ;IN}SoGIzHg0;uit!vPyAw=EW;Nlyp&Bzs)kN_#ofM*H)tBQ{)_l1TInqj5b
z>q|;*E@8~{%D;xFUW2~}oN;fhd>DQhwGHOOu~X{vltzxyc8bKwZk~zG`ff@;$DHPR
z_G6QU6oy92Jiebc*RJb3ks2dE@7cItz=MAhySzQ(q0-<>urZ&>Fi?jS!<mLQ!&m{Y
zYARL5!X6n3FC65nbP~BV;`up6ma~5f;K6Spx&v5N<@}E5m{awJ^p@naCBEa7^2QPR
zrl#0Nee29T<a5fl148%3(<}iUxLu05mj3#}1knVgKOaoI^=!ECocKyi46t7eVgEAN
z0kPGe$F)9T?ndobY|J*s-lJ#Vaqdj<46s)rIjF!McT#Ic97rFis=kj!&ARoFd?wBn
zLyuUX`I?3-NEimFvjZ$gGo4xx2RhEGs@Ltt<=-tZ;GLZ3C^OrkOf!RSZaTp1%rp!>
zsnINXL^Ly|h4MLr&IR~ru7pNm_X(S6{91lQr^eciMpJ1k#=+#?`rE|1SWL0UR<}6O
zD}LRbu$6nssr7D!s)_XgZx=3@<gO~Z8Ihs$!+AxG4~PmRhRAP}1&?bqR{1H=Dv4_H
zwn-wbaiXI$lUr?L*1@!uw4`mGJ~)J5Fyhz=>X7=Co966i`Oz3n%WmdWnX8g@4vpog
zE2?_A#x*h|xqZw`xurZcaPbbB-8*t8UPDVmxGk?qXotDEaUiGL+OeZZ85Pv2XqLnu
ze;~A#w9jOzbw_kKJR8yqsOD=rGGxDu2p)+FEOtKvze5`fNf%>FW4~mvrogqc`atuw
zelm1@Xr553((kGZp;*_%89p9OP5s&{p|Kk{hbGInt16!Yh?sTGLPhGd2<m>MWE(XX
z=g=vQg`o%tiQb@f1xZh$DHhvlX|uS-i;y%FzN690h^9kPJnJ%75Pb#guz63W&u44#
z3}7kTkJh{;;up_>=g(US>;&3fXS<jEh&E2z6wMGgVijWyt1zEhq2oyjAqbh!&$#?b
zj52HF@Zi>}UKYQ0-ea|9$*u`1de#L2?L6iY69peSG@iB0>g34)WAR#<Xsj@4J(Gml
zSIk=>i<{>7KcYDF%`qL<Nv}GYSvS^0$Hsq1+HpiDE-7^AGo})@VBG=hx)VmxXyaE<
z=rw-rc6K-^zdl)$6_!d(lkNziXkZR#{KU71v#|LLuFp3y#XRHr2PTBnPUsIS)s#{@
zbTLn!>rYIm-U2mv0f~kBQu@FhFKY8fIwJGI!9io3(d+qF)9gEXL)gMR3>*IiOV3hd
z@&Xav{s!Qn=4`1dEGhMfjtBRrIAPJH77Jk#4r}95)(14LHKUpw5fPN9{zp~K>oh4f
zbssuO1e&;%+aqzF`S#=jOn#?I-;Ap3g1Z>vx$8+x@6bwa<vO}Ro-6B39nFyp*>fEB
zOYj0R!#jq07!7{S0&|_p;XgWp`xU@K2yDr8O!y`<%%bSj5Iwk5%LtLnF}hH%*-uzD
z^o+8Xb<YVTFGP9<yW^HH%)FEDdf`=@ivt<u0(P~{^K&B(mTuos65S9z(WXW+FPP@j
z!YU4~<CYqg`!*=P&P_OtDuS~!R(S*+2Ap81OVb#SLx!~ifR!{DmE?m9weTKKx`qg4
zQ3&{zzXNFDo=q}Xs@fZf9J?i=Nif}{ibu9ykZPM|vy%+I*|Wm4zQVi;(!E?z9z9v4
zndQ3m38Q?4KUV;w`=DJx$#I-X?Ag0OZ$4`?25R49h&>v!4L&KM?Z*X$zM)nXq$U9K
zYYRkqkZGB7iN3~_YN2aBtZcIsH~5ICT#(gHu3V6>&tCogTW>xSS)}bhd8;i&ANEn^
z(eTq<j0p)p^}V_F#jh<w^8b63IEo;A+Om3B^yEYDfI>coC&wjZ3{N+f+DeMKAFcQq
z?yxegNNR!IcpnD)F)CXqqFqWn2Yj011Zt@po-o+?-pyepm6mMX>_kIZKV0@`y6)w4
zU5^Zs*>kWtQEL!IA;I@UibBbimW*>qrcCY2g|hlhQrhLFc~buDZ@v-Z!3CL?6^bd~
zdx?SEAk`H7W}ywbR;ZB4%3(XUeGdhdA{`E=cn-YODfB91)`KN?K5iX~C?T|14z11>
z6&thml7)POKqxS#sZ2&RC_s+Vb!-v{kmfK#^AJRYT!6W8I)s}S02;b>cr*HgWN3iQ
z1S9N_CNZQpQ;Y-dXo8uUz1zE;{+Cp>Gpy)m(X<+sxeZGcrw9N*ybLf6s!795@)Ee@
zUrX$?exQX8D$zodhLS2ugUr%$QgX_CM5<OJ)OVT~HYx=A#h&lsD}1=rtp;y#@GsHa
z7q$d6$6A}xRGGeceCSw@1heUT<MsGJ=k8!{pn1E?ML|?-)Nx7jA1gO~?Rzhk9hHd8
z7RV0Yu7d2}MJk0_a4x54RlHGn&S^t?0y{n9iM@NwD)G{H^~AR+(1ir-Z&QPeEv~K}
z^g~swQ?;c$6|G1cLyJ9II2Zj+cS5_l-T~uC4^xT;$_s}_W@$NOx{`7%&yyk(go5ee
zox+<1NM6y5f+NBBVY#J2DHpvNfse}xg4@N(8#{0TBvb<+majP>-udniuajfCc-=c3
z2S?}?{MrF**2M-QD$v=f_0g82MJ-!VbbgS%Jjon-)~To=FKalln9r)ohU-c_^y_8i
zmP;t!TgN*cq>N83OIzpEm#`!5%VIhD!g~sHS&=vpbA(g9$9S3{k~h2hP6FttZVl7Z
za_pld!UxaI7xAk0C02x2t>AzF>+G$zr5KgbPAe;NuK5*j-;ppq!EfumL#g)baYtsw
zFHy!iVb3|)oY^#1f<>>oC5y9>MEY_aZMrufSS{TBoY0#49Beh!`2^lO*AUMWuxfv~
z&n~d%u>6Vnp29Dt8XRJA?%Lx@0;$CuFd)nBm^t|%)bnWb@`vu!KsD{%bpl`)G4t^3
zRYFJ}7HCmb5kaA?vQ2yW*_6F>3f_%0!~QtzKM>5z%!Zv&fnH?KpUP)R-iaS^buYbu
zN+a$$)yAusihSl@NpnUB9<f+E-v2x(8??9qPwpJwUqvh$8R2o_P*OW`1=7*tY7lP&
z;^gYRUOC<;DluHPcDeSrAra5k9-|}%6RQKLN6@u&o&&ea+>GE*-SgSL+KDC#o*0a+
zNCgvFsp~C3^KF)zJ+ScgAdp@D26Qd5OGDiH#?>HT=0d%!(t4$pUJ$yY)Nl&|ItMKd
zgQa<V5Zz5tgoDudd4~@6a=r<=D(HeJ$HaPQCC(ip#Wt@L@8rdTq+;Wi3GvQlks$QL
zsn_hwhRpY^tnS}4y$|BKt+QVlg$4V`Q0SzE+-7Mf&F|e9`u*kN<01l!2rMG7h`_&v
QzzQ?E_2H9z*yphN4<R+&>;M1&

literal 0
HcmV?d00001

diff --git a/tests/f_dirdata_optimize/name b/tests/f_dirdata_optimize/name
new file mode 100644
index 000000000..1649a3702
--- /dev/null
+++ b/tests/f_dirdata_optimize/name
@@ -0,0 +1 @@
+optimize directories with dirdata
diff --git a/tests/f_dirdata_optimize/script b/tests/f_dirdata_optimize/script
new file mode 100644
index 000000000..52cf88ed2
--- /dev/null
+++ b/tests/f_dirdata_optimize/script
@@ -0,0 +1,3 @@
+FSCK_OPT="-Dyf"
+SECOND_FSCK_OPT="-yf"
+. $cmd_dir/run_e2fsck
-- 
2.43.7

