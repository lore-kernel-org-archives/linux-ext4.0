From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsprogs: introduce ext2fs_close_free() helper
Date: Sat, 5 Jul 2014 21:07:05 -0400
Message-ID: <20140706010705.GB19036@thunk.org>
References: <1392908549-32318-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47135 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065AbaGFBHI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 5 Jul 2014 21:07:08 -0400
Content-Disposition: inline
In-Reply-To: <1392908549-32318-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 20, 2014 at 04:02:29PM +0100, Lukas Czerner wrote:
> Currently there are many uses of ext2fs_close() which might be wrong.
> First of all ext2fs_close() does not set the ext2_filsys pointer to NULL
> so the caller is responsible for clearing it, however there are some
> cases there we do not do it.
> 
> Second of all very small number of users of ext2fs_close() actually
> check the return value. If there is a problem in ext2fs_close() it will
> not even free the ext2_filsys structure, but majority of users expect it
> to do so.
> 
> To fix both problems this commit introduces a new helper
> ext2fs_close_free() which will not only check for the return value and
> free the ext2_filsys structure if the call to ext2fs_close2() failed,
> but it will also set the ext2_filsys pointer to NULL.
> 
> Replace every use of ext2fs_close() in e2fsprogs tools with
> ext2fs_close_free() - there is no real reason to keep using
> ext2fs_close().
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Thanks, applied.

					- Ted
