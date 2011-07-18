From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: prevent parallel resizers and fix some error handling in resize
Date: Mon, 18 Jul 2011 09:16:19 +0300
Message-ID: <CAOQ4uxj7C7L_27nEcn5ge6aD=2RLgipGOa_GBhhEeafC1H0HHQ@mail.gmail.com>
References: <1310957555-15617-1-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, aedilger@gmail.com
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48771 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab1GRGQU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Jul 2011 02:16:20 -0400
Received: by wwe5 with SMTP id 5so2853748wwe.1
        for <linux-ext4@vger.kernel.org>; Sun, 17 Jul 2011 23:16:19 -0700 (PDT)
In-Reply-To: <1310957555-15617-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 18, 2011 at 5:52 AM, Yongqiang Yang <xiaoqiangnk@gmail.com>=
 wrote:
> Hi,
>
> =A0This patch series prevents parallel resizer and fixes some error h=
andling in
> resize code. =A0Besides these, some code is simplified so that the co=
de can be
> used easily in new resize implementation.

You should probably mention that "new resize implementation" means:
let the kernel do all the resize work, gaining fast multi group resize,
flex_bg layout, and uninit block groups.
The new kernel resize implementation also prepares the ground for
supporting resize with features like big_alloc, 64bit and exclude_bitma=
p.

You should probably also mention that you have already completed the
"new resize implementation" and that you will post it shortly ;-)

>
> =A0The patches are tested by resize2fs and e2fsck -fn.
>
> [PATCH 01/12] ext4: prevent parallel resizers by atomic bit ops
> [PATCH 02/12] ext4: prevent a fs with errors from being resized
> [PATCH 03/12] ext4: prevent a fs without journal from being resized
> [PATCH 04/12] ext4: rename ext4_add_groupblocks() to
> [PATCH 05/12] ext4: let ext4_group_add_blocks return an error code
> [PATCH 06/12] ext4: let ext4_group_add_blocks() handle 0 blocks
> [PATCH 07/12] ext4: fix a typo in ext4_group_extend()
> [PATCH 08/12] ext4: let setup_new_group_blocks set multi-bits each
> [PATCH 09/12] ext4: simplify journal handling in
> [PATCH 10/12] ext4: remove lock_buffer in bclean() and
> [PATCH 11/12] ext4: simplify parameters of add_new_gdb()
> [PATCH 12/12] ext4: simplify parameters of reserve_backup_gdb()
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
