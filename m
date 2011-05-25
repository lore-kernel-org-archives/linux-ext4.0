From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH v2] ext4:Teach ext4_ext_split to caculate extents efficiently.
Date: Wed, 25 May 2011 10:02:37 +0800
Message-ID: <BANLkTimbiL07BQyF8rgoBVh4apY5ZJdiCA@mail.gmail.com>
References: <1306143057-16962-1-git-send-email-xiaoqiangnk@gmail.com>
	<20110524210721.GD26055@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:55214 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356Ab1EYCCh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 May 2011 22:02:37 -0400
Received: by vxi39 with SMTP id 39so5427062vxi.19
        for <linux-ext4@vger.kernel.org>; Tue, 24 May 2011 19:02:37 -0700 (PDT)
In-Reply-To: <20110524210721.GD26055@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 25, 2011 at 5:07 AM, Ted Ts'o <tytso@mit.edu> wrote:
> On Mon, May 23, 2011 at 05:30:57PM +0800, Yongqiang Yang wrote:
>> @@ -982,20 +997,13 @@ static int ext4_ext_split(handle_t *handle, st=
ruct inode *inode,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D -EIO;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto cleanup;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> - =A0 =A0 =A0 =A0 =A0 =A0 while (path[i].p_idx <=3D EXT_MAX_INDEX(pa=
th[i].p_hdr)) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext_debug("%d: move %d:%ll=
u in new index %llu\n", i,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 le32_to_cpu(path[i].p_idx->ei_block),
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 ext4_idx_pblock(path[i].p_idx),
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 newblock);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*memmove(++fidx, path[i].=
p_idx++,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 sizeof(struct ext4_extent_idx));
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 neh->eh_entries++;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 BUG_ON(neh->eh_entries > n=
eh->eh_max);*/
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 path[i].p_idx++;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 m++;
>> - =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 /* start copy indexes */
>> + =A0 =A0 =A0 =A0 =A0 =A0 m =3D EXT_MAX_INDEX(path[i].p_hdr) - path[=
i].p_idx++;
>> + =A0 =A0 =A0 =A0 =A0 =A0 ext_debug("cur 0x%p, last 0x%p\n", path[i]=
=2Ep_idx,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 EXT_MAX_IN=
DEX(path[i].p_hdr));
>> + =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_show_move(inode, path, newblock, =
i);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (m) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memmove(++fidx, path[i].p_=
idx - m,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memmove(++fidx, path[i].p_=
idx,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sizeof(s=
truct ext4_extent_idx) * m);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 le16_add_cpu(&neh->eh_en=
tries, m);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>
Hi Ted,

Thank you for your review.  I had looked at this case.

> So the old code mutates path[i].p_idx, where as your new code doesn't=
=2E
path[i]p_idx is mutated to EXT_MAX_INDEX(path[i].p_hdr) + 1, it is
meaningless.  ext4_ext_split() is used only by
ext4_ext_create_new_leaf() which drops the path after ext4_ext_split()
returns, so the path[i].p_idx is no longer used.

> The one thing that scares me is that ext4_ext_insert_index() is passe=
d
> &path[at], the function preferences path[at].p_idx.
ext4_ext_split() insert k indexes, where k =3D depth - at -1, starting
from depth - 1 to depth - 1 - k + 1 =3D depth - k =3D at + 1.

So old code does not mutate depth[at].p_idx.

I had tested the patch with fsx.  I am not sure if this test is
enough.  If you want more tests, I can do it.

Thanks,
Yongqiang.
>
> Have you looked at this case?
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0- Ted
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
