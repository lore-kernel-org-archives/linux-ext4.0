From: "NeilBrown" <neilb@suse.de>
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
     possible
Date: Wed, 26 Aug 2009 09:32:32 +1000 (EST)
Message-ID: <79d27e32449ad4b894d0c2929c43c437.squirrel@neil.brown.name>
References: <20090323104525.GA17969@elf.ucw.cz>
    <87ljqn82zc.fsf@frosties.localdomain>
    <20090824093143.GD25591@elf.ucw.cz> <82k50tjw7u.fsf@mid.bfk.de>
    <20090824130125.GG23677@mit.edu> <20090824195159.GD29763@elf.ucw.cz>
    <4A92F6FC.4060907@redhat.com> <20090824205209.GE29763@elf.ucw.cz>
    <4A930160.8060508@redhat.com> <20090824212518.GF29763@elf.ucw.cz>
    <20090824223915.GI17684@mit.edu>
    <19092.27809.480243.979274@notabene.brown>
    <4A946F79.3020103@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: "Theodore Tso" <tytso@mit.edu>, "Pavel Machek" <pavel@ucw.cz>,
	"Florian Weimer" <fweimer@bfk.de>,
	"Goswin von Brederlow" <goswin-v-b@web.de>,
	"Rob Landley" <rob@landley.net>,
	"kernel list" <linux-kernel@vger.kernel.org>,
	"Andrew Morton" <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: "Ric Wheeler" <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:36213 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932463AbZHYXeo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Aug 2009 19:34:44 -0400
In-Reply-To: <4A946F79.3020103@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, August 26, 2009 9:10 am, Ric Wheeler wrote:
> On 08/25/2009 06:58 PM, Neil Brown wrote:
>> On Monday August 24, tytso@mit.edu wrote:
>>> On Mon, Aug 24, 2009 at 11:25:19PM +0200, Pavel Machek wrote:
>>>>> I have to admit that I have not paid enough attention to this
>>>>> specifics
>>>>> of your ext3 + flash card issue - is it the ftl stuff doing out of
>>>>> order
>>>>> IO's?
>>>>
>>>> The problem is that flash cards destroy whole erase block on unplug,
>>>> and ext3 can't cope with that.
>>>
>>> Sure --- but name **any** filesystem that can deal with the fact that
>>> 128k or 256k worth of data might disappear when you pull out the flash
>>> card while it is writing a single sector?
>>
>> A Log structured filesystem could certainly be written to deal with
>> such a situation, providing by 'deal with' you mean 'only loses data
>> that has not yet been acknowledged to the application'.  Of course the
>> filesystem would need clear visibility into exactly how these blocks
>> are positioned.
>>
>> I've been playing with just such a filesystem for some time (never
>> really finding enough time) with the goal of making it work over RAID5
>> with no data risk due to power loss.  One day it will be functional
>> enough for others to try....
>>
>> It is entirely possible that NILFS could be made to meet that
>> requirement, but I haven't made time to explore NILFS so I cannot be
>> sure.
>>
>> NeilBrown
>>
>
> I am not sure that log structure will protect you from this scenario since
> once
> you clean the log, the non-logged data is assumed to be correct.
>
> If your cheap flash storage device can nuke random regions of that clean
> storage, you will lose data....

Hence my observation that "the filesystem would need clear visibility into
exactly how these blocks are positioned".
If there is an FTL in the way that randomly relocates blocks, and a
power fail during write could corrupt data that appears to be
megabytes away in some unpredictable location, then yes: a log structure
won't help.

However I would like to imagine that even a cheep flash device, if it
only ever got writes that were exactly the size of the erase-block, would
not break those writes over multiple erase blocks, so some degree of
integrity and predictability could be preserved.  Even more so, I would
love to  be able to disable the FTL, or at least have clear and correct
documentation about how it works.

So yes, not a panacea.  But an avenue with real possibilities.

NeilBrown

