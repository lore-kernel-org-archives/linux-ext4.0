From: Jaco Kroon <jaco@uls.co.za>
Subject: Re: fragmentation optimization
Date: Tue, 26 Sep 2017 09:31:27 +0200
Message-ID: <871a5a5c-8761-4748-7e00-ef7edb5b2320@uls.co.za>
References: <6f6eb640-cd31-7080-a575-b7c6c4dd9e3f@uls.co.za>
 <20170925115715.2wen25de35iv5hse@rh_laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from othala.uls.co.za ([154.73.34.12]:52782 "EHLO othala.uls.co.za"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935108AbdIZHbp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 26 Sep 2017 03:31:45 -0400
In-Reply-To: <20170925115715.2wen25de35iv5hse@rh_laptop>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Lukas,


On 25/09/2017 13:57, Lukas Czerner wrote:
> On Sat, Sep 23, 2017 at 09:49:25AM +0200, Jaco Kroon wrote:
>
> Hi,
>
> looking at the data like this is not really giving me much enlightment
> on what's going on. You're only left with less than 10% of free space
> and that alone might play some role in your fragmentation. Filefrag
> might give us better picture.
Fair enough.  So essentially we do a lot of rsync, mostly small files 
(average file size 450KB, 106m files), so for the majority of files not 
a real showstopper currently, since based on the statistics I gave 
(unfortunately without adequate background) we have the far majority of 
of free extents for 4K, then 8K, but still around 1m free extents in the 
512K - 1M range, which can accommodate these files.  The problem comes 
in when running rsync on files larger than a few MB (eg, 300GB) where 
there really aren't many suitable extents available.
>
> Also, I do not see any mention of how this hurts you exactly ? There is
> going to be some cost associated with processing bigger extent tree,
> or reading fragmented file from disk. However, do you have any data
> backing this up ?
The speculation is that the block allocator ends up working really hard 
to allocate blocks.  With the largest blocks being max 32MB, and only 5 
of those, and files of 300GB being written, we suspect that the holes 
being created is causing trouble.
>
> One other thing you could try is to use --preallocate for rsync. This
> should preallocate entire file size, before writing into it. It should
> help with fragmentation. This also has a sideeffect of ext4 using another
> optimization where instead of splitting the extent when leaving a hole in
> the file it will write zeroes to fill the gap instead. The maximum size
> of the hole we're going to zeroout can be configured by
> /sys/fs/ext4/<device>/extent_max_zeroout_kb. By default this is 32kB.
That is indeed interesting.  Do you know if --sparse and --preallocate 
can be used in combination?

Looking at receiver.c for rsync it indeed looks like this will 
fallocate() the full file, and not only the chunks to be written. 
--sparse still seems to be in effect so it looks like this may be the 
way to go.  I'll have to test this, but first I want to run some stats 
to see what the effect in terms of available storage is going to be.

Thanks for the input - really insightful thank you very much.

Kind Regards,
Jaco
