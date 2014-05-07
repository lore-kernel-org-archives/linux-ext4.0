From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH -v2 2/3] mke2fs: print extra information about existing
 ext2/3/4 file systems
Date: Tue, 6 May 2014 22:46:21 -0400
Message-ID: <20140507024621.GB6461@thunk.org>
References: <1399338133-21373-1-git-send-email-tytso@mit.edu>
 <1399338133-21373-2-git-send-email-tytso@mit.edu>
 <alpine.LFD.2.00.1405061528470.2255@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53364 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752239AbaEGCqZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 May 2014 22:46:25 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1405061528470.2255@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 06, 2014 at 03:42:37PM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
> > +	retval =3D ext2fs_open2(device, 0, 0, 0, 0, unix_io_manager, &fs)=
;
>=20
> Sorry for not noticing this earlier, but we might want to pass
> EXT2_FLAG_64BITS.

Done.

> > +	} else if (sb->s_mkfs_time) {
> > +		tm =3D sb->s_mkfs_time;
> > +		printf(_("\tcreated on %s"), ctime(&tm));
> > +	} else if (sb->s_mkfs_time) {
>=20
> This does not seem right, you've already checked for s_mkfs_time and
> if was not set if you got here. I guess, it should be something else
> ? s_wtime perhaps ? But, can this be set when the fs was not mounted
> (like using ext2fs library ?)
>=20
> > +		tm =3D sb->s_mtime;
>=20
> If you got here, then again this is not set.


Yes, that's a cut and paste typo, thanks for spotting it.  It should
have been:

	} else if (sb->s_mkfs_time) {
		tm =3D sb->s_mkfs_time;
		printf(_("\tcreated on %s"), ctime(&tm));
	} else if (sb->s_mtime) {  <=3D=3D=3D=3D=3D=3D=3D=3D
		tm =3D sb->s_mtime;
		printf(_("\tlast modified on %s"), ctime(&tm));
	}


Cheers,

					- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
