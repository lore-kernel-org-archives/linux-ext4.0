From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/2] ext3: Add batched discard support for ext3
Date: Thu, 6 Jan 2011 15:26:37 +0100
Message-ID: <20110106142637.GH4641@quack.suse.cz>
References: <1290603991-6151-1-git-send-email-jack@suse.cz>
 <1290603991-6151-2-git-send-email-jack@suse.cz>
 <alpine.LFD.2.00.1011251512020.2871@dhcp-lab-213.englab.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	greg.freemyer@gmail.com, linux-fsdevel@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:42939 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752357Ab1AFO0j (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 6 Jan 2011 09:26:39 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1011251512020.2871@dhcp-lab-213.englab.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

On Thu 25-11-10 15:27:09, Lukas Czerner wrote:
> > +/**
> > + * ext3_trim_fs() -- trim ioctl handle function
> > + * @sb:			superblock for filesystem
> > + * @start:		First Byte to trim
> > + * @len:		number of Bytes to trim from start
> > + * @minlen:		minimum extent length in Bytes
> > + *
> > + * ext3_trim_fs goes through all allocation groups containing Bytes from
> > + * start to start+len. For each such a group ext3_trim_all_free function
> > + * is invoked to trim all free space.
> > + */
> > +int ext3_trim_fs(struct super_block *sb, struct fstrim_range *range)
> > +{
> > +	ext3_grpblk_t last_block, first_block, free_blocks;
> > +	unsigned long first_group, last_group;
> > +	unsigned long group, ngroups;
> > +	struct ext3_group_desc *gdp;
> > +	struct ext3_super_block *es;
> > +	uint64_t start, len, minlen, trimmed;
> > +	int ret = 0;
> We probably need to add this:
> 
> ext3_fsblk_t blocks_count = le32_to_cpu(EXT3_SB(sb)->s_es->s_blocks_count);
> 
> > +
> > +	start = range->start >> sb->s_blocksize_bits;
> > +	len = range->len >> sb->s_blocksize_bits;
> > +	minlen = range->minlen >> sb->s_blocksize_bits;
> > +	trimmed = 0;
> and this:
> 
> 	if (len > blocks_count)
> 		len = blocks_count - start;
  Thanks for letting me know. The above could go negative if start is too
big. So I've ended up with checks:

+       if (start >= max_blks)
+               goto out;
+       if (start + len > max_blks)
+               len = max_blks - start;

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
