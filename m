From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: page_cache pages not released in
 ext4_mb_load_buddy()
Date: Fri, 26 Mar 2010 13:34:46 +0530
Message-ID: <87y6hfv78h.fsf@linux.vnet.ibm.com>
References: <ac8f92701003240721l7a7079dnd9cbd55526cd1788@mail.gmail.com>
	<87eij9d5qs.fsf@linux.vnet.ibm.com>
	<ac8f92701003250702u4d98bbe3n3d486e462de192af@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	"Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: jing zhang <zj.barak@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:35474 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab0CZIE4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Mar 2010 04:04:56 -0400
Received: from d23relay05.au.ibm.com (d23relay05.au.ibm.com [202.81.31.247])
	by e23smtp09.au.ibm.com (8.14.3/8.13.1) with ESMTP id o2Q84qNj016290
	for <linux-ext4@vger.kernel.org>; Fri, 26 Mar 2010 19:04:52 +1100
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay05.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o2Q7wj6g1441990
	for <linux-ext4@vger.kernel.org>; Fri, 26 Mar 2010 18:58:45 +1100
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o2Q84pa4029091
	for <linux-ext4@vger.kernel.org>; Fri, 26 Mar 2010 19:04:51 +1100
In-Reply-To: <ac8f92701003250702u4d98bbe3n3d486e462de192af@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 25 Mar 2010 22:02:44 +0800, jing zhang <zj.barak@gmail.com> wrote:
> 2010/3/25, Aneesh Kumar K. V <aneesh.kumar@linux.vnet.ibm.com>:
> > On Wed, 24 Mar 2010 22:21:01 +0800, jing zhang <zj.barak@gmail.com> wrote:
> >> From: Jing Zhang <zj.barak@gmail.com>
> >>
> >> Date: Wed Mar 24 20:38:48     2010
> >>
> >> If ext4_mb_init_cache() returns error, there is no page_cache_release()
> >> issued.
> >>
> >> Cc: Theodore Ts'o <tytso@mit.edu>
> >> Cc: Andreas Dilger <adilger@sun.com>
> >> Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
> >> Signed-off-by: Jing Zhang <zj.barak@gmail.com>
> >>
> >> ---
> >>
> >> --- linux-2.6.32/fs/ext4/mballoc.c	2009-12-03 11:51:22.000000000 +0800
> >> +++ ext4_mm_leak/mballoc-9.c	2010-03-24 22:24:56.000000000 +0800
> >> @@ -1132,8 +1132,6 @@ repeat_load_buddy:
> >>  	e4b->bd_buddy = page_address(page) + (poff * sb->s_blocksize);
> >>  	mark_page_accessed(page);
> >>
> >> -	BUG_ON(e4b->bd_bitmap_page == NULL);
> >> -	BUG_ON(e4b->bd_buddy_page == NULL);
> >
> > Why remove these ?
> 
> Just before return successfully, both bitmap page and buddy page are assigned.
> If not either, EIO will branch.
> 
> >
> >>
> >>  	return 0;
> >>
> >> @@ -1142,6 +1140,8 @@ err:
> >>  		page_cache_release(e4b->bd_bitmap_page);
> >>  	if (e4b->bd_buddy_page)
> >>  		page_cache_release(e4b->bd_buddy_page);
> >> +	if (page)
> >> +		page_cache_release(page);
> >>  	e4b->bd_buddy = NULL;
> >>  	e4b->bd_bitmap = NULL;
> >
> > Can you add a comment which says on error page will point to the page
> > cache page which haven't been assigned to neither bd_bitmap_page or
> > bd_buddy_page
> 
> +	if (page)
> +            /* we have to release page here in case that
> +             * ext4_mb_init_cache() returns error when preparing
> +             * either bitmap_ or buddy_page.
> +             */
> +		page_cache_release(page);
> 
> >
> > But good catch !!
> >
> > -aneesh
> >
> 
> Is that ok, Aneesh?

looks good

-aneesh
