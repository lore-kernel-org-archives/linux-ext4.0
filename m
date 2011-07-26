From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: Checks in ext4_ext_fiemap_cb() broken
Date: Tue, 26 Jul 2011 09:30:11 -0700
Message-ID: <4E2EEB93.1010106@linux.vnet.ibm.com>
References: <20110725155836.GF6107@quack.suse.cz> <CAGBYx2ZsxvmEcC0akMRQTgDWUmkUHOp=D4Ff69_pSMb+bGH5Sg@mail.gmail.com> <20110726121225.GC20131@quack.suse.cz> <CAGBYx2YV5-yNA9cRwU0ojmMnOqNsc_gLLGrc+jenDBk4uYbM8g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, "Ted Ts'o" <tytso@mit.edu>,
	linux-ext4@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:60241 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752789Ab1GZQay (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Jul 2011 12:30:54 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e6.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p6QG6fJi027036
	for <linux-ext4@vger.kernel.org>; Tue, 26 Jul 2011 12:06:41 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p6QGUFfX443680
	for <linux-ext4@vger.kernel.org>; Tue, 26 Jul 2011 12:30:15 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p6QCU0YS032500
	for <linux-ext4@vger.kernel.org>; Tue, 26 Jul 2011 09:30:02 -0300
In-Reply-To: <CAGBYx2YV5-yNA9cRwU0ojmMnOqNsc_gLLGrc+jenDBk4uYbM8g@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 07/26/2011 05:48 AM, Yongqiang Yang wrote:
> On Tue, Jul 26, 2011 at 8:12 PM, Jan Kara<jack@suse.cz>  wrote:
>>   Hi Yongqiang,
>>
>> On Tue 26-07-11 09:20:28, Yongqiang Yang wrote:
>>> I have been thinking if we can handle fiemap much simpler for a while.
>>>   Current code is very ugly due to page cache look up.  I have a
>>> thought on simplifying these code.  The reason leading us to looking
>>> up page cache is that delayed extents are not in extents tree.  I
>>> think we can add an in-memory delayed extents list in inode, and we
>>> can delete entries in the list after we allocate blocks for them.
>>> There is no limit on length of extents in the list, this way can an
>>> entry contain as many blocks as they are contiguous logically.
>>>
>>> What's your opinion?
>>   Yes, that should be doable and shouldn't have too big overhead. It's just
>> stupid we'll do all this stuff only for fiemap call which is relatively
>> rare.
>
> I guess there are other places where delayed extents should be handled
> by looking up page cache.
>
> SEEK_HOLE and SEEK_DATA also need to lookup page cache to handle
> delayed extents.
>
> Hi Allison,
>
> If a delayed extents list added in the inode, could punch hole code be simpler?
>
>
> Yongqiang.

Hi there,

Well, I think we may be able to make it more efficient if we had the 
delayed extent list.

The earlier versions of punch hole were complex because of the different 
mechanisms needed to identify when extents were mapped, delayed or a 
hole.  Later we decided that this was too complex, and the pages that 
covered the hole need to be sync'd anyway, which eliminated the need to 
detect the delayed extents, but it is a wasteful operation if the 
extents in the hole were just unwritten.  If we had the delayed extent 
list, I think we may just be able to sync extents as needed instead of 
syncing the entire hole.

Allison Henderson

>>
>>                                                                 Honza
>>
>>> On Mon, Jul 25, 2011 at 11:58 PM, Jan Kara<jack@suse.cz>  wrote:
>>>>   Hello,
>>>>
>>>>   I just had a look at the code checking delayed allocated buffers in
>>>> ext4_ext_fiemap_cb(). I believe the checks there could use some elimiation
>>>> of common patterns but that's just a minor thing. The main problem is that
>>>> the code can easily crash the kernel when it races with page reclaim. You
>>>> just cannot access most of the page contents (and for buffers it is
>>>> especially true) without locking the page. Getting a reference via
>>>> find_get_pages_tag() guarantees you the structure cannot go away but mm is
>>>> still free to detach the page from the mapping at any moment. So you must
>>>> always lock a page and check that it still belongs to the desired mapping
>>>> before you check 'page_has_buffers()'.
>>>>
>>>>                                                                 Honza
>>>> --
>>>> Jan Kara<jack@suse.cz>
>>>> SUSE Labs, CR
>>>>
>>>
>>>
>>>
>>> --
>>> Best Wishes
>>> Yongqiang Yang
>> --
>> Jan Kara<jack@suse.cz>
>> SUSE Labs, CR
>>
>
>
>

