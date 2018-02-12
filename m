From: Eric Sandeen <esandeen@redhat.com>
Subject: Re: [PATCH] mke2fs: avoid inode number error with large FS
Date: Mon, 12 Feb 2018 10:06:57 -0600
Message-ID: <520607f6-a5c2-1b6f-4a6b-813cbb8e2abd@redhat.com>
References: <20180212111419.25036-1-artem.blagodarenko@gmail.com>
 <20180212154553.g3jfjdmta7uw7n4s@rh_laptop>
Reply-To: sandeen@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca,
        Alexey Lyashkov <alexey.lyashkov@gmail.com>
To: Lukas Czerner <lczerner@redhat.com>,
        Artem Blagodarenko <artem.blagodarenko@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43348 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932878AbeBLQHX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 12 Feb 2018 11:07:23 -0500
In-Reply-To: <20180212154553.g3jfjdmta7uw7n4s@rh_laptop>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On 2/12/18 9:45 AM, Lukas Czerner wrote:
> On Mon, Feb 12, 2018 at 02:14:19PM +0300, Artem Blagodarenko wrote:
>> From: Alexey Lyashkov <alexey.lyashkov@gmail.com>
>>
>> Sometimes during system deployment customers are faced with system
>> formating problem for given inodes/bytes rate. User need to recalucate
>> this rate and start formating again.
>>
>> This patch adds code that limit inodes count instead of error return,
>> to use all inodes in the filesystem.
> 
> Hi,
> 
> in this case then you do not have byte-per-inode ratio you've
> specified. So why to specify it in the first place ?
> 
> Maybe I am missing something but I would think that if you specify -i
> then you know what you want and if it's not possible then I would not
> expect the mke2fs to just succeed regardless. I guess it's confusing.

I agree that fixing up incorrect/impossible format specifications and
continuing is not preferable; it really makes the behavior matrix complex
when some incorrect options are fixed on the fly, while others fail.

And worse, this creates a new "default" behavior which comes into play
only when specific incorrect mkfs options are explicitly provided.

When an admin stops using mkfs defaults and starts manually specifying
geometry, the onus is on /them/ to specify options which are valid.

> Also the man page says:
> 
> "This value generally shouldn't be smaller than the blocksize of the
> filesystem, since in that case more inodes would be made than can ever
> be used."
> 
> But in your case you're using "-i 1024" on what I assume is a 4k bs file
> system ?

Right, can you offer a concrete example of the commandline you're trying
to fix?

If it's "-i 1024" on a 4k filesystem, that's simply broken and /should/
be rejected.  If the error message is not clear, perhaps that's the best
place to focus these efforts.

Thanks,
-Eric
