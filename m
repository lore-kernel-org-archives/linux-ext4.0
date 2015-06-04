From: Jan Kara <jack@suse.cz>
Subject: Rules for calling ->releasepage()
Date: Thu, 4 Jun 2015 10:39:53 +0200
Message-ID: <20150604083953.GB5923@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, mfasheh@suse.de,
	mgorman@suse.de, linux-ext4@vger.kernel.org
To: linux-mm@kvack.org
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

  Hello,

  we were recently debugging an issue where customer was hitting warnings
in xfs_vm_releasepage() which was complaining that the page it was called
for has delay-allocated buffers. After some debugging we realized that
indeed try_to_release_page() call from shrink_active_list() can happen for
a page in arbitrary state (that call happens only if
buffer_heads_over_limit is set so that is the reason why we normally don't
see that).

Hence comes my question: What are the rules for when can ->releasepage() be
called? And what is the expected outcome? We are certainly guaranteed to
hold page lock. try_to_release_page() also makes sure the page isn't under
writeback.  But what is ->releasepage() supposed to do with a dirty page?
Generally IFAIU we aren't supposed to discard dirty data but I wouldn't bet
on all filesystems getting it right because the common call paths make sure
page is clean. I would almost say we should enforce !PageDirty in
try_to_release_page() if it was not for that ext3 nastyness of cleaning
buffers under a dirty page - hum, but maybe the right answer for that is
ripping ext3 out of tree (which would also allow us to get rid of some code
in the blocklayer for bouncing journaled data buffers when stable writes
are required).

Thoughts?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
