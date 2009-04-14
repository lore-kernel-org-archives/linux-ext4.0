From: Ying Han <yinghan@google.com>
Subject: Re: [patch 42/51] ext2: fix data corruption for racing writes
Date: Tue, 14 Apr 2009 07:25:31 -0700
Message-ID: <604427e00904140725p5451e969j8446d95ef89ed9e2@mail.gmail.com>
References: <200904132140.n3DLeELl024735@imap1.linux-foundation.org>
	 <200904142302.03702.nickpiggin@yahoo.com.au>
	 <20090414131340.GF398@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, akpm@linux-foundation.org,
	torvalds@linux-foundation.org, cmm@us.ibm.com,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:50177 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756103AbZDNOZf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Apr 2009 10:25:35 -0400
Received: from wpaz29.hot.corp.google.com (wpaz29.hot.corp.google.com [172.24.198.93])
	by smtp-out.google.com with ESMTP id n3EEPXOh010316
	for <linux-ext4@vger.kernel.org>; Tue, 14 Apr 2009 15:25:33 +0100
Received: from wf-out-1314.google.com (wfg23.prod.google.com [10.142.7.23])
	by wpaz29.hot.corp.google.com with ESMTP id n3EEPV7i017305
	for <linux-ext4@vger.kernel.org>; Tue, 14 Apr 2009 07:25:31 -0700
Received: by wf-out-1314.google.com with SMTP id 23so2330996wfg.2
        for <linux-ext4@vger.kernel.org>; Tue, 14 Apr 2009 07:25:31 -0700 (PDT)
In-Reply-To: <20090414131340.GF398@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 14, 2009 at 6:13 AM, Jan Kara <jack@suse.cz> wrote:
> On Tue 14-04-09 23:02:02, Nick Piggin wrote:
>> Thanks for the fix. I meant to ask but forgot: I guess you have chec=
ked
>> that no other ext/minix derived filesystem has similar problems? I d=
id
>> attempt to reproduce with ext3 but couldn't. I don't know enough of
>> the code to say whether it does not exist though.
> =A0I've checked that ext3 does the right thing (in fact I've made ext=
2 do
> a similar thing as ext3 does) and ext4 is fine as well. I've looked a=
t minix
> now and it seems to be correct as well. It's curious how the bug got =
into
> ext2...
I haven't been able to reproduce on ext4 neither.

--Ying
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Honza
>
>> On Tuesday 14 April 2009 07:40:14 akpm@linux-foundation.org wrote:
>> > From: Jan Kara <jack@suse.cz>
>> >
>> > If two writers allocating blocks to file race with each other (e.g=
=2E
>> > because writepages races with ordinary write or two writepages rac=
e with
>> > each other), ext2_getblock() can be called on the same inode in pa=
rallel.
>> > Before we are going to allocate new blocks, we have to recheck the=
 block
