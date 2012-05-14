From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH RESEND] implement uid and gid mount options for ext2,
 ext3 and ext4
Date: Tue, 15 May 2012 09:15:42 +1000
Message-ID: <20120515091542.51f3dd78@notabene.brown>
References: <1336660924-9598-1-git-send-email-ludwig.nussel@suse.de>
 <20120511034945.GA15892@mobil.systemanalysen.net>
 <4FAD30D7.3070208@panasas.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/JN2F3xW84eIpxNCXYnxuere"; protocol="application/pgp-signature"
Cc: Ludwig Nussel <ludwig.nussel@suse.de>,
	<linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
	Jan Kara <jack@suse.cz>, Rob Landley <rob@landley.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	"Theodore Ts'o" <tytso@mit.edu>,
	EXT2 FILE SYSTEM <linux-ext4@vger.kernel.org>,
	DOCUMENTATION <linux-doc@vger.kernel.org>
To: Boaz Harrosh <bharrosh@panasas.com>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <4FAD30D7.3070208@panasas.com>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

--Sig_/JN2F3xW84eIpxNCXYnxuere
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 11 May 2012 18:31:35 +0300 Boaz Harrosh <bharrosh@panasas.com> wrot=
e:

> On 05/11/2012 06:49 AM, Roland Eggner wrote:
>=20
> > On 2012-05-10 Thu 16:42 +0200, Ludwig Nussel wrote:
> >> =E2=80=A6
> >> When using 'real' file systems on removable storage devices such as
> >> hard disks or usb sticks people quickly face the problem that their
> >> Linux users have different uids on different machines. Therefore one
> >> cannot modify or even read files created on a different machine
> >> without running chown as root or storing everything with mode 777.
> >> Simple file systems such as vfat don't have that problem as they
> >> don't store file ownership information and one can pass the uid
> >> files should belong to as mount option.
> >>
> >> The following two patches (for 3.4.0-rc4) implement the uid (and
> >> gid) mount option for ext2, ext3 and ext4 to make them actually
> >> useful on removable media. If a file system is mounted with the uid
> >> option all files appear to be owned by the specified uid. Only newly
> >> created files actually end up with that uid as owner on disk though.
> >> Ownership of existing files cannot be changed permanently if the uid
> >> option was specified.
> >>
> >> Acked-by: Rob Landley <rob@landley.net>
> >> Signed-off-by: Ludwig Nussel <ludwig.nussel@suse.de>
> >> ---
> >>  Documentation/filesystems/ext2.txt |    9 ++++++
> >>  Documentation/filesystems/ext3.txt |    9 ++++++
> >>  Documentation/filesystems/ext4.txt |    9 ++++++
> >>  fs/ext2/ext2.h                     |    8 +++++
> >>  fs/ext2/inode.c                    |   42 ++++++++++++++++++++------
> >>  fs/ext2/super.c                    |   57 +++++++++++++++++++++++++++=
++++++++-
> >>  fs/ext3/ext3.h                     |    8 +++++
> >>  fs/ext3/inode.c                    |   50 ++++++++++++++++++++++-----=
----
> >>  fs/ext3/super.c                    |   57 +++++++++++++++++++++++++++=
++++++++-
> >>  fs/ext4/ext4.h                     |    4 ++
> >>  fs/ext4/inode.c                    |   50 ++++++++++++++++++++++-----=
----
> >>  fs/ext4/super.c                    |   49 +++++++++++++++++++++++++++=
+++-
> >>  12 files changed, 311 insertions(+), 41 deletions(-)
> >>
> >> =E2=80=A6
> >=20
> >=20
> > In short:
> > .........
> > Problem solving at its root is more efficient than at =E2=80=9Cend of p=
ipe=E2=80=9D.
> >=20
> >=20
> >=20
> > IMHO this is an example of =E2=80=9Cend of pipe=E2=80=9C thinking with =
following downsides:
> > .......................................................................=
....
> > *  Maintainers point of view:
> >    *  Introduces new problems:  Breaking holes in the access restrictio=
ns
> >       provided by the Linux kernel at will of unprivileged users would =
render
> >       the kernel unusable for reliable operation in multiuser environme=
nts.
> >    *  Adds code complexity and risk of bugs.
> >    *  Adds future maintainance load.
> > *  Users point of view:
> >    *  Editing /etc/fstab or using mount commands with options not in
> >       /etc/fstab require root privileges anyway, at least on sane syste=
ms.
> >    *  Adds usage complexity (new vs. old files, on disk vs. pretended U=
IDs =E2=80=A6).
> >    *  Adds risk of usage errors.
> >=20
> >=20
> >=20
> > IMHO the =E2=80=9Cright thing to do=E2=80=9D is to solve the problem at=
 its root:
