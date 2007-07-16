From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: Initial results of FLEX_BG feature.
Date: Mon, 16 Jul 2007 07:27:18 -0500
Message-ID: <20070716072718.339551e0@gara>
References: <20070710112307.34c2ba5c@rx8>
	<20070711041213.GH6417@schatzie.adilger.int>
	<20070711003004.531c9307@naruto>
	<20070711221425.GH19456@thunk.org>
	<20070712100906.2e2afb9c@gara>
	<20070716063457.GA5992@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:40323 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760263AbXGPM3E (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Jul 2007 08:29:04 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l6GCUHGw029548
	for <linux-ext4@vger.kernel.org>; Mon, 16 Jul 2007 08:30:17 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.4) with ESMTP id l6GCT4f8557362
	for <linux-ext4@vger.kernel.org>; Mon, 16 Jul 2007 08:29:04 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l6GCT3pa030410
	for <linux-ext4@vger.kernel.org>; Mon, 16 Jul 2007 08:29:03 -0400
In-Reply-To: <20070716063457.GA5992@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 16 Jul 2007 00:34:57 -0600
Andreas Dilger <adilger@clusterfs.com> wrote:

> On Jul 12, 2007  10:09 -0500, Jose R. Santos wrote:
> > @@ -1271,6 +1271,9 @@ static int ext4_check_descriptors (struc
> >  
> >  	ext4_debug ("Checking group descriptors");
> >  
> > +	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLEX_BG))
> > +		return 1;
> > +
> >  	for (i = 0; i < sbi->s_groups_count; i++)
> >  	{
> >  		if (i == sbi->s_groups_count - 1)
> 
> It looks pretty straight forward to just change this code to leave
> first_block at s_first_data_block, and leave last_block at ext4_blocks_count()
> if FLEX_BG is set.

Sure.  I'll add that.
 
> Even with FLEX_BG we want to keep the group metadata within the bounds of
> the filesystem.

Eventually, I want to be able to export the groups per flex groups so
that we can correctly calculate where the bounds of each block groups
metadata should be.

> Cheers, Andreas
> --
> Andreas Dilger
> Principal Software Engineer
> Cluster File Systems, Inc.
> 

-JRS
