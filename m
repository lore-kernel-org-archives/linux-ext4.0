From: Dmitry Monakhov <rjevskiy@gmail.com>
Subject: Re: [PATCH] ext4: fix sleep inside spinlock issue aka #14739 V2
Date: Sat, 19 Dec 2009 18:11:51 +0300
Message-ID: <c18d6aa20912190711u1c66973dp78d9bdc63b77437a@mail.gmail.com>
References: <1260409362-4349-1-git-send-email-dmonakhov@openvz.org>
	 <20091210161553.GG26516@atrey.karlin.mff.cuni.cz>
	 <87bpi6zquv.fsf_-_@openvz.org>
	 <20091218100603.GC9437@skywalker.linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>, cmm@us.ibm.com
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:58499 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191AbZLSPLx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 19 Dec 2009 10:11:53 -0500
Received: by ey-out-2122.google.com with SMTP id d26so1004229eyd.19
        for <linux-ext4@vger.kernel.org>; Sat, 19 Dec 2009 07:11:51 -0800 (PST)
In-Reply-To: <20091218100603.GC9437@skywalker.linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2009/12/18 Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>:
> On Thu, Dec 10, 2009 at 08:22:16PM +0300, Dmitry Monakhov wrote:
>>
>> drop i_block_reservation_lock before vfs_dq_reserve_block().
>> this patch fix http://bugzilla.kernel.org/show_bug.cgi?id=3D14739
>>
>> changes from previous version:
>> =C2=A0- simplify the patch according to Jan's comments
>>
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
>> -
>> =C2=A0 =C2=A0 =C2=A0 spin_unlock(&EXT4_I(inode)->i_block_reservation=
_lock);
>> +
>> =C2=A0 =C2=A0 =C2=A0 return 0; =C2=A0 =C2=A0 =C2=A0 /* success */
>
>
> NACK
> I guess we would end up setting i_reserved_meta_blocks wrongly becaus=
e
> mdblocks could be based on the old value of i_reserved_meta_blocks
> because we are dropping i_block_reservation_lock lock.
Yes. you right. I've already fixed this.
Please take a look at committed version:
http://git.kernel.org/?p=3Dlinux/kernel/git/jack/linux-fs-2.6.git;a=3Dc=
ommitdiff;h=3Def22d6deda461ef32c72944f662863c022253571
>
> -aneesh
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
