From: Joel Becker <Joel.Becker@oracle.com>
Subject: Confused by commit 56a76f [fs: fix page_mkwrite error cases in
 core code and btrfs]
Date: Thu, 30 Dec 2010 15:29:36 -0800
Message-ID: <20101230232936.GA931@mail.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	ocfs2-devel@oss.oracle.com, wengang@ca-server1.us.oracle.com
To: Nick Piggin <npiggin@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:39231 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618Ab0L3Xav (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 30 Dec 2010 18:30:51 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Nick,
	While visiting some issues in ocfs2_page_mkwrite(), I realized
that we're returning 0 to mean "Please try again Mr VM", but the caller
of page_mkwrite() now expects VM_FAULT_NOPAGE.  This is all due to
56a76f [fs: fix page_mkwrite error cases in core code and btrfs].
	In the comment for 56a76f, you state that btrfs is the example
but all other filesystems need to be fixed...yet ocfs2, ext4, and gfs2
continue to return 0 or VM_FAULT_SIGBUS.
	I guess this continues to work because we return the page
unlocked (thus triggering the "if (unlikely(!(tmp & VM_FAULT_LOCKED)))"
logic).  Was this expected to continue to work, or do you consider these
filesystems broken until they are updated with the new return codes?
	Back to the ocfs2 issue.  Am I correctly reading the current
code that we can safely throw away the page passed in to page_mkwrite()
if a pagecache flush has dropped it?  Currently, we presume that the
page passed in must be the one we make writable.  We make a quick check
of page->mapping == inode->i_mapping, returning 0 (for "try again")
immediately if that's false.  But once we get into the meat of our
locking and finally lock the page for good, we assume mapping==i_mapping
still holds.  That obviously breaks when the pagecache gets truncated.
At this late stage, we -EINVAL (clearly wrong).
	It looks hard to lock the page for good high up at our first
check of the mapping.  Wengang has proposed to simply ignore the page
passed into page_mkwrite() and just find_or_create_page() the sucker at
the place we're ready to consider it stable.  As I see it, the two
places that call page_mkwrite() are going to revalidate the pte anyway,
and they'll find the newly created page if find_or_create_page() gets a
different.  Is that safe behavior?

Joel

-- 

Life's Little Instruction Book #3

	"Watch a sunrise at least once a year."

Joel Becker
Senior Development Manager
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
