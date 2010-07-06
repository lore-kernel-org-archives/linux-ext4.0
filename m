From: "Amir G." <amir73il@users.sourceforge.net>
Subject: Re: [PATCH] fix for consistency errors after crash
Date: Tue, 6 Jul 2010 15:00:51 +0200
Message-ID: <AANLkTilxxsCSTIFLzg95xooW70SCNfWiDUVqpAT32FbX@mail.gmail.com>
References: <AANLkTimYavpuyNiaKYqUe3LFp0uzix_-ITV9ao0VagLs@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ric Wheeler <rwheeler@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f51.google.com ([209.85.214.51]:54343 "EHLO
	mail-bw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754657Ab0GFNGw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Jul 2010 09:06:52 -0400
Received: by bwz4 with SMTP id 4so3477172bwz.10
        for <linux-ext4@vger.kernel.org>; Tue, 06 Jul 2010 06:06:50 -0700 (PDT)
In-Reply-To: <AANLkTimYavpuyNiaKYqUe3LFp0uzix_-ITV9ao0VagLs@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Eric,

I've seen you guys had some open RH bugs on ext3, who all share in
common the "bit already free" error.

This bug I reported can explain many different problems in ext[34].

Essentially, every time there is a kernel crash (or hard reboot)
during delete/truncate of a large file,
it may result in "bit already clear" error after reboot.

The problem is very simple and so is the fix.
I proved the problem with 100% recreation chances using a small patch,
instead of running statistical stress tests.
All I did was to add a print and 10 seconds delay after transaction
restart in ext3_free_branches and reboot > 5 seconds after the
transaction restarts, so that kjournald will have time to commit the
old transaction.
After the reboot, I always get "bit already clear" errors, because the
"half large truncate" transaction is not handled properly.

I did not get any response from ext4 guys so far and since this bug
dates back to ext3,
I was hoping you guys could take a look and put your weight on pushing
the fix upstream.

Thanks,
Amir.

On Wed, Jun 23, 2010 at 9:27 PM, Amir G. <amir73il@users.sourceforge.ne=
t> wrote:
> Sorry, posting the patch again with a better title.
> This bug needs to be fixed also in Ext3.
> just need to move the ext3_forget() line down to ext3_free_blocks() l=
ine.
>
> Amir.
>
> On Wed, Jun 23, 2010 at 10:01 PM, Amir G.
> <amir73il@users.sourceforge.net> wrote:
>> Hi,
>>
>> We have experienced bitmap inconsistencies after crash during file
>> delete under heavy load.
>> The crash is not file system related and I the following patch in
>> ext4_free_branches() fixes the recovery problem.
>>
>> If the transaction is restarted and there is a crash before the new
>> transaction is committed,
>> then after recovery, the blocks that this indirect block points to
>> have been freed, but the indirect block itself
>> has not been freed and may still point to some of the free blocks
>> (because of the ext4_forget()).
>>
>> So ext4_forget() should be called inside ext4_free_blocks() to avoid
>> this problem.
>> Are there any consequences to this patch that I am not aware of?
>>
>> Amir.
>>
>> Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
>>
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index 42272d6..682e2fa 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
>> @@ -4458,6 +4458,7 @@ static void ext4_free_branches(handle_t *handl=
e,
>> struct inode *inode,
>> =A0{
>> =A0 =A0 =A0 =A0ext4_fsblk_t nr;
>> =A0 =A0 =A0 =A0__le32 *p;
>> + =A0 =A0 =A0 int =A0 =A0 flags;
>>
>> =A0 =A0 =A0 =A0if (ext4_handle_is_aborted(handle))
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return;
>> @@ -4520,7 +4521,7 @@ static void ext4_free_branches(handle_t *handl=
e,
>> struct inode *inode,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * revoke records mus=
t be emitted *before* clearing
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * this block's bit i=
n the bitmaps.
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 */
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_forget(handle, 1,=
 inode, bh, bh->b_blocknr);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 flags =3D
>> EXT4_FREE_BLOCKS_METADATA|EXT4_FREE_BLOCKS_FORGET;
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/*
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * Everything below t=
his this pointer has been
>> @@ -4546,8 +4547,7 @@ static void ext4_free_branches(handle_t *handl=
e,
>> struct inode *inode,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0blocks_for_truncate(inode));
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>>
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_free_blocks(handl=
e, inode, 0, nr, 1,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0EXT4_FREE_BLOCKS_METADATA);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_free_blocks(handl=
e, inode, 0, nr, 1, flags);
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (parent_bh) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/*
>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
