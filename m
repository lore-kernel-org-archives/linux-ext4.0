From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: References to unmapped sectors [Was: [RFC] ext4_bmap() may return
	blocks outside filesystem]
Date: Thu, 5 Feb 2009 17:58:03 -0500
Message-ID: <87f94c370902051458t714822cbj84011446c24ec3dc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ric Wheeler <rwheeler@redhat.com>,
	Thiemo Nagel <thiemo.nagel@ph.tum.de>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f11.google.com ([209.85.221.11]:51951 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbZBEW6H (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Feb 2009 17:58:07 -0500
Received: by qyk4 with SMTP id 4so805223qyk.13
        for <linux-ext4@vger.kernel.org>; Thu, 05 Feb 2009 14:58:04 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 5, 2009 at 5:18 PM, Theodore Tso <tytso@mit.edu> wrote:
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
> thin-provisioned devices, people shouldn't use them.  Given that we
> are conservative about when we tell thin-provisioned devices that
> blocks are no longer in use (i.e., on journal commits, and if we
> crash, just don't tell the device the blocks can be reused), what's
> the problem that you're worried about?  How does it occur in real
> life?
>
> It's hard to defend against a theoretical problem when you only give
> vague fears about how it might be triggered...
>
>                                                - Ted

Ted,

I just have a very fundamental issue with a storage spec that allows
random garbage to be returned in response to a read request with no
signaling mechanism included to notify the kernel that it is reading
trash.  Ric has told me that in the real world, storage vendors are
likely to return a well defined pattern (nulls, etc.) in response to
reads of these unmapped sectors.  If true, why not have the spec say
so.

Or have some way to communicate to the kernel which sectors are
reliable (mapped) vs. unreliable (unmapped).

On the one hand the whole purpose of the SCSI DIF/DIX extension is to
ensure that the data being read from a scsi device is the exact data
that was written, but the thin-provisioning specs go in the opposite
direction and allow complete garbage to be returned with no signaling
mechanism to allow the kernel to even conceivably find out.

Instead of focusing on the negative, I'll reword my issue to discuss
how unmapped sector knowledge (if available) could be used to
_improve_ the current functionality of a filesystem:

==> Positive spin on how knowledge of which sectors are unmapped could
improve filesystem reliability

The original email discussed pointers that in someway became corrupted
to point at blocks which NEVER contained valid data.  Since the data
is outside of the overall range of data blocks, it can be identified
and both the kernel and userspace can be prevented from relying on
what would obviously be trash.

Whatever mechanism caused the bmap pointers to point outside the
overall range of the filesystem, I assume could just as easily cause
the those pointers to point at unmapped sectors.

If the SCSI / ATA specs were enhanced to somehow notify the kernel
when a read of these unmapped sectors occurred, then both the  kernel
and userspace could be protected from relying on this potential trash
as well.

FYI: I've tried to find a way to send my comments to the T10
committee, but I have not found a way to do that since the spec is not
in a "public comment" period at present.

Greg
-- 
Greg Freemyer
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
First 99 Days Litigation White Paper -
http://www.norcrossgroup.com/forms/whitepapers/99%20Days%20whitepaper.pdf

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com
