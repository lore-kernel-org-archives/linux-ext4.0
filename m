From: Curt Wohlgemuth <curtw@google.com>
Subject: Re: [PATCH] ext4: Ensure zeroout blocks have no dirty metadata
Date: Tue, 29 Dec 2009 09:56:29 -0800
Message-ID: <6601abe90912290956s6837803ck76e8c36e96f225ae@mail.gmail.com>
References: <6601abe90912100928v747671dat489aeee5dabf2c03@mail.gmail.com>
	 <20091218114946.GD9437@skywalker.linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:61897 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420AbZL2R4d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 29 Dec 2009 12:56:33 -0500
Received: from spaceape23.eur.corp.google.com (spaceape23.eur.corp.google.com [172.28.16.75])
	by smtp-out.google.com with ESMTP id nBTHuV3h022716
	for <linux-ext4@vger.kernel.org>; Tue, 29 Dec 2009 17:56:32 GMT
Received: from qyk11 (qyk11.prod.google.com [10.241.83.139])
	by spaceape23.eur.corp.google.com with ESMTP id nBTHuT9C018511
	for <linux-ext4@vger.kernel.org>; Tue, 29 Dec 2009 09:56:30 -0800
Received: by qyk11 with SMTP id 11so4873354qyk.13
        for <linux-ext4@vger.kernel.org>; Tue, 29 Dec 2009 09:56:29 -0800 (PST)
In-Reply-To: <20091218114946.GD9437@skywalker.linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 18, 2009 at 3:49 AM, Aneesh Kumar K.V
<aneesh.kumar@linux.vnet.ibm.com> wrote:
> On Thu, Dec 10, 2009 at 09:28:28AM -0800, Curt Wohlgemuth wrote:
>> This fixes a bug in which new blocks returned from an extent created=
 with
>> ext4_ext_zeroout() can have dirty metadata still associated with the=
m.
>>
>> =A0 =A0 =A0 Signed-off-by: Curt Wohlgemuth <curtw@google.com>
>> ---
>>
>> This is for the problem I reported on 23 Nov ("Bug in extent zeroout=
: blocks
>> not marked as new"). =A0I'm not seeing the corruption with this fix =
that I was
>> seeing without it.
>>
>> diff -uprN orig/fs/ext4/extents.c new/fs/ext4/extents.c
>> --- orig/fs/ext4/extents.c =A0 =A02009-12-09 15:09:25.000000000 -080=
0
>> +++ new/fs/ext4/extents.c =A0 =A0 2009-12-09 15:09:37.000000000 -080=
0
>> @@ -2474,9 +2474,21 @@ static int ext4_ext_zeroout(struct inode
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 submit_bio(WRITE, bio);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 wait_for_completion(&event);
>>
>> - =A0 =A0 =A0 =A0 =A0 =A0 if (test_bit(BIO_UPTODATE, &bio->bi_flags)=
)
>> + =A0 =A0 =A0 =A0 =A0 =A0 /* On success, we need to insure all metad=
ata associated
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0* with each of these blocks is unmapped=
=2E */
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (test_bit(BIO_UPTODATE, &bio->bi_flags)=
) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sector_t block =3D ee_pblo=
ck;
>> +
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D 0;
>> - =A0 =A0 =A0 =A0 =A0 =A0 else {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 done =3D 0;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 while (done < len) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unmap_unde=
rlying_metadata(inode->i_sb->s_bdev,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 block);
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 done++;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 block++;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 } else {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D -EIO;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>
> a) We are zeroing out 'done' blocks but you are unmapping 'len' block=
s ?
> b) We are already doing a unmap in mpage_da_map_blocks so i guess
> =A0 what you want is to unmap the extra block allocated
> c) ee_pblock is in 512 byte units so the block number is wrong.
>
> how about the patch below ?

Thanks for pointing out the arithmetic problems in my patch.  Yours
below looks good to me.
Curt


>
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 3a7928f..f9a735f 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -3023,6 +3023,14 @@ out:
> =A0 =A0 =A0 =A0return err;
> =A0}
>
> +static void unmap_underlying_metadata_blocks(struct block_device *bd=
ev,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sector_t block, int cou=
nt)
> +{
> + =A0 =A0 =A0 int i;
> + =A0 =A0 =A0 for (i =3D 0; i < count; i++)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unmap_underlying_metadata(bdev, bloc=
k + i);
> +}
> +
> =A0static int
> =A0ext4_ext_handle_uninitialized_extents(handle_t *handle, struct ino=
de *inode,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_lblk_t iblock, un=
signed int max_blocks,
> @@ -3098,6 +3106,18 @@ out:
> =A0 =A0 =A0 =A0} else
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0allocated =3D ret;
> =A0 =A0 =A0 =A0set_buffer_new(bh_result);
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* if we allocated more blocks than requested
> + =A0 =A0 =A0 =A0* we need to make sure we unmap the extra block
> + =A0 =A0 =A0 =A0* allocated. The actual needed block will get
> + =A0 =A0 =A0 =A0* unmapped later when we find the buffer_head marked
> + =A0 =A0 =A0 =A0* new.
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 if (allocated > max_blocks) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 unmap_underlying_metadata_blocks(inode-=
>i_sb->s_bdev,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 newblock + max_blocks,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 allocated - max_blocks);
> + =A0 =A0 =A0 }
> =A0map_out:
> =A0 =A0 =A0 =A0set_buffer_mapped(bh_result);
> =A0out1:
>
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
