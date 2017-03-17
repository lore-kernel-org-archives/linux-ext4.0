From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext4: Add statx support
Date: Fri, 17 Mar 2017 14:19:22 -0600
Message-ID: <1A035757-CBE2-40F1-9CD3-9554F56F63CB@dilger.ca>
References: <148966413352.3279.15659219505999889147.stgit@warthog.procyon.org.uk>
 <20170317054755.GA595@zzz>
Mime-Version: 1.0 (Mac OS X Mail 10.2 \(3259\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_E47DE187-2587-41E1-A853-E0CC4BB1AEEE";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: David Howells <dhowells@redhat.com>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
To: Eric Biggers <ebiggers3@gmail.com>, Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170317054755.GA595@zzz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--Apple-Mail=_E47DE187-2587-41E1-A853-E0CC4BB1AEEE
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Mar 16, 2017, at 11:47 PM, Eric Biggers <ebiggers3@gmail.com> wrote:
> On Thu, Mar 16, 2017 at 11:35:33AM +0000, David Howells wrote:
>> +
>> +	ext4_get_inode_flags(ei);
>> +	flags =3D ei->i_flags & EXT4_FL_USER_VISIBLE;
>> +	if (flags & EXT4_APPEND_FL)
>> +		stat->attributes |=3D STATX_ATTR_APPEND;
>> +	if (flags & EXT4_COMPR_FL)
>> +		stat->attributes |=3D STATX_ATTR_COMPRESSED;
>> +	if (flags & EXT4_ENCRYPT_FL)
>> +		stat->attributes |=3D STATX_ATTR_ENCRYPTED;
>> +	if (flags & EXT4_IMMUTABLE_FL)
>> +		stat->attributes |=3D STATX_ATTR_IMMUTABLE;
>> +	if (flags & EXT4_NODUMP_FL)
>> +		stat->attributes |=3D STATX_ATTR_NODUMP;
>>=20
>> -	inode =3D d_inode(path->dentry);
>> 	generic_fillattr(inode, stat);
>> +	return 0;
>> +}
>=20
> I think it's the wrong approach to be calling ext4_get_inode_flags() =
here to
> sync the generic inode flags (inode->i_flags) to the ext4-specific =
inode flags
> (ei->i_flags).  I know the GETFLAGS and FSGETXATTR ioctls do it too, =
but I
> think it's a mistake --- at least, when done so without holding the =
inode lock.
> The issue is that flag syncs can occur in both directions concurrently =
and
> cause an update to be lost.  For example, with thread 1 doing a stat() =
and
> thread 2 doing the SETFLAGS ioctl to set the APPEND flag:
>=20
> Thread 1, ext4_get_inode_flags()	Thread 2, ext4_ioctl_setflags()
> -----------------------------------	---------------------------
> Read inode->i_flags; S_APPEND clear
> 					Set EXT4_APPEND_FL in =
ei->i_flags
> Clear EXT4_APPEND_FL in ei->i_flags
> 					Read ei->i_flags; EXT4_APPEND_FL =
clear
> 					Clear S_APPEND in inode->i_flags
>=20
> So the flag set by SETFLAGS gets lost.  This bug probably hasn't =
really been
> noticable with GETFLAGS and FSGETXATTR since they're rarely used, but =
stat() on
> the other hand is very common, and I'm worried that with this change =
people
> would start seeing this race more often.
>=20
> Ultimately this needs to be addressed in ext4 more fully, but how =
about for
> ->getattr() just skipping the call to ext4_get_inode_flags() and =
instead
> populating the generic attributes like STATX_ATTR_APPEND and
> STATX_ATTR_IMMUTABLE from the generic inode flags, rather than from =
the
> ext4-specific flags?  Actually, it could even be done in =
generic_fillattr(), so
> that all filesystems benefit.

Wouldn't it make more sense to just extract the ext4 flags directly from
ei->i_flags?  I think ext4_get_inode_flags() is only really useful when
the VFS inode flags are changed and they need to be propagated to the =
ext4
inode.

I guess the other more significant question is when/where are the VFS =
inode
flags changed that they need to be propagated into the ext4 disk inode?
The main avenue for changing these attribute flags that I know about is =
via
EXT4_IOC_SETFLAGS (FS_IOC_SETFLAGS), and there is one place that I could
find in fs/nsfs.c that sets S_IMMUTABLE but I don't think that =
propagates
down to an ext4 disk inode.

It seems like the use of ext4_get_inode_flags() is largely superfluous.
The original commit ff9ddf7e847 indicates this was for quota inodes =
only.
I think it can be removed from EXT4_IOC_FSGETXATTR, and =
EXT4_IOC_GETFLAGS
and made conditional in ext4_do_update_inode():

#ifdef CONFIG_QUOTA
        for (i =3D 0; i < EXT4_MAXQUOTAS; i++) {
                if (unlikely(sb_dqopt(sb)->files[i] =3D=3D inode))
                        ext4_get_inode_flags(EXT4_I(inode));
        }
#endif

Jan, what do you think?

Cheers, Andreas

>=20
>> diff --git a/fs/ext4/symlink.c b/fs/ext4/symlink.c
>> index 73b184d161fc..4c6b23a0603e 100644
>> --- a/fs/ext4/symlink.c
>> +++ b/fs/ext4/symlink.c
>> @@ -91,11 +91,13 @@ const struct inode_operations =
ext4_encrypted_symlink_inode_operations =3D {
>> const struct inode_operations ext4_symlink_inode_operations =3D {
>> 	.get_link	=3D page_get_link,
>> 	.setattr	=3D ext4_setattr,
>> +	.getattr	=3D ext4_getattr,
>> 	.listxattr	=3D ext4_listxattr,
>> };
>>=20
>> const struct inode_operations ext4_fast_symlink_inode_operations =3D =
{
>> 	.get_link	=3D simple_get_link,
>> 	.setattr	=3D ext4_setattr,
>> +	.getattr	=3D ext4_getattr,
>> 	.listxattr	=3D ext4_listxattr,
>> };
>>=20
>=20
> getattr needs to be added to ext4_encrypted_symlink_inode_operations =
too.
>=20
> - Eric


Cheers, Andreas






--Apple-Mail=_E47DE187-2587-41E1-A853-E0CC4BB1AEEE
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFYzETMpIg59Q01vtYRAiz2AJsFzK0pPFpymM2v2RNf1b41w6YAlQCg5ue2
dGloPv9uUmPpgZJlKkCZols=
=WRH3
-----END PGP SIGNATURE-----

--Apple-Mail=_E47DE187-2587-41E1-A853-E0CC4BB1AEEE--
