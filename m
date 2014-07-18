From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 20/24] e2fsck: pass2 should not process directory blocks
 that are impossibly large
Date: Fri, 18 Jul 2014 15:54:46 -0700
Message-ID: <20140718225446.31374.67903.stgit@birch.djwong.org>
References: <20140718225200.31374.85411.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36002 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756528AbaGRWzQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Jul 2014 18:55:16 -0400
In-Reply-To: <20140718225200.31374.85411.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently, directories cannot be fallocated, which means that the only
way they get bigger is for the kernel to append blocks one by one.
Therefore, if we encounter a logical block offset that is too big, we
needn't bother adding it to the dblist for pass2 processing, because
it's unlikely to contain a valid directory block.  The code that
handles extent based directories also does not add toobig blocks to
the dblist.

Note that we can easily cause e2fsck to fail with ENOMEM if we start
feeding it really large logical block offsets, as the dblist
implementation will try to realloc() an array big enough to hold it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass1.c                  |   11 +++++++++++
 tests/f_hugedir_blocks/expect.1 |   10 ++++++++++
 tests/f_hugedir_blocks/expect.2 |    7 +++++++
 tests/f_hugedir_blocks/image.gz |  Bin
 tests/f_hugedir_blocks/name     |    1 +
 5 files changed, 29 insertions(+)
 create mode 100644 tests/f_hugedir_blocks/expect.1
 create mode 100644 tests/f_hugedir_blocks/expect.2
 create mode 100644 tests/f_hugedir_blocks/image.gz
 create mode 100644 tests/f_hugedir_blocks/name


diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 7a16780..b478bca 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -2758,6 +2758,17 @@ static int process_block(ext2_filsys fs,
 			blk = *block_nr = 0;
 			ret_code = BLOCK_CHANGED;
 			p->inode_modified = 1;
+			/*
+			 * If the directory block is too big and is beyond the
+			 * end of the FS, don't bother trying to add it for
+			 * processing -- the kernel would never have created a
+			 * directory this large, and we risk an ENOMEM abort.
+			 * In any case, the toobig handler for extent-based
+			 * directories also doesn't feed toobig blocks to
+			 * pass 2.
+			 */
+			if (problem == PR_1_TOOBIG_DIR)
+				return ret_code;
 			goto mark_dir;
 		} else
 			return 0;
diff --git a/tests/f_hugedir_blocks/expect.1 b/tests/f_hugedir_blocks/expect.1
new file mode 100644
index 0000000..798a7ac
--- /dev/null
+++ b/tests/f_hugedir_blocks/expect.1
@@ -0,0 +1,10 @@
+Pass 1: Checking inodes, blocks, and sizes
+Inode 12 is too big.  Truncate? yes
+
+Block #1074791435 (13) causes directory to be too big.  CLEARED.
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 12/128 files (8.3% non-contiguous), 22/512 blocks
+Exit status is 0
diff --git a/tests/f_hugedir_blocks/expect.2 b/tests/f_hugedir_blocks/expect.2
new file mode 100644
index 0000000..ac5f4c1
--- /dev/null
+++ b/tests/f_hugedir_blocks/expect.2
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 12/128 files (8.3% non-contiguous), 22/512 blocks
+Exit status is 0
diff --git a/tests/f_hugedir_blocks/image.gz b/tests/f_hugedir_blocks/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..1d54de806e596575a2a081931c587d77a695b79d
GIT binary patch
literal 2497
zcmb2|=3uxyeNiwI^V>Uy*}{P`3?Is;hhz(93W_gGC@csx?s^bZx=}%o@nERSk`B?T
zq-@zBbMwNN_YU$ucr@$%0)-tMeNDSwEOM%u?w!>sn6uV%_P@G^^~X=|z4LVM?md6r
z7pbr$?9X~K*`y`8@S7s1;%l4vWs71L2A+AhcJ1}~$32`@hyI__5@CDhcu{$*XL{UA
zk#kR9cW6g;e)fOAU$1RucmBMXox5r>Yo7ixxV7ucn`2M2?>~>*yQlWq(VyGZkAM0e
z?c1F?`}W4*Wsj9#ey*`RHpiKtp+WJ)<@?Hpep^2O*O_wbW~L%{zyE7R1_p*3zoU+y
ze(3&EK8_#AdsFrE{r{^ImTV2U!yUkz8MRvU`v*B*;g@q;kG{FGw)J;;{<G6g6}FLH
z)2GSrDqsTYsP<U;{LlZ>DTV()`g>+*#sVpZbN?BE<n#X^HV_=xAajWoNE>`wCH?R}
zSPm@Cz>u)rY7IA(jZ7sdL`}9$1&Sm**}(*|hfHuF?9BSL*LQE6f9vl@r#U{NZ_ir=
z>S(rq^qZ^V_R>DL-s;%pXU&@{OTITR7L;f?mNmyD{ddp*lgEB+kDWTN=u`X0_1~*c
z#5Eqwc=q#r&i+68yvDO%O-=4OY9a9W0pD}`!+-vif8PIQ`=9sWzdsjdC(V9+{`iHf
z<@e?O`u>~lzVC0I9tW8YAJsM*0;3@?8UmvsFd71*AwVbu4qW@oGI8xHe+C8x1^`B?
B32*=a

literal 0
HcmV?d00001

diff --git a/tests/f_hugedir_blocks/name b/tests/f_hugedir_blocks/name
new file mode 100644
index 0000000..d74761b
--- /dev/null
+++ b/tests/f_hugedir_blocks/name
@@ -0,0 +1 @@
+crash e2fsck with a dir with an impossibly high logical blk offset

