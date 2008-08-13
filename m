From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/6 ]Ext4: journal credits reservation fixes for DIO,
	fallocate
Date: Wed, 13 Aug 2008 15:44:47 +0530
Message-ID: <20080813101447.GE6439@skywalker>
References: <48841077.500@cse.unsw.edu.au> <20080721082010.GC8788@skywalker> <1216774311.6505.4.camel@mingming-laptop> <20080723074226.GA15091@skywalker> <1217032947.6394.2.camel@mingming-laptop> <1218558190.6766.37.camel@mingming-laptop> <1218558590.6766.47.camel@mingming-laptop> <20080813085307.GC6439@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger@sun.com>
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:54474 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621AbYHMKSi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Aug 2008 06:18:38 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp03.au.ibm.com (8.13.1/8.13.1) with ESMTP id m7DAGiTB007039
	for <linux-ext4@vger.kernel.org>; Wed, 13 Aug 2008 20:16:44 +1000
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7DAEw0G121984
	for <linux-ext4@vger.kernel.org>; Wed, 13 Aug 2008 20:15:19 +1000
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7DAEvSZ001819
	for <linux-ext4@vger.kernel.org>; Wed, 13 Aug 2008 20:14:57 +1000
Content-Disposition: inline
In-Reply-To: <20080813085307.GC6439@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 13, 2008 at 02:23:07PM +0530, Aneesh Kumar K.V wrote:
> > 
> >  	if (create && !handle) {
> >  		/* Direct IO write... */
> >  		if (max_blocks > DIO_MAX_BLOCKS)
> >  			max_blocks = DIO_MAX_BLOCKS;
> > -		handle = ext4_journal_start(inode, DIO_CREDITS +
> > -			      2 * EXT4_QUOTA_TRANS_BLOCKS(inode->i_sb));
> > +		dio_credits = ext4_data_trans_blocks(inode, max_blocks);
> > +		handle = ext4_journal_start(inode, dio_credits);
> 
> Even in data=journal mode directIO will put the buffer_heads to journal
> right ? . So should we use ext4_data_trans_blocks here ?
> 

That should be
Even in data=journal mode directIO will NOT put the buffer_heads to journal

> 
> 
> >  		if (IS_ERR(handle)) {
> >  			ret = PTR_ERR(handle);
> >  			goto out;
> > @@ -2222,7 +2214,7 @@ static int ext4_da_writepage(struct page
> >   * for DIO, writepages, and truncate
> >   */
> >  #define EXT4_MAX_WRITEBACK_PAGES      DIO_MAX_BLOCKS
> > -#define EXT4_MAX_WRITEBACK_CREDITS    DIO_CREDITS
> > +#define EXT4_MAX_WRITEBACK_CREDITS    25
> > 
> >  static int ext4_da_writepages(struct address_space *mapping,
> >  				struct writeback_control *wbc)
> > @@ -4429,7 +4421,8 @@ static int ext4_writeblocks_trans_credit


-aneesh
