From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/3] Add batched discard support for ext4
Date: Sun, 8 Aug 2010 00:25:40 +0200
Message-ID: <20100807222540.GA3573@quack.suse.cz>
References: <1281094276-11377-1-git-send-email-lczerner@redhat.com>
 <1281094276-11377-4-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, dmonakhov@openvz.org,
	jmoyer@redhat.com, rwheeler@redhat.com, eshishki@redhat.com,
	sandeen@redhat.com, jack@suse.cz, tytso@mit.edu
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:47302 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752690Ab0HGW0P (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 7 Aug 2010 18:26:15 -0400
Content-Disposition: inline
In-Reply-To: <1281094276-11377-4-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 06-08-10 13:31:16, Lukas Czerner wrote:
...
> +/**
> + * ext4_trim_fs() -- trim ioctl handle function
> + * @sb:			superblock for filesystem
> + * @start:		First Byte to trim
> + * @len:		number of Bytes to trim from start
> + * @minlen:		minimum extent length in Bytes
> + *
> + * ext4_trim_fs goes through all allocation groups containing Bytes from
> + * start to start+len. For each such a group ext4_trim_all_free function
> + * is invoked to trim all free space.
> + */
> +int ext4_trim_fs(struct super_block *sb, uint64_t start, uint64_t len,
> +		uint64_t minlen)
> +{
> +	struct ext4_buddy e4b;
> +	ext4_fsblk_t first_group, last_group;
> +	ext4_group_t group, ngroups = ext4_get_groups_count(sb);
> +	ext4_grpblk_t cnt, first_block, last_block;
> +	struct ext4_super_block *es = EXT4_SB(sb)->s_es;
> +	int ret = 0;
> +
> +	start >>= sb->s_blocksize_bits;
> +	len >>= sb->s_blocksize_bits;
> +	minlen >>= sb->s_blocksize_bits;
> +
> +	if (unlikely(minlen > EXT4_BLOCKS_PER_GROUP(sb)))
> +		return -EINVAL;
> +
> +	/* Determine first and last group to examine based on start and len */
> +	first_group = (start - le32_to_cpu(es->s_first_data_block)) /
> +		      EXT4_BLOCKS_PER_GROUP(sb);
> +	last_group = (start + len - le32_to_cpu(es->s_first_data_block)) /
> +		     EXT4_BLOCKS_PER_GROUP(sb);
> +	last_group = (last_group > ngroups - 1) ? ngroups - 1 : last_group;
> +
> +	if (first_group > last_group)
> +		return -EINVAL;
> +
> +	first_block = start % EXT4_BLOCKS_PER_GROUP(sb);
  I think you should substract "le32_to_cpu(es->s_first_data_block)" from
the start before doing modulo.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
