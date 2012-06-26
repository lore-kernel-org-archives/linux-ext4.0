From: Ric Wheeler <ricwheeler@gmail.com>
Subject: Re: ext4_fallocate
Date: Tue, 26 Jun 2012 15:30:25 -0400
Message-ID: <4FEA0DD1.8080403@gmail.com>
References: <4FE8086F.4070506@zoho.com> <20120625085159.GA18931@gmail.com> <20120625191744.GB9688@thunk.org> <4FE9B57F.4030704@redhat.com> <4FE9F9F4.7010804@zoho.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ric Wheeler <rwheeler@redhat.com>, Theodore Ts'o <tytso@mit.edu>,
	linux-ext4@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>,
	wenqing.lz@taobao.com, Eric Sandeen <sandeen@redhat.com>
To: Fredrick <fjohnber@zoho.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43198 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab2FZT33 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 26 Jun 2012 15:29:29 -0400
Received: by dady13 with SMTP id y13so319182dad.19
        for <linux-ext4@vger.kernel.org>; Tue, 26 Jun 2012 12:29:28 -0700 (PDT)
In-Reply-To: <4FE9F9F4.7010804@zoho.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 06/26/2012 02:05 PM, Fredrick wrote:
>
>> Hi Ted,
>>
>> Has anyone made progress digging into the performance impact of running
>> without this patch? We should definitely see if there is some low
>> hanging fruit there, especially given that XFS does not seem to suffer
>> such a huge hit.
>>
>> I think that we need to get a good reproducer for the workload that
>> causes the pain and start to dig into this.
>>
>> Opening this security exposure is still something that is clearly a hack
>> and best avoided if we can fix the root cause :)
>>
>> Ric
>>
>>>
>
> Hi Ric,
>
> I had run perf stat on ext4 functions between two runs of our program
> writing data to a file for the first time and writing data to the file
> for the second time(where the extents are initialized).
> The amount of data written is same between the two runs.
>
> left is first time
> right is second time.
>
>
> <                 42 ext4:ext4_mb_bitmap_load
> <                 42 ext4:ext4_mb_buddy_bitmap_load
> <                642 ext4:ext4_mb_new_inode_pa
> <                645 ext4:ext4_mballoc_alloc
> <              9,596 ext4:ext4_mballoc_prealloc
> <             10,240 ext4:ext4_da_update_reserve_space
> ---
> >              7,413 ext4:ext4_mark_inode_dirty
> 49d52
> <             10,241 ext4:ext4_allocate_blocks
> 51d53
> <             10,241 ext4:ext4_request_blocks
> 55d56
> <          1,310,720 ext4:ext4_da_reserve_space
> 58,60c59,60
> <          1,331,288 ext4:ext4_ext_map_blocks_enter
> <          1,331,288 ext4:ext4_ext_map_blocks_exit
> <          1,341,467 ext4:ext4_mark_inode_dirty
> ---
> >          1,310,806 ext4:ext4_ext_map_blocks_enter
> >          1,310,806 ext4:ext4_ext_map_blocks_exit
>
>
> May be the mballocs have overhead.
>
> I ll try to compare numbers on XFS during this week.
>
> -Fredrick
>

Thanks!  Eric is also running some tests to evaluate the impact of various 
techniques :)

ric

