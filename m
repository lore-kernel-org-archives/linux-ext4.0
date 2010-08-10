From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 3/3] Add batched discard support for ext4
Date: Tue, 10 Aug 2010 13:32:37 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1008101332060.2831@localhost>
References: <1281094276-11377-1-git-send-email-lczerner@redhat.com> <1281094276-11377-4-git-send-email-lczerner@redhat.com> <20100807222540.GA3573@quack.suse.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	dmonakhov@openvz.org, jmoyer@redhat.com, rwheeler@redhat.com,
	eshishki@redhat.com, sandeen@redhat.com, tytso@mit.edu
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30743 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756571Ab0HJLcp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Aug 2010 07:32:45 -0400
In-Reply-To: <20100807222540.GA3573@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, 8 Aug 2010, Jan Kara wrote:

> On Fri 06-08-10 13:31:16, Lukas Czerner wrote:
> ...
> > +/**
> > + * ext4_trim_fs() -- trim ioctl handle function
> > + * @sb:			superblock for filesystem
> > + * @start:		First Byte to trim
> > + * @len:		number of Bytes to trim from start
> > + * @minlen:		minimum extent length in Bytes
> > + *
> > + * ext4_trim_fs goes through all allocation groups containing Bytes from
> > + * start to start+len. For each such a group ext4_trim_all_free function
> > + * is invoked to trim all free space.
> > + */
> > +int ext4_trim_fs(struct super_block *sb, uint64_t start, uint64_t len,
> > +		uint64_t minlen)
> > +{
> > +	struct ext4_buddy e4b;
> > +	ext4_fsblk_t first_group, last_group;
> > +	ext4_group_t group, ngroups = ext4_get_groups_count(sb);
> > +	ext4_grpblk_t cnt, first_block, last_block;
> > +	struct ext4_super_block *es = EXT4_SB(sb)->s_es;
> > +	int ret = 0;
> > +
> > +	start >>= sb->s_blocksize_bits;
> > +	len >>= sb->s_blocksize_bits;
> > +	minlen >>= sb->s_blocksize_bits;
> > +
> > +	if (unlikely(minlen > EXT4_BLOCKS_PER_GROUP(sb)))
> > +		return -EINVAL;
> > +
> > +	/* Determine first and last group to examine based on start and len */
> > +	first_group = (start - le32_to_cpu(es->s_first_data_block)) /
> > +		      EXT4_BLOCKS_PER_GROUP(sb);
> > +	last_group = (start + len - le32_to_cpu(es->s_first_data_block)) /
> > +		     EXT4_BLOCKS_PER_GROUP(sb);
> > +	last_group = (last_group > ngroups - 1) ? ngroups - 1 : last_group;
> > +
> > +	if (first_group > last_group)
> > +		return -EINVAL;
> > +
> > +	first_block = start % EXT4_BLOCKS_PER_GROUP(sb);
>   I think you should substract "le32_to_cpu(es->s_first_data_block)" from
> the start before doing modulo.
> 
> 									Honza

Oh, right thanks.

-Lukas
