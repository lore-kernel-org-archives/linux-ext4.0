From: Curt Wohlgemuth <curtw@google.com>
Subject: RFC PATCH: ext4 no journal corruption with locale-gen
Date: Wed, 17 Jun 2009 11:48:19 -0700
Message-ID: <6601abe90906171148w1431258fvd0afa105cda9b77b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:11076 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbZFQSsV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Jun 2009 14:48:21 -0400
Received: from wpaz1.hot.corp.google.com (wpaz1.hot.corp.google.com [172.24.198.65])
	by smtp-out.google.com with ESMTP id n5HImMhS025782
	for <linux-ext4@vger.kernel.org>; Wed, 17 Jun 2009 19:48:22 +0100
Received: from pxi38 (pxi38.prod.google.com [10.243.27.38])
	by wpaz1.hot.corp.google.com with ESMTP id n5HImJDC022217
	for <linux-ext4@vger.kernel.org>; Wed, 17 Jun 2009 11:48:20 -0700
Received: by pxi38 with SMTP id 38so515340pxi.16
        for <linux-ext4@vger.kernel.org>; Wed, 17 Jun 2009 11:48:19 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

So I finally was able to figure out the data corruption problem with
locale-gen on ext4 without a journal.

Basically, using mmap(MAP_SHARED, PROT_WRITE) to write to a file through an
mmap'ed pointer is broken on ext4 when there is no journal.

It seems to be a combination of several problems:

   a. The choice of what address space ops to use in ext4_set_aops() just
      seems wrong to me.

   b. The use of ext4_journalled_writepage() if there is no journal being
      used is broken if the page was marked dirty from
      ext4_journalled_set_page_dirty().

      I don't understand how __ext4_journalled_writepage() would ever work.

ext4_set_aops() chooses among 4 different structures:

            ext4_da_aops
            ext4_ordered_aops
            ext4_writeback_aops
            ext4_journalled_aops

It seems to me that ext4_da_aops should be used whenever delayed allocation
is used, and the rest otherwise.  But this leaves open the question of what
to use when nodelalloc is used, AND there's no journal.  Today, this uses
ext4_journalled_aops, but this seems odd on its face.  Yes, I know that all
the routines there are supposed to handle no journal, but it's nevertheless
odd.

The problem with ext4_journalled_writepage() is this:

1. ext4_journalled_set_page_dirty() sets the PageChecked bit, then dirties
   the page.

2. ext4_journalled_writepage() will do the following; note the goto if there
   IS a journal:

===================================================================
	if (ext4_journal_current_handle())
		goto no_write;

	if (PageChecked(page)) {
		/*
		 * It's mmapped pagecache.  Add buffers and journal it.  There
		 * doesn't seem much point in redirtying the page here.
		 */
		ClearPageChecked(page);
		return __ext4_journalled_writepage(page, wbc);
	} else {
		/*
		 * It may be a page full of checkpoint-mode buffers.  We don't
		 * really know unless we go poke around in the buffer_heads.
		 * But block_write_full_page will do the right thing.
		 */
		return block_write_full_page(page,
						ext4_normal_get_block_write,
						wbc);
	}
no_write:
===================================================================

3. Unfortunately, __ext4_journalled_writepage() in the case of no journal,
   will just

      - call block_prepare_write()
      - calls write_end_fn() on all buffers, which just marks them dirty,
        doesn't actually write them out.

   And it doesn't seem to me that __ext4_journalled_writepage() will ever be
   called if there IS a journal.

   Am I missing something here?

4. If PageChecked bit isn't set, it calls block_write_full_page() and works
   fine.


Below is a patch that "fixes" ext4_set_aops(): that is, in the case of
delayed allocation but no journal, we'll use ext4_da_aops.  It does NOT fix
the problem of nodelalloc and either

   - no journal
   - data=journal

I'm holding off on fixing this because I'm not sure of the right place for
it.  I think it should be one of:

   a. Adding an address space ops structure just for nodelalloc/nojournal
   b. Getting rid of __ext4_journalled_writepage() as well as
      ext4_journalled_set_page_dirty(), since I'm not really sure they do
      anything.

Comments please?


	Signed-off-by: Curt Wohlgemuth <curtw@google.com>
---
--- linux-2.6/fs/ext4/inode.c.orig	2009-06-09 20:05:27.000000000 -0700
+++ linux-2.6/fs/ext4/inode.c	2009-06-17 11:07:57.000000000 -0700
@@ -3442,14 +3442,10 @@ static const struct address_space_operat

 void ext4_set_aops(struct inode *inode)
 {
-	if (ext4_should_order_data(inode) &&
-		test_opt(inode->i_sb, DELALLOC))
+	if (test_opt(inode->i_sb, DELALLOC))
 		inode->i_mapping->a_ops = &ext4_da_aops;
 	else if (ext4_should_order_data(inode))
 		inode->i_mapping->a_ops = &ext4_ordered_aops;
-	else if (ext4_should_writeback_data(inode) &&
-		 test_opt(inode->i_sb, DELALLOC))
-		inode->i_mapping->a_ops = &ext4_da_aops;
 	else if (ext4_should_writeback_data(inode))
 		inode->i_mapping->a_ops = &ext4_writeback_aops;
 	else
