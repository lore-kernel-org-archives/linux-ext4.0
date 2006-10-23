From: Jan Kara <jack@suse.cz>
Subject: Re: 2.6.18-mm2: ext3 BUG?
Date: Mon, 23 Oct 2006 12:41:41 +0200
Message-ID: <20061023104141.GB3162@atrey.karlin.mff.cuni.cz>
References: <45257A6C.3060804@gmail.com> <20061005145042.fd62289a.akpm@osdl.org> <4525925C.6060807@gmail.com> <20061005171428.636c087c.akpm@osdl.org> <20061008063330.GA30283@lug-owl.de> <20061010070933.GE30283@lug-owl.de> <20061011104201.GD6865@atrey.karlin.mff.cuni.cz> <20061023081354.GK26271@lug-owl.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andrew Morton <akpm@osdl.org>, Jiri Slaby <jirislaby@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	sct@redhat.com, adilger@clusterfs.com, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:13285 "EHLO
	atrey.karlin.mff.cuni.cz") by vger.kernel.org with ESMTP
	id S1751895AbWJWKky (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Oct 2006 06:40:54 -0400
To: Jan-Benedict Glaw <jbglaw@lug-owl.de>
Content-Disposition: inline
In-Reply-To: <20061023081354.GK26271@lug-owl.de>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  Hello,

> On Wed, 2006-10-11 12:42:02 +0200, Jan Kara <jack@suse.cz> wrote:
> > > On Sun, 2006-10-08 08:33:30 +0200, Jan-Benedict Glaw <jbglaw@lug-=
owl.de> wrote:
> > > While I could reproduce it with a 200MB file, it seems I can't br=
eak
> > > it with a 10MB file.
> >   Hmm, I was running the test for several ours without any problem.=
=2E.
> > The kernel is 2.6.17.6, ext3 in ordered data mode, standard SATA di=
sk. I'm
> > now running it again and trying my luck ;). What is your testing en=
vironment?
>=20
> kolbe34-backup:/mnt# uname -a
  Thanks for info. This looks pretty similar to what I have (only that
I have Athlon).

> Still running Debian's 2.6.17-2-686, I'm now tracking down the file
> size when I start to see this type of corruption. Right now, it seems
> I never get it with a 16384 KB (16 MB) large file, but I get it with =
a
> 21504 KB (21 MB) file.
>=20
> Is there something important that changes handling of file contents i=
n
> the 16..21 MB range?
  Umm, I've checked and found nothing obvious. We already have to use
double-indirect block at 16MB, maybe reservation code does some
distiction. Could you mount the filesystem with -o 'noreservation' and
see whether you can still reproduce the problem? Also it may be useful
to find out, whether you see the failure also with some older kernels..=
=2E

								Honza
>=20
> dumpe2fs output at http://lug-owl.de/~jbglaw/ext3-dumpe2fs.txt for
> that filesystem.  I'll now run with a 18.5 MB file...
>=20
> MfG, JBG
>=20
> --=20
>       Jan-Benedict Glaw      jbglaw@lug-owl.de              +49-172-7=
608481
>   Signature of:                           Wenn ich wach bin, tr=E4ume=
 ich.
>   the second  :


--=20
Jan Kara <jack@suse.cz>
SuSE CR Labs
