From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: [RFC] ext4_bmap() may return blocks outside filesystem
Date: Sat, 07 Feb 2009 14:27:31 +0100
Message-ID: <87r62aidh8.fsf@frosties.localdomain>
References: <498AD58B.5000805@ph.tum.de> <20090205134905.GL8945@mit.edu>
	<87f94c370902050722wf2099c9i2d815737e85209f3@mail.gmail.com>
	<498B084F.2060608@redhat.com> <20090205164803.GM8945@mit.edu>
	<87f94c370902051401s6d73d810s720f187c134f0b1e@mail.gmail.com>
	<20090205221809.GD9814@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:51315 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893AbZBGN1d (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 7 Feb 2009 08:27:33 -0500
In-Reply-To: <20090205221809.GD9814@mit.edu> (Theodore Tso's message of "Thu,
	5 Feb 2009 17:18:09 -0500")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso <tytso@mit.edu> writes:

> On Thu, Feb 05, 2009 at 05:01:01PM -0500, Greg Freemyer wrote:
>> > It also has absolutely nothing to do with the original thread, which
>> > was block numbers which are far outside the range of valid block
>> > numbers given the size of the block device.  :-)
>> 
>> The subject was "return blocks outside filesystem".
>
> Yes, it's clear you didn't read the e-mail thread, but rather just
> keyed off the subject line.  :-)
>
>> In a thin-provisioning environment I'd argue that unmapped sectors are
>> "outside the filesystem". :)
>> 
>> Unfortunately, I can't get anyone else to see the world from my
>> apparently unique perspective. :(
>
> If you don't like this, don't use thin-provisioned devices.  Again, I
> don't see the likely scenario where your fears are likely to be a
> factor in a real world scenario.  If there are bugs in the

There will be bugs.

> thin-provisioned devices, people shouldn't use them.  Given that we

And people will still use them.

Assuming that storage boxes work perfectly is just ignoring reality.
Even if the software has no bugs there will still be hardware
failures. Given enough boxes there will be multi-bit toggles with
correct ECC sum in ram or on disks. Power and battery backups will
fail mid update and and and.

> are conservative about when we tell thin-provisioned devices that
> blocks are no longer in use (i.e., on journal commits, and if we
> crash, just don't tell the device the blocks can be reused), what's
> the problem that you're worried about?  How does it occur in real
> life?
>
> It's hard to defend against a theoretical problem when you only give
> vague fears about how it might be triggered...
>
> 						- Ted

I see the following scenario:

1) The filesystem / thin-provision gets corrupted somehow. fs bug,
hardware, whatever.

2) The thin-provision thinks a block is free while the FS thinks it is
in use. Make it a meta data block so it really matters.

3) The thin-provision still has the mapping and data of the block and
hasn't reused the block yet. On read the device will return the
correct data as long as the block is not reused. This seems to be a
valid implementation for a thin-provision device.

4) fsck will find no error but future writes will reuse the block on
the thin-provision device overwriting the data and causing
catastrophic FS corruption.


So I think a fsck pass to check FS used blocks against hardware used
blocks is essential if the FS does support thin-provisioned devices.
Once you free hardware blocks you have to check that what the FS and
hardware think are compatible.

MfG
        Goswin
