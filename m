From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Ext4 devel interlock meeting minutes (Nov. 22 2006)
Date: Wed, 22 Nov 2006 21:33:16 -0600
Message-ID: <4565167C.4060802@redhat.com>
References: <1164232428.29430.27.camel@dyn9047017105.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:56017 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S1754887AbWKWDdW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 22 Nov 2006 22:33:22 -0500
To: Avantika Mathur <mathur@us.ibm.com>
In-Reply-To: <1164232428.29430.27.camel@dyn9047017105.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Avantika Mathur wrote:
> Ext4 Developer Interlock Call: 11/22/06 minutes
>=20
> Attendees: Mingming Cao, Eric Sandeen, Suparna Bhattacharya, Takashi =
Sato, Jean-Pierre Dion, Val=C3=A9rie Cl=C3=A9ment, Avantika Mathur
>=20
> - Online Defrag:
>  -- Last week we determined that ioctl was the preferred=20
> interface for the online defrag.
>  -- Eric will send out an ovreview of the steps completed by XFS for =
file defragmentation.
>  -- Last week Eric said that in XFS defrag implementation, you can't =
defrag a file that is open/being written to.  This was an incorrect ass=
umption. There will be more explanation in his mail.
>=20
> - Preallocation:
>  -- We need to decide which interface to use in the implementation
>    * ioctl: simple solution preferred method for defrag and user in r=
eservation

And would also be useful for testing, at least.  If reiserfs or jfs or=20
xfs has existing interfaces for preallocation that are at all useful,=20
perhaps we could even piggyback on them for now, in the same way that=20
other filesystems picked up ext[23]'s chattr interfaces?

>    * posix_fallocate: writes zero to the first byte of every block; p=
robably preferred solution

=46or the record, this is only how glibc does it today, it certainly=20
doesn't have to be done this way, ideally a kernel syscall which allows=
=20
filesystems to be smart would be best.  Coordinating glibc & kernel=20
changes will be tricky & time consuming though... but it's a noble goal=
=2E=20
  I'd like to see it happen; I'll chat with Ulrich when I get a chance,=
=20
see what he thinks.

>    * ftruncate: consistency across platforms may be an issue

I agree w/ Andreas on this, I don't see how ftruncate can be used w/o=20
making holey files impossible.

-Eric
