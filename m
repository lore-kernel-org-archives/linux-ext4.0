From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
 possible
Date: Tue, 25 Aug 2009 19:10:49 -0400
Message-ID: <4A946F79.3020103@redhat.com>
References: <20090323104525.GA17969@elf.ucw.cz>	<87ljqn82zc.fsf@frosties.localdomain>	<20090824093143.GD25591@elf.ucw.cz>	<82k50tjw7u.fsf@mid.bfk.de>	<20090824130125.GG23677@mit.edu>	<20090824195159.GD29763@elf.ucw.cz>	<4A92F6FC.4060907@redhat.com>	<20090824205209.GE29763@elf.ucw.cz>	<4A930160.8060508@redhat.com>	<20090824212518.GF29763@elf.ucw.cz>	<20090824223915.GI17684@mit.edu> <19092.27809.480243.979274@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, Pavel Machek <pavel@ucw.cz>,
	Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	Rob Landley <rob@landley.net>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <19092.27809.480243.979274@notabene.brown>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 08/25/2009 06:58 PM, Neil Brown wrote:
> On Monday August 24, tytso@mit.edu wrote:
>> On Mon, Aug 24, 2009 at 11:25:19PM +0200, Pavel Machek wrote:
>>>> I have to admit that I have not paid enough attention to this specifics
>>>> of your ext3 + flash card issue - is it the ftl stuff doing out of order
>>>> IO's?
>>>
>>> The problem is that flash cards destroy whole erase block on unplug,
>>> and ext3 can't cope with that.
>>
>> Sure --- but name **any** filesystem that can deal with the fact that
>> 128k or 256k worth of data might disappear when you pull out the flash
>> card while it is writing a single sector?
>
> A Log structured filesystem could certainly be written to deal with
> such a situation, providing by 'deal with' you mean 'only loses data
> that has not yet been acknowledged to the application'.  Of course the
> filesystem would need clear visibility into exactly how these blocks
> are positioned.
>
> I've been playing with just such a filesystem for some time (never
> really finding enough time) with the goal of making it work over RAID5
> with no data risk due to power loss.  One day it will be functional
> enough for others to try....
>
> It is entirely possible that NILFS could be made to meet that
> requirement, but I haven't made time to explore NILFS so I cannot be
> sure.
>
> NeilBrown
>

I am not sure that log structure will protect you from this scenario since once 
you clean the log, the non-logged data is assumed to be correct.

If your cheap flash storage device can nuke random regions of that clean 
storage, you will lose data....

ric

