From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: fiemap bugs on sparse files.
Date: Wed, 23 Feb 2011 09:34:37 -0600
Message-ID: <4D65290D.4040800@redhat.com>
References: <1298409435-sup-2565@think>	<AANLkTikMhTM6c1=ihMj0XOZD0VYVLoHOeoGV4_7qvN=b@mail.gmail.com> <AANLkTikTet_Gw2kCQ8+j-qYVJgUc0dxKQ=kE295gcJR7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Chris Mason <chris.mason@oracle.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46466 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754090Ab1BWPem (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Feb 2011 10:34:42 -0500
In-Reply-To: <AANLkTikTet_Gw2kCQ8+j-qYVJgUc0dxKQ=kE295gcJR7@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2/23/11 3:34 AM, Yongqiang Yang wrote:
> On Wed, Feb 23, 2011 at 4:59 PM, Yongqiang Yang <xiaoqiangnk@gmail.com> wrote:
>> On Wed, Feb 23, 2011 at 5:18 AM, Chris Mason <chris.mason@oracle.com> wrote:
>>> [ resend, sorry if this is a dup ]
>>>
>>> Hi everyone,
>>>
>>> We've had reports on btrfs that cp is giving us files full of zeros
>>> instead of actually copying them.  It was tracked down to a bug with
>>> the btrfs fiemap implementation where it was returning holes for
>>> delalloc ranges.
>>>
>>> Newer versions of cp are trusting fiemap to tell it where the holes
>>> are, which does seem like a pretty neat trick.
>>>
>>> I decided to give xfs and ext4 a shot with a few tests cases too, xfs
>>> passed with all the ones btrfs was getting wrong, and ext4 got the basic
>>> delalloc case right.
>>>
>>> # mkfs.ext4 /dev/xxx
>>> # mount /dev/xxx /mnt
>>> # dd if=/dev/zero of=/mnt/foo bs=1M count=1
>>> # fiemap-test foo
>>> ext:   0 logical: [       0..     255] phys:        0..     255 flags: 0x007 tot: 256
>>>
>>> Horray!  But once we throw a hole in, things go bad:
>>>
>>> # mkfs.ext4 /dev/xxx
>>> # mount /dev/xxx /mnt
>>> # dd if=/dev/zero of=/mnt/foo bs=1M count=1 seek=1
>>> # fiemap-test foo
>>> < no output >
>> Actually, there is no extent in extent tree now, so
>> ext4_ext_walk_space() will pass ext4_ext_fiemap_cb() a variable of
>> struct ext4_ext_cache with the requested length. But in
>> ext4_ext_fiemap_cb() just the paging contains start block is got
>> via find_get_page(), if find_get_page() return null,
>> ext4_ext_fiemap_cb()  thinks the whole request range is empty and it
>> returns request range.
>>
>> In 1st case, find_get_page() will succeed.
>>
>> It seems that we should get no. of pages in page cache if
>> find_get_page() fails, and correct the range to be returned.
> We can call find_get_pages() with nr_pages=1 instead. And we can regulate
> the range with page->index if it is not the the paging contains start block.
> 
> 
>>
>> Right?
>>
>> If right I will send a patch.

Your analysis is correct, the way it's working now is pretty broken (my fault I'm afraid)

Right now we only look at the first page in a "gap" to see if it's delalloc; we need to search through any dirty pages in the gap, since the first page may be a hole, with delalloc ranges coming later.

We need some variant of page cache search, yes.

-Eric
