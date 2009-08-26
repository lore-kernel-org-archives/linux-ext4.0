From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Drop mapped buffer_head check during page_mkwrite
Date: Tue, 25 Aug 2009 22:24:45 -0400
Message-ID: <20090826022445.GA32712@mit.edu>
References: <1251210179-7634-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:55600 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751189AbZHZCYr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Aug 2009 22:24:47 -0400
Content-Disposition: inline
In-Reply-To: <1251210179-7634-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 25, 2009 at 07:52:59PM +0530, Aneesh Kumar K.V wrote:
> Inorder to check whether the buffer_heads are mapped we need
> to hold page lock. Otherwise a reclaim can cleanup the attached
> buffer_heads. Instead of taking page lock and check whether
> buffer_heads are mapped we let the write_begin/write_end callback
> does the equivalent. It does have a performance impact in that we
> are doing more work if we the buffer_heads are already mapped.

I'm not sure I understand the commit description.  From the patch you
are removing the check to see if all of the buffers are mapped.  But
the patch isn't moving the check to ext4_write_begin() or
ext4_write_end().  Are you saying the check is already in
ext4_write_begin()?  It doesn't seem to be in ext4_write_end().  

I see that we do call write_page_buffers() in ext4_write_begin(), and
in do_journal_get_write_access() we do check to see if the buffers are
present.  But if they aren't, we don't return an error; we just fail
request journal write access for the buffer head.

Am I missing something?  This patch doesn't feel complete, or the
commit description is very confusing....

						- Ted
