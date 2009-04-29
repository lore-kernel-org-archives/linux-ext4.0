From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH -V3] Fix sub-block zeroing for buffered writes into
	unwritten extents
Date: Wed, 29 Apr 2009 10:16:23 +0530
Message-ID: <20090429044623.GA7766@skywalker>
References: <1240944653-4328-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1240968626.5583.25.camel@BVR-FS.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: Mingming <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:37821 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbZD2Eqb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 29 Apr 2009 00:46:31 -0400
Received: from d23relay01.au.ibm.com (d23relay01.au.ibm.com [202.81.31.243])
	by e23smtp02.au.ibm.com (8.13.1/8.13.1) with ESMTP id n3T4iweH013507
	for <linux-ext4@vger.kernel.org>; Wed, 29 Apr 2009 14:44:58 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay01.au.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n3T4kTwa438704
	for <linux-ext4@vger.kernel.org>; Wed, 29 Apr 2009 14:46:29 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n3T4kT9v012185
	for <linux-ext4@vger.kernel.org>; Wed, 29 Apr 2009 14:46:29 +1000
Content-Disposition: inline
In-Reply-To: <1240968626.5583.25.camel@BVR-FS.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 28, 2009 at 06:30:26PM -0700, Mingming wrote:
> 
> On Wed, 2009-04-29 at 00:20 +0530, Aneesh Kumar K.V wrote:
> > We need to mark the  buffer_head mapping prealloc space
> > as new during write_begin. Otherwise we don't zero out the
> > page cache content properly for a partial write. This will
> > cause file corruption with preallocation.
> > 
> > Also use block number -1 as the fake block number so that
> > unmap_underlying_metadata doesn't drop wrong buffer_head
> > 
> > Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> > 
> > ---
> >  fs/ext4/inode.c |   11 ++++++++++-
> >  1 files changed, 10 insertions(+), 1 deletions(-)
> > 
> > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> > index e91f978..0214389 100644
> > --- a/fs/ext4/inode.c
> > +++ b/fs/ext4/inode.c
> > @@ -2318,11 +2318,20 @@ static int ext4_da_get_block_prep(struct inode *inode, sector_t iblock,
> >  			/* not enough space to reserve */
> >  			return ret;
> > 
> > -		map_bh(bh_result, inode->i_sb, 0);
> > +		map_bh(bh_result, inode->i_sb, -1);
> >  		set_buffer_new(bh_result);
> >  		set_buffer_delay(bh_result);
> >  	} else if (ret > 0) {
> >  		bh_result->b_size = (ret << inode->i_blkbits);
> > +		bh_result->b_bdev = inode->i_sb->s_bdev;
> > +		bh->b_blocknr = -1;
> 
> A small typo, should be bh_result->b_blocknr
> 
> But isn't this will incorrect set up the b_blocknr for normal
> successful(allocated, non preallocated) get_block lookup? As
> ext4_get_blocks_wrap() will return 1 (>0) if it found it allocated.
> 
> > +		/*
> > +		 * With sub-block writes into unwritten extents
> > +		 * we also need to mark the buffer as new so that
> > +		 * the unwritten parts of the buffer gets correctly zeroed.
> > +		 */
> > +		if (buffer_unwritten(bh_result))
> > +			set_buffer_new(bh_result);
> >  		ret = 0;
> >  	}
> > 
> 
> I think it nicer to setup the fake block_nr together when
> set_buffer_new(), at the ext4_ext_get_block() time when it handles
> preallocation lookup on delalloc. This will avoid calling
> buffer_unwritten(bh_result) check for every return bh result for
> ext4_get_blocks_wrap(). And makes the logic more saner.
> 
> How about patch attached, tested with my testcase, the partial write
> preallocation corruption is fixed.
> 
> But looking at the comment change, looks like the original intention is
> to set the buffer unwritten so that a read from that uninitialzed block
> returns 0. Turns out the VFS needs to set the buffer new for this
> purpose.

Should work. My only concern is this change will have impact on the read
path and for non delalloc case. For 2.6.30 I guess we can do the change
only for delayed alloc case which is less intrusive.(ie to to change only
ext4_da_get_block_prep). I have split the patches into two and will send a
follow up patch. For .31 we want to do return with same buffer_head flags 
that xfs sets for delayed and unwritten extents.

-aneesh


