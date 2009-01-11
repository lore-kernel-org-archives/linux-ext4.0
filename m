From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: fix unhandled ext4_free_data allocation failure
Date: Sun, 11 Jan 2009 08:46:32 -0600
Message-ID: <496A0648.9050100@redhat.com>
References: <20081223104016.GC7217@localhost.localdomain> <20081223142915.GA23303@unused.rdu.redhat.com> <961aa3350812231437x4debaf9byf230a63582561010@mail.gmail.com> <20090111020352.GA4285@localhost.localdomain> <20090111143942.GA28488@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	Theodore Tso <tytso@mit.edu>, adilger@sun.com,
	linux-ext4@vger.kernel.org
To: Josef Bacik <jbacik@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:47388 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468AbZAKOrb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 11 Jan 2009 09:47:31 -0500
In-Reply-To: <20090111143942.GA28488@unused.rdu.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Josef Bacik wrote:
> On Sun, Jan 11, 2009 at 11:03:53AM +0900, Akinobu Mita wrote:
>> In ext4_mb_free_blocks() ext4_free_data allocation failure
>> is not handled. This error handling cannot be simple error return because
>> ext4_mb_free_blocks() cannot fail.
>>
>> This patch add __GFP_NOFAIL to gfp mask for the allocation.
>>
>> Cc: Theodore Tso <tytso@mit.edu>
>> Cc: adilger@sun.com
>> Cc: linux-ext4@vger.kernel.org
>> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> 
> Sorry but thats still not right, the fs should never force the box to come up
> with memory, it should be able to gracefully handle ENOMEM cases.  This patch
> does this properly.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@redhat.com>
> 
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 918aec0..e97ea09 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -4886,6 +4886,10 @@ do_more:
>  		 * be used until this transaction is committed
>  		 */
>  		new_entry  = kmem_cache_alloc(ext4_free_ext_cachep, GFP_NOFS);
> +		if (!new_entry) {
> +			err = -ENOMEM;
> +			goto error_return;
> +		}
>  		new_entry->start_blk = bit;
>  		new_entry->group  = block_group;
>  		new_entry->count = count;

Well, this will now force a filesystem error (then remount-ro or panic
(or ignore) if the allocation fails.  I'm not sure that's better...?

-Eric
