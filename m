From: Theodore Tso <tytso@mit.edu>
Subject: Re: ext4: Can we talk about bforget() and metadata blocks
Date: Wed, 9 Sep 2009 21:35:40 -0400
Message-ID: <20090910013540.GF24951@mit.edu>
References: <6601abe90909091029s74465ebave932987e5fdf93ba@mail.gmail.com> <20090909225429.GB24951@mit.edu> <6601abe90909091707s1df9e71bvb4551772dc4917cb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:41713 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753910AbZIJBfn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 9 Sep 2009 21:35:43 -0400
Content-Disposition: inline
In-Reply-To: <6601abe90909091707s1df9e71bvb4551772dc4917cb@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 09, 2009 at 05:07:28PM -0700, Curt Wohlgemuth wrote:
> 
> First, ext4_journal_forget() is called from ext4_forget() only when
> we're journalling; without a journal, ext4_journal_forget() is only
> called for various non-extent paths.  ext4_forget() could be changed,
> of course...

Ext4_forget() calls either ext4_journal_forget() or
ext4_journal_revoke().  So we need to fix up both functions.

			      	      	  - Ted

commit 4afdf0958f6f7b878e6d85cb4e0c0c12a0bd74e2
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Wed Sep 9 21:32:41 2009 -0400

    ext4: Use bforget() in no journal mode for ext4_journal_{forget,revoke}()
    
    When ext4 is using a journal, a metadata block which is deallocated
    must be passed into the journal layer so it can be dropped from the
    current transaction and/or revoked.  This is done by calling the
    functions ext4_journal_forget() and ext4_journal_revoke(), which call
    jbd2_journal_forget(), and jbd2_journal_revoke(), respectively.
    
    Since the jbd2_journal_forget() and jbd2_journal_revoke() call
    bforget(), if ext4 is not using a journal, ext4_journal_forget() and
    ext4_journal_revoke() must call bforget() to avoid a dirty metadata
    block overwriting a block after it has been reallocated and reused for
    another inode's data block.
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
index eb27fd0..ecb9ca4 100644
--- a/fs/ext4/ext4_jbd2.c
+++ b/fs/ext4/ext4_jbd2.c
@@ -44,7 +44,7 @@ int __ext4_journal_forget(const char *where, handle_t *handle,
 						  handle, err);
 	}
 	else
-		brelse(bh);
+		bforget(bh);
 	return err;
 }
 
@@ -60,7 +60,7 @@ int __ext4_journal_revoke(const char *where, handle_t *handle,
 						  handle, err);
 	}
 	else
-		brelse(bh);
+		bforget(bh);
 	return err;
 }
 
