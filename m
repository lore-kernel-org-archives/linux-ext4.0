From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: ext4 lock ordering patch
Date: Mon, 26 May 2008 23:21:09 +0530
Message-ID: <20080526175109.GA14718@skywalker>
References: <20080526173452.GL32407@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:59408 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087AbYEZRvS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 26 May 2008 13:51:18 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp04.au.ibm.com (8.13.1/8.13.1) with ESMTP id m4QHoXlK023604
	for <linux-ext4@vger.kernel.org>; Tue, 27 May 2008 03:50:33 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m4QHp1M44571172
	for <linux-ext4@vger.kernel.org>; Tue, 27 May 2008 03:51:01 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m4QHpFod003659
	for <linux-ext4@vger.kernel.org>; Tue, 27 May 2008 03:51:16 +1000
Content-Disposition: inline
In-Reply-To: <20080526173452.GL32407@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 26, 2008 at 07:34:52PM +0200, Jan Kara wrote:
>   Hi Mingming,
> 
>   I've noticed you removed the patch reversing locking order of page lock
> and transaction start from ext4 patch queue. Was this because of that
> reported performance problem or for some other reason? As far as I've
> understood that problem has been just in the patch fixing the delalloc mode
> part so just removing that patch would be enough AFAICT.
>   Anyway, the problem is I have now ordered mode rewrite for JBD2/ext4
> which depends on this patch so the question is how to proceed... Should we
> first fix that delalloc problem (are you looking into that?) or do we merge
> all the changes and then fixup the delalloc code?
> 
> 								Honza

That was due to delalloc interaction with locking order change patches.
I am right now testing some changes for delalloc. But I still have file
system hang with fsstress. So I haven't posted the latest changes yet.


-aneesh
