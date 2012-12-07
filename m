From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: fix extent tree corruption that incurred by hole
 punch
Date: Fri, 07 Dec 2012 16:17:10 -0600
Message-ID: <50C26AE6.9080902@redhat.com>
References: <1354623069-8124-1-git-send-email-forrestl@synology.com> <50C0BDA2.4090203@redhat.com> <50C0BE40.5060003@redhat.com> <CAOiN93kvSdzsJXqbabuLDcOh2me9wzLUPBsr2UY5BgHFXrhcnA@mail.gmail.com> <CAJSVwFOkH3MzdJTVm9M1fFycNqWr4oy+zUNaDUy0LPnXk=YZMg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ashish Sangwan <ashishsangwan2@gmail.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Forrest Liu <forrestl@synology.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38502 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755263Ab2LGWRT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 7 Dec 2012 17:17:19 -0500
In-Reply-To: <CAJSVwFOkH3MzdJTVm9M1fFycNqWr4oy+zUNaDUy0LPnXk=YZMg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12/7/12 6:26 AM, Forrest Liu wrote:
> 2012/12/7 Ashish Sangwan <ashishsangwan2@gmail.com>:
>> On Thu, Dec 6, 2012 at 9:18 PM, Eric Sandeen <sandeen@redhat.com> wrote:
>>> On 12/6/12 9:45 AM, Eric Sandeen wrote:
>>>> On 12/4/12 6:11 AM, Forrest Liu wrote:
>>>>> Extent indexes didn't update correctly in ext4_ext_rm_idx, when depth
>>>>> of extent tree is greater than 1.
>>>>
>>>> This is interesting; we had 2 reports of similar corruption on the
>>>> list, I wonder if the application in question was doing hole punching.
>>>> I didn't expect that they were, so TBH I was pretty much ignoring
>>>> the hole-punch cases for parent index updates.  Hm.  I'll have
>>>> to look into that.
>>>> Could you turn your testcase into an xfstest regression test?
> 
> Hi Eric,
>    I will check how to do that.
>>>
>>> Also, please note that I sent an e2fsck patch to try to fix this
>>> problem after the fact; it'd be great if in your testing, you could
>>> also confirm that e2fsck w/ my patch fixes it correctly.
>>>
>> I checked you patch.
>> This was the extent tree situation after removing 1st extent index:
>> debugfs:  ex abc
>> Level Entries       Logical        Physical Length Flags
>>  0/ 2   1/  1     0 -  8399  32857            8400
>>  1/ 2   1/  4  2048 -  4081   4138            2034
>>  2/ 2   1/339  2048 -  2053  69632 -  69637      6
>>  2/ 2   2/339  2054 -  2059  69656 -  69661      6
>>
>> E2fsck's output with your patch=>
>> Linux#> /dtv/usb/sdb1/e2fsck /dev/sda1 -f
>> e2fsck 1.42.6.1 (06-DEC-2012)
>> Pass 1: Checking inodes, blocks, and sizes
>> Interior extent node level 0 of inode 31:
>> Logical start 0 does not match logical start 2048 at next level.  Fix<y>? yes
>> Inode 31, i_blocks is 50856, should be 16280.  Fix<y>? yes
> 
> I got similar result, pb->num_blocks is incorrect if
> ext2fs_extent_fix_parents called.

Maybe I should ask what it looks like without my patch?  I didn't
think my patch would change anything at all about block count
or use.

-Eric

