From: Jiaying Zhang <jiayingz@google.com>
Subject: Re: [PATCHv2 2/3] ext4: use direct_IO_no_locking in ext4 DIO read
Date: Tue, 12 Jan 2010 11:49:40 -0800
Message-ID: <5df78e1d1001121149y94a3c82x5140b6deab0d7a0b@mail.gmail.com>
References: <20100112194210.C27AC6E85C@peat.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, mrubin@google.com, akpm@linux-foundation.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:2852 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510Ab0ALTtq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 Jan 2010 14:49:46 -0500
Received: from spaceape9.eur.corp.google.com (spaceape9.eur.corp.google.com [172.28.16.143])
	by smtp-out.google.com with ESMTP id o0CJnhdB021824
	for <linux-ext4@vger.kernel.org>; Tue, 12 Jan 2010 19:49:43 GMT
Received: from pxi30 (pxi30.prod.google.com [10.243.27.30])
	by spaceape9.eur.corp.google.com with ESMTP id o0CJnfVw030000
	for <linux-ext4@vger.kernel.org>; Tue, 12 Jan 2010 11:49:42 -0800
Received: by pxi30 with SMTP id 30so6493900pxi.14
        for <linux-ext4@vger.kernel.org>; Tue, 12 Jan 2010 11:49:40 -0800 (PST)
In-Reply-To: <20100112194210.C27AC6E85C@peat.mtv.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Oops, this should be [PATCHv2 3/3].

Jiaying

On Tue, Jan 12, 2010 at 11:42 AM, Jiaying Zhang <jiayingz@google.com> w=
rote:
>
> =A0 =A0ext4: Use direct_IO_no_locking in ext4 dio read.
>
> =A0 =A0Signed-off-by: Jiaying Zhang <jiayingz@google.com>
>
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 9ee3550..44d2e19 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3395,7 +3395,15 @@ static ssize_t ext4_ind_direct_IO(int rw, stru=
ct kiocb *iocb,
> =A0 =A0 =A0 =A0}
>
> =A0retry:
> - =A0 =A0 =A0 ret =3D blockdev_direct_IO(rw, iocb, inode, inode->i_sb=
->s_bdev, iov,
> + =A0 =A0 =A0 if (rw =3D=3D READ && test_opt(inode->i_sb, DIOREAD_NOL=
OCK)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 && (EXT4_I(inode)->i_fl=
ags & EXT4_EXTENTS_FL))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D blockdev_direct_IO_no_locking(r=
w, iocb, inode,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0inod=
e->i_sb->s_bdev, iov,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0offs=
et, nr_segs,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4=
_get_block, NULL);
> + =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D blockdev_direct_IO(rw, iocb, in=
ode,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0inod=
e->i_sb->s_bdev, iov,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 offse=
t, nr_segs,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_=
get_block, NULL);
> =A0 =A0 =A0 =A0if (ret =3D=3D -ENOSPC && ext4_should_retry_alloc(inod=
e->i_sb, &retries))
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
