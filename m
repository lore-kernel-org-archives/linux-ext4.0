From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: ext2/3: document conditions when reliable operation is possible
Date: Mon, 30 Mar 2009 17:06:15 +0200
Message-ID: <87ljqn82zc.fsf@frosties.localdomain>
References: <20090312092114.GC6949@elf.ucw.cz>
	<200903121413.04434.rob@landley.net>
	<20090316122847.GI2405@elf.ucw.cz>
	<200903161426.24904.rob@landley.net>
	<20090323104525.GA17969@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Rob Landley <rob@landley.net>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	tytso@mit.edu, rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:48390 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbZC3PGV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Mar 2009 11:06:21 -0400
In-Reply-To: <20090323104525.GA17969@elf.ucw.cz> (Pavel Machek's message of
	"Mon, 23 Mar 2009 11:45:25 +0100")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Pavel Machek <pavel@ucw.cz> writes:

> On Mon 2009-03-16 14:26:23, Rob Landley wrote:
>> On Monday 16 March 2009 07:28:47 Pavel Machek wrote:
>> > > > +	otherwise, disks may write garbage during powerfail.
>> > > > +	Not sure how common that problem is on generic PC machines.
>> > > > +
>> > > > +	Note that atomic write is very hard to guarantee for RAID-4/5/6,
>> > > > +	because it needs to write both changed data, and parity, to
>> > > > +	different disks.
>> > >
>> > > These days instead of "atomic" it's better to think in terms of
>> > > "barriers".

Would be nice to have barriers in md and dm.

>> > This is not about barriers (that should be different topic). Atomic
>> > write means that either whole sector is written, or nothing at all is
>> > written. Because raid5 needs to update both master data and parity at
>> > the same time, I don't think it can guarantee this during powerfail.

Actualy raid5 should have no problem with a power failure during
normal operations of the raid. The parity block should get marked out
of sync, then the new data block should be written, then the new
parity block and then the parity block should be flaged in sync.

>> Good point, but I thought that's what journaling was for?
>
> I believe journaling operates on assumption that "either whole sector
> is written, or nothing at all is written".

The real problem comes in degraded mode. In that case the data block
(if present) and parity block must be written at the same time
atomically. If the system crashes after writing one but before writing
the other then the data block on the missng drive changes its
contents. And for example with a chunk size of 1MB and 16 disks that
could be 15MB away from the block you actualy do change. And you can
not recover that after a crash as you need both the original and
changed contents of the block.

So writing one sector has the risk of corrupting another (for the FS)
totally unconnected sector. No amount of journaling will help
there. The raid5 would need to do journaling or use battery backed
cache.

MfG
        Goswin
