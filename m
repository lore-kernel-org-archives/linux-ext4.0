From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] debugfs: Add inline data feature for symlink.
Date: Fri, 1 Aug 2014 09:48:10 -0700
Message-ID: <20140801164810.GT8628@birch.djwong.org>
References: <1406789932-13770-1-git-send-email-houpu.hp@alibaba-inc.com>
 <63e6941e-70ab-4fec-941c-f13f47585594@alibaba-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: =?utf-8?B?5L6v5pmuKOiwt+eGoCk=?= <houpu.hp@alibaba-inc.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25195 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbaHAQsS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Aug 2014 12:48:18 -0400
Content-Disposition: inline
In-Reply-To: <63e6941e-70ab-4fec-941c-f13f47585594@alibaba-inc.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 01, 2014 at 06:37:56PM +0800, =E4=BE=AF=E6=99=AE(=E8=B0=B7=E7=
=86=A0) wrote:
> On Thu, Jul 31, 2014 at 02:58:52PM +0800, Pu Hou wrote:
> >> Symlink in debugfs can take advantage of inline data feature. The =
path name of the target of the symbol link which is longer than 60 byte=
 and shorter than 132 byte can stay in inline data area.
> >
> >I think Ted prefers wrapping commit messages at 70 bytes.
> >
> Thanks for reminding me. I will fix it.
>=20
> >> +	data.ea_size =3D size - EXT4_MIN_INLINE_DATA_SIZE;
> >> +	data.ea_data =3D buf + EXT4_MIN_INLINE_DATA_SIZE;
> >> +	return ext2fs_inline_data_ea_set(&data);
> >
> >Doesn't ext2fs_inline_data_set() suffice?
> >
> It is unnecessary to use this dedicated function.

Why do you say it's unnecessary?  The dedicated function does (or at le=
ast is
supposed to) do exactly what you want.

Now I'm wondering -- why worry about size at all?  You can modify
ext2fs_symlink to call ext2fs_inline_data_set() directly.  If there's n=
ot
enough room, it'll return EXT2_ET_INLINE_DATA_NO_SPACE and you can try =
again
with the classic stuff-it-in-a-block method.

(Of course, if you try this and the API turns not to behave as advertis=
ed I'd
like to hear about that too. :))

--D

>=20
> >> +					sizeof(__u32)+
> >> +					EXT4_MIN_INLINE_DATA_SIZE;
> >> +			inline_link =3D (target_len < max_inline);
> >
> >Does ext2fs_xattr_inode_max_size() + EXT4_MIN_INLINE_DATA_SIZE retur=
n incorrect
> >results?  I don't think we should have all xattr specific stuff belo=
ngs here in
> >the symlink routines.
>=20
> Sorry. I did not notice that some xattr might be existed  when an ino=
de
> number is passed to ext2fs_symlink(). But, as far as I can see, when =
0
> is pass as inode number. ext2fs_xattr_inode_max_size() will read inod=
e
> by ext2fs_read_inode_full(). But at that time, we have not writen the
> inode back. and the size of inline data for symlink is uncertain.
> I will try to find a workaround.
>=20
> >> -		if (retval)
> >> -			goto cleanup;
> >> +		  retval =3D io_channel_write_blk64(fs->io, blk, 1, block_buf);
> >> +		  if (retval)
> >> +		    goto cleanup;
> >
> >Please fix the indentation inconsistency (tabs, not spaces).
>=20
> >> -	if (!fastlink)
> >> +	if ((!fastlink) && (!inline_link))
> >
> >Probably unnecessary to put !fastlink and !inline_link in parenthese=
s.
> >
> >--D
> Darrick, thank again for your generous help.
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
