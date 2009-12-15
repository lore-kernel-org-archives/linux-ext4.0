From: Dmitry Monakhov <rjevskiy@gmail.com>
Subject: Re: [PATCH] ext4: fix sleep inside spinlock issue aka #14739 V2
Date: Wed, 16 Dec 2009 02:16:36 +0300
Message-ID: <c18d6aa20912151516g3ad5e0a6iccaaa3a77a7a5f63@mail.gmail.com>
References: <1260409362-4349-1-git-send-email-dmonakhov@openvz.org>
	 <20091210161553.GG26516@atrey.karlin.mff.cuni.cz>
	 <87bpi6zquv.fsf_-_@openvz.org> <20091215214806.GD9554@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, cmm@us.ibm.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:38273 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934266AbZLOXQi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Dec 2009 18:16:38 -0500
Received: by ewy19 with SMTP id 19so434678ewy.21
        for <linux-ext4@vger.kernel.org>; Tue, 15 Dec 2009 15:16:36 -0800 (PST)
In-Reply-To: <20091215214806.GD9554@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2009/12/16 Jan Kara <jack@suse.cz>:
> On Thu 10-12-09 20:22:16, Dmitry Monakhov wrote:
>>
>> drop i_block_reservation_lock before vfs_dq_reserve_block().
>> this patch fix http://bugzilla.kernel.org/show_bug.cgi?id=3D14739
>>
>> changes from previous version:
>> =C2=A0- simplify the patch according to Jan's comments
> =C2=A0Dmitry, I suppose I should also merge this patch together with =
your other
> fixes, right? For some reason, it was not part of the last submission=
 of
> your patch series...
yes. it is not in the series because it is another bug, and it is not
depended from
other patches.
Please merge newst version of the patch http://patchwork.ozlabs.org/pat=
ch/40896/
This version is affected by stupid bug, see at the bottom of the patch.
In fact this patch does help Justin Maggard to overcome his issue.

BTW  i've also have another patch http://patchwork.ozlabs.org/patch/408=
05/
it was acked by you, but ASAIK it was't pushed to the ext4 queue yet.
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0Honza
>
>> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
>> ---
>> =C2=A0fs/ext4/inode.c | =C2=A0 =C2=A06 +++---
>> =C2=A01 files changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index 942e183..2327f7a 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
>> @@ -1851,6 +1851,7 @@ repeat:
>>
>> =C2=A0 =C2=A0 =C2=A0 md_needed =3D mdblocks - EXT4_I(inode)->i_reser=
ved_meta_blocks;
>> =C2=A0 =C2=A0 =C2=A0 total =3D md_needed + nrblocks;
>> + =C2=A0 =C2=A0 spin_unlock(&EXT4_I(inode)->i_block_reservation_lock=
);
>>
>> =C2=A0 =C2=A0 =C2=A0 /*
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0* Make quota reservation here to prevent =
quota overflow
>> @@ -1858,12 +1859,10 @@ repeat:
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0* time.
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
>> =C2=A0 =C2=A0 =C2=A0 if (vfs_dq_reserve_block(inode, total)) {
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 spin_unlock(&EXT4_I(inod=
e)->i_block_reservation_lock);
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -EDQUOT;
>> =C2=A0 =C2=A0 =C2=A0 }
>>
>> =C2=A0 =C2=A0 =C2=A0 if (ext4_claim_free_blocks(sbi, total)) {
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 spin_unlock(&EXT4_I(inod=
e)->i_block_reservation_lock);
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 vfs_dq_release_rese=
rvation_block(inode, total);
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (ext4_should_ret=
ry_alloc(inode->i_sb, &retries)) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 yield();
>> @@ -1871,10 +1870,11 @@ repeat:
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -ENOSPC;
>> =C2=A0 =C2=A0 =C2=A0 }
>> + =C2=A0 =C2=A0 spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
>> =C2=A0 =C2=A0 =C2=A0 EXT4_I(inode)->i_reserved_data_blocks +=3D nrbl=
ocks;
>> =C2=A0 =C2=A0 =C2=A0 EXT4_I(inode)->i_reserved_meta_blocks =3D mdblo=
cks;
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^=
^^^^^^^
meta_blocks may be changed after we dropped the lock, so we have to
use add here:
EXT4_I(inode)->i_reserved_meta_blocks +=3D mb_needed;
I've overlooked this simple bug, and in fact i'm able to catch it only
with havy io load
=2E/fsstress -p16 .....
>> -
>> =C2=A0 =C2=A0 =C2=A0 spin_unlock(&EXT4_I(inode)->i_block_reservation=
_lock);
>> +
>> =C2=A0 =C2=A0 =C2=A0 return 0; =C2=A0 =C2=A0 =C2=A0 /* success */
>> =C2=A0}
>>
>> --
>> 1.6.0.4
>>
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
