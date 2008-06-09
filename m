From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Subject: Re: [PATCH 1/5] jbd: strictly check for write errors on data buffers
Date: Mon, 09 Jun 2008 19:09:25 +0900
Message-ID: <484D0155.4040701@hitachi.com>
References: <20080603153050.fb99ac8a.akpm@linux-foundation.org>
    <20080604101925.GB16572@duck.suse.cz>
    <20080604111911.c1fe09c6.akpm@linux-foundation.org>
    <20080604212202.GA8727@mit.edu>
    <20080604145848.e3da6f20.akpm@linux-foundation.org>
    <20080604225155.GB8727@mit.edu> <20080605093536.GE27370@duck.suse.cz>
    <4847CF07.1020904@hitachi.com> <20080605142948.GA25477@mit.edu>
    <20080605092006.ba7dceef.akpm@linux-foundation.org>
    <20080605184941.GX2961@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	sct@redhat.com, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, jbacik@redhat.com, cmm@us.ibm.com,
	yumiko.sugita.yf@hitachi.com, satoshi.oshima.fk@hitachi.com
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail9.hitachi.co.jp ([133.145.228.44]:53282 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758966AbYFIKJg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 Jun 2008 06:09:36 -0400
In-Reply-To: <20080605184941.GX2961@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:
> On Jun 05, 2008  09:20 -0700, Andrew Morton wrote:

>>I guess we need to undo this.  And yes, propagating errors into AS_EIO
>>is the way.  I guess that's safe without holding lock_page(), as long
>>as the bh is pinned.
> 
> Something like the following instead if -EIO and journal abort:
> 
> 		if (!buffer_uptodate(bh)) {
> 			set_bit(AS_EIO, &bh->b_page->mapping->flags);
> 			SetPageError(bh->b_page);
> 		}
> 
> It seems end_buffer_async_write() does this already, but
> journal_do_submit_data() uses end_buffer_write_sync() and it does not
> do either of those operations.

Thank you for your suggestion.  I wrote an additional patch to do
that below.  Please apply it as the 6th patch of this patch series.

BTW, I'm developing a patch which makes "abort the journal if a file
data buffer has an error" tunable.  I'll send it in another thread
because it's not a bug fix patch.

Regards,
-- 
Hidehiro Kawai
Hitachi, Systems Development Laboratory
Linux Technology Center


Subject: JBD: don't abort if flushing file data failed

In ordered mode, it is not appropriate behavior to abort the journal
when we failed to write file data.  This patch calls printk()
instead of aborting the journal.  Additionally, set AS_EIO into
the address_space object of the buffer which is written out by
journal_do_submit_data() and failed so that fsync() can get -EIO.

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
---
 fs/jbd/commit.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

Index: linux-2.6.26-rc4/fs/jbd/commit.c
===================================================================
--- linux-2.6.26-rc4.orig/fs/jbd/commit.c
+++ linux-2.6.26-rc4/fs/jbd/commit.c
@@ -432,8 +432,11 @@ void journal_commit_transaction(journal_
 			wait_on_buffer(bh);
 			spin_lock(&journal->j_list_lock);
 		}
-		if (unlikely(!buffer_uptodate(bh)))
+		if (unlikely(!buffer_uptodate(bh))) {
+			set_bit(AS_EIO, &bh->b_page->mapping->flags);
+			SetPageError(bh->b_page);
 			err = -EIO;
+		}
 		if (!inverted_lock(journal, bh)) {
 			put_bh(bh);
 			spin_lock(&journal->j_list_lock);
@@ -452,8 +455,11 @@ void journal_commit_transaction(journal_
 	}
 	spin_unlock(&journal->j_list_lock);
 
-	if (err)
-		journal_abort(journal, err);
+	if (err) {
+		printk(KERN_WARNING
+		       "JBD: Detected IO errors during flushing file data\n");
+		err = 0;
+	}
 
 	journal_write_revoke_records(journal, commit_transaction);
 



