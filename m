From: "Daniel Taylor" <Daniel.Taylor@wdc.com>
Subject: RE: breaking ext4 to test recovery
Date: Tue, 29 Mar 2011 15:26:55 -0700
Message-ID: <25B374CC0D9DFB4698BB331F82CD0CF20D61BC@wdscexbe08.sc.wdc.com>
References: <25B374CC0D9DFB4698BB331F82CD0CF20D61B8@wdscexbe08.sc.wdc.com> <4D91E39A.3000800@redhat.com> <20110329143305.GA6057@bitwizard.nl> <AANLkTinJ4-PPTi0q76fThmq9a_qe1PadVueObPtRLruY@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wdscspam3.wdc.com ([129.253.55.42]:15589 "EHLO
	wdscspam3.wdc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754715Ab1C2W0z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 29 Mar 2011 18:26:55 -0400
Content-class: urn:content-classes:message
In-Reply-To: <AANLkTinJ4-PPTi0q76fThmq9a_qe1PadVueObPtRLruY@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

=20

> -----Original Message-----
> From: Greg Freemyer [mailto:greg.freemyer@gmail.com]=20
> Sent: Tuesday, March 29, 2011 10:34 AM
> To: Rogier Wolff
> Cc: Eric Sandeen; Daniel Taylor; linux-ext4@vger.kernel.org
> Subject: Re: breaking ext4 to test recovery
>=20
> On Tue, Mar 29, 2011 at 10:33 AM, Rogier Wolff=20
> <R.E.Wolff@bitwizard.nl> wrote:
> > On Tue, Mar 29, 2011 at 08:50:18AM -0500, Eric Sandeen wrote:
> >> Another tool which can be useful for this sort of thing is
> >> fsfuzzer. =A0It writes garbage; using dd to write zeros actually
> >> might be "nice" corruption.
> >
> > Besides writing blocks of "random data", you could write=20
> blocks with a
> > small percentage of bits (byte) set to non-zero, or just toggle a
> > configurable number of bits (bytes). This is slightly more=20
> devious than just
> > "random data".
>=20
> I don't know what exactly is being tested, but "hdparm
> --make-bad-sector" can be used to create a media error on a specific
> sector.
>=20
> Thus allowing you to simulate a sector failing in the middle=20
> of the journal.
>=20
> I assume that is a relevant test.
>=20
> fyi: --repair-sector undoes the damage.  You may need to follow that
> with a normal write to put legit data there.
>=20
> If you try a normal data write without first repairing, the drive
> should mark the sector permanently bad and remap that sector to a
> spare sector.
>=20
> I have only used these tools with raw drives, no partitions, etc.  So
> I've never had to worry about data loss, etc.
>=20
> Greg
>=20

Thanks for the suggestions.  Tao Ma's got me started, but doing some
of the more "devious" tests is on my list, too.

The original issue was that during component stress testing, we were
seeing instances of the ext4 file system becoming "read-only" (showing
in /proc/mounts, but not "mount").  Looking back through the logs, we
saw that at mount time, there was a complaint about a corrupted journal=
=2E

Some writing had occurred before the change to read-only, however.

The original mount script didn't check for any "mount" return value, so
we theorized that ext4 just got to a point where it couldn't sensibly
handle any more changes.

It seemed that the right answer was to check the return value from moun=
t
and, if non-0, umount the file system, fix it, and try again.  To test
the return value from mount, I need to be able to corrupt, but not
destroy the journal, since the component tests were taking days to show
the failure.

Running an "fsck -f" every time on a 3TB file system with an embedded
PPC was just taking too much time to impose on a consumer-level custome=
r.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
