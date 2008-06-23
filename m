From: Mingming <cmm@us.ibm.com>
Subject: Re: [PATCH] delalloc: Add block reservation estimate for
	non-extent files
Date: Mon, 23 Jun 2008 11:57:31 -0700
Message-ID: <1214247451.27507.247.camel@BVR-FS.beaverton.ibm.com>
References: <1214010691.27507.223.camel@BVR-FS.beaverton.ibm.com>
	 <20080621102520.GA9584@skywalker>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:44659 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753379AbYFWS55 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Jun 2008 14:57:57 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m5NIvuNa032724
	for <linux-ext4@vger.kernel.org>; Mon, 23 Jun 2008 14:57:56 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m5NIurnk186154
	for <linux-ext4@vger.kernel.org>; Mon, 23 Jun 2008 14:56:54 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m5NIurBf006259
	for <linux-ext4@vger.kernel.org>; Mon, 23 Jun 2008 14:56:53 -0400
In-Reply-To: <20080621102520.GA9584@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Sat, 2008-06-21 at 15:55 +0530, Aneesh Kumar K.V wrote:
> On Fri, Jun 20, 2008 at 06:11:31PM -0700, Mingming wrote:
> > Add support for full delayed allocation over ext3 format file.
> > 
> > This patch added a function to estimate the number of indirect blocks need
> > to reserve for non-extent based (ext3) file, in order to properly
> > reserve the need amount of indirect blocks for delayed allocation.
> > 
> > 
> > Signed-off-by: Mingming Cao <cmm@us.ibm.com>
> > ---
> >  fs/ext4/inode.c |   34 ++++++++++++++++++++++++++++++++--
> >  1 file changed, 32 insertions(+), 2 deletions(-)
> > 
> > Index: linux-2.6.26-rc6/fs/ext4/inode.c
> > ===================================================================
> > --- linux-2.6.26-rc6.orig/fs/ext4/inode.c	2008-06-20 16:50:09.000000000 -0700
> > +++ linux-2.6.26-rc6/fs/ext4/inode.c	2008-06-20 17:36:08.000000000 -0700
> > @@ -1426,6 +1426,36 @@ static int ext4_journalled_write_end(str
> > 
> >  	return ret ? ret : copied;
> >  }
> > +/*
> > + * Calculate the number of metadata blocks need to reserve
> > + * to allocate @blocks for non extent file based file
> > + */
> > +static int ext4_indirect_calc_metadata_amount(struct inode *inode, int blocks)
> > +{
> > +	int icap = EXT4_ADDR_PER_BLOCK(inode->i_sb);
> > +	int ind_blks, dind_blks, tind_blks;
> > +
> > +	/* number of new indirect blocks needed */
> > +	ind_blks = (blocks + icap - 1) / icap;
> > +
> > +	dind_blks = (ind_blks + icap - 1) / icap;
> > +
> > +	tind_blks = 1;
> > +
> > +	return ind_blks + dind_blks + tind_blks;
> > +}
> > +
> 
> With block mapped files using logical block number we should be able to
> find out the exact number of meta-data blocks we would need. I am not sure
> whether we need to be that complex is calculating the same.
> 

Yeah the complexity is the part I was trying to avoid, plus we can't get
the exact number unless lock the indirect block mapping tree to do the
look up, that's seems too expensive to me as this is called for every
write..

Mingming

