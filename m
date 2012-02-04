From: Hin-Tak Leung <htl10@users.sourceforge.net>
Subject: Re: sane fsck default behavior for "Entry ... in ... has deleted/unused inode ....  Clear? yes"
Date: Sat, 4 Feb 2012 17:53:10 +0000 (GMT)
Message-ID: <1328377990.1636.YahooMailClassic@web29504.mail.ird.yahoo.com>
References: <1AB9AC11-F9E9-4F52-8CBC-D050B056D013@mit.edu>
Reply-To: htl10@users.sourceforge.net
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Theodore Tso <tytso@MIT.EDU>, tytso@users.sourceforge.net,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nm7.bullet.mail.ird.yahoo.com ([77.238.189.21]:47596 "HELO
	nm7.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753917Ab2BDR7r convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 4 Feb 2012 12:59:47 -0500
In-Reply-To: <1AB9AC11-F9E9-4F52-8CBC-D050B056D013@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--- On Sat, 4/2/12, Theodore Tso <tytso@MIT.EDU> wrote:

<snipped>
> Most of this message isn't appropriate for
> fs-devel.=A0=A0=A0The ext4 bits are
> germane to the ext4 list, and the USB read errors should be
> taken to
> the usb folks.=A0 =A0 I've removed fs-devel from the
> reply-to header, and
> I'll ask people who are replying to further edit the cc list
> if appropriate.

=46air enough - I just thought the interaction between usb-storage and =
lvm2 would warrant some wider discussion.=20

> This error means the inode entry (and perhaps the entire
> inode table
> block in your case) has been zapped.=A0 So all that's
> left is the directory
> entry, containing the file name and inode
> number.=A0=A0=A0There's nothing
> really left to save.
>=20
> > I also want to make a suggestion: when such a decision
> is made, I'd like to keep a record of what files are lost,
> etc. Can an option be added to e2fsck to log its decisions
> somewhere?
>=20
> I suggest that you look at using the "script" program if you
> are running
> e2fsck manually, or if you are interested in saving the
> output of fsck
> during the boot sequence, if your distro isn't already using
> logsave,
> consider using that binary.

That files are lost forever I understand, but from a user's point of vi=
ew, the most important thing is preserving data, or at least, when lost=
 is inevitable, know that they are lost and hope to recover that somewh=
ere. Is it possible to offer that - i.e. prompt for a log file - when s=
uch a decision is needed, when run interactively?
=20
> > it appears that some combination of SATA->USB
> enclosure plus usb-storage plus usb hci driver doesn't like
> read errors, and the kernel resets the usb device and
> reconnects whenever that happens. That has the unfortunate
> side effect of renaming /dev/sdb into /dev/sdc, etc,
> underneath lvm2, and causes lvm2 to get stuck. I suppose
> that's the sane behavior since one wants to stop I/O and
> further damage, but maybe the kernel should only reset usb
> storage devices on write-errors, rather than read-errors?
> And somehow limit the device to read-only access after a
> read-error?
>=20
> I'd suggest that you send your dmesg output to the USB
> folks.
> That might give them more of an idea which portion of the
> stack is causing the stack is causing the
> reset.=A0=A0=A0It may very
> well be the SATA->USB enclosure is reporting some error
> much worse than a read error as a result of the error.=20

Thanks. The curious thing is that running hdparm -a0/-A0 can get around=
 the reset, so it seems to be a performance related issue.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
