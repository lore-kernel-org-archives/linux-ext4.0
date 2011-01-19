From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext3: fix trim length underflow with small trim length.
Date: Wed, 19 Jan 2011 12:39:21 +0100
Message-ID: <20110119113921.GA4246@quack.suse.cz>
References: <1295430550-8978-1-git-send-email-tm@tao.ma>
 <alpine.LFD.2.00.1101191125120.2686@dhcp-lab-213.englab.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tao Ma <tm@tao.ma>, linux-ext4@vger.kernel.org,
	Jan Kara <jack@suse.cz>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59963 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753636Ab1ASLjY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 Jan 2011 06:39:24 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1101191125120.2686@dhcp-lab-213.englab.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 19-01-11 11:42:50, Lukas Czerner wrote:
> On Wed, 19 Jan 2011, Tao Ma wrote:
> 
> > From: Tao Ma <boyu.mt@taobao.com>
> > 
> > We adjust 'len' with s_first_data_block - start in case of start is less
> > than s_first_data_block, but it could underflow in case blocksize=1K, while
> > fstrim_range.len=512 and fstrim_range.start = 0. In this case len happens
> > to be underflow and in the end, although we are safe that last_group check
> > will limit the trim to the whole volume, I am afraid that isn't what the user
> > really want.
> > 
> > So this patch fix it. It also adds a new variable s_first_data_block so that
> > the 4 le32_to_cpu can be replaced with 1.
> 
> Well, I just realized that what are we doing is not exactly what will
> user expect. User does not really care where the first data block is.
> What the user will expect is, to trim let's say first one gigabyte
> of his filesystem, not gigabyte - first data block.
> 
> So what I suggest is to always add first_data_block to
> fstrim_range.start and do all the necessary checks for overflow. If no
> one has any objections I'll put it to the patch.
  Well, since we speak about at most 1KB (s_first_data_block is non-zero
only when blocksize == 1024 and in that case it is 1), I don't think it
really matters and I don't mind whatever solution. What user expects is
a bit hard to guess (whether he views 'start' as a start of the filesystem
or a start of the device). Maybe the former makes a tad bit more sense
but as I said I don't really care so since you're the author of the code I
leave it up to you.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
