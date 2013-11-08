From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: remove unreachable code after
 ext4_can_extents_be_merged()
Date: Thu, 7 Nov 2013 22:26:13 -0500
Message-ID: <20131108032613.GB11668@thunk.org>
References: <5272C4E3.5040206@redhat.com>
 <5272C929.80303@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:55540 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755178Ab3KHD0P (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 7 Nov 2013 22:26:15 -0500
Content-Disposition: inline
In-Reply-To: <5272C929.80303@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 31, 2013 at 04:18:33PM -0500, Eric Sandeen wrote:
> commit
> ec22ba8e ext4: disable merging of uninitialized extents
>  
> ensured that if either extent under consideration is uninit,
> we decline to merge, and ext4_can_extents_be_merged() returns false.
> 
> So there is no need for the caller to then test whether the
> extent under consideration is unitialized; if it were, we
> wouldn't have gotten that far.
> 
> The comments were also inaccurate; ext4_can_extents_be_merged()
> no longer XORs the states, it fails if *either* is uninit.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Thanks, applied.

					- Ted
