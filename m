Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=79.135.106.111
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792857927;
	b=tXmJTc1D6s5XHsJw7HHo4ieeutLxCQIEMTzhH0NTBq4HRUoAqiX4c43/9vjvWJ5rVaGM
	 JGL+M7rFRmwc2Wj01dc6E4exPhAF7gFwYUaSEamE0m+yRrRaLwixprL7Hyz2UigJvyOQO
	 WC1W6Vj7m3cdEbpWN+p13YAzRAesA7ydxDPQ+E7iJxMAsWkOHIl7+zuI44eYWVw7SAjc2
	 w1EIipxPV0c9hL4blyk0S9Vz+G0sPjtmJJtyukbDiI6iZDlsQpQLTiC+Y3n5qMuY9Yuw3
	 0mdJVFmrZnVn9SuFjd8RxqvmCynb/XzrNp3WkfNVJAZr1Bl9hIH0v4vGCgQt0LFCMXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792857927;
	h=DMARC-Filter:DKIM-Signature:X-Pm-Submission-Id:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=hl2zlBTHf9XOwBRkj52ERH8BBJerunOirfEW4DQts1c=;
	b=4M/rdTooYWryU0LKPzEjbPh7M7X6/844ExaYxADbOxfjlKfKf4Fcc7yofH00AyNa0YXc
	 j4N0NBTF5e53JK2X7XJJsHKzf3ZgTSCMZqpaWpYvROgxLQdXXs/zysqj6ptczDp6owmkF
	 ZLNKaAop1i+hALrDqavDUQ8LLiBSSW4yCtaw38xdTd6JmRRaYWNIYRB5tb1G8A8nfW574
	 5mvV8tyqY4qG3Dz0VGNxDkWLXsJ5AMJGTIGTvlAjX0zK5NF5XKxfQ6gxuDs/izmtYEDJX
	 TZQg3lKdvVaZ+O9guaxEpxeR8t4VJfKGvnZ4GC8uv6pcU+GDdQ3QwBwT2FY1YdDrUPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=czerner.cz;
	spf=pass smtp.mailfrom=czerner.cz;
	dkim=pass header.d=czerner.cz header.i=@czerner.cz header.a=rsa-sha256 header.s=protonmail3 header.b=n2KT4Bbk;
	arc=none smtp.remote-ip=79.135.106.111
