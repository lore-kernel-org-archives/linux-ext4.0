From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: Fix ext4_bmap to flush the data to the disk with
	delalloc
Date: Thu, 19 Jun 2008 00:00:47 +0530
Message-ID: <20080618183047.GA24400@skywalker>
References: <1213811531-23829-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <48594DF4.3060000@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, tytso@mit.edu, adilger@sun.com,
	linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:58707 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755021AbYFRSbH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 18 Jun 2008 14:31:07 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp05.au.ibm.com (8.13.1/8.13.1) with ESMTP id m5IIURiu010040
	for <linux-ext4@vger.kernel.org>; Thu, 19 Jun 2008 04:30:27 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m5IIUhH44227122
	for <linux-ext4@vger.kernel.org>; Thu, 19 Jun 2008 04:30:43 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m5IIV3Oi000993
	for <linux-ext4@vger.kernel.org>; Thu, 19 Jun 2008 04:31:04 +1000
Content-Disposition: inline
In-Reply-To: <48594DF4.3060000@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 18, 2008 at 01:03:32PM -0500, Eric Sandeen wrote:
> Aneesh Kumar K.V wrote:
> > With delalloc we don't do block allocation in the write_begin/write_end.
> > So when using bmap we first need to flush data to the disk so that blocks
> > get allocated and then call generic_block_bmap.
> > 
> > Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> > ---
> >  fs/ext4/inode.c |   11 +++++++++++
> >  1 files changed, 11 insertions(+), 0 deletions(-)
> > 
> > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> > index 7035621..cfeb869 100644
> > --- a/fs/ext4/inode.c
> > +++ b/fs/ext4/inode.c
> > @@ -1833,6 +1833,17 @@ sector_t ext4_bmap(struct address_space *mapping, sector_t block)
> >  	journal_t *journal;
> >  	int err;
> >  
> > +	if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY) &&
> > +			test_opt(inode->i_sb, DELALLOC)) {
> > +		/*
> > +		 * With delalloc we want to sync the file
> > +		 * so that we can make sure we allocate
> > +		 * blocks for file
> > +		 */
> > +		filemap_fdatawrite(mapping);
> > +		filemap_fdatawait(mapping);
> > +	}
> 
> This seems fine.
> 
> I wonder, does it make any sense at all to only do the flushing if the
> block we wish to map is actually in a delalloc state at the moment?
> 

I am not sure it is worth the complexity considering bmap is not a
frequently used API. Initially I was even thinking should i be doing
it only for delalloc. That test seems to be a simple one to put.

-aneesh
