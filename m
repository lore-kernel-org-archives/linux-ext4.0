From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC PATCH] mark buffer_head mapping preallocate area as new during write_begin with delayed allocation
Date: Wed, 29 Apr 2009 13:57:27 +0200
Message-ID: <20090429115727.GC18195@atrey.karlin.mff.cuni.cz>
References: <1240859143-31122-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1240873494.6775.8.camel@mingming-laptop> <20090428042049.GA6520@skywalker> <20090428093145.GA13719@skywalker> <20090428124821.GJ22104@mit.edu> <20090428163554.GA27670@skywalker> <20090428170047.GC24043@mit.edu> <20090428185749.GA3275@skywalker> <49F75A9C.6000307@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Theodore Tso <tytso@mit.edu>, Mingming Cao <cmm@us.ibm.com>,
	linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34282 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754966AbZD2L52 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 29 Apr 2009 07:57:28 -0400
Content-Disposition: inline
In-Reply-To: <49F75A9C.6000307@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Aneesh Kumar K.V wrote:
> > On Tue, Apr 28, 2009 at 01:00:47PM -0400, Theodore Tso wrote:
> >> On Tue, Apr 28, 2009 at 10:05:54PM +0530, Aneesh Kumar K.V wrote:
> ...
> >>>> The other problem seems to be in the case of a delayed allocation
> >>>> write, where we return a buffer_head which is marked new, and this
> >>>> causes block_prepare_write() to call unmap_underlying_metadata(dev, 0).
> >>> Not just that. On block allocation we are not calling
> >>> unmap_underlying_metadata(dev, blocknumber) for delayed allocated
> >>> blocks. That would imply file corruption.
> >> I don't think I'm following you .  If we write into block that was
> >> delayed allocated.  Are you saying we might get in trouble of the
> >> delayed allocation block is mmap'ed in?
> > 
> > We allocate blocks for delayed buffer during writepage. Now we need to
> > make sure after getting the blocks we drop the old buffer_head mapping
> > that we may have with this particular block attached to the block
> > device. That is done by calling unmap_underlying_metadata. Now the
> > current code doesn't call unmap_underlying_metadata for delayed
> > allocated blocks. That would mean we can see corrupt files if old
> > buffer_head mapping gets synced to disk AFTER we write the new
> > buffer_head mapping.
> 
> 
> Talking w/ Aneesh on IRC, I don't see how we can have stray dirty
> mappings lying around for this block device unless someone is writing
> directly to the mounted block device, which I don't think is ever
> considered safe ...
> 
> I'm not quite sure what the call to __unmap_underlying_blocks() in
> mpage_da_map_blocks() is for, I guess?
  For ext3 / ext4 I think we don't need unmap_underlying_blocks() since
before we reallocate a block, we make sure that the transaction freeing
the block is committed and clear all dirty bits from freed blocks.
  But for more careless filesystems, if they reallocate metadata block
as a data block and don't clear the dirty bit in blockdev mapping,
unmap_underlying_blocks() does it for them.

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
