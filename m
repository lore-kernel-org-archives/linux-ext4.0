From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext3: fix message in ext3_remount for rw-remount case
Date: Mon, 8 Aug 2011 14:48:19 +0200
Message-ID: <20110808124819.GA8919@quack.suse.cz>
References: <20110801135451.cb73c981.toshi.okajima@jp.fujitsu.com>
 <20110801084526.GB6522@quack.suse.cz>
 <4E3675D6.3010201@jp.fujitsu.com>
 <20110801095731.GI6522@quack.suse.cz>
 <4E37BFEA.7020601@jp.fujitsu.com>
 <4E38B57B.4050304@jp.fujitsu.com>
 <20110803095754.GA5047@quack.suse.cz>
 <20110803222548.7c1ee229.toshi.okajima@jp.fujitsu.com>
 <20110803162525.GB10815@quack.suse.cz>
 <4E3F65A0.9090109@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, akpm@linux-foundation.org,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
To: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43045 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753124Ab1HHMsW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Aug 2011 08:48:22 -0400
Content-Disposition: inline
In-Reply-To: <4E3F65A0.9090109@jp.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

On Mon 08-08-11 13:27:12, Toshiyuki Okajima wrote:
> >On Wed 03-08-11 22:25:48, Toshiyuki Okajima wrote:
> >>On Wed, 3 Aug 2011 11:57:54 +0200
> >>Jan Kara<jack@suse.cz>  wrote:
> >>>>To tell the truth, I think the race creates the message:
> >>>>-----------------------------------------------------------------=
------
> >>>>  EXT3-fs:<dev>: couldn't remount RDWR because of
> >>>>  =E3=80=80=E3=80=80=E3=80=80 =E3=80=80unprocessed orphan inode l=
ist.  Please umount/remount instead.
> >>>>-----------------------------------------------------------------=
------
> >>>>which hides a serious problem.
> >>>   I've inquired about this at linux-fsdevel (I think you were in =
CC unless
> >>>I forgot). It's a race in VFS remount code as you properly analyze=
d below.
> >>>People are working on fixing it but it's not trivial. Filesystem i=
s really
> >>>a wrong place to fix such problem. If there is a trivial fix for e=
xt3 to
> >>>workaround the issue, I can take it but I'm not willing to push an=
ything
> >>>complex - effort should better be spent working on a generic fix.
> >>I also think read-only remount race in VFS layer should be fixed.
> >>However, I think this race depends on ext3/ext4 filesystem
> >>implementation. (Orphan inode list)
> >>So, we should modify ext3/ext4(jbd/jbd2) to fix it.
>=20
> >   Umm, I don't understand here. If VFS makes sure that there are no
>=20
> After I saw the following messages, I thought we must fix EXT3-fs err=
or
> at first. So, I created the fix patch.
>=20
> (1) kernel: EXT3-fs: <dev>: couldn't remount RDWR because of
>  =E3=80=80=E3=80=80=E3=80=80 =E3=80=80unprocessed orphan inode list. =
 Please umount/remount instead.
> (2) kernel: EXT3-fs error (device <dev>) in start_transaction: Readon=
ly filesystem
>=20
> I wasn't aware that by fixing the race between "ro-remount" and "unli=
nk",
> that EXT3-fs error can be also fixed then.
>=20
> >files open for writing, no unfinished operations changing the filesy=
stem (e.g.
> >unlink), and no open-but-unlinked files, what remains for ext3 to ch=
eck?
> OK.
> Now, I also think we need not modify ext3 to fix these problems.
> If we can prevent to add an inode into the orphan list (to start unli=
nking)
> while ro-remounting, we can also prevent (1) and (2).
>=20
> However, new mechanism to confirm whether "no open-but-unlinked" file=
s
> exist while ro-remounting is required, isn't it?
  Yes. Actually, VFS already tracks open-but-unlinked files but the che=
ck &
remount pair is not atomic so that needs to be fixed and it is not that
simple.

								Honza
--=20
Jan Kara <jack@suse.cz>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
