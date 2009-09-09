From: Curt Wohlgemuth <curtw@google.com>
Subject: Re: Odd "leak" of extent info into data blocks?
Date: Tue, 8 Sep 2009 21:00:50 -0700
Message-ID: <6601abe90909082100n48afdba9qee087ff46bfe4e3f@mail.gmail.com>
References: <6601abe90908221610p60629809qcde6848308b8affe@mail.gmail.com>
	 <20090908175605.GB7801@shell>
	 <6601abe90909081121p17b154a4s2e6852da2b71951f@mail.gmail.com>
	 <20090908194045.GQ22901@mit.edu>
	 <6601abe90909081418k5de55938mfe411fccfe10a258@mail.gmail.com>
	 <20090908233644.GV22901@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Valerie Aurora <vaurora@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:29096 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbZIIEAw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Sep 2009 00:00:52 -0400
Received: from spaceape8.eur.corp.google.com (spaceape8.eur.corp.google.com [172.28.16.142])
	by smtp-out.google.com with ESMTP id n8940rAM002342
	for <linux-ext4@vger.kernel.org>; Wed, 9 Sep 2009 05:00:54 +0100
Received: from an-out-0708.google.com (ancc5.prod.google.com [10.100.29.5])
	by spaceape8.eur.corp.google.com with ESMTP id n8940p4p019543
	for <linux-ext4@vger.kernel.org>; Tue, 8 Sep 2009 21:00:51 -0700
Received: by an-out-0708.google.com with SMTP id c5so1517542anc.42
        for <linux-ext4@vger.kernel.org>; Tue, 08 Sep 2009 21:00:50 -0700 (PDT)
In-Reply-To: <20090908233644.GV22901@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted:

On Tue, Sep 8, 2009 at 4:36 PM, Theodore Tso<tytso@mit.edu> wrote:
> On Tue, Sep 08, 2009 at 02:18:35PM -0700, Curt Wohlgemuth wrote:
>>
>> All bforget() does is clear the buffer's dirty bit. =A0Meanwhile, th=
e
>> page is still marked dirty, and can be in the middle of writeback;
>> it's true that __block_write_full_page() will check the dirty bit fo=
r
>> each buffer in the page, but there doesn't seem to be any
>> synchronization to ensure that the write won't take place at some
>> point in time after bforget() is called. =A0Which means it can be ca=
lled
>> after the bitmap is changed.
>
> Let me make sure I got this right. =A0The problem that you're worried
> about is a block that had previously contained an extent tree node fo=
r
> an inode that gets deleted, and then that blocks gets reallocated for
> use as a data block.

Correct.

>=A0In ext3 and ext4, metadata blocks (such as
> extent tree blocks), aren't stored in the page cache.

Hmm.  You're saying that in the absence of a journal, all metadata
writes go direct to disk?  Where should I look for this in the code?

Looking at ext4_ext_new_meta_block() and code that uses it, I don't
see anything that prevents the use of the page cache.  And if this
were the case, wouldn't the call to mark_buffer_dirty() in
__ext4_handle_dirty_metadata() (when there's no journal) do nothing?

I also put in code in submit_bio() to scan all pages for the extent
header pattern that I was seeing ("leaking" into the data pages).
When I saw it, the stack trace was always from pdflush() (from
wb_kupdate()).  I.e., these are from the page cache.

> So I'm not sure why you're worried about the page being marked dirty.
> What's the scenario you are concerned about?

If you're right that metadata writes are not through the page cache,
then there is no scenario I'm worried about :-) .

The problem is that I've seen this in real life.  And the patch below
seems to fix it.  (Unfortunately, I haven't been able to recreate this
in a simple example, after several days work.  I've only seen this in
a *very* small number of cases on heavily loaded machines.)

> If it's the case where a data block for a deleted inode getting
> rewritten after the inode is deleted, when the inode is deleted,
> truncate_inode_apges() end up dropping the pages from the page cache
> *before* the block allocation bitmap is dropped.

It's quite possible that there's an interaction with older code that
we have in our 2.6.26-based kernels -- our ext4/jbd2 code is pretty
up-to-date, but the rest of the code base is not.  But really, in my
case -- and you'll have to trust me -- I've seen this pattern:

1. file A (~8MB) is written out and closed, with a final mod time of 12=
:08 p.m.
2. My submit_bio() scan sees the "bad extent header" written out to
physical block B at 12:15 p.m.
3. Looking at file A later, its logical block 2048 corresponds to
physical block B -- and contains the "bad extent header" pattern.

truncate_inode_pages() only deals with data blocks, right?  So it
should have no effect on metadata...

>> This is why I opted to wait for the buffer to be written out before
>> continuing on to ext4_free_blocks().
>
> Just to be clear, which buffer are you talking about here?

The leaf extent blocks buffer_head.  Here's the patch, as applied to a
2.6.30.3 version of extents.c:

diff -Naur orig/fs/ext4/extents.c new/fs/ext4/extents.c
--- orig/fs/ext4/extents.c	2009-09-08 20:28:46.000000000 -0700
+++ new/fs/ext4/extents.c	2009-09-08 20:31:42.000000000 -0700
@@ -1958,6 +1958,15 @@
 		return err;
 	ext_debug("index is empty, remove it, free block %llu\n", leaf);
 	bh =3D sb_find_get_block(inode->i_sb, leaf);
+
+	/*
+	 * If we don't have a journal, then we've dirtied the BH for the leaf
+	 * block, but we're freeing the block now.  We need to wait here for
+	 * the page to be written out before we proceed.
+	 */
+	if (!ext4_handle_valid(handle) && bh)
+		sync_dirty_buffer(bh);
+
 	ext4_forget(handle, 1, inode, bh, leaf);
 	ext4_free_blocks(handle, inode, leaf, 1, 1);
 	return err;


Thanks,
Curt
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
