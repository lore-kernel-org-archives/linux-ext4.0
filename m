From: Greg KH <gregkh@suse.de>
Subject: [patch 56/60] ext4: Ignore i_file_acl_high unless EXT4_FEATURE_INCOMPAT_64BIT is present
Date: Tue, 09 Jun 2009 17:14:24 -0700
Message-ID: <20090610002352.596502059@blue.kroah.org>
References: <20090610001328.251476848@blue.kroah.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
	Zwane Mwaikambo <zwane@arm.linux.org.uk>,
	Theodore Ts'o <tytso@mit.edu>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Dave Jones <davej@redhat.com>,
	Chuck Wolber <chuckw@quantumlinux.com>,
	Chris Wedgwood <reviews@ml.cw.f00f.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Chuck Ebbert <cebbert@redhat.com>,
	Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
	Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
	Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	alan@lxorguk.ukuu.org.uk, linux-ext4@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:57521 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757925AbZFJDhD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Jun 2009 23:37:03 -0400
Content-Disposition: inline; filename=ext4-ignore-i_file_acl_high-unless-ext4_feature_incompat_64bit-is-present.patch
In-Reply-To: <20090610032135.GA19346@kroah.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: "Theodore Ts'o" <tytso@mit.edu>

(cherry picked from commit a9e817425dc0baede8ebe5fbc9984a640257432b)

Don't try to look at i_file_acl_high unless the INCOMPAT_64BIT feature
bit is set.  The field is normally zero, but older versions of e2fsck
didn't automatically check to make sure of this, so in the spirit of
"be liberal in what you accept", don't look at i_file_acl_high unless
we are using a 64-bit filesystem.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/inode.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4064,11 +4064,9 @@ struct inode *ext4_iget(struct super_blo
 	ei->i_flags = le32_to_cpu(raw_inode->i_flags);
 	inode->i_blocks = ext4_inode_blocks(raw_inode, ei);
 	ei->i_file_acl = le32_to_cpu(raw_inode->i_file_acl_lo);
-	if (EXT4_SB(inode->i_sb)->s_es->s_creator_os !=
-	    cpu_to_le32(EXT4_OS_HURD)) {
+	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_64BIT))
 		ei->i_file_acl |=
 			((__u64)le16_to_cpu(raw_inode->i_file_acl_high)) << 32;
-	}
 	inode->i_size = ext4_isize(raw_inode);
 	ei->i_disksize = inode->i_size;
 	inode->i_generation = le32_to_cpu(raw_inode->i_generation);


