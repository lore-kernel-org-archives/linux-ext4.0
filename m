From: Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [PATCH] x86_64/lib: improve the performance of memmove
Date: Fri, 17 Sep 2010 11:37:39 +0800
Message-ID: <4C92E283.4090802@cn.fujitsu.com>
References: <56957.91.60.149.91.1284619705.squirrel@www.firstfloor.org>	 <4C91C44F.40700@cn.fujitsu.com> <1284684918.13201.114.camel@localhost.localdomain>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Cc: Andi Kleen <andi@firstfloor.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>, "Theodore Ts'o" <tytso@mit.edu>,
	Chris Mason <chris.mason@oracle.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Linux Ext4 <linux-ext4@vger.kernel.org>
To: ykzhao <yakui.zhao@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:49349 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751673Ab0IQDhb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Sep 2010 23:37:31 -0400
In-Reply-To: <1284684918.13201.114.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 17 Sep 2010 08:55:18 +0800, ykzhao wrote:
> On Thu, 2010-09-16 at 15:16 +0800, Miao Xie wrote:
>> On Thu, 16 Sep 2010 08:48:25 +0200 (cest), Andi Kleen wrote:
>>>> When the dest and the src do overlap and the memory area is large, memmove
>>>> of
>>>> x86_64 is very inefficient, and it led to bad performance, such as btrfs's
>>>> file
>>>> deletion performance. This patch improved the performance of memmove on
>>>> x86_64
>>>> by using __memcpy_bwd() instead of byte copy when doing large memory area
>>>> copy
>>>> (len>   64).
>>>
>>>
>>> I still don't understand why you don't simply use a backwards
>>> string copy (with std) ? That should be much simpler and
>>> hopefully be as optimized for kernel copies on recent CPUs.
>>
>> But according to the comment of memcpy, some CPUs don't support "REP" instruction,
> 
> Where do you find that the "REP" instruction is not supported on some
> CPUs? The comment in arch/x86/lib/memcpy_64.s only states that some CPUs
> will run faster when using string copy instruction.

Sorry! I misread the comment.

>> so I think we must implement a backwards string copy by other method for those CPUs,
>> But that implement is complex, so I write it as a function -- __memcpy_bwd().
> 
> Will you please look at tip/x86/ tree(mem branch)? The memory copy on
> x86_64 is already optimized.

Thanks for your reminding! It is very helpful.
Miao
 
> thanks.
>      Yakui
>>
>> Thanks!
>> Miao
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 