> > .................................................................
> > My habit is, whenever I use {group,user}add commands:
> > *  In advance I create a list of all current and future users (user, GI=
D, UID)
> >    common to all systems that might exchange files.  The list is design=
ed to
> >    have =E2=80=9Cheadroom=E2=80=9D for future additions.
> > *  I always consult this list and use options --gid $userGID --uid $use=
rUID to
> >    {group,user}add commands.
> > *  Exchanging files with an unforeseen system is an exception, which re=
quires
> >    root privileges anyway,
> >=20
> > Advantages:
> > *  Decent migration of files to other systems via backups, external sto=
rage =E2=80=A6
> > *  No NEW wholes in the access restrictions provided by the Linux kerne=
l.
> > *  No NEW kernel code possibly introducing bugs.
> > *  No need to learn new mount options.
> > *  No NEW risks of usage errors.
> >=20
> >=20
> > Summary:
> > ........
> > *  If UIDs differ on machines FORESEEN for file exchange, this is an
> >    administrator error, not a kernel deficit.
> > *  File exchange with an UNFORESEEN system requires root privileges any=
way.
> >=20
> >=20
>=20
>=20
> I agree with Ludwig completely!!! Thanks, good policy rules.

I think you mean "Roland" - you seem to disagree with Ludwig.

For the record I don't agree with Roland.. though I'm not 100% sure what he
is saying.  I cannot quite figure out what the "pipe" is that he is talking
about.

The thrust of the argument seems to be that by establishing good habits from
the very beginning you can avoid the need for change.  That may well be tru=
e,
but it isn't particularly "user friendly".  We should make things simple and
safe so that people don't *need* to carefully form good habits.


>=20
> 1. ext* are nothing special and are not a special domain of removable med=
ia.
>    (If any vfat is dominant at that end)

VFAT is indeed dominant.  But cannot handle files >4GB and cannot handle a
variety of special characters in file names.  But that isn't really relevan=
t.
Given that we have ext[234] rather than everyone using VFAT or NTFS
everywhere, we should make them as broadly usable as possible.  That path in
general encourages innovation.


>=20
> 2. What the hell does removable-media means? and how is it different then
>    something else? is ext* over iscsi removable? a soft-mount NFS, is it
>    removable?

"removable-media" means "The owner is the person holding the physical devic=
e,
not the person who knows the password which is stored in some databases alo=
ng
side some id which is attached to files in the filesystem".

So if I hold a device which has an ethernet port on which it talks NFS or
ISCSI, then yes: it is removable.

And this is not at all far-fetched.  Mobile internet devices (aka phones) a=
re
quite capable for serving NFS.  The current common practice where you need =
to
tell your device how to appear on the USB (mass storage?  media device?
propriety thingy?) is not very friendly.  If we just do IP (IPv6 of course)
to the devices (whether over USB or BT or Wifi) and provided every service
over that concurrently, that would be much better.

And with NFS, I could write to my uSD card in my smart-phone over the USB
cable at the same time that the phone itself was using the storage of other
purposes.  You cannot do that with usb/mass-storage/VFAT.

My access to files on that filesystem should not be guided by the uid of my
processes, but rather by the crypto-key that I made available.
And I suspect you can do exactly that using kerberos - and that is awesome.
We should have that access to ext4 over usb/mass storage too.

