From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH] ext4: fix ext4_init_block_bitmap() for metablock block
	group
Date: Mon, 16 Jun 2008 23:10:17 +0900
Message-ID: <20080616141016.GA19080@localhost.localdomain>
References: <20080615142455.GA3502@localhost.localdomain> <20080616051859.GK3726@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Cc: linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Stephen Tweedie <sct@redhat.com>, adilger@clusterfs.com,
	Mingming Cao <cmm@us.ibm.com>, Theodore Tso <tytso@MIT.EDU>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.233]:11473 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656AbYFPOLl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Jun 2008 10:11:41 -0400
Received: by rv-out-0506.google.com with SMTP id k40so3602265rvb.1
        for <linux-ext4@vger.kernel.org>; Mon, 16 Jun 2008 07:11:38 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20080616051859.GK3726@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jun 15, 2008 at 11:19:00PM -0600, Andreas Dilger wrote:
> On Jun 15, 2008  23:24 +0900, Akinobu Mita wrote:
> > When meta_bg feature is enabled and s_first_meta_bg != 0, 
> > ext4_init_block_bitmap() miscalculates the number of block used by
> > the group descriptor table (0 or 1 for metablock block group)
> 
> Can you please clarify why the calculation is incorrect?  I admit that
> I didn't test with META_BG enabled, so it could well be wrong, but looking
> at the code I can't understand why it is incorrect.

group_rel in the original code should be calculated by:

        group_rel = block_group % EXT4_DESC_PER_BLOCK(sb);

No need to subtract s_first_meta_bg from brock_group.
It will be equivalent what ext4_bg_num_gdb_meta() does

> > @@ -121,12 +121,7 @@ unsigned ext4_init_block_bitmap(struct s
>         if (!EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_META_BG) ||
>             block_group < le32_to_cpu(sbi->s_es->s_first_meta_bg) *
>                           sbi->s_desc_per_block) {
>                 if (bit_max) {
>                         bit_max += ext4_bg_num_gdb(sb, block_group);
>                         bit_max +=
> >  				le16_to_cpu(sbi->s_es->s_reserved_gdt_blocks);
> >  		}
> >  	} else { /* For META_BG_BLOCK_GROUPS */
> > -		int group_rel = (block_group -
> > -				 le32_to_cpu(sbi->s_es->s_first_meta_bg)) %
> > -				EXT4_DESC_PER_BLOCK(sb);
> > -		if (group_rel == 0 || group_rel == 1 ||
> > -		    (group_rel == EXT4_DESC_PER_BLOCK(sb) - 1))
> > -			bit_max += 1;
> > +		bit_max += ext4_bg_num_gdb(sb, block_group);
> >  	}
> 
> As you can see, the "if" checks if the block group is before s_first_meta_bg
> to treat it as a "normal" group, and only uses the "else" once beyond the
> start of the s_first_meta_bg limit.
> 
> It definitely is less complex to use ext4_bg_num_gdb(), and this could
> further be simplified by using ext4_bg_gdb_meta() in the "else" clause.
> In fact, the whole if/else could be replaced with ext4_bg_num_gdb() if
> it weren't for s_reserved_gdt_blocks.
> 
> Maybe it makes sense (cleaner code, less chance for bugs) to change the
> ext4_bg_num_gdb() function to take a parameter on whether it should
> include the s_reserved_gdt_blocks or not:
> 
> static unsigned long ext4_bg_num_gdb_nometa(struct super_block *sb, int group,
> 					    int reserved)
> {
> 	if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
> 				       EXT4_FEATURE_RO_COMPAT_SPARSE_SUPER) &&
> 	    !ext4_group_sparse(group))
> 		return 0;
> 	return EXT4_SB(sb)->s_gdb_count +
> 		reserved ? EXT4_SB(sb)->s_reserved_gdt_blocks : 0;
> }
> 
> unsigned long ext4_bg_num_gdb(struct super_block *sb, int group, int reserved)
> {
> 	unsigned long first_meta_bg =
> 			le32_to_cpu(EXT4_SB(sb)->s_es->s_first_meta_bg);
> 	unsigned long metagroup = group / EXT4_DESC_PER_BLOCK(sb);
> 
> 	if (!EXT4_HAS_INCOMPAT_FEATURE(sb,EXT4_FEATURE_INCOMPAT_META_BG) ||
> 	    metagroup < first_meta_bg)
> 		return ext4_bg_num_gdb_nometa(sb, group, reserved);
> 
> 	return ext4_bg_num_gdb_meta(sb, group);
> }
> 
> The fewer places in the code that need to understand META_BG, the less
> chance of having a bug.  Now the code in ext4_init_block_bitmap() can be:
> 
> 	bit_max += ext4_bg_num_gdb(sb, block_group, 1);

Looks good to me. But I'd like to divide into the change into simple
bugfix and cleanup patch in order to clarify the each change.

Here is a bugfix only patch.

From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: ext4: fix ext4_init_block_bitmap() for metablock block group

When meta_bg feature is enabled and s_first_meta_bg != 0, 
ext4_init_block_bitmap() miscalculates the number of block used by
the group descriptor table (0 or 1 for metablock block group)

group_rel in the original code should be calculated by:

        group_rel = block_group % EXT4_DESC_PER_BLOCK(sb);

No need to subtract s_first_meta_bg from brock_group.
It will be equivalent what ext4_bg_num_gdb_meta() does

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Tweedie <sct@redhat.com>
Cc: adilger@clusterfs.com
Cc: Mingming Cao <cmm@us.ibm.com>
Cc: Theodore Tso <tytso@MIT.EDU>
---
 fs/ext4/balloc.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

Index: 2.6-git/fs/ext4/balloc.c
===================================================================
--- 2.6-git.orig/fs/ext4/balloc.c
+++ 2.6-git/fs/ext4/balloc.c
@@ -121,9 +121,8 @@ unsigned ext4_init_block_bitmap(struct s
 				le16_to_cpu(sbi->s_es->s_reserved_gdt_blocks);
 		}
 	} else { /* For META_BG_BLOCK_GROUPS */
-		int group_rel = (block_group -
-				 le32_to_cpu(sbi->s_es->s_first_meta_bg)) %
-				EXT4_DESC_PER_BLOCK(sb);
+		int group_rel = block_group % EXT4_DESC_PER_BLOCK(sb);
+
 		if (group_rel == 0 || group_rel == 1 ||
 		    (group_rel == EXT4_DESC_PER_BLOCK(sb) - 1))
 			bit_max += 1;
