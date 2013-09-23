From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH][RESEND] tests: add another test for uninit extents past eof
Date: Mon, 23 Sep 2013 10:35:18 -0400
Message-ID: <20130923143518.GA2464@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qa0-f54.google.com ([209.85.216.54]:49260 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306Ab3IWOfX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 23 Sep 2013 10:35:23 -0400
Received: by mail-qa0-f54.google.com with SMTP id bv4so1510294qab.20
        for <linux-ext4@vger.kernel.org>; Mon, 23 Sep 2013 07:35:22 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Commit d3f32c2db8 was intended to detect extents found outside their
proper location in the extent tree, including invalid extents at the
end of an extent block.  However, it incorrectly reported legal
uninitialized extents created by fallocate() at the end of file with
the FALLOC_FL_KEEP_SIZE flag as false positives.  xfstests
generic/263 (among others) caught this problem, while the e2fsprogs
test f_uninit_ext_past_eof did not.  The latter test failed to
detect the problem in part because it uses a test file whose i_size
is 0.

Add a test derived from the fsx-based test case in xfstests
generic/263 consisting of a file with non-zero length, more than
four extents total, and two uninitialized extents past EOF to
reliably reproduce commit d3f32c2db8's false positive behavior.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 tests/f_uninit_ext_past_eof2/expect.1 |    7 +++++++
 tests/f_uninit_ext_past_eof2/expect.2 |    7 +++++++
 tests/f_uninit_ext_past_eof2/image.gz |  Bin 0 -> 989 bytes
 tests/f_uninit_ext_past_eof2/name     |    1 +
 4 files changed, 15 insertions(+)
 create mode 100644 tests/f_uninit_ext_past_eof2/expect.1
 create mode 100644 tests/f_uninit_ext_past_eof2/expect.2
 create mode 100644 tests/f_uninit_ext_past_eof2/image.gz
 create mode 100644 tests/f_uninit_ext_past_eof2/name

diff --git a/tests/f_uninit_ext_past_eof2/expect.1 b/tests/f_uninit_ext_past_eof2/expect.1
new file mode 100644
index 0000000..eb8248e
--- /dev/null
+++ b/tests/f_uninit_ext_past_eof2/expect.1
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 12/16 files (8.3% non-contiguous), 70/100 blocks
+Exit status is 0
diff --git a/tests/f_uninit_ext_past_eof2/expect.2 b/tests/f_uninit_ext_past_eof2/expect.2
new file mode 100644
index 0000000..eb8248e
--- /dev/null
+++ b/tests/f_uninit_ext_past_eof2/expect.2
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 12/16 files (8.3% non-contiguous), 70/100 blocks
+Exit status is 0
diff --git a/tests/f_uninit_ext_past_eof2/image.gz b/tests/f_uninit_ext_past_eof2/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..c739e499475a47d2ebc8247a5e448b4bba310e33
GIT binary patch
literal 989
zcmb2|=HN&!{}{-`oSB=Lp33m{?&<uHP#J~?#{3Ije#mH)I-21#u_Z{;Bs6Q$5e3C*
zD*`g4Qx~#iE)~r1jK3%`dDH9o2j`|9*--fWkSe#>-HnDjN)9*m@;5EB6MJk~o>pKb
zdsJgq)_(n;U+0{&J%776?_HXoGsCr2+awknUOQT0<7Vi#Zr=gnsUA=J&fK;9=++aX
zF};1?+0>`I9=+eXXlvC{iO+`fdOs%FwR}(db#ZO`Ion@PA9~Nvv-<pye|KK5Szq$~
zqn$JBtJW>utiCQrvi9f7)AP6FWd8o~b#~?+>DAX?J^!fibau_OcOMzO`$HE9BuDqm
zz4=f7*w?5v(aX1Uy%YFTKlQZt(<iMn{%_=2qx$oWti|;AEBCF=<M~<R@BdV`t~%pv
z{ERvCUe;9?l_hQYwC<1V!Wq@+Wsml#tN-~vRqEUS@2#i)v0v+06wUC>KH)zzHiBVw
z<m<a%6L&leO$hIqmbFhi<lH}xpM4Yd2}^wbtY{;2xjlJJ|Ig!2Pv1<CHQa9=vQNE2
z*(-JWCuL>L*f$ycyLWpfK0F&_@&D(Q@|{`HFRQfd3raG6eE67rSiOIL(R-i1fbjik
z!BV&HEYpc!J^$FR&`|Hgf3n`bfAjWr{jUA{zdOX|U;e1No89`*+lfItDnGwSe`xnO
zJA22zf(;_;_C=q%m6>Dzcb~-beLreGzt)t!AH&7`c<F_rvg`;gk$orsUi_06a%Ek9
zU*`FJGdI4RxjB8=@pHYtEoUPazV&_f-zWe6r+?ha%GOD@em?oFFDq+jYjLHzD&xVA
zY~^NWpbKTHzBZrR@OV4l>=nKBwO{3y87?cS@qc;m$L&?~^^cs7+U5Ol=c~V~*T?6q
zsNcG<u1N9NTidDC5%KnOV~bxVq^Fm4_)h+K_1cj`{<k-k-p%>b`}h63xSRivnyh~}
z^>2R1&y^cz-dx$aVPPT5>0keMR{r1mO+5Mb_SswR%YD9FEL^?(n4aIcp096S&YZhT
z;FdP)w5|V7zdyhJ<NM1+wb^F-KZ)IMY}<NDT7Urstg(wNF890g=>D7UubmaGYZSj$
zuacUo-TLOg;PS~Hmm($BmKUGy(>%?3eA>tFXXE?qzlnEiU$0-c>)*d!W!uZI?w&T!
z{`YL#|DSIDbelSPLYQ6sB}uE-at{B)Fa46{d3dGkdA#19sY{tl&+ospw<>z|%lVee
dU*7sL?e)J)DDEJcbKvhEu8<}N4TcGf3;?{p01W^D

literal 0
HcmV?d00001

diff --git a/tests/f_uninit_ext_past_eof2/name b/tests/f_uninit_ext_past_eof2/name
new file mode 100644
index 0000000..352a0f5
--- /dev/null
+++ b/tests/f_uninit_ext_past_eof2/name
@@ -0,0 +1 @@
+fallocated extents after nonzero i_size and total extents > 4
-- 
1.7.10.4

