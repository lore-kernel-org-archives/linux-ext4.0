From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: Ideas on unified real-ro mount option across all filesystems
Date: Tue, 22 Dec 2015 02:32:21 +0100
Message-ID: <20151222023221.56a89345@jupiter.sol.kaishome.de>
References: <567212DA.8050808@cn.fujitsu.com>
	<567228EF.80007@redhat.com>
	<5673616C.1040706@cn.fujitsu.com>
	<1450404066.6498.70.camel@scientia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Am Fri, 18 Dec 2015 03:01:06 +0100
schrieb Christoph Anton Mitterer <calestyo@scientia.net>:

> The manpage says:
> > ro=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Mount the filesystem read-only.
> > rw=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Mount the filesystem read-write. =20

That means: the filesystem... Not the block device...

Sorry, it's kinda nitpicking. But actually, the file system IS
read-only: You cannot modify files from user's view.

What you actually want is not modifying the underlying storage which is
the block device and includes stuff like meta and journal data (which
is only indirectly visible to users at best).

You can argue that man pages are not particularly end-user friendly.
But for an admin this makes sense without being an fs developer.

--=20
Regards,
Kai

Replies to list-only preferred.


--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
