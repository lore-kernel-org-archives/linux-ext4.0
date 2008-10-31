From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC][PATCH 7/9]ext4: Add the EXT4_IOC_FIEMAP_INO ioctl
Date: Fri, 31 Oct 2008 06:05:47 -0400
Message-ID: <20081031100547.GA22093@infradead.org>
References: <49019EF6.4000706@rs.jp.nec.com> <20081026084048.GF3184@webber.adilger.int> <20081026084848.GA9270@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Akira Fujita <a-fujita@rs.jp.nec.com>, linux-ext4@vger.kernel.org,
	Theodore Tso <tytso@mit.edu>, Mingming Cao <cmm@us.ibm.com>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:52626 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbYJaKFt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 31 Oct 2008 06:05:49 -0400
Content-Disposition: inline
In-Reply-To: <20081026084848.GA9270@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Akira, can you please comment on these issues before going on?
I think the generation issue is a particularly important one if you
want to allow defrag by normal users.

On Sun, Oct 26, 2008 at 04:48:48AM -0400, Christoph Hellwig wrote:
> On Sun, Oct 26, 2008 at 02:40:48AM -0600, Andreas Dilger wrote:
> > This was mentioned last time these patches were posted, but there was
> > no reply from you.  Christoph suggested a more generic VFS open-by-inum,
> > which isn't impossible to do but would cause a lot of controversy I
> > think, while the EXT4_IOC_WRAPPER is at least contained within ext4,
> > but is more generically useful than EXT4_IOC_FIEMAP_INO.
> 
> I'll hack up a generic open_by_handle and then we can gather the
> reaction - it shouldn't be more than about one or two hundred lines of
> code.  Note that you really want an open by handle and not just inum for
> a defragmentation tool - without the generation you can easily run into
> races.
> 
> Btw, any reason the XFS approach of passing in *file descriptors* for both
> the inode to be defragmented and the "donor" inode doesn't work for you?
