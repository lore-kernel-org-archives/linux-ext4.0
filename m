From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] e2fsprogs: Limit number of reserved gdt blocks on small
 fs
Date: Mon, 02 Mar 2015 10:06:23 -0600
Message-ID: <54F48A7F.2090204@redhat.com>
References: <1425056428-22598-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
To: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48810 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753537AbbCBQG0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Mar 2015 11:06:26 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t22G6Q97024289
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-ext4@vger.kernel.org>; Mon, 2 Mar 2015 11:06:26 -0500
In-Reply-To: <1425056428-22598-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2/27/15 11:00 AM, Lukas Czerner wrote:
> Currently we're unable to online resize very small (smaller than 32 MB)
> file systems with 1k block size because there is not enough space in the
> journal to put all the reserved gdt blocks.
> 
> I tried to find solution in kernel which does not require to reserve
> journal credits for all the gdt blocks, but it looks like we have to
> have them all in journal to make sure that we atomically either change
> them all, or none.
> 
> So it leaves us with fixing the root cause which is the fact that mke2fs
> is setup by default so that it creates so many gdt blocks that it can't
> fit into the journal transaction.
> 
> Fix it by limiting the default number of reserved gdt blocks in the
> specific case of 1k bs and fs size < 32M. Note that it's still possible
> to create such file system by specifying non-default options so I've
> added mke2fs message that would warn users that would try to create such
> file system, but will still allow them to do so.
> 
> We still need to address the kernel problem where such file system would
> generate scary kernel warning, but that's for a separate patch.
> 
> Also fix output of some tests, because this change slightly alters the
> file system layout (specifically number of free blocks and number of
> reserved gdt blocks) on very small file systems.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
>  lib/ext2fs/initialize.c         |  23 +++
>  misc/mke2fs.c                   |  28 +++
>  tests/f_create_symlinks/expect  |   8 +-
>  tests/f_desc_size_bad/expect.1  |   2 +-
>  tests/f_desc_size_bad/expect.2  |   2 +-
>  tests/f_resize_inode/expect     |  44 ++---
>  tests/m_mkfs_overhead/script    |   2 +-
>  tests/r_fixup_lastbg/expect     |  22 +--
>  tests/r_fixup_lastbg_big/expect |  26 +--
>  tests/r_move_itable/expect      | 404 ++++++++++++++++++++--------------------
>  tests/r_resize_inode/expect     |  96 +++++-----
>  11 files changed, 354 insertions(+), 303 deletions(-)
> 
> diff --git a/lib/ext2fs/initialize.c b/lib/ext2fs/initialize.c
> index 75fbf8e..0ef0e94 100644
> --- a/lib/ext2fs/initialize.c
> +++ b/lib/ext2fs/initialize.c
> @@ -71,6 +71,29 @@ static unsigned int calc_reserved_gdt_blocks(ext2_filsys fs)
>  	 */
>  	rsv_groups = ext2fs_div_ceil(max_blocks - sb->s_first_data_block, bpg);
>  	rsv_gdb = ext2fs_div_ceil(rsv_groups, gdpb) - fs->desc_blocks;
> +
> +	/*
> +	 * In online resize we require a huge number of journal
> +	 * credits mainly because of the reserved_gdt_blocks. The
> +	 * exact number of journal credits needed is:
> +	 * flex_gd->count * 4 + reserved_gdb
> +	 *
> +	 * In order to allow online resize on file system with tiny
> +	 * journal (tiny fs) we have to make the sure we have to
> +	 * make sure

Some extra "making sure" in the above sentence.  ;)

>                    reserved_gdt_blocks is small enough. If the user
> +	 * specifies non-default values he can still run into this issue
> +	 * but we do not want to make that mistake by default.
> +	 *
> +	 * Magic numbers:
> +	 * - At block count smaller than 32768, journal will be 1024 block
> +	 *   blocks long which would not be enough by default.
> +	 * - 64 reserved gtd blocks is maximum number we can fit into said

gtd?  (gdt?  gdb?)

> +	 *   journal by default (flex_bg_count * 4 + rsv_gdb)

This is a little confusing; "flex_bg_count" isn't a thing, and it seems to
say that the reserved blocks depend on the number of reserved blocks?

I'm curious, why does this matter only for 1k blocks, and not, say 2k blocks?

> +	 */
> +	if ((fs->blocksize == 1024) && (ext2fs_blocks_count(sb) < 32768) &&
> +	    (rsv_gdb > 64))
> +		rsv_gdb = 64;
> +
>  	if (rsv_gdb > EXT2_ADDR_PER_BLOCK(sb))
>  		rsv_gdb = EXT2_ADDR_PER_BLOCK(sb);
>  #ifdef RES_GDT_DEBUG
> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> index aeb852f..e9edd3b 100644
> --- a/misc/mke2fs.c
> +++ b/misc/mke2fs.c
> @@ -3076,6 +3076,34 @@ int main (int argc, char *argv[])
>  		}
>  		if (!quiet)
>  			printf("%s", _("done\n"));
> +
> +		/*
> +		 * In online resize we require a huge number of journal
> +		 * credits mainly because of the reserved_gdt_blocks. The
> +		 * exact number of journal credits needed is:
> +		 * flex_gd->count * 4 + reserved_gdb
> +		 *
> +		 * Warn user if we will not have enough credits to resize
> +		 * the file system online.
> +		 */
> +		if (fs_param.s_feature_compat & EXT2_FEATURE_COMPAT_RESIZE_INODE)
> +		{
> +			unsigned int credits;
> +
> +			/*
> +			* This is the amount we're allowed to use for a
> +			* single handle in a transaction
> +			*/
> +			journal_blocks /= 8;

This seems a little dangerous; if someone decides to use journal_blocks
later in the function, it might be unexpectedly smaller.

> +			credits = (1 << fs_param.s_log_groups_per_flex) * 4 +
> +				  fs->super->s_reserved_gdt_blocks;
> +			if (credits > journal_blocks) {

so maybe just scale this by 8, i.e. "if (credits > journal_blocks/8)"

And actually, I find myself wondering if this same calculation can be used
in calc_reserved_gdt_blocks, rather than using the magic numbers?


Thanks,
-Eric

> +				fprintf(stderr, "%s", _("Warning: Journal is "
> +					"not big enough. In this configuration "
> +					"the file system will not be able to "
> +					"grow online!\n"));
> +			}
> +		}
>  	}
>  no_journal:
>  	if (!super_only &&

