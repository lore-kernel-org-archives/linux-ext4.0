From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/4] ext4: Add batched discard support for ext4
Date: Mon, 25 Oct 2010 14:50:10 -0400
Message-ID: <20101025185010.GH16981@thunk.org>
References: <1285596600-28358-1-git-send-email-lczerner@redhat.com>
 <1285596600-28358-4-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, rwheeler@redhat.com,
	sandeen@redhat.com, adilger@dilger.ca,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:50797 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751492Ab0JYSuS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Oct 2010 14:50:18 -0400
Content-Disposition: inline
In-Reply-To: <1285596600-28358-4-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 27, 2010 at 04:09:59PM +0200, Lukas Czerner wrote:
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 93eb6c2..80a5139 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
      ....
> +	struct ext4_buddy e4b;
> +	ext4_fsblk_t first_group, last_group;

This should be ext4_group_t, shouldn't it?  

> +	/* Determine first and last group to examine based on start and len */
> +	first_group = (start - le32_to_cpu(es->s_first_data_block)) /
> +		      EXT4_BLOCKS_PER_GROUP(sb);
> +	last_group = (start + len - le32_to_cpu(es->s_first_data_block)) /
> +		     EXT4_BLOCKS_PER_GROUP(sb);

I've tried compiling this for 32-bit x86, and this blows up because
you can't divide long long's in the kernel.  (This is what do_div is
for, and it's why ext4_get_group_no_and_offset() exists.)

> +	first_block = (start - le32_to_cpu(es->s_first_data_block)) %
> +			EXT4_BLOCKS_PER_GROUP(sb);
> +	last_block = EXT4_BLOCKS_PER_GROUP(sb);

This means that the ext4 FITRIM ioctl will trim to the end of the
blockgroup, and not just to the last block specified by the user.  Is
this intentional?

Also, it looks like there's nothing to check for the last blockgroup,
where the last block might be less than a grpblk_t offset of
EXT4_BLOCKS_PER_GROUP()?

						- Ted
