From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] resize2fs: fix ENOSPC corruption case
Date: Wed, 20 May 2009 16:58:29 -0400
Message-ID: <20090520205829.GK24836@mit.edu>
References: <4A11D375.30709@redhat.com> <20090520113748.GC24836@mit.edu> <4A142851.6000807@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:45037 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750946AbZETU6f (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 May 2009 16:58:35 -0400
Content-Disposition: inline
In-Reply-To: <4A142851.6000807@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 20, 2009 at 10:57:05AM -0500, Eric Sandeen wrote:
> For F11 I will likely put in the later 2 patches, to fix up the minimum
> size reporting and then enforce that as the minimum size, so we
> shouldn't(tm) get into these error paths.  Seems like the safer
> last-minute change.

The first half of this patch I think is quite safe, and after stepping
through tst_etent, I'm pretty sure the second half of this patch would
be pretty easy to validate.  We probably don't want to enter any of
these error paths for now, though, since it's not clear we've fied all
of them, particularly in the split_node code.

						- Ted
