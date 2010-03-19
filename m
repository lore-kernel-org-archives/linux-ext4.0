From: jing zhang <zj.barak@gmail.com>
Subject: Re: [PATCH] ext4: memory leakage in ext4_discard_preallocations
Date: Fri, 19 Mar 2010 22:17:39 +0800
Message-ID: <ac8f92701003190717u19334b4ei58e4829e4651db22@mail.gmail.com>
References: <ac8f92701003180539h7228040bm82a0c69d678ec93b@mail.gmail.com>
	 <20100318174629.GK8256@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@sun.com>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yx0-f182.google.com ([209.85.210.182]:59053 "EHLO
	mail-yx0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265Ab0CSORk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 19 Mar 2010 10:17:40 -0400
Received: by yxe12 with SMTP id 12so634669yxe.33
        for <linux-ext4@vger.kernel.org>; Fri, 19 Mar 2010 07:17:39 -0700 (PDT)
In-Reply-To: <20100318174629.GK8256@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>>  		ext4_get_group_no_and_offset(sb, pa->pa_pstart, &group, NULL);
>> @@ -3811,6 +3813,12 @@ repeat:
>>  		list_del(&pa->u.pa_tmp_list);
>>  		call_rcu(&(pa)->u.pa_rcu, ext4_mb_pa_callback);
>>  	}
>> +	if (! list_empty(&list)) {
>> +		if (occurs++ < 2)
>> +			goto best_efforts;
>> +		else
>> +			BUG();
>> +	}
>>  	if (ac)
>>  		kmem_cache_free(ext4_ac_cachep, ac);
>>  }
>
> Hmm, I'm not sure that BUG() is appropriate here.  If there is an
> I/O error reading the block bitmap, #1, retrying isn't going to help,
> and #2, bringing down the entire system just because of an I/O error
> in reading the block bitmap doesn't seem right.

But disk hardware error is not rare,

> Right now, if there is a problem, we just end up leaving the
> preallocated list on the inode.  Does that cause problems later on
> down the line which you have observed?
>
> 					- Ted

and is there still chance to call the
       call_rcu(&(pa)->u.pa_rcu, ext4_mb_pa_callback);
function again later on? (I am not sure yet the chance does exist.)

If no chance, how about the kmem_cache subsystem then?
After reboot, the file system is still reliable, or just with a few lost blocks?

Thus it is necessary, at least for me, to make sure whether the chance exists.
                                      - zj
