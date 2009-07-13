From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] Fix buffer head reference leak in no-journal mode
Date: Mon, 13 Jul 2009 09:08:29 -0400
Message-ID: <20090713130829.GB12833@mit.edu>
References: <6601abe90907091010u526b84afxdbb0ea00c4ab2fd8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:33343 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755802AbZGMNIb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Jul 2009 09:08:31 -0400
Content-Disposition: inline
In-Reply-To: <6601abe90907091010u526b84afxdbb0ea00c4ab2fd8@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 09, 2009 at 10:10:55AM -0700, Curt Wohlgemuth wrote:
> We found a problem with buffer head reference leaks when using an ext4
> partition without a journal.  In particular, calls to ext4_forget() would
> not to a brelse() on the input buffer head, which will cause pages they
> belong to to not be reclaimable.
> 
> Further investigation showed that all places where ext4_journal_forget() and
> ext4_journal_revoke() are called are subject to the same problem.  The patch
> below changes __ext4_journal_forget/__ext4_journal_revoke to do an explicit
> release of the buffer head when the journal handle isn't valid.
> 
> 	Signed-off-by: Curt Wohlgemuth <curtw@google.com>

Thanks, applied.

						- Ted