Received: from mail-106111.protonmail.ch (mail-106111.protonmail.ch [79.135.106.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CA81606A322
	for <linux-ext4@vger.kernel.org>; Sat, 24 Oct 2026 16:05:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9CA81606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=czerner.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=czerner.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=czerner.cz header.i=@czerner.cz header.a=rsa-sha256 header.s=protonmail3 header.b=n2KT4Bbk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=czerner.cz;
	s=protonmail3; t=1792857922; x=1793117122;
	bh=hl2zlBTHf9XOwBRkj52ERH8BBJerunOirfEW4DQts1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:From:To:
	 Cc:Date:Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=n2KT4BbkJqw9yWi/yWtbz7Yg0C7uAuD0U72l6Y9INHY+vesRKt19qFC5I8vUG3j5p
	 RZ5FfPqsOGaBDVbfBpVCCRxF2sAhVoRgtBeAQ9okzD3yE38/gHaN0NkSYTetNwoQPF
	 9suCW+qPUp893a8C/9gXEHBAuRikMd8T/IHbL/R+7HCZ3b0Gzr4gjMN5Zwsqr1yHwv
	 tQOKLJMON58EdTKC+xU48CSP9qsqSU/H3MuwEFym5e73BTNmCUG/EA4DZquNHjQlcp
	 DdZjVFvuursYl+2h/PjStJVtPVX7Yy3I+qLTM1PVjHiBKeU81CSe6lEC8AvqdeCf63
	 4ddqaUlM18r8w==
X-Pm-Submission-Id: 4jBl8w0n3sz2ScjG
From: Lukas Czerner <lukas@czerner.cz>
To: linux-ext4@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>,
	Lukas Czerner <lukas@czerner.cz>
Subject: [PATCH 4/4] e2fsck: add test for resize inode with too many backups
Date: Sat, 24 Oct 2026 18:04:52 +0200
Message-ID: <20261024160452.1818872-5-lukas@czerner.cz>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261024160452.1818872-1-lukas@czerner.cz>
References: <20261024160452.1818872-1-lukas@czerner.cz>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Add a test file f_resize_inode_many_backups with a filesystem image
which has resize_inode feature enabled, sparse_super disabled and 258
block groups at 1KiB blocksize. Every block group has a backup
superblock, so the resize inode would need 257 backup GDT entries in
one indirect block, which only fits 256 (blocksize / 4). The resize
inode on the image is zeroed, which is the state e2fsck ends with when
it repeatedly fails to recreate it on such a filesystem.

The test framework runs e2fsck twice. With the fix, the first run
offers to disable the resize_inode feature, clears it together with
s_reserved_gdt_blocks and the second run finds a clean filesystem
(exit status 1 then 0).  Without the fix the first run instead offers
to recreate the resize inode which always fails, and the second run
reports the same errors again (exit status 1 then 1), so the test
fails and catches the regression.

Signed-off-by: Lukas Czerner <lukas@czerner.cz>
---
 tests/f_resize_inode_many_backups/expect.1 | 144 +++++++++++++++++++++
 tests/f_resize_inode_many_backups/expect.2 |   7 +
 tests/f_resize_inode_many_backups/image.gz | Bin 0 -> 69405 bytes
 tests/f_resize_inode_many_backups/name     |   1 +
 4 files changed, 152 insertions(+)
 create mode 100644 tests/f_resize_inode_many_backups/expect.1
 create mode 100644 tests/f_resize_inode_many_backups/expect.2
 create mode 100644 tests/f_resize_inode_many_backups/image.gz
 create mode 100644 tests/f_resize_inode_many_backups/name

diff --git a/tests/f_resize_inode_many_backups/expect.1 b/tests/f_resize_in=
ode_many_backups/expect.1
new file mode 100644
index 00000000..7716a0d8
--- /dev/null
+++ b/tests/f_resize_inode_many_backups/expect.1
@@ -0,0 +1,144 @@
+Too many backup superblock groups (257) to fit in the resize
+inode indirect block. Resize inode should be disabled.  Fix? yes
+
+Pass 1: Checking inodes, blocks, and sizes
+Root inode is not a directory.  Clear? yes
+
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Root inode not allocated.  Allocate? yes
+
+/lost+found not found.  Create? yes
+
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+Block bitmap differences:  +(3--10) -25 +(259--266) +(513--522) +(770--778=
) +(1025--1034) +(1282--1290) +(1537--1546) +(1794--1802) +(2049--2058) +(2=
306--2314) +(2561--2570) +(2817--2826) +(3073--3082) +(3329--3338) +(3585--=
3594) +(3841--3850) +(4097--4106) +(4353--4362) +(4609--4618) +(4865--4874)=
 +(5121--5130) +(5377--5386) +(5633--5642) +(5889--5898) +(6145--6154) +(64=
02--6410) +(6657--6666) +(6914--6922) +(7169--7178) +(7425--7434) +(7681--7=
690) +(7938--7946) +(8194--8202) +(8450--8458) +(8705--8714) +(8961--8970) =
+(9217--9226) +(9473--9482) +(9729--9738) +(9985--9994) +(10241--10250) +(1=
0497--10506) +(10753--10762) +(11009--11018) +(11265--11274) +(11521--11530=
) +(11777--11786) +(12033--12042) +(12289--12298) +(12546--12554) +(12801--=
12810) +(13057--13066) +(13313--13322) +(13569--13578) +(13825--13834) +(14=
081--14090) +(14337--14346) +(14593--14602) +(14849--14858) +(15105--15114)=
 +(15361--15370) +(15617--15626) +(15873--15882) +(16130--16138) +(16386--1=
6394) +(16642--16650) +(16897--16906) +(17153--17162) +(17409--17418) +(176=
65--17674) +(17921--17930) +(18177--18186) +(18433--18442) +(18689--18698) =
+(18945--18954) +(19201--19210) +(19457--19466) +(19713--19722) +(19969--19=
978) +(20225--20234) +(20481--20490) +(20738--20746) +(20993--21002) +(2124=
9--21258) +(21505--21514) +(21761--21770) +(22017--22026) +(22273--22282) +=
(22529--22538) +(22785--22794) +(23041--23050) +(23297--23306) +(23553--235=
62) +(23809--23818) +(24065--24074) +(24322--24330) +(24578--24586) +(24834=
--24842) +(25089--25098) +(25345--25354) +(25601--25610) +(25857--25866) +(=
26113--26122) +(26369--26378) +(26625--26634) +(26881--26890) +(27137--2714=
6) +(27393--27402) +(27649--27658) +(27905--27914) +(28161--28170) +(28417-=
-28426) +(28673--28682) +(28929--28938) +(29185--29194) +(29441--29450) +(2=
9697--29706) +(29953--29962) +(30209--30218) +(30465--30474) +(30721--30730=
) +(30977--30986) +(31233--31242) +(31489--31498) +(31745--31754) +(32002--=
32010) +(32257--32266) +(32514--32522) +(32770--32778) +(33026--33034) +(33=
281--33290) +(33537--33546) +(33793--33802) +(34049--34058) +(34305--34314)=
 +(34561--34570) +(34817--34826) +(35073--35082) +(35329--35338) +(35585--3=
5594) +(35841--35850) +(36097--36106) +(36353--36362) +(36609--36618) +(368=
65--36874) +(37121--37130) +(37377--37386) +(37633--37642) +(37889--37898) =
+(38145--38154) +(38401--38410) +(38657--38666) +(38913--38922) +(39169--39=
178) +(39425--39434) +(39681--39690) +(39937--39946) +(40193--40202) +(4044=
9--40458) +(40706--40714) +(40962--40970) +(41218--41226) +(41473--41482) +=
(41729--41738) +(41985--41994) +(42241--42250) +(42497--42506) +(42753--427=
62) +(43009--43018) +(43265--43274) +(43521--43530) +(43777--43786) +(44033=
--44042) +(44289--44298) +(44545--44554) +(44801--44810) +(45057--45066) +(=
45313--45322) +(45569--45578) +(45825--45834) +(46081--46090) +(46337--4634=
6) +(46593--46602) +(46849--46858) +(47105--47114) +(47361--47370) +(47617-=
-47626) +(47873--47882) +(48129--48138) +(48385--48394) +(48641--48650) +(4=
8898--48906) +(49154--49162) +(49410--49418) +(49665--49674) +(49921--49930=
) +(50177--50186) +(50433--50442) +(50689--50698) +(50945--50954) +(51201--=
51210) +(51457--51466) +(51713--51722) +(51969--51978) +(52225--52234) +(52=
481--52490) +(52737--52746) +(52993--53002) +(53249--53258) +(53505--53514)=
 +(53761--53770) +(54017--54026) +(54273--54282) +(54529--54538) +(54785--5=
4794) +(55041--55050) +(55297--55306) +(55553--55562) +(55809--55818) +(560=
65--56074) +(56321--56330) +(56577--56586) +(56833--56842) +(57090--57098) =
+(57346--57354) +(57602--57610) +(57857--57866) +(58113--58122) +(58369--58=
378) +(58625--58634) +(58881--58890) +(59137--59146) +(59393--59402) +(5964=
9--59658) +(59905--59914) +(60161--60170) +(60417--60426) +(60673--60682) +=
(60929--60938) +(61185--61194) +(61441--61450) +(61697--61706) +(61953--619=
62) +(62210--62218) +(62465--62474) +(62721--62730) +(62977--62986) +(63233=
--63242) +(63489--63498) +(63745--63754) +(64001--64010) +(64257--64266) +(=
64513--64522) +(64769--64778) +(65025--65034) +(65282--65290) +(65538--6554=
6) +(65794--65802)
+Fix? yes
+
+Free blocks count wrong for group #0 (232, counted=3D234).
+Fix? yes
+
+Free blocks count wrong for group #1 (234, counted=3D236).
+Fix? yes
+
+Free blocks count wrong for group #3 (235, counted=3D236).
+Fix? yes
+
+Free blocks count wrong for group #5 (235, counted=3D236).
+Fix? yes
+
+Free blocks count wrong for group #7 (235, counted=3D236).
+Fix? yes
+
+Free blocks count wrong for group #9 (235, counted=3D236).
+Fix? yes
+
+Free blocks count wrong for group #25 (235, counted=3D236).
+Fix? yes
+
+Free blocks count wrong for group #27 (235, counted=3D236).
+Fix? yes
+
+Free blocks count wrong for group #31 (235, counted=3D236).
+Fix? yes
+
+Free blocks count wrong for group #32 (235, counted=3D236).
+Fix? yes
+
+Free blocks count wrong for group #33 (235, counted=3D236).
+Fix? yes
+
+Free blocks count wrong for group #49 (235, counted=3D236).
+Fix? yes
+
+Free blocks count wrong for group #63 (235, counted=3D236).
+Fix? yes
+
+Free blocks count wrong for group #64 (235, counted=3D236).
+Fix? yes
+
+Free blocks count wrong for group #65 (235, counted=3D236).
+Fix? yes
+
+Free blocks count wrong for group #81 (235, counted=3D236).
+Fix? yes
+
+Free blocks count wrong for group #95 (235, counted=3D236).
+Fix? yes
+
+Free blocks count wrong for group #96 (235, counted=3D236).
+Fix? yes
+
+Free blocks count wrong for group #97 (235, counted=3D236).
+Fix? yes
+
+Free blocks count wrong for group #125 (235, counted=3D236).
+Fix? yes
+
+Free blocks count wrong for group #127 (235, counted=3D236).
+Fix? yes
+
+Free blocks count wrong for group #128 (235, counted=3D236).
+Fix? yes
+
+Free blocks count wrong for group #129 (235, counted=3D236).
+Fix? yes
+
+Free blocks count wrong for group #159 (235, counted=3D236).
+Fix? yes
+
+Free blocks count wrong for group #160 (235, counted=3D236).
+Fix? yes
+
+Free blocks count wrong for group #161 (235, counted=3D236).
+Fix? yes
+
+Free blocks count wrong for group #191 (235, counted=3D236).
+Fix? yes
+
+Free blocks count wrong for group #192 (235, counted=3D236).
+Fix? yes
+
+Free blocks count wrong for group #193 (235, counted=3D236).
+Fix? yes
+
+Free blocks count wrong for group #223 (235, counted=3D236).
+Fix? yes
+
+Free blocks count wrong for group #224 (235, counted=3D236).
+Fix? yes
+
+Free blocks count wrong for group #225 (235, counted=3D236).
+Fix? yes
+
+Free blocks count wrong for group #243 (235, counted=3D236).
+Fix? yes
+
+Free blocks count wrong for group #255 (235, counted=3D236).
+Fix? yes
+
+Free blocks count wrong for group #256 (235, counted=3D236).
+Fix? yes
+
+Free blocks count wrong for group #257 (235, counted=3D236).
+Fix? yes
+
+Free blocks count wrong (60848, counted=3D60886).
+Fix? yes
+
+Inode bitmap differences:  +1 +(3--10)
+Fix? yes
+
+Free inodes count wrong for group #0 (63, counted=3D53).
+Fix? yes
+
+Directories count wrong for group #0 (1, counted=3D2).
+Fix? yes
+
+Free inodes count wrong (16511, counted=3D16501).
+Fix? yes
+
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 11/16512 files (0.0% non-contiguous), 5163/66049 blocks
+Exit status is 1
diff --git a/tests/f_resize_inode_many_backups/expect.2 b/tests/f_resize_in=
ode_many_backups/expect.2
new file mode 100644
index 00000000..932dd776
--- /dev/null
+++ b/tests/f_resize_inode_many_backups/expect.2
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 11/16512 files (0.0% non-contiguous), 5163/66049 blocks
+Exit status is 0
diff --git a/tests/f_resize_inode_many_backups/image.gz b/tests/f_resize_in=
ode_many_backups/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..a09994438ddd6f8d34361e37b01=
bf0e1dd4fb6b5
GIT binary patch
literal 69405
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
D;a|M?

literal 0
HcmV?d00001

diff --git a/tests/f_resize_inode_many_backups/name b/tests/f_resize_inode_=
many_backups/name
new file mode 100644
index 00000000..f39d3b0c
--- /dev/null
+++ b/tests/f_resize_inode_many_backups/name
@@ -0,0 +1 @@
+e2fsck: resize inode with more backups than fit in one indirect block
--=20
2.56.0

