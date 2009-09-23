From: Curt Wohlgemuth <curtw@google.com>
Subject: Re: ext4 inode corruption
Date: Wed, 23 Sep 2009 15:50:53 -0700
Message-ID: <6601abe90909231550g5b55f277l218560c827693322@mail.gmail.com>
References: <6601abe90909230927m6d45cd75wef3525fc23837110@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:30489 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbZIWWuy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Sep 2009 18:50:54 -0400
Received: from spaceape8.eur.corp.google.com (spaceape8.eur.corp.google.com [172.28.16.142])
	by smtp-out.google.com with ESMTP id n8NMov9M000916
	for <linux-ext4@vger.kernel.org>; Wed, 23 Sep 2009 15:50:57 -0700
Received: from pxi36 (pxi36.prod.google.com [10.243.27.36])
	by spaceape8.eur.corp.google.com with ESMTP id n8NMorFD018711
	for <linux-ext4@vger.kernel.org>; Wed, 23 Sep 2009 15:50:54 -0700
Received: by pxi36 with SMTP id 36so919272pxi.18
        for <linux-ext4@vger.kernel.org>; Wed, 23 Sep 2009 15:50:53 -0700 (PDT)
In-Reply-To: <6601abe90909230927m6d45cd75wef3525fc23837110@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Sorry to reply to self, but I'm now pretty sure that I understand this
problem.  (Of course this insight came mere hours after I sent this
email -- and not in the previous 4 days of staring at it.)

It's likely the same issue fixed by

       commit	1b774f669b4b02f4d2abf2792362ab72a2e124ab
       ext4: Use bforget() in no journal mode for ext4_journal_{forget,=
revoke}()

In the previous case, in no-journal mode an about-to-be-freed metadata
block is marked dirty and available for writeback.  The block is then
marked free, and re-used as a data block for a different inode; the
writeback takes place, corrupting the data block.

In this case, the newly-freed block is re-used as a *metadata* block
for a different inode.  Hence the same pattern we were seeing before:
eh_entries =3D 0, eh_max =3D 340.

These inodes were left on systems from kernels without the above
patch.  Accessing the files on *patched* kernels will still make the
BUG fire, hence the confusion.

Thanks,
Curt


On Wed, Sep 23, 2009 at 9:27 AM, Curt Wohlgemuth <curtw@google.com> wro=
te:
> We've been seeing sporadic inode corruption on our ext4 partitions wh=
ich
> we've been trying to analyze, without much success. =A0I'm wondering =
if
> anybody might have some clues as to where things might be going wrong=
=2E
>
> We find out about the corruption via a BUG firing in ext4_ext_get_blo=
cks():
>
> =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 * consistent leaf must not be empty;
> =A0 =A0 =A0 =A0 * this situation is possible, though, _during_ tree m=
odification;
> =A0 =A0 =A0 =A0 * this is why assert can't be put in ext4_ext_find_ex=
tent()
> =A0 =A0 =A0 =A0 */
> =A0 =A0 =A0 =A0BUG_ON(path[depth].p_ext =3D=3D NULL && depth !=3D 0);
>
> Of course, this fires long after the inode in question is corrupted. =
=A0With
> some diagnostics added in front of this bug, we can find the inodes; =
they
> all have characteristics like this:
>
> Output from debugfs' stat command:
>
> =A0 Inode: 1195575 =A0 Type: regular =A0 =A0Mode: =A00600 =A0 Flags: =
0x80000
> =A0 Generation: 2821101782 =A0 =A0Version: 0x00000001
> =A0 User: 35800 =A0 Group: =A05000 =A0 Size: 8400896
> =A0 File ACL: 0 =A0 =A0Directory ACL: 0
> =A0 Links: 1 =A0 Blockcount: 8
> =A0 Fragment: =A0Address: 0 =A0 =A0Number: 0 =A0 =A0Size: 0
> =A0 ctime: 0x4a9f8009 -- Thu Sep =A03 01:36:25 2009
> =A0 atime: 0x4a9f7ff7 -- Thu Sep =A03 01:36:07 2009
> =A0 mtime: 0x4a9f8009 -- Thu Sep =A03 01:36:25 2009
> =A0 EXTENTS:
>
> Note that no data blocks are printed out here.
>
> Following the actual extent tree, it always looks like this:
>
> =A0 in-inode extent header:
> =A0 =A0 eh_magic: 0xf30a
> =A0 =A0 eh_entries: 1
> =A0 =A0 eh_max: 4
> =A0 =A0 eh_depth: 1
>
> =A0 in-inode extent index 0:
> =A0 =A0 ei_block: 0
> =A0 =A0 ei_leaf_lo: 36738577
> =A0 =A0 ei_leaf_hi: 0
>
> =A0 =A0 =A0leaf node header (at block 36738577):
> =A0 =A0 =A0 =A0eh_magic: 0xf30a
> =A0 =A0 =A0 =A0eh_entries: 0
> =A0 =A0 =A0 =A0eh_max: 340
> =A0 =A0 =A0 =A0eh_depth: 0
>
> The i_size value of the inode will vary, from 8192 to 8400896. =A0But=
 the
> i_blocks value is *always* 8.
>
> The extent tree always has depth of 1 in the in-inode header, and a v=
alid
> leaf node header; but the leaf node header always has 0 entries. =A0T=
his is
> what's causing the BUG above to fire.
>
> We believe the general pattern of user space calls to create these fi=
les is
> something like this:
>
> =A0 open(O_DIRECT)
> =A0 fallocate(fd, FALLOC_FL_KEEP_SIZE, 0, 8400896)
> =A0 < various writes to the file >
> =A0 fallocate(fd, 0, 0, actual_size + BLOCK_SIZE)
> =A0 ftruncate(fd, actual_size)
>
> The second fallocate() call without KEEP_SIZE allows the following
> ftruncate to actually truncate the file -- a known issue recently fix=
ed by
> Jiaying Zhang (but her fix is not in our kernel yet). =A0"actual_size=
" can be
> 0 at times.
>
> I can't think of any actions that would cause the i_size to be so lar=
ge, yet
> the i_blocks always be 8. =A0Looking at the code in
>
> =A0 ext4_ext_remove_space()
> =A0 ext4_ext_rm_leaf()
> =A0 ext4_ext_rm_idx()
>
> I don't see a way for the extent tree to take the shape above. =A0The=
re are no
> errors that I can see around the time the corrupted inodes are create=
d. =A0It
> *seems* as though the corruption is coming during truncation, but all=
 our
> efforts to reproduce this with small test cases have so far failed.
>
> We're using a 2.6.26 code base, with most of the latest ext4 patches
> applied.
>
> Any insights/ruminations/guesses as to what might be happening are we=
lcome.
>
> Thanks,
> Curt
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
