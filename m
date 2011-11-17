From: NamJae Jeon <linkinjeon@gmail.com>
Subject: Re: [PATCH] ext4: slab caches set to SLAB_MEM_SPREAD flags.
Date: Thu, 17 Nov 2011 14:35:52 +0900
Message-ID: <CAKYAXd9wCJFuJZ8uxHESuq92G9EUc0Dq0ejAwbJk0OrwhCcVCA@mail.gmail.com>
References: <1321455848-1929-1-git-send-email-linkinjeon@gmail.com>
	<47270FB7-96AC-4F41-98D3-9AD469080DBE@mit.edu>
	<alpine.DEB.2.00.1111161347000.16596@chino.kir.corp.google.com>
	<CADDb1s1pLddZ4TQciL=yO-17WwQDyLmzP1E8U0UsyiQqez8Q8A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	Amit Sahrawat <amit.sahrawat83@gmail.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56962 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538Ab1KQFfy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Nov 2011 00:35:54 -0500
In-Reply-To: <CADDb1s1pLddZ4TQciL=yO-17WwQDyLmzP1E8U0UsyiQqez8Q8A@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2011/11/17 Amit Sahrawat <amit.sahrawat83@gmail.com>:
> Hi All,
>
> To share with you all, this was picked as part of some review process=
=2E
> We looked for the details regarding the introduction of
> SLAB_MEM_SHARED(http://linux.derkeiler.com/Mailing-Lists/Kernel/2006-=
02/msg01409.html
> - provide the slab cache infrastructure to support cpuset memory
> spreading), and further the changes were introduced across all
> filesystems - http://lwn.net/Articles/173654/.
> Since, we do not have direct access to NUMA architecture machine, so
> could not think of verifying the changes - but looking at the
> respective changes - the changes in this patch does seems relevant
> keeping in sync with all changes.
> And, Yes David - these changes will make sense in case of CONFIG_SLAB=
=2E
>
> Please share your opinion on the above introductions irrespective of
> the code changes done in this patch.
>
> Thanks & Regards,
> Amit Sahrawat
>
> On Thu, Nov 17, 2011 at 3:22 AM, David Rientjes <rientjes@google.com>=
 wrote:
>> On Wed, 16 Nov 2011, Theodore Tso wrote:
>>
>>> On Nov 16, 2011, at 10:04 AM, Namjae Jeon wrote:
>>>
>>> > If slab caches set to SLAB_MEM_SPREAD flags, The allocation is sp=
read
>>> > evenly over all the memory nodes instead of favoring allocation o=
n the
>>> > node local to current cpu.
>>>
>>> And why do you think this is a good thing? =C2=A0 For mballoc in pa=
rticular,
>>> the data structures are used immediately and then freed immediately=
 ---
>>> on the local node, so using a non-local memory just makes things wo=
rse
>>> in a NUMA system.
>>>
>>
>> I don't think this has the effect that Namjae thinks it does: this i=
s only
>> useful for CONFIG_SLAB and when you have cpusets enabled with
>> cpuset.memory_spread_slab set.
>>
>> To test how useful it is, you should enable CONFIG_SLAB and then mou=
nt
>> cpusets, set cpuset.memory_spread_slab, and create an MPOL_INTERLEAV=
E
>> mempolicy over all online nodes. =C2=A0This will have the same effec=
t as adding
>> SLAB_MEM_SPREAD to these slab caches (it just doesn't require the
>> mempolicy) and will be able to quantify the effects without any chan=
ges to
>> the kernel at all.
Regarding ted's question,
We prevent one node being concentrating workload from redundant
alloc/free by balancing workload to other nodes in performance side.
and we can avoid reclaim probability a little by allocation from only
local node also.
slab caches for extents io of btrfs is set to SLAB_MEM_SPREAD flags
with recliam flags.
>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
