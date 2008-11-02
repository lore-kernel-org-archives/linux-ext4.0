From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] jbd2: deregister proc on failure in
	jbd2_journal_init_inode
Date: Sun, 2 Nov 2008 18:48:50 -0500
Message-ID: <20081102234850.GP8134@mit.edu>
References: <20081102195857.GM5994@lh.kyla.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: sct@redhat.com, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org
To: Sami Liedes <sliedes@cc.hut.fi>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:52174 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753852AbYKBXtC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Nov 2008 18:49:02 -0500
Content-Disposition: inline
In-Reply-To: <20081102195857.GM5994@lh.kyla.fi>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Nov 02, 2008 at 09:58:57PM +0200, Sami Liedes wrote:
> jbd2_journal_init_inode() does not call jbd2_stats_proc_exit() on all
> failure paths after calling jbd2_stats_proc_init(). This leaves
> dangling references to the fs in proc.
> 
> This patch fixes bug #11493.
> 
> Signed-off-by: Sami Liedes <sliedes@cc.hut.fi>
> 
> ---
> 
> I hope this is correct. I don't understand the code very well, but I
> did test my patch and it seems to fix the problem. Please don't hit me
> too hard, this is the first kernel patch I have ever submitted.

The patch looks good.  I'll get this into the ext4 patch queue and
queue it for submission to Linus.  I normally reference kernel bugs
via the full URL, i.e:

This patch fixes a bug reported by Sami Leides at:
http://bugzilla.kernel.org/show_bug.cgi?id=11493

...but that's just a tiny nit.   Thanks!!

							- Ted
