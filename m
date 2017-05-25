From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsck: fix sparse bmap to extent conversion
Date: Thu, 25 May 2017 13:13:21 -0400
Message-ID: <20170525171321.s3znxceikisdwjh5@thunk.org>
References: <20170523190019.GF4510@birch.djwong.org>
 <982fc176-2a8d-1318-8eec-2524c6af1e00@dragonfly.plus.com>
 <20170525022135.tbzsiyd3cbvrdlto@thunk.org>
 <e8704df9-dac3-d7c8-2907-b116d9a3f2e6@dragonfly.plus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>
To: Marc Thomas <marc@dragonfly.plus.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38256 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1035857AbdEYRN2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 25 May 2017 13:13:28 -0400
Content-Disposition: inline
In-Reply-To: <e8704df9-dac3-d7c8-2907-b116d9a3f2e6@dragonfly.plus.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 25, 2017 at 02:11:52PM +0100, Marc Thomas wrote:
> 
> As regards the f_detect_junk test, it seems a change in "debugfs" is
> emitting an extra message "Checksum errors in superblock!  Retrying..."
> which is not present in the "expect" output.
> It appears this was introduced in commit
> https://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git/commit/?id=bf615bb0ccadeb1579463f94a2a4752e7ec53f57

Ah, now I see.  This was not a regression from Darrick's patch, but
rather a pre-existing failure.  One that I hadn't noticed because I
don't have libmagic-dev installed on my new development laptop.  :-)

I've checked in a fix into my repository.

					- Ted
					
>From 1a4c6384c438f4ca4a0eae9a21c4d465cb7275ef Mon Sep 17 00:00:00 2001
From: Theodore Ts'o <tytso@mit.edu>
Date: Thu, 25 May 2017 13:11:40 -0400
Subject: [PATCH] tests: fix expected output for f_detect_junk

The expect files for f_detect_junk had gotten out of sync with the
code base, and since this test is optional (it depends on libmagic
being installed), we hadn't noticed.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 tests/f_detect_junk/expect           | 1 +
 tests/f_detect_junk/expect.nodebugfs | 2 --
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/tests/f_detect_junk/expect b/tests/f_detect_junk/expect
index 4295886e..8febb84d 100644
--- a/tests/f_detect_junk/expect
+++ b/tests/f_detect_junk/expect
@@ -13,6 +13,7 @@ is corrupt, and you might try running e2fsck with an alternate superblock:
 
 *** debugfs
 test.img: Bad magic number in super-block while opening filesystem
+Checksum errors in superblock!  Retrying...
 *** tune2fs
 ../misc/tune2fs: Bad magic number in super-block while trying to open test.img
 *** mke2fs
diff --git a/tests/f_detect_junk/expect.nodebugfs b/tests/f_detect_junk/expect.nodebugfs
index 0d4ba54b..b528046c 100644
--- a/tests/f_detect_junk/expect.nodebugfs
+++ b/tests/f_detect_junk/expect.nodebugfs
@@ -11,11 +11,9 @@ is corrupt, and you might try running e2fsck with an alternate superblock:
  or
     e2fsck -b 32768 <device>
 
-test.img contains `PNG image data, 148 x 31, 8-bit/color RGBA, non-interlaced' data
 *** debugfs
 *** tune2fs
 ../misc/tune2fs: Bad magic number in super-block while trying to open test.img
-test.img contains `PNG image data, 148 x 31, 8-bit/color RGBA, non-interlaced' data
 *** mke2fs
 Creating filesystem with 16384 1k blocks and 4096 inodes
 Superblock backups stored on blocks: 
-- 
2.11.0.rc0.7.gbe5a750
