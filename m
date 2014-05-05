From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 2/3] mke2fs: print extra information about existing ext2/3/4 file systems
Date: Mon, 5 May 2014 10:30:29 -0600
Message-ID: <DA1F1E74-0E30-4CB8-826B-768A86AF2D48@dilger.ca>
References: <1399295044-24489-1-git-send-email-tytso@mit.edu> <1399295044-24489-2-git-send-email-tytso@mit.edu> <alpine.LFD.2.00.1405051541080.2223@localhost.localdomain> <20140505140401.GD22287@thunk.org> <20140505142808.GF22287@thunk.org> <alpine.LFD.2.00.1405051629270.2223@localhost.localdomain> <20140505144423.GG22287@thunk.org>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?utf-8?Q?Luk=C3=A1=C5=A1_Czerner?= <lczerner@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"kzak@redhat.com" <kzak@redhat.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20140505144423.GG22287@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The last time I asked to have the VFS add mountpoint info to the superb=
lock, it got a strong NACK from Al Viro because of the possibility of m=
ultiple mountpoints due to bind mounts or namespaces.

I think the current hack is as good as it gets.=20

Cheers, Andreas

> On May 5, 2014, at 8:44, Theodore Ts'o <tytso@mit.edu> wrote:
>=20
> On Mon, May 05, 2014 at 04:38:37PM +0200, Luk=C3=A1=C5=A1 Czerner wro=
te:
>>> % ./misc/mke2fs -t ext4 /dev/sdc3
>>> mke2fs 1.42.9 (4-Feb-2014)
>>> /dev/sdc3 contains a ext4 file system
>>>    last mounted on /SOX-backups on Mon May  5 08:59:53 2014
>>> Proceed anyway? (y,n)=20
>>>=20
>>> ... where this becomes a last-ditch saving through against the
>>> accidental wiping of the enterprise's Sarbanes-Oxley records.  :-)
>>>=20
>>=20
>> Yep, it's really useful. I just was not sure what is this all about =
since
>> there was not description and I was missing context from the other p=
atches.
>>=20
>> But this makes me think that it would be very useful if blkid could
>> gather this information for other file system if possible :). This
>> might be very useful if we can get some overlap with other file
>> system with the information provided in superblock.
>=20
> Unfortunately, as far as I know, none of the other file systems
> currently save the location where the file system was last mounted.
> And to be honest, the way we do it in ext4 is a horrible hack (get ou=
t
> your barf bags!):
>=20
> static int ext4_file_open(struct inode * inode, struct file * filp)
> {
>    struct super_block *sb =3D inode->i_sb;
>    struct ext4_sb_info *sbi =3D EXT4_SB(inode->i_sb);
>    struct vfsmount *mnt =3D filp->f_path.mnt;
>    struct path path;
>    char buf[64], *cp;
>=20
>    if (unlikely(!(sbi->s_mount_flags & EXT4_MF_MNTDIR_SAMPLED) &&
>             !(sb->s_flags & MS_RDONLY))) {
>        sbi->s_mount_flags |=3D EXT4_MF_MNTDIR_SAMPLED;
>        /*
>         * Sample where the filesystem has been mounted and
>         * store it in the superblock for sysadmin convenience
>         * when trying to sort through large numbers of block
>         * devices or filesystem images.
>         */
>        memset(buf, 0, sizeof(buf));
>        path.mnt =3D mnt;
>        path.dentry =3D mnt->mnt_root;
>        cp =3D d_path(&path, buf, sizeof(buf));
>        ...
>=20
> What we would need to do is file a feature request in the other file
> systems to save this information, and then add proper support for to
> pass this information from the VFS layer into the struct
> super_operations's mount function, which would be the proper, sane wa=
y
> to provide this functionality.
>=20
>                        - Ted
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
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
