From: Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
Subject: Re: [PATCH 0/2] ext4: Reduce contention on s_orphan_lock
Date: Fri, 02 May 2014 15:56:56 -0600
Message-ID: <536414A8.2040506@hp.com>
References: <1398814353-11904-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>, T Makphaibulchoke <tmac@hp.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from g2t2354.austin.hp.com ([15.217.128.53]:10906 "EHLO
	g2t2354.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446AbaEBV6S (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 2 May 2014 17:58:18 -0400
In-Reply-To: <1398814353-11904-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 04/29/2014 05:32 PM, Jan Kara wrote:
> 
>   Hello,
> 
>   so I finally got to looking into your patches for reducing contention
> on s_orphan_lock. AFAICT these two patches (the first one is just a
> small cleanup) should have the same speed gain as the patches you wrote
> and they are simpler. Can you give them a try please? Thanks!
> 
> 								Honza
> 

I applied your patch and ran aim7 on both the 80 and 120 core count machines.  There are aim7 workloads that your patch does show some performance improvement.  Unfortunately in general, it does not have the same performance level as my original patch, especially with high user count, 500 or more.

As for the hashed mutex used in my patch to serialize orphan operation within a single node, even if I agree with you that with existing code it is not required, I don't believe that you can count on that in the future.  I believe that is also your concern, as you also added comment indicating the requirement of the i_mutex in your patch.

In terms of maintainability, I do not believe simply relying on warning in a comment is sufficient.  On top of that with this new requirement, we are unnecessarily coupling the orphan operations to i_mutex, adding more contention to it.  This would likely to cause performance regression, as my experiment in responding to your earlier comment on my patch did show some regression when using i_mutex for serialization of orphan operations within a single node (adding code to lock the if it is not already locked).

I still believe having a different mutex for orphan operation serialization is a better and safer alternative.  From my experiment so far (I'm still verifying this), it may even help improving the performance by spreading out the contention on the s_orphan_mutex.

Please also see my response to patch 2/2 for comments on the actual code.

Thanks,
Mak.


