From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: EXT4: kernel BUG at fs/ext4/mballoc.c:1721!
Date: Mon, 7 Sep 2009 15:05:20 +0530
Message-ID: <20090907093520.GA6079@skywalker.linux.vnet.ibm.com>
References: <4A9F7B48.9010903@in.ibm.com> <20090903112003.GA13105@skywalker.linux.vnet.ibm.com> <4AA0CF83.8060405@in.ibm.com> <20090904084943.GB19757@skywalker.linux.vnet.ibm.com> <20090904125233.GE4197@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sachin Sant <sachinp@in.ibm.com>, linux-ext4@vger.kernel.org,
	Theodore Tso <tytso@mit.edu>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:54508 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbZIGJfp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Sep 2009 05:35:45 -0400
Received: from d23relay01.au.ibm.com (d23relay01.au.ibm.com [202.81.31.243])
	by e23smtp06.au.ibm.com (8.14.3/8.13.1) with ESMTP id n879Zg3E029194
	for <linux-ext4@vger.kernel.org>; Mon, 7 Sep 2009 19:35:42 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay01.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n879Zkmd434562
	for <linux-ext4@vger.kernel.org>; Mon, 7 Sep 2009 19:35:46 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n879ZjAW028859
	for <linux-ext4@vger.kernel.org>; Mon, 7 Sep 2009 19:35:46 +1000
Content-Disposition: inline
In-Reply-To: <20090904125233.GE4197@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 04, 2009 at 06:52:33AM -0600, Andreas Dilger wrote:
> On Sep 04, 2009  14:19 +0530, Aneesh Kumar wrote:
> > Ok i am running test with the below patch. It is more invasive in that it
> > moves the need init flag check into load buddy. I guess we need to do that,
> > otherwise we will be operating with stale buddy information when
> > we have resize happening parallel. Also with the patch i posted before
> > we still have issues as explained below
> > 
> > a) we check for init flag we find it doesn't need an cache init
> > b) we resize and mark the group in need for init
> > c) in load buddy we look at the pageuptodate flag and find it uptodate
> >    and continue using the old buddy cache information.
> 
> Why not have the resize code do the update of the buddy bitmap also?
> When we were just using the block bitmap for allocation the resize
> code would clear the bits in the bitmap just like deleting a file,
> so that it was totally coherent with any other bitmap user.  Having
> the resize code do the same with the buddy (instead of only marking
> it stale and leaving it for another process to refresh) should avoid
> the race condition entirely.
> 

We have EXT4_GROUP_INFO_NEED_INIT_BIT used at mutliple places. So
having ext4_mb_load_buddy check for EXT4_GROUP_INFO_NEED_INIT_BIT
flag make sense. It also allows us to consolidate the group init
in one location. Another advantage is, with ext4_mb_load_buddy checking
for EXT4_GROUP_INFO_NEED_INIT_BIT flag, we don't do reinit the buddy
cache each time we add few blocks to the group. 

-aneesh
