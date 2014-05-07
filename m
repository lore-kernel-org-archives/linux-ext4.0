From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH -v2 2/3] mke2fs: print extra information about existing
 ext2/3/4 file systemsG
Date: Wed, 7 May 2014 08:39:13 -0400
Message-ID: <20140507123913.GA28814@thunk.org>
References: <1399338133-21373-1-git-send-email-tytso@mit.edu>
 <1399338133-21373-2-git-send-email-tytso@mit.edu>
 <alpine.LFD.2.00.1405061528470.2255@localhost.localdomain>
 <20140507024621.GB6461@thunk.org>
 <alpine.LFD.2.00.1405071014350.2128@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54247 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933078AbaEGN2D (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 7 May 2014 09:28:03 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1405071014350.2128@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 07, 2014 at 10:15:56AM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
> > Yes, that's a cut and paste typo, thanks for spotting it.  It shoul=
d
> > have been:
> >=20
> > 	} else if (sb->s_mkfs_time) {
> > 		tm =3D sb->s_mkfs_time;
> > 		printf(_("\tcreated on %s"), ctime(&tm));
> > 	} else if (sb->s_mtime) {  <=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> But you're already checking for sb->s_mtime in the first condition,
> am I missing something ?

The basic idea is to give one bit of context, and whatever would be
the most useful.  In order of preference, it's:

1)  Last mount directory (if available) and last mount time
2)  Time file system was created
3)  Time file system was written

#2 or #3 is only needed if the file system was never mounted.

#3 is only needed for those file systems that (a) were never mounted,
(b) was modified/filled via e2tools or debugfs.  (Or Windows FS SDK
based hacks, etc.)

					- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
