From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] ext4: memory leakage in ext4_discard_preallocations
Date: Fri, 19 Mar 2010 11:27:44 -0600
Message-ID: <67790F0F-9921-4A98-8DC6-DA1C00CE6CA9@sun.com>
References: <ac8f92701003180539h7228040bm82a0c69d678ec93b@mail.gmail.com>
 <20100318174629.GK8256@thunk.org>
 <ac8f92701003190717u19334b4ei58e4829e4651db22@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7BIT
Cc: tytso@mit.edu, linux-ext4 <linux-ext4@vger.kernel.org>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: jing zhang <zj.barak@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:49507 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792Ab0CSR1s (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 19 Mar 2010 13:27:48 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id o2JHRjdX025392
	for <linux-ext4@vger.kernel.org>; Fri, 19 Mar 2010 10:27:47 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KZJ00B00GZO2G00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Fri,
 19 Mar 2010 10:27:45 -0700 (PDT)
In-reply-to: <ac8f92701003190717u19334b4ei58e4829e4651db22@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-03-19, at 08:17, jing zhang wrote:
>>> 		ext4_get_group_no_and_offset(sb, pa->pa_pstart, &group, NULL);
>>> @@ -3811,6 +3813,12 @@ repeat:
>>> 		list_del(&pa->u.pa_tmp_list);
>>> 		call_rcu(&(pa)->u.pa_rcu, ext4_mb_pa_callback);
>>> 	}
>>> +	if (! list_empty(&list)) {
>>> +		if (occurs++ < 2)
>>> +			goto best_efforts;
>>> +		else
>>> +			BUG();
>>> +	}
>>> 	if (ac)
>>> 		kmem_cache_free(ext4_ac_cachep, ac);
>>> }
>>
>> Hmm, I'm not sure that BUG() is appropriate here.  If there is an
>> I/O error reading the block bitmap, #1, retrying isn't going to help,
>> and #2, bringing down the entire system just because of an I/O error
>> in reading the block bitmap doesn't seem right.
>
> But disk hardware error is not rare,

Exactly, which is the reason why it should not cause the system to  
hang.  The filesystem should handle such errors gracefully if this is  
possible, return an error to the application, and/or marking the  
filesystem in error so that it will be checked on next boot, or similar.

>> Right now, if there is a problem, we just end up leaving the
>> preallocated list on the inode.  Does that cause problems later on
>> down the line which you have observed?
>>
>> 					- Ted
>
> and is there still chance to call the
>       call_rcu(&(pa)->u.pa_rcu, ext4_mb_pa_callback);
> function again later on? (I am not sure yet the chance does exist.)
>
> If no chance, how about the kmem_cache subsystem then?
> After reboot, the file system is still reliable, or just with a few  
> lost blocks?
>
> Thus it is necessary, at least for me, to make sure whether the  
> chance exists.
>                                      - zj
> --
> To unsubscribe from this list: send the line "unsubscribe linux- 
> ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

