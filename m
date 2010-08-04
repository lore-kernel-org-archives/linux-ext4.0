From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH, RFC 2/3] jbd2: Change j_state_lock to be a rwlock_t
Date: Tue, 3 Aug 2010 20:08:39 -0400
Message-ID: <20100804000839.GI9453@thunk.org>
References: <1280851315-9167-1-git-send-email-tytso@mit.edu>
 <1280851315-9167-3-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: John Stultz <johnstul@us.ibm.com>,
	Keith Maanthey <kmannth@us.ibm.com>,
	Eric Whitney <eric.whitney@hp.com>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	ocfs2-devel@oss.oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:32809 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757344Ab0HDAIl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Aug 2010 20:08:41 -0400
Content-Disposition: inline
In-Reply-To: <1280851315-9167-3-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 03, 2010 at 12:01:54PM -0400, Theodore Ts'o wrote:
> Lockstat reports have shown that j_state_lock is a major source of
> lock contention, especially on systems with more than 4 CPU cores.  So
> change it to be a read/write spinlock.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

Oops, this patch can result in a BUG_ON in fs/jbd2/transaction.c.  I'm
currently testing a fix/replacement patch, but I figured I send a
quick warning to folks not to waste time trying this out just yet.  I
should hopefully have a new, better-tested patch in by tomorrow
morning.

						- Ted

