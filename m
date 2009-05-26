From: Chris Worley <worleys@gmail.com>
Subject: Re: zero out blocks of freed user data for operation a virtual
	machine environment
Date: Tue, 26 May 2009 10:52:21 -0600
Message-ID: <f3177b9e0905260952x2e382d9ana02dcd10a5bcc63d@mail.gmail.com>
References: <20090524170045.GC24753@cip.informatik.uni-erlangen.de>
	 <20090524101551.57b706e9@infradead.org>
	 <20090524173933.GD24753@cip.informatik.uni-erlangen.de>
	 <20090525120320.GA25908@mit.edu>
	 <20090525123430.GA5534@cip.informatik.uni-erlangen.de>
	 <87ab51qq91.fsf@frosties.localdomain>
	 <f3177b9e0905251023n762b815akace1ae34e643458e@mail.gmail.com>
	 <87ab50p3ip.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-px0-f103.google.com ([209.85.216.103]:39006 "EHLO
	mail-px0-f103.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755057AbZEZQwU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 26 May 2009 12:52:20 -0400
In-Reply-To: <87ab50p3ip.fsf@frosties.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 26, 2009 at 4:22 AM, Goswin von Brederlow <goswin-v-b@web.d=
e> wrote:
> Chris Worley <worleys@gmail.com> writes:
>
>> On Mon, May 25, 2009 at 7:14 AM, Goswin von Brederlow <goswin-v-b@we=
b.de>
>> wrote:
>>
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Thomas Glanzmann <thomas@glanzmann.de=
> writes:
>>
>> =A0 =A0 =A0> Hello Ted,
>> =A0 =A0 =A0>
>> =A0 =A0 =A0>> Yes, it does, sb_issue_discard(). =A0So if you wanted =
to hook into
>> =A0 =A0 =A0this
>> =A0 =A0 =A0>> routine with a function which issued calls to zero out=
 blocks, it
>> =A0 =A0 =A0>> would be easy to create a private patch.
>> =A0 =A0 =A0>
>> =A0 =A0 =A0> that sounds good because it wouldn't only target the mo=
st used
>> =A0 =A0 =A0> filesystem but every other filesystem that uses the int=
erface as
>> =A0 =A0 =A0well.
>> =A0 =A0 =A0> Do you think that a tunable or configurable patch has a=
 chance to
>> =A0 =A0 =A0hit
>> =A0 =A0 =A0> upstream as well?
>> =A0 =A0 =A0>
>> =A0 =A0 =A0> =A0 =A0 =A0 =A0 Thomas
>>
>>
>>
>>
>> =A0 =A0 =A0I could imagine a device mapper target that eats TRIM com=
mands and
>> =A0 =A0 =A0writes out zeroes instead. That should be easy to maintai=
n outside
>> =A0 =A0 =A0or
>> =A0 =A0 =A0inside the upstream kernel source.
>>
>>
>> Why bother with a time-consuming performance-draining operation?=A0 =
There are
>> devices that already support TRIM/discard commands today, and once y=
ou discard
>> a block, it's completely irretrievable (you'll just get back zeros i=
f you try
>> to read that block w/o writing it after the discard).
>> Chris
>

I do enjoy a good argument... and don't mean this as a flame (I'm told
I obliviously write curtly)...

Old man's observation: I've found that the people you would think
would readily embrace a new technology are as terrified of change as a
Windows user, and always find so many excuses for "why change won't
work for them" ;)

> Because you have one of the billions of devices that don't.

You have devices that _do_ work now, that should be your selection if
you want both this functionality and high performance.  If you don't
want performance, write zeros to rotating media.

The time frame given in this thread is two years.  In 2-5 years,
rotating media will be history.  The tip of the Linux kernel should
not be focused on defunct technology.

>
> Because, iirc, the specs say nothing about getting back zeros.
>

But all a Solid State Storage controller can do is give you garbage
when asked for an unwritten or discarded block; it doesn't know where
the data is, which is all that is needed for the functionality desired
(there's no need to specify exactly what a controller should return
when asked to read a block it knows nothing about).  Once the
controller is no longer managing a block, there is no way for it to
retrieve that block.  That's what TRIM is all about: get greatest
performance by allowing the SSS controller to manage as few blocks as
absolutely necessary.  Not being able to retrieve valid data for an
unwritten or discarded block is a side-effect of TRIM, that fits well
for this desired functionality.

=46rom drives I've tested so far, the de-facto standard is "zero" when
reading unmanaged blocks.

> Because someone could read the raw data from disk and recover your
> state secrets.

Water-boarding won't help... the controller simply doesn't know the
information you demand.

This isn't your grandfathers rotating media...

You would have to read at the Erase Block level, and know the specific
vendor implementation's EB layout and block-level
mapping/metadata/wear-leveling strategy (i.e. very tightly held IP).
Controllers don't provide the functionality to request raw EB's; there
is no way to read raw EB's.  There is no spec for it in existence for
reading EB's from a SCSI/SAS/SATA/block device.  Your only recourse
would be to pull the NAND chips physically off the drive and weld them
to another piece of hardware specifically designed to blindly read all
the erase blocks, then try to infer the manufacturers chip
organization as well as block-level metatdata, and then you'd only
know all the active blocks (which you would have known those blocks
anyway, before you pulled the chips off) and would have to come up
with some strategy for trying to figure out the original LBA's for all
the inactive data... so there _is_ a very small chance of recovery,
lacking physical security... there are worse issues too, when physical
security is not available on site (i.e. all your active data would be
vulnerable as with any mechanical drive).

Of concern to those handling state secrets: there is no guarantee in
SSS that writing whatever pattern over and over again will physically
overwrite the targeted LBA.  New methods of "declassifying" SSS drives
will be necessary (i.e. a Secure Erase where the controller is told to
erase all EB's... so your NAND EB reading device will read all ones no
matter what EB is read).  These methods are simple enough to develop,
but those who care about this should be aware that the old rotating
media methods no longer apply.

> Because loopback don't support TRIM and compression of the image file
> is much better with zeroes.

Wouldn't it be best if the block is not in existence after the
discard?  Then there would be nothing to compress, which I believe
"nothing" compresses very compactly.

>
> Because on a crypted device TRIM would show how much of the device is
> in used while zeroing out (before crypting) would result in random
> data.

TRIM doesn't tell you how much of the drive is used?

>
> Because it is fun?

You've got me there.  To each his own.

>
> So many reasons.

=2E..to switch from the old rotating media to SSS ;)

Chris
>
> MfG
> =A0 =A0 =A0 =A0Goswin
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
