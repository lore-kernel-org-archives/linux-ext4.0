From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: GRUB and the risk of block list corruption in extX
Date: Sat, 9 Feb 2013 23:45:55 -0500
Message-ID: <20130210044555.GD8526@thunk.org>
References: <B6CCAB6A-D340-47F8-9231-1280151552DC@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:47664 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761083Ab3BJEp6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 9 Feb 2013 23:45:58 -0500
Content-Disposition: inline
In-Reply-To: <B6CCAB6A-D340-47F8-9231-1280151552DC@colorremedies.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Feb 09, 2013 at 05:17:58PM -0700, Chris Murphy wrote:
> On the other hand=E2=80=A6
>=20
> > There are some folks who are proposing that we use a bootloader ino=
de:
> > for grub's benefit.=20
>=20
> Who are requesting this? If not GRUB's devs, it would seem there are
> other developers who are also paranoid.

Well, it was one of the participants (or observers) of=20

     https://bugzilla.redhat.com/show_bug.cgi?id=3D872826

He posted on the linux-ext4 list a week or so ago:

    http://comments.gmane.org/gmane.comp.file-systems.ext4/36637

> > But it's not something that has been terribly high priority, since
> > it's basically more of a security blanket for the grub2 developers
> > more than anything else=E2=80=A6.
>=20
> It may be a security blanket for grub2 developers. However, it
> appears to me users want a security blanket also.

Well, a participant of on the redhat bugzilla inquired about it.

If someone wants to send me some patches, I'm happy to review them.  I
personally think it's not a great use of time, but that's the
wonderful thing about open source.  You can always send patches.  :-)

> Despite my bias against two bootloaders (I think it's ridiculous,
> but then I prefer 1/2 a boot loader), the question I have is if a
> blocklist is really needed to find and load the 2nd boot loader?
> Because needing a blocklist in the VBR implies the first boot loader
> doesn't understand ext(4). If true, before engineering file system
> changes, users need to upgrade their ancient primary boot loader.

It's been a long time since I really spent a lot of time studying
grub, but my understanding is that the first boot loader (which fits
in the MBR) is just too small to have room to understand the ext[234]
file system; you can't really do a lot in 492 bytes of x86
assembly.....  That's why it uses a block list instead.

But honestly, I really don't care a whole lot about the emotional
insecurity of the grub2 developers, and if distributions are worried
about their users being insecure, they can always comment out the
alarmist message in grub2.  Or they can send me patches.  :-)

	 	    	       	    	     - Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
