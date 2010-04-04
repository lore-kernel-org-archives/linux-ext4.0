From: tytso@mit.edu
Subject: Re: [PATCH] ext4_freeze: don't return to userspace with a mutex
 held
Date: Sun, 4 Apr 2010 16:52:37 -0400
Message-ID: <20100404205237.GK18524@thunk.org>
References: <4BB12B03.9070906@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:54705 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752139Ab0DDUwk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 4 Apr 2010 16:52:40 -0400
Content-Disposition: inline
In-Reply-To: <4BB12B03.9070906@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 29, 2010 at 05:34:43PM -0500, Eric Sandeen wrote:
> 
> I don't -think- we need to do this; by now we should have s_frozen
> set, and nobody else should be coming down the pipe to get to
> the journal.  However, just to be on the safe side, I added
> a couple of vfs_check_frozen() calls in ext4 functions which will
> arrive at start_this_handle(), which should ensure that we never
> get any journal traffic generated while frozen.

Um, I think the addition of vfs_check_frozen(), esp. to
ext4_journal_start_sb() is absolutely necessary.  What else do we have
to prevent filesystem modifications from going to the file systme
layer?  I didn't see anything in the VFS layer that checks s_frozen;
am I missing something?

					- Ted
