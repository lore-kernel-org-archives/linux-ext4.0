From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: [RFC] ext4_bmap() may return blocks outside filesystem
Date: Thu, 5 Feb 2009 10:22:43 -0500
Message-ID: <87f94c370902050722wf2099c9i2d815737e85209f3@mail.gmail.com>
References: <498AD58B.5000805@ph.tum.de> <20090205134905.GL8945@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Thiemo Nagel <thiemo.nagel@ph.tum.de>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f11.google.com ([209.85.221.11]:43548 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754219AbZBEPWo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Feb 2009 10:22:44 -0500
Received: by qyk4 with SMTP id 4so387169qyk.13
        for <linux-ext4@vger.kernel.org>; Thu, 05 Feb 2009 07:22:43 -0800 (PST)
In-Reply-To: <20090205134905.GL8945@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 5, 2009 at 8:49 AM, Theodore Tso <tytso@mit.edu> wrote:
> On Thu, Feb 05, 2009 at 01:03:23PM +0100, Thiemo Nagel wrote:
>> But there also are cases which are not handled gracefully by bmap() callers.
>>
>> I've attached a conceptual patch against 2.6.29-rc2 which fixes one case
>> in which invalid block numbers are returned (there might be more) by
>> adding sanity checks to ext4_ext_find_extent(), but before I start
>> looking for further occurences, I'd like to ask whether you think my
>> approach is reasonable.
>
> Yes, it's reasonable; the right thing is not just to jump out to
> errout, though, but to call ext4_error() first, since the filesystem is
> clearly corrupted, so we want to mark the filesystem as needing to be
> fsck'ed, and so if the filesystem is marked "remount readonly" or
> "panic" on filesystem errors, that the right thing happens.  We should
> also log the device name, inode number and logical block number that
> was requested, so that someone who is looking in the console logs can
> see what was going on at the time.
>
> As an unrelated patch, might also want to put a check in
> fs/ext4/inode.c's ext4_get_branch(), so we can equivalently detect
> bogus direct/indirect blocks and flag them with the appropriate
> errors.
>
>                                                - Ted

This is just a rant, and I doubt anyone can do anything about it, but
it is still worth reading imho.

<rant>
This brings up a concern I have with the proposed Thin Provisioning
updates to the SCSI and ATA specs.

As I'm sure most know, both are looking at supporting the concept of
mapped / unmapped sectors being tracked not only in the filesystem but
also in the storage device.

[SSDs are one use case, and  storage arrays are the other.  Many
storage arrays already support thin provisioning but not via the new
"discard" functionality in the linux kernel.]

My big concern is that neither is proposing a way for a tool like fsck
to query the storage device to verify the filesystem's view of what is
mapped vs unmapped agrees with the storage devices view.

For both sets of proposed spec updates there are circumstances where
the storage device spec allows garbage to be returned for non-mapped
sectors.  Thus in the situation of a corrupt filesystem, it is very
possible that some of the sectors that the filesystem is relying on
are actually unmapped and potentially garbage.

Lacking any knowledge of which specific sectors the underlying storage
systems treats as reliable vs. unreliable, I can imagine the
filesystem corruption will go from a correctable situation to a
"restore from backups" situation.

The solution in my mind is that both specs add a way for diagnostic
tools to query the status of a sector to see if it is mapped vs
unmapped, etc.
</rant>.

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
