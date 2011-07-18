From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: prevent parallel resizers and fix some error handling in resize
Date: Mon, 18 Jul 2011 18:16:07 +0800
Message-ID: <CAGBYx2YxnOSJTM78pJNNjjVf7DfWktx04v9HDReqWMXpqOxKRQ@mail.gmail.com>
References: <1310957555-15617-1-git-send-email-xiaoqiangnk@gmail.com>
	<CAOQ4uxj7C7L_27nEcn5ge6aD=2RLgipGOa_GBhhEeafC1H0HHQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, aedilger@gmail.com
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34736 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755688Ab1GRKQI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Jul 2011 06:16:08 -0400
Received: by pzk3 with SMTP id 3so3913580pzk.5
        for <linux-ext4@vger.kernel.org>; Mon, 18 Jul 2011 03:16:07 -0700 (PDT)
In-Reply-To: <CAOQ4uxj7C7L_27nEcn5ge6aD=2RLgipGOa_GBhhEeafC1H0HHQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 18, 2011 at 2:16 PM, Amir Goldstein <amir73il@gmail.com> wr=
ote:
> On Mon, Jul 18, 2011 at 5:52 AM, Yongqiang Yang <xiaoqiangnk@gmail.co=
m> wrote:
>> Hi,
>>
>> =A0This patch series prevents parallel resizer and fixes some error =
handling in
>> resize code. =A0Besides these, some code is simplified so that the c=
ode can be
>> used easily in new resize implementation.
>
> You should probably mention that "new resize implementation" means:
> let the kernel do all the resize work, gaining fast multi group resiz=
e,
> flex_bg layout, and uninit block groups.
> The new kernel resize implementation also prepares the ground for
> supporting resize with features like big_alloc, 64bit and exclude_bit=
map.
>
> You should probably also mention that you have already completed the
> "new resize implementation" and that you will post it shortly ;-)
Thank you for pointing it out:-)

Yongqiang.
>
>>
>> =A0The patches are tested by resize2fs and e2fsck -fn.
>>
>> [PATCH 01/12] ext4: prevent parallel resizers by atomic bit ops
>> [PATCH 02/12] ext4: prevent a fs with errors from being resized
>> [PATCH 03/12] ext4: prevent a fs without journal from being resized
>> [PATCH 04/12] ext4: rename ext4_add_groupblocks() to
>> [PATCH 05/12] ext4: let ext4_group_add_blocks return an error code
>> [PATCH 06/12] ext4: let ext4_group_add_blocks() handle 0 blocks
>> [PATCH 07/12] ext4: fix a typo in ext4_group_extend()
>> [PATCH 08/12] ext4: let setup_new_group_blocks set multi-bits each
>> [PATCH 09/12] ext4: simplify journal handling in
>> [PATCH 10/12] ext4: remove lock_buffer in bclean() and
>> [PATCH 11/12] ext4: simplify parameters of add_new_gdb()
>> [PATCH 12/12] ext4: simplify parameters of reserve_backup_gdb()
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
