From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: remove unreachable code in
 ext4_can_extents_be_merged()
Date: Thu, 7 Nov 2013 22:26:00 -0500
Message-ID: <20131108032600.GA11668@thunk.org>
References: <5272C4E3.5040206@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:55536 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755178Ab3KHD0F (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 7 Nov 2013 22:26:05 -0500
Content-Disposition: inline
In-Reply-To: <5272C4E3.5040206@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 31, 2013 at 04:00:19PM -0500, Eric Sandeen wrote:
> commit
> ec22ba8e ext4: disable merging of uninitialized extents
> 
> ensured that if either extent under consideration is uninit,
> we decline to merge, and immediately return.
> 
> But right after that test, we test again for an uninit
> extent; we can never hit this.  So just remove the impossible
> test and associated variable.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Thanks, applied

					- Ted
