From: david@lang.hm
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
 	possible
Date: Tue, 25 Aug 2009 18:34:54 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.0908251828260.30426@asgard.lang.hm>
References: <20090312092114.GC6949@elf.ucw.cz> <200903121413.04434.rob@landley.net> <20090316122847.GI2405@elf.ucw.cz> <200903161426.24904.rob@landley.net> <20090323104525.GA17969@elf.ucw.cz> <87ljqn82zc.fsf@frosties.localdomain> <20090824093143.GD25591@elf.ucw.cz>
 <87f94c370908240621n32ea310sd24196084c42107a@mail.gmail.com> <19092.29618.98997.854784@notabene.brown>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="680960-446280904-1251250494=:30426"
Cc: Greg Freemyer <greg.freemyer@gmail.com>,
	Pavel Machek <pavel@ucw.cz>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	Rob Landley <rob@landley.net>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	tytso@mit.edu, rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.lang.hm ([64.81.33.126]:55405 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754473AbZHZBfL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Aug 2009 21:35:11 -0400
In-Reply-To: <19092.29618.98997.854784@notabene.brown>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--680960-446280904-1251250494=:30426
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT

On Wed, 26 Aug 2009, Neil Brown wrote:

> On Monday August 24, greg.freemyer@gmail.com wrote:
>>> +Don't damage the old data on a failed write (ATOMIC-WRITES)
>>> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>> +
>>> +Either whole sector is correctly written or nothing is written during
>>> +powerfail.
>>> +
>>> +       Because RAM tends to fail faster than rest of system during
>>> +       powerfail, special hw killing DMA transfers may be necessary;
>>> +       otherwise, disks may write garbage during powerfail.
>>> +       This may be quite common on generic PC machines.
>>> +
>>> +       Note that atomic write is very hard to guarantee for RAID-4/5/6,
>>> +       because it needs to write both changed data, and parity, to
>>> +       different disks. (But it will only really show up in degraded mode).
>>> +       UPS for RAID array should help.
>>
>> Can someone clarify if this is true in raid-6 with just a single disk
>> failure?  I don't see why it would be.
>
> It does affect raid6 with a single drive missing.
>
> After an unclean shutdown you cannot trust any Parity block as it
> is possible that some of the blocks in the stripe have been updated,
> but others have not.  So you must assume that all parity blocks are
> wrong and update them.  If you have a missing disk you cannot do that.
>
> To take a more concrete example, imagine a 5 device RAID6 with
> 3 data blocks D0 D1 D2 as well a P and Q on some stripe.
> Suppose that we crashed while updating D0, which would have involved
> writing out D0, P and Q.
> On restart, suppose D2 is missing. It is possible that 0, 1, 2, or 3
> of D0, P and Q have been updated and the others not.
> We can try to recompute D2 from D0 D1 and P, from
> D0 P and Q or from D1, P and Q.
>
> We could conceivably try each of those and if they all produce the
> same result we might be confident of it.
> If two produced the same result and the other was different we could
> use a voting process to choose the 'best'.  And in this particular
> case I think that would work.  If 0 or 3 had been updates, all would
> be the same.  If only 1 was updated, then the combinations that
> exclude it will match.  If 2 were updated, then the combinations that
> exclude the non-updated block will match.
>
> But if both D0 and D1 were being updated I think there would be too
> many combinations and it would be very possibly that all three
> computed values for D2 would be different.
>
> So yes: a singly degraded RAID6 cannot promise no data corruption
> after an unclean shutdown.  That is why "mdadm" will not assemble such
> an array unless you use "--force" to acknowledge that there has been a
> problem.

thanks for this detail, I would not have expected a partially degraded 
raid 6 array to be this sensitive to problems.

assuming that the degradation happens prior to the power failure, what 
could be done to make this safer and more predictable.

off the top of my head (and possibly an extreme performance hit, not 
nessasarily suitable for everyone) is there something that could be done 
with ordering the writes to the various drives?

David Lang
--680960-446280904-1251250494=:30426--
