From: Andreas Dilger <aedilger@gmail.com>
Subject: Re: [BUG] copy file result with zero
Date: Sun, 2 Oct 2011 00:59:22 -0700
Message-ID: <89E75765-AC24-4EF4-9547-6EE7A1A38B5A@dilger.ca>
References: <CABqxG0feuZCmx=RfxU-50uFK9-P2vNbAMqJUdWM5RhuJifD5Ow@mail.gmail.com> <20111001143900.GH28234@thunk.org> <CABqxG0eiRiCSirXi5rBB0bJ2AJSQjF2dje2BcjbVYEYWgf-zpw@mail.gmail.com> <A2FF8835-2386-47F9-AFF8-4E09BEC4F80E@oracle.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Dave Young <hidave.darkstar@gmail.com>, "Ted Ts'o" <tytso@mit.edu>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: Jeff liu <jeff.liu@oracle.com>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42309 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156Ab1JBG7k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Oct 2011 02:59:40 -0400
In-Reply-To: <A2FF8835-2386-47F9-AFF8-4E09BEC4F80E@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-10-01, at 11:41 PM, Jeff liu wrote:
>> On Sat, Oct 1, 2011 at 10:39 PM, Ted Ts'o <tytso@mit.edu> wrote:
>>> On Sat, Oct 01, 2011 at 10:01:35PM +0800, Dave Young wrote:
>>>> Hi,
>>>> 
>>>> Weird problem, when I build app from source,
>>>> make; make install
>>>> run the command, but got "cannot execute binary file"
>>>> 
>>>> hexdump shows the installed binary is full of zero
>>>> 
>>>> Is it related to ext4 fiemap problem described below?
>>>> http://lwn.net/Articles/429349/
>>> 
>>> There is general agreement that /bin/cp should not have been relying
>>> on FIEMAP, and I believe the more recent versions of /bin/cp have
>>> removed that code by default pending implementation of
>>> SEEK_HOLE/SEEK_DATA.  That being said, ext4 had a workaround to its
>>> FIEMAP implementation that landed in 2.6.39, and you're using
>>> 3.1.0-rc6.
> 
> Actually, upstream cp(1) using FIEMAP only if the source file is sparse,  or else, it will do normal copy, i.e, block based.

My understanding is that cp uses the blocks count to determine whether the file is sparse or not.  In the case of delayed allocation (where blocks are not yet allocated, if they are not reflected in the i_blocks count) it might mistakenly think that the file is sparse.

Given the danger of this bug, it is important to ensure ext4 returns DELALLOC extents for pages in the page cache.  I think Yongqiang Yang just submitted a patch series to do this for ext4, so it would be important to verify it fixes this problem.

>> Do you means It should work in 3.1.0-rc6 even with cp which depends fiemap?
>> 
>>> 
>>>> I finally managed to find the way to reproduce this:
>>>> just cp a elf binary A  to file B, then cp B to file C,  then you will get:
>>>> A == B != C
>>>> 
>>>> ie.
>>>> cp /bin/ls ls1
>>>> cp ls1 ls2
>>>> 
>>>> ls2 will be filled with zero
>>> 
>>> If you add a "sync" between the two copies, does that work around the
>>> problem?  I bet it will...
>> 
>> Yes, it works
>> 
>>> 
>>> My suggestion is to upgrade to a newer version of coreutils that
>>> doesn't try to use FIEMAP.
>> 
>> Thanks, will try
>> 
>>> 
>>>                                       - Ted
>>> 
>> 
>> 
>> 
>> -- 
>> Regards
>> Dave
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





