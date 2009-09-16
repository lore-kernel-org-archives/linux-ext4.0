From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH][RFC] resize2fs and uninit_bg questions
Date: Wed, 16 Sep 2009 13:08:31 -0600
Message-ID: <20090916190831.GH2537@webber.adilger.int>
References: <20090916162457.GA84213@freezingfog.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Will Drewry <redpig@dataspill.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:64491 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbZIPTIg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Sep 2009 15:08:36 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n8GJ8bQ2018676
	for <linux-ext4@vger.kernel.org>; Wed, 16 Sep 2009 12:08:39 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KQ200800VI3S100@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Wed,
 16 Sep 2009 12:08:37 -0700 (PDT)
In-reply-to: <20090916162457.GA84213@freezingfog.local>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sep 16, 2009  11:24 -0500, Will Drewry wrote:
> I have a two questions with an accompanying patch for clarification.
>=20
> resize2fs is uninit_bg aware, but when it is expanding an ext4
> filesystem, it will always zero the inode tables.  Is it safe to mimi=
ck
> mke2fs's write_inode_table(.., lazy_flag=3D1) and leave the new block
> groups' inode tables marked INODE_UNINIT, BLOCK_UNINIT and _not_ zero
> out the inode table if uninit_bg is supported?
>=20
> If it is okay, then it means offline resizing upwards can be just as
> fast as mke2fs.  I've attached a patch which is probably incomplete.
> I'd love feedback as to the feasibility of the change and/or patch
> quality.
>=20
> As a follow-on, would it be sane to add support like this for
> online resizing.  From a cursory investigation, it looks like
> setup_new_block_groups() could be modified to not zero itables
> if uninit_bg is supported, and INODE_ZEROED could be replaced
> with =CE=92G_*_UNINIT.  However, I'm not sure if that is a naive
> view.  I'm happy to send along a patch illustrating this change
> if that'd be helpful or welcome.

The question is why you would want to risk disk corruption vs.
the (likely not performance critical) online resize?

> Any and all feedback is appreciated -- even if it just for me
> to look at the archives/link/etc.
>=20
> diff --git a/resize/resize2fs.c b/resize/resize2fs.c
> index 1a5d910..9fcc3b9 100644
> --- a/resize/resize2fs.c
> +++ b/resize/resize2fs.c
> @@ -497,8 +497,7 @@ retry:
> =20
>  		fs->group_desc[i].bg_flags =3D 0;
>  		if (csum_flag)
> -			fs->group_desc[i].bg_flags |=3D EXT2_BG_INODE_UNINIT |
> -				EXT2_BG_INODE_ZEROED;
> +			fs->group_desc[i].bg_flags |=3D EXT2_BG_INODE_UNINIT;

This shouldn't be unconditional, since most users will want the
safety of having zeroed inode tables.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
