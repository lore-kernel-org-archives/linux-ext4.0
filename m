From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: How to run xfstests against multipath disks on SuSE?
Date: Mon, 26 Nov 2012 09:55:59 -0500
Message-ID: <20121126145559.GK31891@thunk.org>
References: <CAPxxNQmwX+TmJ=B-H0f+bzpx5JdijyyRrxCAAZRi9+c8HjQL9Q@mail.gmail.com>
 <alpine.LFD.2.00.1211261442490.18234@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ryan Wang <openspace.wang@gmail.com>, linux-ext4@vger.kernel.org,
	xfs@oss.sgi.com
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:34857 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754356Ab2KZO4D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Nov 2012 09:56:03 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1211261442490.18234@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 26, 2012 at 02:43:40PM +0100, Luk=C3=A1=C5=A1 Czerner wrote=
:
> > The I checked the script common.rc, and found that it uses
> > df to determine the filesystem type and it uses the realpath
> > "/dev/dm-0" instead of "/dev/mapper/mpatha", while df always
> > shows "devtmpfs" instead of "ext4" for /dev/dm-0.
> >=20
> > I run "mount" and found that devtmpfs is mount on /dev/ on opensuse
> > ***by default***. Even though  I run "mount -t btrfs /dev/dm-0 /som=
edir",
> > df still showed devtmpfs.
> >=20
> > Any ideas to kick off the xfstests?

At least with the df which ships with Debian Testing, df will display
the file system in use if it matches the device name which is
/etc/mtab.  It looks the issue is that mount is canonicalizing the
device name to be the human friendly version:

# ls -l /dev/mapper/closure-bigscratch=20
0 lrwxrwxrwx 1 root root 7 Nov 16 15:15 /dev/mapper/closure-bigscratch =
-> ../dm-7
<tytso.root@closure> {/home/tytso/bin}, level 2 =20
# mount /dev/dm-7 /u2
# df /u2
=46ilesystem                     1K-blocks   Used Available Use% Mounte=
d on
/dev/mapper/closure-bigscratch  52403200 224772  52178428   1% /u2
# grep /u2 /etc/mtab
/dev/mapper/closure-bigscratch /u2 xfs rw,relatime,attr2,inode64,noquot=
a 0 0

So the simplest solution is to just use /dev/mapper/mpatha instead of
insisting on using /dev/dm-0.  That's what I do....

						- Ted

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
