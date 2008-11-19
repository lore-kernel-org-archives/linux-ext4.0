From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Conversion to ext4 renders a filesystem unbootable
Date: Wed, 19 Nov 2008 12:12:18 -0600
Message-ID: <49245702.1070406@redhat.com>
References: <491ec8f2.h+/NctvgrQETYou26OH9qFQ1@Brain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Bruce Jerrick <bmj001@ippimail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:39779 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752906AbYKSSMY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 Nov 2008 13:12:24 -0500
In-Reply-To: <491ec8f2.h+/NctvgrQETYou26OH9qFQ1@Brain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Bruce Jerrick wrote:
> Despite ext4[dev] support in Fedora 9 and 10, conversion of an ext3 filesystem
> to ext4 will render it permanently unbootable (read on; there's a "yes, I know"
> down there).
> 
> I'm not looking for a rescue (this was all done to an expendable system), and
> it appears to be a known "issue", but additional warnings in 'man tune2fs'
> (or even in the executable) seem to be warranted.
> 
> The scenario was:
> 
> On a multi-boot machine with my main system being Fedora 8 (with
> kernel-2.6.26.6-49.fc8 and e2fsprogs-1.41.3-2.fc9, so it has ext4dev support),
> I "converted" an ext3 filesystem by setting 'test_fs' with tune2fs, then
> mounting it (successfully) under the F8 system as type ext4dev.
> 
> The converted filesystem contained an F10 installation all on one filesystem,
> i.e., no separate /boot .  (I had overlooked the fact that the anaconda
> installer doesn't support ext4 on a bootable partition; the goal was just to
> make sure I can access F10 ext4 filesystems from the F8 system.)  Later I
> discovered that the F10 system wouldn't boot, with a message about
> "unsupported features".

Yep, afraid grub doesn't support it yet.  See below (or Peng's email)

> Presumably this was because it now uses extents instead of indirect blocks
> (after it was ext4, I modified a file on it, so I assume it started
> using extents).  The really bad news is that this conversion seems to
> be irreversible.  So there should probably be warnings in 'man tune2fs'
> similar to those in 'man mkfs.ext4' (and also a warning about rendering a
> partition permanently unbootable).

Warnings might be in order, although tune2fs warning that some other
applications may not yet grok ext4 seems above & beyond the call of
duty; Fedora release notes might have been a good place for it ...

It's sorta-reversible; see below.

> BTW, there's a minor inconsistency in F10 'man mke2fs' (and its hardlink
> clones).  In the OPTIONS section, "-O" has "extent" listed, but the example
> after "-t fs-type" uses "-O extents" (granted, either form seems to be
> accepted).
> 
> Similarly, 'tune2fs -l' reports "extent" (in Filesystem features), but
> /etc/mke2fs.conf uses "extents" (as a features value).

Yeah, I've noticed those too.

> -- Bruce Jerrick
> 
> PS.  If feasible, a two-way ext3 <-> ext4 converter would be nice.

You can do it manually by mounting w/o extents (-o noextents) and then
for each extent-based file, cp $FILE $FILE.bak; mv $FILE.bak $FILE, and
when that is all done, remove the extents flag.

> PPS.  Are bootable ext4 partitions in the cards?  (I assume yes.)

Yep, as Peng Tao said, there is a patch, and I've sent it to our grub
maintainer; filing a fedora bug/rfe might kick that along a bit :)

> PPPS.  Why am I still using F8?  <flame> Because gnome-session/gnome-terminal
>  save/restore is (repairably) broken in F9 and gone entirely in F10. </flame>

Filed a bug?

-Eric


