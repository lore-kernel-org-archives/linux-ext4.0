From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: ext4 lock ordering patch
Date: Wed, 28 May 2008 14:08:42 -0700
Message-ID: <1212008922.3791.34.camel@localhost.localdomain>
References: <20080526173452.GL32407@duck.suse.cz>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:51328 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753119AbYE1VI5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 28 May 2008 17:08:57 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e3.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m4SL8t05024062
	for <linux-ext4@vger.kernel.org>; Wed, 28 May 2008 17:08:55 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m4SL8iY1148948
	for <linux-ext4@vger.kernel.org>; Wed, 28 May 2008 17:08:44 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m4SL8iY3021232
	for <linux-ext4@vger.kernel.org>; Wed, 28 May 2008 17:08:44 -0400
In-Reply-To: <20080526173452.GL32407@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 2008-05-26 at 19:34 +0200, Jan Kara wrote:
>   Hi Mingming,
> 
Hi Jan,

>   I've noticed you removed the patch reversing locking order of page lock
> and transaction start from ext4 patch queue. Was this because of that
> reported performance problem or for some other reason? As far as I've
> understood that problem has been just in the patch fixing the delalloc mode
> part so just removing that patch would be enough AFAICT.

It was because of the reverse locking handling for delayed allocation.
But we can't just drop the patch fixing the locking order in delalloc
mode part only,  we need to drop the whole delalloc or drop the whole
inverse locking patches. 

>   Anyway, the problem is I have now ordered mode rewrite for JBD2/ext4
> which depends on this patch so the question is how to proceed... Should we
> first fix that delalloc problem (are you looking into that?) or do we merge
> all the changes and then fixup the delalloc code?
> 

Aneesh is close to getting lock reserve fixed for delalloc... Let's see.
If that takes too long I think it make sense to merge the new ordered
mode rewrite first then re-think of the delalloc solution based on
reversed locking (rather than fixing around) and the new ordered mode. 

Mingming

