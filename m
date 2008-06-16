From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] ext4: fix ext4_init_block_bitmap() for metablock block
	group
Date: Sun, 15 Jun 2008 23:19:00 -0600
Message-ID: <20080616051859.GK3726@webber.adilger.int>
References: <20080615142455.GA3502@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Stephen Tweedie <sct@redhat.com>, adilger@clusterfs.com,
	Mingming Cao <cmm@us.ibm.com>, Theodore Tso <tytso@MIT.EDU>
To: Akinobu Mita <akinobu.mita@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:64087 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035AbYFPFTE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Jun 2008 01:19:04 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m5G5J2K3028308
	for <linux-ext4@vger.kernel.org>; Sun, 15 Jun 2008 22:19:03 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K2J00K01IJ2VN00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Sun, 15 Jun 2008 22:19:02 -0700 (PDT)
In-reply-to: <20080615142455.GA3502@localhost.localdomain>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jun 15, 2008  23:24 +0900, Akinobu Mita wrote:
> When meta_bg feature is enabled and s_first_meta_bg != 0, 
> ext4_init_block_bitmap() miscalculates the number of block used by
> the group descriptor table (0 or 1 for metablock block group)

Can you please clarify why the calculation is incorrect?  I admit that
I didn't test with META_BG enabled, so it could well be wrong, but looking
at the code I can't understand why it is incorrect.

> @@ -121,12 +121,7 @@ unsigned ext4_init_block_bitmap(struct s
        if (!EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_META_BG) ||
            block_group < le32_to_cpu(sbi->s_es->s_first_meta_bg) *
                          sbi->s_desc_per_block) {
                if (bit_max) {
                        bit_max += ext4_bg_num_gdb(sb, block_group);
                        bit_max +=
>  				le16_to_cpu(sbi->s_es->s_reserved_gdt_blocks);
>  		}
>  	} else { /* For META_BG_BLOCK_GROUPS */
> -		int group_rel = (block_group -
> -				 le32_to_cpu(sbi->s_es->s_first_meta_bg)) %
> -				EXT4_DESC_PER_BLOCK(sb);
> -		if (group_rel == 0 || group_rel == 1 ||
> -		    (group_rel == EXT4_DESC_PER_BLOCK(sb) - 1))
> -			bit_max += 1;
> +		bit_max += ext4_bg_num_gdb(sb, block_group);
>  	}

As you can see, the "if" checks if the block group is before s_first_meta_bg
to treat it as a "normal" group, and only uses the "else" once beyond the
start of the s_first_meta_bg limit.

It definitely is less complex to use ext4_bg_num_gdb(), and this could
further be simplified by using ext4_bg_gdb_meta() in the "else" clause.
In fact, the whole if/else could be replaced with ext4_bg_num_gdb() if
it weren't for s_reserved_gdt_blocks.

Maybe it makes sense (cleaner code, less chance for bugs) to change the
ext4_bg_num_gdb() function to take a parameter on whether it should
include the s_reserved_gdt_blocks or not:

static unsigned long ext4_bg_num_gdb_nometa(struct super_block *sb, int group,
					    int reserved)
{
	if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
				       EXT4_FEATURE_RO_COMPAT_SPARSE_SUPER) &&
	    !ext4_group_sparse(group))
		return 0;
	return EXT4_SB(sb)->s_gdb_count +
		reserved ? EXT4_SB(sb)->s_reserved_gdt_blocks : 0;
}

unsigned long ext4_bg_num_gdb(struct super_block *sb, int group, int reserved)
{
	unsigned long first_meta_bg =
			le32_to_cpu(EXT4_SB(sb)->s_es->s_first_meta_bg);
	unsigned long metagroup = group / EXT4_DESC_PER_BLOCK(sb);

	if (!EXT4_HAS_INCOMPAT_FEATURE(sb,EXT4_FEATURE_INCOMPAT_META_BG) ||
	    metagroup < first_meta_bg)
		return ext4_bg_num_gdb_nometa(sb, group, reserved);

	return ext4_bg_num_gdb_meta(sb, group);
}

The fewer places in the code that need to understand META_BG, the less
chance of having a bug.  Now the code in ext4_init_block_bitmap() can be:

	bit_max += ext4_bg_num_gdb(sb, block_group, 1);


Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

