From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH] ext4: restart ext4_ext_remove_space() after transaction
	restart V2
Date: Wed, 26 May 2010 21:22:39 +0400
Message-ID: <AANLkTimbee1-W6gqEO9HbEg4oBAMea66bmDOaOElRaXG@mail.gmail.com>
References: <1271910671-16627-1-git-send-email-dmonakhov@openvz.org>
	<20100525133241.GF5556@thunk.org>
	<87632ckqcy.fsf@openvz.org>
	<20100525214447.GA14530@thunk.org>
	<87hblvqb6c.fsf@openvz.org>
	<87pr0ilw3n.fsf_-_@openvz.org>
	<20100526132352.GA29528@thunk.org>
	<87k4qqlp1g.fsf@openvz.org>
	<20100526144545.GD29528@thunk.org>
	<20100526144751.GE29528@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, jack@suse.cz,
	aneesh.kumar@linux.vnet.ibm.com
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f216.google.com ([209.85.219.216]:38059 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753618Ab0EZRWm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 26 May 2010 13:22:42 -0400
Received: by ewy8 with SMTP id 8so188004ewy.28
        for <linux-ext4@vger.kernel.org>; Wed, 26 May 2010 10:22:39 -0700 (PDT)
In-Reply-To: <20100526144751.GE29528@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 26, 2010 at 6:47 PM,  <tytso@mit.edu> wrote:
> On Wed, May 26, 2010 at 10:45:45AM -0400, tytso@MIT.EDU wrote:
>> OK, but why not have the truncate *always* restart its job after
>> restarting the transaction? =C2=A0#1, it's relatively rare in most
>> workloads that we need to restart the transaction at all in the firs=
t
>> place, and #2, it's easier to test if we always restart the truncate=
,
>> and #3, it's not like we'll be doing that much extra work if we
>> restart the truncate and the file wasn't extended significantly...
>>
>
> Like this.... (note how much simpler this patch is compared to earlie=
r
> versions)
I've added statistic counters to truncate code and found that each
4'th rm_leaf() result in
actual transaction restart, and number of truncate/get_block races is
less than 0.001 from total
restart number and may be neglected.  So simplified version perform
false restart for each 4'th truncate.
But fairly to say what this is still invisible in terms of total trunca=
te time.
Do we care about performance in truncate? IMHO it is not the hottest
path so it is possible to end up with
simplified version.

>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0- Ted
>
> ext4: restart ext4_ext_remove_space() after transaction restart
>
> From: Dmitry Monakhov <dmonakhov@openvz.org>
>
> If i_data_sem was internally dropped due to transaction restart, it i=
s
> necessary to restart path look-up because extents tree was possibly
> modified by ext4_get_block().
>
> https://bugzilla.kernel.org/show_bug.cgi?id=3D15827
>
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> Acked-by: Jan Kara <jack@suse.cz>
> ---
> =C2=A0fs/ext4/extents.c | =C2=A0 16 +++++++++-------
> =C2=A01 files changed, 9 insertions(+), 7 deletions(-)
>
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index ffcaa11..0a47bec 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -107,11 +107,8 @@ static int ext4_ext_truncate_extend_restart(hand=
le_t *handle,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (err <=3D 0)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return err;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0err =3D ext4_truncate_restart_trans(handle=
, inode, needed);
> - =C2=A0 =C2=A0 =C2=A0 /*
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0* We have dropped i_data_sem so someone =
might have cached again
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0* an extent we are going to truncate.
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> - =C2=A0 =C2=A0 =C2=A0 ext4_ext_invalidate_cache(inode);
> + =C2=A0 =C2=A0 =C2=A0 if (err =3D=3D 0)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 err =3D -EAGAIN;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0return err;
> =C2=A0}
> @@ -2359,7 +2356,7 @@ static int ext4_ext_remove_space(struct inode *=
inode, ext4_lblk_t start)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0int depth =3D ext_depth(inode);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct ext4_ext_path *path;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0handle_t *handle;
> - =C2=A0 =C2=A0 =C2=A0 int i =3D 0, err =3D 0;
> + =C2=A0 =C2=A0 =C2=A0 int i, err;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0ext_debug("truncate since %u\n", start);
>
> @@ -2368,23 +2365,26 @@ static int ext4_ext_remove_space(struct inode=
 *inode, ext4_lblk_t start)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (IS_ERR(handle))
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return PTR_ERR=
(handle);
>
> +again:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0ext4_ext_invalidate_cache(inode);
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0/*
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 * We start scanning from right side, free=
ing all the blocks
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 * after i_size and walking into the tree =
depth-wise.
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 */
> + =C2=A0 =C2=A0 =C2=A0 depth =3D ext_depth(inode);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0path =3D kzalloc(sizeof(struct ext4_ext_pa=
th) * (depth + 1), GFP_NOFS);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (path =3D=3D NULL) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ext4_journal_s=
top(handle);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -ENOMEM=
;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> + =C2=A0 =C2=A0 =C2=A0 path[0].p_depth =3D depth;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0path[0].p_hdr =3D ext_inode_hdr(inode);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ext4_ext_check(inode, path[0].p_hdr, d=
epth)) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0err =3D -EIO;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> - =C2=A0 =C2=A0 =C2=A0 path[0].p_depth =3D depth;
> + =C2=A0 =C2=A0 =C2=A0 i =3D err =3D 0;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0while (i >=3D 0 && err =3D=3D 0) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (i =3D=3D d=
epth) {
> @@ -2478,6 +2478,8 @@ static int ext4_ext_remove_space(struct inode *=
inode, ext4_lblk_t start)
> =C2=A0out:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0ext4_ext_drop_refs(path);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0kfree(path);
> + =C2=A0 =C2=A0 =C2=A0 if (err =3D=3D -EAGAIN)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto again;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0ext4_journal_stop(handle);
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0return err;
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