To make that clear: if I "own" a filesystem - whether because I hold the
physical non-encrypted devices or because I know the encryption key - then I
want to be able to  leverage that "ownership" to full access rights to
the contents of the filesystem.  By typing in a key or plugging in a device=
 I
want to get full "root" access to the filesystem on the device.  Not giving
that to me is just getting in my way.

>=20
> Above sounds to me like a huge security breach, and actually a data-corru=
ption.

It can certainly be used to cause a security breach, just as "rm -r" can be
used to cause data corruption.  We shouldn't disallow it for that reason
though.


>=20
> In the NFS world I hang around, we constantly encounter multiple domain
> uid/gid views, and it does not mean we blow a hole in POSIX security rule=
s.

The Linux NFS server has "all_squash" and "anon_uid=3D" export options.

>=20
> The root that mounts this FS can just copy+chmod or just-chmod them.

Sorry, I don't understand.  It sounds like you are suggesting that when I
mount an ext3 filesystem on my usb-stick, I should chmod -R all 3,000,000
files to make them world writeable?  Or maybe chown them all to me?  Or copy
them to my home directory?
And somehow this is safer than making it appear as though this has already
happened through mount options?
I must have misunderstood something.

> Next we'll see auto-mounters use these flags and goodbye file-access-cont=
rol.

Yes, of course auto-mounters will do this.  It makes perfect sense for any
removable (physically carry in my hand) media.  You cannot prevent data
destruction on such devices if you lose physical control, and the only
workable data privacy option is encryption.  Trying to pretend that file
permission bits mean anything is extremely naive.

>=20
> There is some convenience you do not allow. a password-less root, and no =
access
> control at all is most convenient would you say?
>=20
> I bet this code opens up an attack vector like crazy. Windows viruses wel=
come.
>=20
> No thanks

I'm sure we could provide a CONFIG option for you.

NeilBrown


> Boaz
>=20
> >=20
>=20
> > Thanks,
> > Roland Eggner
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


--Sig_/JN2F3xW84eIpxNCXYnxuere
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT7GSHjnsnt1WYoG5AQLqzw//cLXhWccpcf0ymPH0+PkRBuUIWEnJmpLz
G6zo0cVtnbLjEvHepqXjZidqG0GLeKtjcgmo22VwP9ld8HWG39XcvRmhGY+/vIhm
+roUYy8EDtTE5qrksn5pSQQ7TOicaK8mhPCjGtfQ7Q+Oeoa7ceXa9hZjcwfnNrPp
nG51RfNmniKS8qiT5GGRkAEdfuRWnk6WERet/LACLwR7g6vyOcoxqB3/39ZyNI+9
54mBqDVHG+7yek/9BTZiViDW04VPMccSa/HdgAdxomJx9rRfH/tRvoWHRg0P+kS0
1WJMl3URC3MR01DuLvhomPGuayUIgW2FD+ZaQqYR+C2OdICfpzRzcO3+7BtrEOZi
JsFvvDDIN8fkbhfXUZFr+z/hoyfSgaaq78B6+19oh7V/Ruw+0tOltdy/XyOuOfLn
WbuBBN/jbcVkVU3sWAPo3SBEPQXafE/4I4o1bYQYqHywQ2Nt2lDDw1Rs/ac7Xi6V
xHSjwFtuqNl+fjhai08NPh+s/CK7AFfpWQ4feR8TndSzfN49vLXTiA0CIrDRGhZ3
Tl7ippWcRb86+9DrlcoKrhgEmlHkXg/CERU3QtW5Y04F6T034ijX9TH6xcXcshhu
Pi+7ZJuc5mInoBALvAc05sk2i67QguB9FE9WDQ7Lvv+Dbk5xbCctL86uf/6yVE1r
wxsCaST5BRY=
=40fS
-----END PGP SIGNATURE-----

--Sig_/JN2F3xW84eIpxNCXYnxuere--
