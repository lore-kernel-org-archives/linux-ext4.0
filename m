From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 1/7] e2fsprogs: Add discard function into
 struct_io_manager
Date: Thu, 18 Nov 2010 10:52:23 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1011181042450.15886@dhcp-lab-213.englab.brq.redhat.com>
References: <1288115658-7004-1-git-send-email-lczerner@redhat.com> <1288115658-7004-2-git-send-email-lczerner@redhat.com> <4CE2CD55.9070207@redhat.com> <alpine.LFD.2.00.1011162044060.2896@dhcp-lab-213.englab.brq.redhat.com> <4CE2F302.3050904@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	tytso@mit.edu, adilger@dilger.ca
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44420 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756206Ab0KRJwa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Nov 2010 04:52:30 -0500
In-Reply-To: <4CE2F302.3050904@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 16 Nov 2010, Eric Sandeen wrote:

-snip-

> >>> +
> >>> +	struct struct_ext2_filsys *fs;
> >>> +	struct unix_private_data *u_priv;
> >>> +	errcode_t	retval = 0;
> >>> +	__uint64_t	range[2];
> >>> +	int		blocksize;
> >>> +
> >>> +	EXT2_CHECK_MAGIC(channel, EXT2_ET_MAGIC_IO_CHANNEL);
> >>> +	u_priv = (struct unix_private_data *) channel->private_data;
> >>> +	EXT2_CHECK_MAGIC(u_priv, EXT2_ET_MAGIC_UNIX_IO_CHANNEL);
> >>> +
> >>> +	fs = (struct struct_ext2_filsys *) data;
> >>> +	if (!fs)
> >>> +		return EXT2_ET_INVALID_ARGUMENT;
> >>> +
> >>> +	blocksize = EXT2_BLOCK_SIZE(fs->super);
> >>
> >> This seems a little convoluted; you pass in *data, which gets you the fs,
> >> from which you get the super, from which you get the blocksize,
> >> which is all that you ever actually use here:
> >>
> >>> +	range[0] = (__uint64_t)(block);
> >>> +	range[1] = (__uint64_t)(count);
> >>> +	range[0] *= (__uint64_t)(blocksize);
> >>> +	range[1] *= (__uint64_t)(blocksize);
> >>
> >> any reason to not just pass in the blocksize?
> >>
> >> Maybe this is for flexibility for not-linux, but I guess we don't know what
> >> they need anyway...?
> >>
> >> And if you do that you can change "u_priv" to "data" just to match the
> >> other handlers, perhaps.
> > 
> > You're right, I was so closely following the example that I forget that
> > it can be done more simply. Does this looks good to you ?
> > 
> > static errcode_t unix_discard(io_channel channel, unsigned long long block,
> > 			     unsigned long long count, const void *blocksize)
> > {
> > 	unsigned int    *bsize = (unsigned int *) blocksize;
> 
> I think you can just pass in "int blocksize" right?
> 
> and 
> 
> ret = manager->discard(fs->io, start, count, fs->blocksize);
> 
> -Eric
> 

You are probably right, there is no need for io_manager to pass other
information than just block, count and blocksize, so I'll change discard
definition for that.

Thanks!

-Lukas
