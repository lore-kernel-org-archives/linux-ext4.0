From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: Query FSCK Errors on ext4
Date: Mon, 28 Oct 2013 14:39:06 +0800
Message-ID: <20131028063905.GA9017@gmail.com>
References: <008701cecc19$14734370$3d59ca50$@ntlworld.com>
 <F81EF3B4-CEBF-43FD-BD38-0AFFF56014C6@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Stephen Elliott <techweb@ntlworld.com>,
	David Jeffery <djeffery@redhat.com>,
	"linux-ext4@vger.kernel.org List" <linux-ext4@vger.kernel.org>,
	Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>,
	Eric Whitney <enwlinux@gmail.com>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f54.google.com ([209.85.160.54]:60445 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857Ab3J1Ggy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Oct 2013 02:36:54 -0400
Received: by mail-pb0-f54.google.com with SMTP id ro8so2602654pbb.13
        for <linux-ext4@vger.kernel.org>; Sun, 27 Oct 2013 23:36:54 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <F81EF3B4-CEBF-43FD-BD38-0AFFF56014C6@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

[Cc Eric Whitney to confirm this problem]

Hi Andreas,

If I remember correctly, this patch might can fix this problem [1].

1. http://www.spinics.net/lists/linux-ext4/msg39485.html

Regards,
                                                - Zheng

On Mon, Oct 28, 2013 at 12:13:26AM -0600, Andreas Dilger wrote:
> The error reported here is a relatively new one.  It only appeared in
> e2fsck 1.42.8, and wasn=E2=80=99t in the code that I=E2=80=99m using =
locally (1.42.7)
> so I wasn=E2=80=99t sure what it actually meant without looking at it=
=2E
>=20
> It looks like some kind of overflow of the extent tree, which causes
> e2fsck to chop off the last 5 disk blocks (40 sectors), though I=E2=80=
=99m not
> sure exactly why.  From your comments, this can be reproduced with
> your database usage?  Does it use fallocate() or any other strange
> IO operations that might be causing this?
>=20
> Have you tried updating your kernel?  If there is repeated corruption
> appearing in the filesystem, then it is either a bug in the kernel or
> in e2fsck.  Not really sure which one to blame at this point.
>=20
> Cheers, Andreas
>=20
> On Oct 18, 2013, at 9:45 AM, Stephen Elliott <techweb@ntlworld.com> w=
rote:
>=20
> > Any feedback on this guys??? Would really appreciate somebody takin=
g a look over this.
> > =20
> > From: Stephen Elliott [mailto:techweb@ntlworld.com]=20
> > Sent: 22 September 2013 20:13
> > To: linux-ext4@vger.kernel.org; linux-fsdevel@vger.kernel.org; Andr=
eas Dilger (adilger@dilger.ca); 'Bernd Schubert'
> > Subject: Query FSCK Errors on ext4
> > =20
> > Hi all,
> > =20
> > I have theorised that the problem comes from the MS access DB being=
 open (over Samba) on client workstations when the server is reloaded.
> > =20
> > Since ensuring these are closed prior to reloading, I have not seen=
 further FSCK errors on reload. Is there an explanation for this? I can=
 see why this may corrupt DB but not the filesystem.
> > =20
> > Just as a primer, I used a ReadyNAS NV+ for many years which was ru=
nning ext3 and never had this issue. However, since using ext4 on a Rea=
dyNAS Pro, I now see this issue.
> > =20
> > Many Thanks
> > Stephen Elliott
> > =20
> > From: Stephen Elliott [mailto:techweb@ntlworld.com]=20
> > Sent: 23 July 2013 22:02
> > To: linux-ext4@vger.kernel.org; linux-fsdevel@vger.kernel.org; Andr=
eas Dilger (adilger@dilger.ca); 'Bernd Schubert'
> > Subject: RE: FSCK Errors on ext4
> > =20
> > If it helps guys, the same file as before is causing the issue with=
 inode 4195610, a very large MS access DB.
> > =20
> > From: Stephen Elliott [mailto:techweb@ntlworld.com]=20
> > Sent: 23 July 2013 21:52
> > To: linux-ext4@vger.kernel.org; linux-fsdevel@vger.kernel.org; Andr=
eas Dilger (adilger@dilger.ca); 'Bernd Schubert'
> > Subject: FSCK Errors on ext4
> > =20
> > Hi Andreas / Bernd / all,
> > =20
> > You may recall advising me on another batch of FSCK errors a few mo=
nths back.
> > =20
> > The same device on an ext4 file system has produced the following e=
rrors after a clean reload. It seems to be fine now but wanted your inp=
ut on this. No bad blocks are reported on the devices etc.
> > =20
> > ***** File system check forced at Tue Jul 23 21:02:13 WEST 2013 ***=
** fsck 1.42.8 (20-Jun-2013) e2fsck 1.42.8 (20-Jun-2013) Pass 1: Checki=
ng inodes, blocks, and sizes Inode 4195619, end of extent exceeds allow=
ed value
> >                 (logical block 64907, physical block 11435403, len =
16) Clear? yes
> > =20
> > Inode 4195619, i_blocks is 1337216, should be 1337176.  Fix? yes
> > =20
> > Pass 2: Checking directory structure
> > Pass 3: Checking directory connectivity
> > Pass 4: Checking reference counts
> > Pass 5: Checking group summary information Block bitmap differences=
:  -(11435403--11435407) Fix? yes
> > =20
> > Free blocks count wrong for group #348 (2130, counted=3D2135).
> > Fix? yes
> > =20
> > Free blocks count wrong (417470107, counted=3D417470112).
> > Fix? yes
> > =20
> > =20
> > /dev/c/c: ***** FILE SYSTEM WAS MODIFIED *****
> > /dev/c/c: 625785/30212096 files (13.6% non-contiguous), 65923424/48=
3393536 blocks
> > =20
> > Many Thanks
> > Stephen Elliott
>=20
>=20
> Cheers, Andreas
>=20
>=20
>=20
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
