From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: kernel BUG at fs/buffer.c:1234!
Date: Thu, 20 Jun 2013 12:34:06 -0400
Message-ID: <20130620163406.GB4982@thunk.org>
References: <51C1DF40.7030708@null-ptr.net>
 <20130619185537.GB24587@thunk.org>
 <51C32BB1.5070902@null-ptr.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dustin Lundquist <dustin@null-ptr.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:59848 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965608Ab3FTQeK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Jun 2013 12:34:10 -0400
Content-Disposition: inline
In-Reply-To: <51C32BB1.5070902@null-ptr.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 20, 2013 at 09:20:01AM -0700, Dustin Lundquist wrote:
> 
> Since the system is still half way responsive after this occurs, is
> there any other information I can gather after if occurs to aid in
> diagnosing this?

Hmm.... the only thing I can think of is to sprinkle in some

        WARN_ON(irqs_disabled());

calls in various top-half routines in ext4 code, especially in
ext4_lookup() and ext4_find_entry(), and perhaps in the vfs layer to
see if we can figure out where the interrupts are getting disabled.
The fact that blkcipher_walk_done() was showing up in the stack trace
is certainly suspicious.

					- Ted
