From: Eric Sandeen <esandeen@redhat.com>
Subject: Re: [PATCH] mke2fs: avoid inode number error with large FS
Date: Mon, 12 Feb 2018 10:23:53 -0600
Message-ID: <d7b615e9-baf5-1998-13a2-f24c8cdebb6b@redhat.com>
References: <20180212111419.25036-1-artem.blagodarenko@gmail.com>
 <20180212154553.g3jfjdmta7uw7n4s@rh_laptop>
 <520607f6-a5c2-1b6f-4a6b-813cbb8e2abd@redhat.com>
Reply-To: sandeen@redhat.com, sandeen@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca,
        Alexey Lyashkov <alexey.lyashkov@gmail.com>
To: Lukas Czerner <lczerner@redhat.com>,
        Artem Blagodarenko <artem.blagodarenko@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47422 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964875AbeBLQXy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 12 Feb 2018 11:23:54 -0500
In-Reply-To: <520607f6-a5c2-1b6f-4a6b-813cbb8e2abd@redhat.com>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On 2/12/18 10:06 AM, Eric Sandeen wrote:
> 
> 
> On 2/12/18 9:45 AM, Lukas Czerner wrote:
>> On Mon, Feb 12, 2018 at 02:14:19PM +0300, Artem Blagodarenko wrote:
>>> From: Alexey Lyashkov <alexey.lyashkov@gmail.com>
>>>
>>> Sometimes during system deployment customers are faced with system
>>> formating problem for given inodes/bytes rate. User need to recalucate
>>> this rate and start formating again.
>>>
>>> This patch adds code that limit inodes count instead of error return,
>>> to use all inodes in the filesystem.
>>
>> Hi,
>>
>> in this case then you do not have byte-per-inode ratio you've
>> specified. So why to specify it in the first place ?
>>
>> Maybe I am missing something but I would think that if you specify -i
>> then you know what you want and if it's not possible then I would not
>> expect the mke2fs to just succeed regardless. I guess it's confusing.
> 
> I agree that fixing up incorrect/impossible format specifications and
> continuing is not preferable; it really makes the behavior matrix complex
> when some incorrect options are fixed on the fly, while others fail.
> 
> And worse, this creates a new "default" behavior which comes into play
> only when specific incorrect mkfs options are explicitly provided.
> 
> When an admin stops using mkfs defaults and starts manually specifying
> geometry, the onus is on /them/ to specify options which are valid.

Ok, I have read the patch more carefully now ;)

So prior to this patch, on a filesystem /with/ the 64bit feature, we
already silently limit inode count to MAX_32_NUM.  So if an inode ratio
is specified which would be > MAX_32_NUM we silently cap it, but only
if 64bit is turned on.

With your patch, you change the behavior so that the MAX_32_NUM
cap/adjustment is always in place both with and without the 64bit
feature, but it only warns the user when the 64bit feature is not present?

So I guess there is precedent for the behavior.  I'd have preferred that
mkfs simply fail if an invalid inode ratio was specified, but I guess
that is already not the case.  So perhaps fixing it on the fly for
both 64bit and !64bit is reasonable, though I'm not sure why we should
warn with !64bit and be silent with 64bit...

I guess my preference would be to always fail the mkfs if an invalid
inode ratio was specified on the commandline, regardless of 64bit
feature presence.  Silent fix-ups of incorrect specifications tend
to violate the principle of least surprise.

-Eric
