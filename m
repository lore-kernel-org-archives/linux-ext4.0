From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/3] e2fsck: make sure the extent tree is consistent
 after bogus node in the tree
Date: Thu, 20 Dec 2012 22:19:56 -0500
Message-ID: <20121221031956.GB5014@thunk.org>
References: <20121220234229.GA22476@thunk.org>
 <1356047023-28367-1-git-send-email-tytso@mit.edu>
 <1356047023-28367-3-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="C7zPtVaVf+AK4Oqc"
Cc: forrestl@synology.com
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:39653 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751516Ab2LUDUE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Dec 2012 22:20:04 -0500
Content-Disposition: inline
In-Reply-To: <1356047023-28367-3-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

And here is the test case....

BTW, #protip: You can use the split_node command in tst_extents
debugging program not only to perform node splits (which will make the
tree wider), but if you try splitting at the root node, it will
allocate a new extent tree block, and then move all of the extent tree
nodes at the top-level, in the inode, into the new exterior extent
tree block.  In effect, this will make the tree deeper.

This should allow you to make fairly arbitrarily deep and complex
extent trees by hand, without having to resort to using fallocate and
punch hole commands, which tend to take a lot longer than using the
"insert_extent", "replace_extent", and "split_node" commands in
tst_extent when creating test cases.

This also makes it easier to create small test file system images so
we don't have to bloat the e2fsprogs source tree with huge test file
systems in our regression test suite (which also tend to very much
slow down running said regression test suite).

Regards,

					- Ted


--C7zPtVaVf+AK4Oqc
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-tests-add-test-of-an-incorrect-interior-node-in-an-e.patch"

>From b4944f654cac5f70edd80d12e59bf1212047cb5d Mon Sep 17 00:00:00 2001
From: Theodore Ts'o <tytso@mit.edu>
Date: Thu, 20 Dec 2012 21:48:08 -0500
Subject: [PATCH] tests: add test of an incorrect interior node in an extent
 tree

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 tests/f_extent_interior_start_lblk/expect.1 |  12 ++++++++++++
 tests/f_extent_interior_start_lblk/expect.2 |   7 +++++++
 tests/f_extent_interior_start_lblk/image.gz | Bin 0 -> 603 bytes
 tests/f_extent_interior_start_lblk/name     |   1 +
 4 files changed, 20 insertions(+)
 create mode 100644 tests/f_extent_interior_start_lblk/expect.1
 create mode 100644 tests/f_extent_interior_start_lblk/expect.2
 create mode 100644 tests/f_extent_interior_start_lblk/image.gz
 create mode 100644 tests/f_extent_interior_start_lblk/name

diff --git a/tests/f_extent_interior_start_lblk/expect.1 b/tests/f_extent_interior_start_lblk/expect.1
new file mode 100644
index 0000000..f5b7d46
--- /dev/null
+++ b/tests/f_extent_interior_start_lblk/expect.1
@@ -0,0 +1,12 @@
+Pass 1: Checking inodes, blocks, and sizes
+Interior extent node level 0 of inode 12:
+Logical start 0 does not match logical start 2 at next level.  Fix? yes
+
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 12/16 files (0.0% non-contiguous), 29/100 blocks
+Exit status is 1
diff --git a/tests/f_extent_interior_start_lblk/expect.2 b/tests/f_extent_interior_start_lblk/expect.2
new file mode 100644
index 0000000..06c6082
--- /dev/null
+++ b/tests/f_extent_interior_start_lblk/expect.2
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 12/16 files (0.0% non-contiguous), 29/100 blocks
+Exit status is 0
diff --git a/tests/f_extent_interior_start_lblk/image.gz b/tests/f_extent_interior_start_lblk/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..0ed71286b308bbe1f2f5e26af1b965c3ace3ed1d
GIT binary patch
literal 603
zc-oWi=HSpjdpUrKIWspgJ(c0@o!wa?ff5W4j5kX!_Ec~a-XO?xFxyEfOo^q_m&;Ks
zBtR#}Nvn|CH&O9O`wjIEmo)Y@D5|vfE)dghQb<Z(9+8o_ecop4kDE9<q*71T$^WVT
zH+SyMopb*ioSh@kkhj(NSWM46iOq(m3^&P#-?-kj<=%&^y+&WR#BnaXXz|-Hd)@V4
z_cm>dt?xN1aXfj>Dd!y%x7C_`dGfZ^c<Zf`w|4JdFaIvrzHen~^8Y_E`unSj|J{3h
z^WUvgpMP)Hw|(Jx+&bWo*`_alZOnqV9o$sX>;Iyvq#>y1uHms+U*q{IH<z#bdU<w#
zjN*-5QoZ*+)NPnrpUH4nCEt!Y{bx!}bmcsMzism#wmZkyEv<U{>qkxL!&fn{BY(QC
zoN_jNHJjfJreC*T{V!e_`rl!?#%`7c{}{jWuc&wU%lt|{;D5s}_AB;aA%>Do`~3Gl
zjG4Ind;O-P0(>I<ESmNbw{u<VG`8(^t+Uv6yZetvPPxd>ieKlI=4YI4Ja<Xr3!h1e
zwz2{P3MiR3acNbm?!V`C_Gfhbm!EVy7WR7TMWsuhp1uq!wwq*f+C%J;jp|MR%Tt!7
zF4KLSuY0dc-u?8`uYc{ef8C!iT~uj(@08E3|I)qnl{bQW>=T<mrYpFeS9|l{?^V69
tV$ZhT`j!9R#+d(0y}#}DSLxpsl~w;;%cU470zam%=UrX*gkb_B0|0Xv5#0a)

literal 0
Hc-jL100001

diff --git a/tests/f_extent_interior_start_lblk/name b/tests/f_extent_interior_start_lblk/name
new file mode 100644
index 0000000..fbd5f58
--- /dev/null
+++ b/tests/f_extent_interior_start_lblk/name
@@ -0,0 +1 @@
+incorrect starting lblk in an interior node
-- 
1.7.12.rc0.22.gcdd159b


--C7zPtVaVf+AK4Oqc--
