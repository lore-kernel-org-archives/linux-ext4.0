From: Curt Wohlgemuth <curtw@google.com>
Subject: Re: [PATCH] ext4: Ensure zeroout blocks have no dirty metadata
Date: Thu, 10 Dec 2009 10:01:21 -0800
Message-ID: <6601abe90912101001o1f6f6ed6jc6ecb6e4c26d2463@mail.gmail.com>
References: <6601abe90912100928v747671dat489aeee5dabf2c03@mail.gmail.com>
	 <4B213391.4050603@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:17698 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448AbZLJSBR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Dec 2009 13:01:17 -0500
Received: from kpbe16.cbf.corp.google.com (kpbe16.cbf.corp.google.com [172.25.105.80])
	by smtp-out.google.com with ESMTP id nBAI1M3P018891
	for <linux-ext4@vger.kernel.org>; Thu, 10 Dec 2009 10:01:23 -0800
Received: from qw-out-1920.google.com (qwc5.prod.google.com [10.241.193.133])
	by kpbe16.cbf.corp.google.com with ESMTP id nBAI1Ls3008779
	for <linux-ext4@vger.kernel.org>; Thu, 10 Dec 2009 10:01:21 -0800
Received: by qw-out-1920.google.com with SMTP id 5so17759qwc.44
        for <linux-ext4@vger.kernel.org>; Thu, 10 Dec 2009 10:01:21 -0800 (PST)
In-Reply-To: <4B213391.4050603@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 10, 2009 at 9:44 AM, Eric Sandeen <sandeen@redhat.com> wrot=
e:
> Curt Wohlgemuth wrote:
>> This fixes a bug in which new blocks returned from an extent created=
 with
>> ext4_ext_zeroout() can have dirty metadata still associated with the=
m.
>
> Do you have a testcase or at least end result details for this corrup=
tion?

<sigh>  I wish I had a testcase.  I do know some facts about the
workload(s) involved:

1. No journal
2. Nearly full ext2 partition, mounted as ext4 -- tune2fs used to turn
on "extent dir_index"
3. Existing non-extent based files are removed, new (extent-based)
files are created.
4. Files created with O_DIRECT, ~8MB, fallocate(KEEP_SIZE) used,
writes are generally in increasing offset order, ~64K usually.
5. Some (~1%) writes are to holes in the fallocate'd file; we're not
yet using Mingming's patches, so these writes fall back to buffered
writes.
6. Lots of processes, lots of threads.
7. End result is a block (or sometimes 2 blocks) of all zeros, at a
block-aligned offset.  This zero'ed block is *always* somewhere in a
14-block extent created from using ext4_ext_zeroout().

Lots and lots of tracing showed that these blocks were originally
dirtied metadata blocks from unlinked (hence truncated) non-extent
based files.  These indirect blocks in ext4 have their direct block
pointers turned to zero as the blocks are truncated, and these
indirect blocks are marked as dirty.  Even though bforget() is called
on these metadata blocks, bforget() won't wait on the buffer.  Waiting
on the buffer is meant to happen at allocate time, for "new" buffers.

>
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
>
> nitpick, "ensure" I think, although I guess they're mostly synonymous
> today so do with that what you will :)

I'll let Ted decide :-)

>
> -Eric
>
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
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
