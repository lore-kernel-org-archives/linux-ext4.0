From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH] ext4: fix race aio-dio vs freeze_fs
Date: Mon, 23 Nov 2015 19:37:56 +0300
Message-ID: <87a8q4k6xn.fsf@openvz.org>
References: <1448294568-20892-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"
Cc: jack@suse.cz, tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:35940 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbbKWQiF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 23 Nov 2015 11:38:05 -0500
Received: by lbblt2 with SMTP id lt2so99500635lbb.3
        for <linux-ext4@vger.kernel.org>; Mon, 23 Nov 2015 08:38:03 -0800 (PST)
In-Reply-To: <1448294568-20892-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Dmitry Monakhov <dmonakhov@openvz.org> writes:

> After freeze_fs was revoked (from Jan Kara) pages's write-back completion
> is deffered before unwritten conversion, so explicit flush_unwritten_io()
> was removed here: c724585b62411
> But we still may face deferred conversion for aio-dio case
> # Trivial testcase
> for ((i=3D0;i<60;i++));do fsfreeze -f /mnt ;sleep 1;fsfreeze -u /mnt;done=
 &
> fio --bs=3D4k --ioengine=3Dlibaio --iodepth=3D128 --size=3D1g --direct=3D=
1 \
>     --runtime=3D60 --filename=3D/mnt/file --name=3Drand-write --rw=3Drand=
write
> NOTE: Sane testcase should be integrated to xfstests, but it requires
> changes in common/* code, so let's use this this test at the moment.
>
> In order to fix this race we have to guard journal transaction with expli=
cit
> sb_{start,end}_intwrite()  as we do with ext4_evict_inode here:8e8ad8a5
Fairly to say I'm not very happy with the fix because it continues bad
practice of ad-hock fixes for generic journal vs freeze synchronization

Ideal fix would be to move sb_start_intwrite/sb_end_intwrite() to
ext4_journal_start()/ext4_journal_stop() but this is not possible due to
limitations introduced by nojournal mode (described here:8e8ad8a5)
So let's fix nojournal instead. In order to do that we somehow have
store ref_count and pointer to sb inside nojournal_handle.
There are two possible ways to do that.
1) Embed second journal related field to task_struct and guard it with
   compile macros definition.
void *journal_info;
+ #ifdef CONFIG_EXTRA_JOURNAL_INFO
+   void *journal_info2;
+ #endif

2) Encode ref and sb in to single long. This can be done by aligning
   ext4_sb_info pointer to 4096. So we can embed ref count to lower bits
   like follows.
#define EXT4_NOJOURNAL_SHIFT 12
#define EXT4_NOJOURNAL_MAX_REF_COUNT 1 << (EXT4_NOJOURNAL_SHIFT-1)
#define EXT4_NOJOURNAL_MASK  (1 << EXT4_NOJOURNAL_SHIFT) -1
#define NOJOURNAL_SB(handle) (handle & ~EXT4_NOJOURNAL_MASK)
#define NOJOURNAL_REF(handle) ((handle & ~EXT4_NOJOURNAL_MASK) >> 1)
static int ext4_handle_valid(handle_t *handle)
{
        return !(handle & 0x1);
}
static handle_t *get_nojournal_handle(struct super_block *sb)
{
        handle_t *handle =3D current->journal_info;
        struct super_block *old_sb  =3D NOJOURNAL_SB(handle);
        unsigned long ref_cnt =3D NOJOURNAL_REF(handle);
        BUG_ON(old_sb && old_sb !=3D sb);
        ref++;
        current->journal_info =3D NOJOURNAL_SB(handle);
}

What do you think about this? Are where any better way to fix this?

>
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  fs/ext4/extents.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
>
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 3a6197a..4cba944 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -5040,6 +5040,12 @@ int ext4_convert_unwritten_extents(handle_t *handl=
e, struct inode *inode,
>  	max_blocks =3D ((EXT4_BLOCK_ALIGN(len + offset, blkbits) >> blkbits) -
>  		      map.m_lblk);
>  	/*
> +	 * Protect us against freezing - AIO-DIO case. Caller didn't have to
> +	 * have any protection against it
> +	 */
> +	sb_start_intwrite(inode->i_sb);
> +
> +	/*
>  	 * This is somewhat ugly but the idea is clear: When transaction is
>  	 * reserved, everything goes into it. Otherwise we rather start several
>  	 * smaller transactions for conversion of each extent separately.
> @@ -5083,6 +5089,7 @@ int ext4_convert_unwritten_extents(handle_t *handle=
, struct inode *inode,
>  	}
>  	if (!credits)
>  		ret2 =3D ext4_journal_stop(handle);
> +	sb_end_intwrite(inode->i_sb);
>  	return ret > 0 ? ret2 : ret;
>  }
>=20=20
> --=20
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBCgAGBQJWU0DkAAoJELhyPTmIL6kBXwgIAJYS/CBmW+5m8sB8i4dZaE6l
pxOEOQxOiduskQuk8tjdQH0XSdGi5nWytNFZn0jNF6I9f9p3d9N27hMuwTaKELFh
V42DDcQsmtYsJLPF/9TeaJU3ccN/aJs39XBh67pC7M2FOhVaMo8vrIVSk6mTHAH0
VrZFlKjSpSsNyY/FUDAGiW2n3ro9sTxQKi/00PoaXbWx0jeUlDTPQP+RvgMfu7/0
fQAe5LJDEP1OQda7xT7b26/NkSXgWd4E0CyHuYbr5pmLbt/BjGQdS6Zgdb7kWCwq
p5FwdMNHRiNQBTEkOeO+p9BXQfbRrNg0WCsgiIFIZshV6EjmAUV06OkpklbQWeA=
=qoQO
-----END PGP SIGNATURE-----
--=-=-=--