>> > chain we have obtained so far without holding truncate_mutex. =A0O=
therwise
>> > we could overwrite the indirect block pointer set by the other wri=
ter
>> > leading to data loss.
>> >
>> > The below test program by Ying is able to reproduce the data loss =
with ext2
>> > on in BRD in a few minutes if the machine is under memory pressure=
:
>> >
>> > long kMemSize =A0=3D 50 << 20;
>> > int kPageSize =3D 4096;
>> >
>> > int main(int argc, char **argv) {
>> > =A0 =A0 int status;
>> > =A0 =A0 int count =3D 0;
>> > =A0 =A0 int i;
>> > =A0 =A0 char *fname =3D "/mnt/test.mmap";
>> > =A0 =A0 char *mem;
>> > =A0 =A0 unlink(fname);
>> > =A0 =A0 int fd =3D open(fname, O_CREAT | O_EXCL | O_RDWR, 0600);
>> > =A0 =A0 status =3D ftruncate(fd, kMemSize);
>> > =A0 =A0 mem =3D mmap(0, kMemSize, PROT_READ | PROT_WRITE, MAP_SHAR=
ED, fd, 0);
>> > =A0 =A0 // Fill the memory with 1s.
>> > =A0 =A0 memset(mem, 1, kMemSize);
>> > =A0 =A0 sleep(2);
>> > =A0 =A0 for (i =3D 0; i < kMemSize; i++) {
>> > =A0 =A0 =A0 =A0 =A0 =A0 int byte_good =3D mem[i] !=3D 0;
>> > =A0 =A0 =A0 =A0 =A0 =A0 if (!byte_good && ((i % kPageSize) =3D=3D =
0)) {
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 //printf("%d ", i / kPageS=
ize);
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 count++;
>> > =A0 =A0 =A0 =A0 =A0 =A0 }
>> > =A0 =A0 }
>> > =A0 =A0 munmap(mem, kMemSize);
>> > =A0 =A0 close(fd);
>> > =A0 =A0 unlink(fname);
>> >
>> > =A0 =A0 if (count > 0) {
>> > =A0 =A0 =A0 =A0 =A0 =A0 printf("Running %d bad page\n", count);
>> > =A0 =A0 =A0 =A0 =A0 =A0 return 1;
>> > =A0 =A0 }
>> > =A0 =A0 return 0;
>> > }
>> >
>> > Cc: Ying Han <yinghan@google.com>
>> > Cc: Nick Piggin <nickpiggin@yahoo.com.au>
>> > Signed-off-by: Jan Kara <jack@suse.cz>
>> > Cc: Mingming Cao <cmm@us.ibm.com>
>> > Cc: <linux-ext4@vger.kernel.org>
>> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>> > ---
>> >
>> > =A0fs/ext2/inode.c | =A0 44 +++++++++++++++++++++++++++++++++-----=
------
>> > =A01 file changed, 33 insertions(+), 11 deletions(-)
>> >
>> > diff -puN fs/ext2/inode.c~ext2-fix-data-corruption-for-racing-writ=
es fs/ext2/inode.c
>> > --- a/fs/ext2/inode.c~ext2-fix-data-corruption-for-racing-writes
>> > +++ a/fs/ext2/inode.c
>> > @@ -590,9 +590,8 @@ static int ext2_get_blocks(struct inode
>> >
>> > =A0 =A0 if (depth =3D=3D 0)
>> > =A0 =A0 =A0 =A0 =A0 =A0 return (err);
>> > -reread:
>> > - =A0 partial =3D ext2_get_branch(inode, depth, offsets, chain, &e=
rr);
>> >
>> > + =A0 partial =3D ext2_get_branch(inode, depth, offsets, chain, &e=
rr);
>> > =A0 =A0 /* Simplest case - block found, no allocation needed */
>> > =A0 =A0 if (!partial) {
>> > =A0 =A0 =A0 =A0 =A0 =A0 first_block =3D le32_to_cpu(chain[depth - =
1].key);
>> > @@ -602,15 +601,16 @@ reread:
>> > =A0 =A0 =A0 =A0 =A0 =A0 while (count < maxblocks && count <=3D blo=
cks_to_boundary) {
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext2_fsblk_t blk;
>> >
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!verify_chain(chain, par=
tial)) {
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!verify_chain(chain, cha=
in + depth - 1)) {
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* Indir=
ect block might be removed by
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* trunc=
ate while we were reading it.
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* Handl=
ing of that case: forget what we've
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* got n=
ow, go to reread.
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D -EAG=
AIN;
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 count =3D =
0;
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto changed=
;
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 blk =3D le32_to_cpu(*(chai=
n[depth-1].p + count));
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (blk =3D=3D first_block=
 + count)
>> > @@ -618,7 +618,8 @@ reread:
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
>> > =A0 =A0 =A0 =A0 =A0 =A0 }
>> > - =A0 =A0 =A0 =A0 =A0 goto got_it;
>> > + =A0 =A0 =A0 =A0 =A0 if (err !=3D -EAGAIN)
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto got_it;
>> > =A0 =A0 }
>> >
>> > =A0 =A0 /* Next simple case - plain lookup or failed read of indir=
ect block */
>> > @@ -626,6 +627,33 @@ reread:
>> > =A0 =A0 =A0 =A0 =A0 =A0 goto cleanup;
>> >
>> > =A0 =A0 mutex_lock(&ei->truncate_mutex);
>> > + =A0 /*
>> > + =A0 =A0* If the indirect block is missing while we are reading
>> > + =A0 =A0* the chain(ext3_get_branch() returns -EAGAIN err), or
>> > + =A0 =A0* if the chain has been changed after we grab the semapho=
re,
>> > + =A0 =A0* (either because another process truncated this branch, =
or
>> > + =A0 =A0* another get_block allocated this branch) re-grab the ch=
ain to see if
>> > + =A0 =A0* the request block has been allocated or not.
>> > + =A0 =A0*
>> > + =A0 =A0* Since we already block the truncate/other get_block
>> > + =A0 =A0* at this point, we will have the current copy of the cha=
in when we
>> > + =A0 =A0* splice the branch into the tree.
>> > + =A0 =A0*/
>> > + =A0 if (err =3D=3D -EAGAIN || !verify_chain(chain, partial)) {
>> > + =A0 =A0 =A0 =A0 =A0 while (partial > chain) {
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 brelse(partial->bh);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 partial--;
>> > + =A0 =A0 =A0 =A0 =A0 }
>> > + =A0 =A0 =A0 =A0 =A0 partial =3D ext2_get_branch(inode, depth, of=
fsets, chain, &err);
>> > + =A0 =A0 =A0 =A0 =A0 if (!partial) {
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 count++;
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mutex_unlock(&ei->truncate_m=
utex);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (err)
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto cleanup=
;
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 clear_buffer_new(bh_result);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto got_it;
>> > + =A0 =A0 =A0 =A0 =A0 }
>> > + =A0 }
>> >
>> > =A0 =A0 /*
>> > =A0 =A0 =A0* Okay, we need to do block allocation. =A0Lazily initi=
alize the block
>> > @@ -683,12 +711,6 @@ cleanup:
>> > =A0 =A0 =A0 =A0 =A0 =A0 partial--;
>> > =A0 =A0 }
>> > =A0 =A0 return err;
>> > -changed:
>> > - =A0 while (partial > chain) {
>> > - =A0 =A0 =A0 =A0 =A0 brelse(partial->bh);
>> > - =A0 =A0 =A0 =A0 =A0 partial--;
>> > - =A0 }
>> > - =A0 goto reread;
>> > =A0}
>> >
>> > =A0int ext2_get_block(struct inode *inode, sector_t iblock, struct=
 buffer_head *bh_result, int create)
>> > _
>> >
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
