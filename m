From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
Subject: Re: Add a norecovery option to ext3/4?
Date: Tue, 10 Apr 2007 09:22:53 +0200
Message-ID: <20070410072253.GA28665@lazybastard.org>
References: <20070409000556.GA13980@implementation> <461A5F13.7040705@cfl.rr.com> <461A760B.1040103@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Phillip Susi <psusi@cfl.rr.com>,
	Samuel Thibault <samuel.thibault@ens-lyon.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lazybastard.de ([212.112.238.170]:48121 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbXDJH0t (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Apr 2007 03:26:49 -0400
Content-Disposition: inline
In-Reply-To: <461A760B.1040103@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 9 April 2007 12:21:15 -0500, Eric Sandeen wrote:
> Phillip Susi wrote:
> >=20
> > When the filesystem is told to mount the disk read only, that means=
 it=20
> > should not write to it. =20
>=20
> It means the filesystem should not be writeable when it is mounted.
> This is not the same as saying that the filesystem itself should do n=
o
> IO in the course of making that read-only mount available.

The filesystem has two interfaces.  One to the device underneith, one t=
o
userspace.  Read-only should certainly mean that no writes cross the
userspace interface.  Traditionally it has implicitly also meant that
no writes are crossing the device interface.  Whether that was/is an
explicit requirement - who knows.

Journaling filesystems have introduced this thing called "journal
replay".  And I have to admit, it makes thing _a lot_ easier to always
replay the journal, even when being mounted read-only.

But "it is easier" is a pretty lame excuse.

> Under all conditions it should be safe to mount a read-only block
> device, but that is not the same as mounting a filesystem read-only.

In particular, it is a lame excuse when this claim is true.  If the
block-device is read-only, then journal replay will not work as expecte=
d
and all the "not so easy" work has to be done anyway.

Did I miss anything?  Is it actually easier to mount a read-only device
with unclean journal than mounting a read-write device and not replay
the journal?

J=C3=B6rn

--=20
Joern's library part 8:
http://citeseer.ist.psu.edu/plank97tutorial.html
