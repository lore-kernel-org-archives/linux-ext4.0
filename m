From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: Fix discard of inode prealloc space with delayed
	allocation.
Date: Wed, 25 Feb 2009 23:07:40 +0530
Message-ID: <20090225173740.GA10367@skywalker>
References: <1235578922-7790-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <m3y6vusbcf.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Dmitri Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:57465 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836AbZBYRiU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 Feb 2009 12:38:20 -0500
Received: from d23relay02.au.ibm.com (d23relay02.au.ibm.com [202.81.31.244])
	by e23smtp04.au.ibm.com (8.13.1/8.13.1) with ESMTP id n1PHaP3e010729
	for <linux-ext4@vger.kernel.org>; Thu, 26 Feb 2009 04:36:25 +1100
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay02.au.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n1PHcXKn917528
	for <linux-ext4@vger.kernel.org>; Thu, 26 Feb 2009 04:38:33 +1100
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n1PHcFF5027099
	for <linux-ext4@vger.kernel.org>; Thu, 26 Feb 2009 04:38:15 +1100
Content-Disposition: inline
In-Reply-To: <m3y6vusbcf.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 25, 2009 at 07:57:52PM +0300, Dmitri Monakhov wrote:
> "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> writes:
> 
> > With delayed allocation we should not/cannot discard inode prealloc space
> > during file close. We would still have dirty pages for which we haven't allocated
> > blocks yet. With this fix after each get_blocks request we check whether we have
> > zero reserved blocks and if yes and we don't have any writers on the file we
> > discard inode prealloc space.
> >
> > Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> >
> > ---
> >  fs/ext4/file.c  |    9 ++++++++-
> >  fs/ext4/inode.c |    6 ++++++
> >  2 files changed, 14 insertions(+), 1 deletions(-)
> >
> > diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> > index f731cb5..4e468e2 100644
> > --- a/fs/ext4/file.c
> > +++ b/fs/ext4/file.c
> > @@ -33,9 +33,16 @@
> >   */
> >  static int ext4_release_file(struct inode *inode, struct file *filp)
> >  {
> > +	int rsv_data_blocks;
> > +
> > +	spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
> > +	rsv_data_blocks = EXT4_I(inode)->i_reserved_data_blocks;
> > +	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
> > +
> Seems we have race condition here because at this point someone may:
> 1)open file
> 2)then perform some write activity => (i_reserved_data_blocks != 0)
> 3)close file => (inode->i_writecount == 1)
> 

i_data_sem doesn't actually ensure i_reserved_data_blocks won't change.
We update i_reserved_data_blocks during block reservation
(ext4_da_write_begin). But yes what you mentioned is possible.
But I am not sure we need to be worried about that. It is true that
throwing away prealloc space is not good. But we still do block allocation
based on goal blocks. So we may end up allocating blocks within the
discarded prealloc space again.

What is bad is that if we don't discard the prealloc space even after
all the needed block allocation. That would mean nothing can be
allocated out of that prealloc space. With the current code We would
be discarding the prealloc space only when we hit ENOSPC 
. But then that would be bad.

-aneesh

