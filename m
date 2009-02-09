From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] Validate extent details only when read from the disk
Date: Mon, 9 Feb 2009 16:18:57 +0530
Message-ID: <20090209104857.GE31884@skywalker>
References: <20090207173239.GA25942@skywalker> <1234036882-30656-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1234036882-30656-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <49900612.3020609@ph.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Thiemo Nagel <thiemo.nagel@ph.tum.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:44320 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157AbZBIKtB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 Feb 2009 05:49:01 -0500
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28smtp06.in.ibm.com (8.13.1/8.13.1) with ESMTP id n19AmxaH020608
	for <linux-ext4@vger.kernel.org>; Mon, 9 Feb 2009 16:18:59 +0530
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id n19An56Q4227116
	for <linux-ext4@vger.kernel.org>; Mon, 9 Feb 2009 16:19:05 +0530
Received: from d28av03.in.ibm.com (loopback [127.0.0.1])
	by d28av03.in.ibm.com (8.13.1/8.13.3) with ESMTP id n19Amwso014992
	for <linux-ext4@vger.kernel.org>; Mon, 9 Feb 2009 21:48:58 +1100
Content-Disposition: inline
In-Reply-To: <49900612.3020609@ph.tum.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 09, 2009 at 11:31:46AM +0100, Thiemo Nagel wrote:
> Aneesh Kumar K.V wrote:
> > Make sure we validate extent details only when read from the disk.
> >
> > @@ -602,15 +607,13 @@ struct ext4_ext_path *
> >  ext4_ext_find_extent(struct inode *inode, ext4_lblk_t block,
> >  					struct ext4_ext_path *path)
> >  {
> > +	int need_to_validate = 0;
> >  	struct ext4_extent_header *eh;
> >  	struct buffer_head *bh;
> >  	short int depth, i, ppos = 0, alloc = 0;
> >  
> >  	eh = ext_inode_hdr(inode);
> >  	depth = ext_depth(inode);
> > -	if (ext4_ext_check(inode, eh, depth))
> > -		return ERR_PTR(-EIO);
> > -
> 

I am doing the check in ext4_iget while reading the inode from disk.

-aneesh
