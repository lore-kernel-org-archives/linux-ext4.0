From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 6/7] mke2fs: check for pre-existing file system
Date: Wed, 30 Apr 2014 10:10:48 -0400
Message-ID: <20140430141048.GC9213@thunk.org>
References: <1398556834-31913-1-git-send-email-tytso@mit.edu>
 <1398556834-31913-6-git-send-email-tytso@mit.edu>
 <alpine.LFD.2.00.1404301346460.2100@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41960 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751602AbaD3OKu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Apr 2014 10:10:50 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1404301346460.2100@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 30, 2014 at 01:50:13PM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
> > +	/*
> > +	 * We should eventually replace this with a test for the
> > +	 * presence of a partition table.  Unfortunately the blkid
> > +	 * library doesn't test for partition tabels, and checking for
> > +	 * valid GPT and MBR and possibly others isn't quite trivial.
> > +	 */
>=20
> That is not true. libblkid definitely can scan for partition or any
> other signature for that matter (lvm, mdraid, ...) and we should
> definitely utilize that.

libblkid scan scan for LVM and mdraid, sure.  But it doesn't scan for
GPT or MBR partition labels:

% dpkg -S /sbin/blkid
util-linux: /sbin/blkid
% fdisk -l /dev/sda

Disk /dev/sda: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders, total 1953525168 sectors
Units =3D sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0xae7b6b2b

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *        2048      206847      102400    7  HPFS/NTFS/exFAT
/dev/sda2          206848   167772159    83782656    7  HPFS/NTFS/exFAT
/dev/sda3       167772160   482344959   157286400   83  Linux
/dev/sda4       482344960  1953525167   735590104   8e  Linux LVM

% sudo /sbin/blkid  /dev/sda
%

Ohhh...  this may be debian's fault for having a pre-historic
util-linux.

But anyway, if util-linux does detect partition labels, then this
patch will catch the problem.



							- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
