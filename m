From: tytso@mit.edu
Subject: Re: [PATCH] resize: check s_log_groups_per_flex before accessing
 flex groups
Date: Sat, 3 Apr 2010 22:17:36 -0400
Message-ID: <20100404021736.GE18524@thunk.org>
References: <4BAE5D40.5050809@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Alessandro Polverini <alex@nibbles.it>,
	Christoph Biedl <bugzilla.kernel.bpeb@manchmal.in-ulm.de>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:33606 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754017Ab0DDCRi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 3 Apr 2010 22:17:38 -0400
Content-Disposition: inline
In-Reply-To: <4BAE5D40.5050809@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Mar 27, 2010 at 02:32:16PM -0500, Eric Sandeen wrote:
> This is for kernel.org bug:
> 
> #13549, Kernel oops while online resizing of an ext4 filesystem
> 
> if groups_per_flex < 2, sbi->s_flex_groups[] doesn't get filled out,
> and every other access to this first tests s_log_groups_per_flex;
> same thing needs to happen in resize or we'll wander off into
> a null pointer.

Added to the ext4 patch queue, thanks.

				- Ted
