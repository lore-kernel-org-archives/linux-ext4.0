From: "Marcel Partap" <mpartap@gmx.net>
Subject: Re: fsck ate my ext4 home partition, help!?
Date: Tue, 05 May 2009 16:44:36 +0200
Message-ID: <20090505144436.125410@gmx.net>
References: <20090504131128.135100@gmx.net>
 <alpine.DEB.2.01.0905042222260.6162@bogon.housecafe.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Christian Kujau <lists@nerdbynature.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:40144 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752912AbZEEOon (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 5 May 2009 10:44:43 -0400
In-Reply-To: <alpine.DEB.2.01.0905042222260.6162@bogon.housecafe.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


> Have you checked /proc/mounts? mtab could be stale, lsof not seeing=20
> everything and the "empty mountpoint" could be some other mount on to=
p of=20
> /home.
Well how did that happen. It indeed still shows up there:
/dev/sdd4 /home ext3 rw,noatime,nodiratime,errors=3Dcontinue,user_xattr=
,data=3Dwriteback 0 0
Which btw means this actually is an ext3 volume, confirmed by fstab. Ho=
w did i miss this. Fo0 bar!

>=20
> > previous run of e2fsck with the -n was showing a bunch of stuff to =
fix,=20
> Do you still have that e2fsck output?
> > revealed the havoc that was done: ls -laR showed abundant I/O error=
s,=20
> Again: error messages would be helpful.
Sending you the screen output buffer in a minute.

> You did not take the dd image before the first e2fsck, hm?
Well backing up files before trashing them is sooo unadventurous aint i=
t. e2fsck really needs the ability to write all actions to an undo log =
file. By default. Hmmpf.

> Now that you=20
> have a backup: a few days ago a tool called "extundelete"[0] has been=
=20
> annunced on ext3-users, maybe that can be of help recovering your fs.
Going to let it loose on the partition and have a go, hopefully i don't=
 have to free another 300gig for it to recover the files...


> e2fsprogs-1.41.5 has been released recently, you might want to give i=
t a=20
> shot.
Hmm will have a look at the changelog and recompile, thx for the notice=
=2E

> Christian.
> Perfect Forward Secrecy is when Bruce Schneier whispers something in =
your
> ear.
Thx so much for your time and effort to provide with a new mission brie=
fing. On to recovery and BEYOND!!!
marcel ;)
--=20
Psssst! Schon vom neuen GMX MultiMessenger geh=F6rt? Der kann`s mit all=
en: http://www.gmx.net/de/go/multimessenger01
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
