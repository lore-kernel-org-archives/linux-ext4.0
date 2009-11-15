From: Theodore Tso <tytso@mit.edu>
Subject: Re: s_first_meta_bg treatment incompatibility between kernel and
	e2fsprogs
Date: Sun, 15 Nov 2009 14:23:55 -0500
Message-ID: <20091115192355.GD4323@mit.edu>
References: <4AFAA95C.5000304@partition-saving.com> <20091115042057.GC4323@mit.edu> <4AFFD7BD.1080300@partition-saving.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Damien Guibouret <damien.guibouret@partition-saving.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:32950 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753494AbZKOTYA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 15 Nov 2009 14:24:00 -0500
Content-Disposition: inline
In-Reply-To: <4AFFD7BD.1080300@partition-saving.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Nov 15, 2009 at 11:28:13AM +0100, Damien Guibouret wrote:
> I've open a kernel bug since:  
> http://bugzilla.kernel.org/show_bug.cgi?id=14601
> with a proposed patch (little different from yours but it is matter of  
> taste :)

For future references, patches are less likely to slip through the
cracks if they are sent to the linux-ext4 mailing list as opposed to
having a BZ bug opened.  (Yeah, I know, that's unusual).  The reason
for that is that patches are tracked via patchwork, here:

	http://patchwork.ozlabs.org/project/linux-ext4

Basically, anything that looks like a patch which is sent to
linux-ext4 gets snagged by patchwork, and it's a good place to look
for stuff that hasn't yet been merged.  In some cases there are good
reasons why a patch has been kept out, and in other cases patches have
been merged or definitely rejected and I don't get to getting that
status updated in patchwork, but overall I've found it to work very
well.

As far as the matter of taste issue is concerned, I think we already
have too many static functions with a single caller, and it actually
makes the code harder to understand.  So adding yet another simple
static function I think is a bad thing, not a good thing.

> And I think there is some other places where kernel should be fixed when  
> it uses s_gdb_count (but here my knowledge of the sources are not deep  
> enough to be sure on what shall be performed).

I've looked through the other areas, and the one place where I see a
problem is in the block validity checks in ext4_iget() for the
extended attribute block and in block_validity.c.  The former can and
should be fixed to use the latter.

Here's the fix that I plan to be using.   Comments, anyone?

							- Ted

ext4: fix block validity checks so they work correctly with meta_bg

The block validity checks used by ext4_data_block_valid() wasn't
correctly written to check file systems with the meta_bg feature.  Fix
this.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/block_validity.c |    2 +-
 fs/ext4/inode.c          |    5 +----
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/block_validity.c b/fs/ext4/block_validity.c
index 50784ef..dc79b75 100644
--- a/fs/ext4/block_validity.c
+++ b/fs/ext4/block_validity.c
@@ -160,7 +160,7 @@ int ext4_setup_system_zone(struct super_block *sb)
 		if (ext4_bg_has_super(sb, i) &&
 		    ((i < 5) || ((i % flex_size) == 0)))
 			add_system_zone(sbi, ext4_group_first_block_no(sb, i),
-					sbi->s_gdb_count + 1);
+					ext4_bg_num_gdb(sb, i) + 1);
 		gdp = ext4_get_group_desc(sb, i, NULL);
 		ret = add_system_zone(sbi, ext4_block_bitmap(sb, gdp), 1);
 		if (ret)
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index b5cdb88..c62ca93 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4886,10 +4886,7 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
 
 	ret = 0;
 	if (ei->i_file_acl &&
-	    ((ei->i_file_acl <
-	      (le32_to_cpu(EXT4_SB(sb)->s_es->s_first_data_block) +
-	       EXT4_SB(sb)->s_gdb_count)) ||
-	     (ei->i_file_acl >= ext4_blocks_count(EXT4_SB(sb)->s_es)))) {
+	    !ext4_data_block_valid(EXT4_SB(sb), ei->i_file_acl, 1)) {
 		ext4_error(sb, __func__,
 			   "bad extended attribute block %llu in inode #%lu",
 			   ei->i_file_acl, inode->i_ino);
