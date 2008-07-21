From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] e2fsprogs: Fix tst_extents output on bigendian machine.
Date: Mon, 21 Jul 2008 11:33:00 +0530
Message-ID: <20080721060300.GB8788@skywalker>
References: <1216382740-24369-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20080721050755.GD3370@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:57717 "EHLO
	e28esmtp04.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754186AbYGUGDH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Jul 2008 02:03:07 -0400
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28esmtp04.in.ibm.com (8.13.1/8.13.1) with ESMTP id m6L633kb002353
	for <linux-ext4@vger.kernel.org>; Mon, 21 Jul 2008 11:33:03 +0530
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6L633Sq978980
	for <linux-ext4@vger.kernel.org>; Mon, 21 Jul 2008 11:33:03 +0530
Received: from d28av04.in.ibm.com (loopback [127.0.0.1])
	by d28av04.in.ibm.com (8.13.1/8.13.3) with ESMTP id m6L632v9016664
	for <linux-ext4@vger.kernel.org>; Mon, 21 Jul 2008 11:33:03 +0530
Content-Disposition: inline
In-Reply-To: <20080721050755.GD3370@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jul 20, 2008 at 11:07:55PM -0600, Andreas Dilger wrote:
> On Jul 18, 2008  17:35 +0530, Aneesh Kumar wrote:
> >  static void dbg_show_header(struct ext3_extent_header *eh)
> >  {
> >  	printf("header: magic=%x entries=%u max=%u depth=%u generation=%u\n",
> > -	       eh->eh_magic, eh->eh_entries, eh->eh_max, eh->eh_depth,
> > -	       eh->eh_generation);
> > +			ext2fs_le16_to_cpu(eh->eh_magic),
> > +			ext2fs_le16_to_cpu(eh->eh_entries),
> > +			ext2fs_le16_to_cpu(eh->eh_max),
> > +			ext2fs_le16_to_cpu(eh->eh_depth),
> > +			ext2fs_le32_to_cpu(eh->eh_generation));
> 
> Please fix indenting to align this with the '(' on the preceeding line.
> 

I am always confused what is the suggested coding guideline here. I
always use TAB instead of space and use TAB aligned offsets for the
continuation line.


-aneesh
