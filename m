From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 0/3] Fix possible NULL pointer dereference in JBD2
Date: Thu, 5 Feb 2009 16:37:44 -0500
Message-ID: <20090205213744.GA9814@mit.edu>
References: <1233845582-954-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>, mfasheh@suse.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:48579 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049AbZBEVhw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 Feb 2009 16:37:52 -0500
Content-Disposition: inline
In-Reply-To: <1233845582-954-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 05, 2009 at 03:52:59PM +0100, Jan Kara wrote:
> 

>   the three patches below fix a bug in
> jbd2_journal_begin_ordered_truncate() that could possibly lead to
> NULL pointer dereference. The question is how to merge the fix as it
> changes the prototype of the function and both ext4 and ocfs2 use
> it.  Mark, Mingming, any suggestions?

Jan, how how easy is it to hit this?  Do you believe we should try to
get this in for 2.6.29?  I got some final things to push to Linus so
I can also push it via the ext4 tree.  I doubt it will conflict with
> anything in my tree, either.

						- Ted
