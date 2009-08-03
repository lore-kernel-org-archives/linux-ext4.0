From: Peng Tao <bergwolf@gmail.com>
Subject: Re: [PATCH 2/2] ext4: fix null pointer bug in move_extent.c
Date: Mon, 3 Aug 2009 21:20:06 +0800
Message-ID: <6149e97b0908030620w3a4b4d9em7d8b1aa4940e837d@mail.gmail.com>
References: <1249213404-6277-1-git-send-email-bergwolf@gmail.com>
	 <1249213404-6277-2-git-send-email-bergwolf@gmail.com>
	 <4A76A043.20105@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.251]:25554 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119AbZHCN1o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Aug 2009 09:27:44 -0400
Received: by an-out-0708.google.com with SMTP id d40so4421948and.1
        for <linux-ext4@vger.kernel.org>; Mon, 03 Aug 2009 06:27:42 -0700 (PDT)
In-Reply-To: <4A76A043.20105@rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi, Akira,

2009/8/3 Akira Fujita <a-fujita@rs.jp.nec.com>:
>
> Peng Tao wrote:
>> In mext_replace_branches(), the oext and dext virable might be NULL =
if the
>> orig extent and donor extent are empty. Later calling *oext and *dex=
t will
>> trigger a kernel null pointer bug like this:
>>
>> BUG: unable to handle kernel NULL pointer dereference at (null)
>> IP: [<ffffffffa0636563>] mext_replace_branches+0x10c/0x2f3 [ext4]
>> PGD 37dba067 PUD cd8ac067 PMD 0
>> Oops: 0000 [#1] SMP
>>
>> The patch checks the two virables and returns EOPNOTSUPP if either o=
f them
>> is NULL.
>>
>> Signed-off-by: Peng Tao <bergwolf@gmail.com>
>> ---
>> =C2=A0fs/ext4/move_extent.c | =C2=A0 12 ++++++++++++
>> =C2=A01 files changed, 12 insertions(+), 0 deletions(-)
>>
>> diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
>> index 5821e0b..4923f70 100644
>> --- a/fs/ext4/move_extent.c
>> +++ b/fs/ext4/move_extent.c
>> @@ -641,10 +641,22 @@ mext_replace_branches(handle_t *handle, struct=
 inode *orig_inode,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out;
>> =C2=A0 =C2=A0 =C2=A0 depth =3D ext_depth(orig_inode);
>> =C2=A0 =C2=A0 =C2=A0 oext =3D orig_path[depth].p_ext;
>> + =C2=A0 =C2=A0 if (oext =3D=3D NULL) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ext4_debug("ext4 move ex=
tent: "
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "orig exten=
ts should not be empty\n");
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 err =3D -EOPNOTSUPP;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out;
>> + =C2=A0 =C2=A0 }
>> =C2=A0 =C2=A0 =C2=A0 tmp_oext =3D *oext;
>>
>> =C2=A0 =C2=A0 =C2=A0 depth =3D ext_depth(donor_inode);
>> =C2=A0 =C2=A0 =C2=A0 dext =3D donor_path[depth].p_ext;
>> + =C2=A0 =C2=A0 if (dext =3D=3D NULL) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ext4_debug("ext4 move ex=
tent: "
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "donor exte=
nts should not be empty\n");
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 err =3D -EOPNOTSUPP;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out;
>> + =C2=A0 =C2=A0 }
>> =C2=A0 =C2=A0 =C2=A0 tmp_dext =3D *dext;
>>
>> =C2=A0 =C2=A0 =C2=A0 mext_calc_swap_extents(&tmp_dext, &tmp_oext, or=
ig_off,
>
> Yes, this problem occurs if extent which ext4_ext_path indicates is N=
ULL,
> but this check should be done in ext4_move_extents()
> which is called before mext_replace_branches().
> And in this case, ENOENT is better for error value, I think.
> How about this patch?
Will there be situations where empty extents exist in the middle of an
extent tree? Because your patch only checks NULL extents once at the
begining. If some NULL extents are later found in the loop, the bug
still can be triggered and we should check NULL extents in
mext_replace_branches().
>
> Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
>
> ---
> =C2=A0move_extent.c | =C2=A0 19 +++++++++++++++----
> =C2=A01 file changed, 15 insertions(+), 4 deletions(-)
> --- ../../LATEST/fs/ext4/move_extent.c =C2=A02009-08-03 14:53:43.0000=
00000 +0900
> +++ fs/ext4/move_extent.c =C2=A0 =C2=A0 =C2=A0 2009-08-03 15:03:33.00=
0000000 +0900
> @@ -1145,19 +1145,23 @@ ext4_move_extents(struct file *o_filp, s
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (file_end < block_end)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0len -=3D block=
_end - file_end;
>
> + =C2=A0 =C2=A0 =C2=A0 depth =3D ext_depth(orig_inode);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0get_ext_path(orig_path, orig_inode, block_=
start, ret);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (orig_path =3D=3D NULL)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out2;
> + =C2=A0 =C2=A0 =C2=A0 else if (orig_path[depth].p_ext =3D=3D NULL) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D -ENOENT;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out;
> + =C2=A0 =C2=A0 =C2=A0 }
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0/* Get path structure to check the hole */
> =C2=A0 =C2=A0 =C2=A0 =C2=A0get_ext_path(holecheck_path, orig_inode, b=
lock_start, ret);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (holecheck_path =3D=3D NULL)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out;
>
> - =C2=A0 =C2=A0 =C2=A0 depth =3D ext_depth(orig_inode);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0ext_cur =3D holecheck_path[depth].p_ext;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ext_cur =3D=3D NULL) {
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D -EINVAL;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D -ENOENT;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>
> @@ -1280,11 +1284,14 @@ ext4_move_extents(struct file *o_filp, s
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* Decrease bu=
ffer counter */
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (holecheck_=
path)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0ext4_ext_drop_refs(holecheck_path);
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 get_ext_path(holec=
heck_path, orig_inode,
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 seq_start, ret=
);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 get_ext_path(holec=
heck_path, orig_inode, seq_start, ret);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (holecheck_=
path =3D=3D NULL)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0break;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0depth =3D hole=
check_path->p_depth;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (holecheck_path=
[depth].p_ext =3D=3D NULL) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 ret =3D -ENOENT;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* Decrease bu=
ffer counter */
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (orig_path)
> @@ -1292,6 +1299,10 @@ ext4_move_extents(struct file *o_filp, s
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0get_ext_path(o=
rig_path, orig_inode, seq_start, ret);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (orig_path =
=3D=3D NULL)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0break;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else if (orig_path=
[depth].p_ext =3D=3D NULL) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 ret =3D -ENOENT;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ext_cur =3D ho=
lecheck_path[depth].p_ext;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0add_blocks =3D=
 ext4_ext_get_actual_len(ext_cur);
>



--=20
Cheers,
Peng Tao
State Key Laboratory of Networking and Switching Technology
Beijing Univ. of Posts and Telecoms.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
