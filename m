From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsprogs: Set pointer to NULL after ext2fs_free
Date: Thu, 20 Feb 2014 20:56:41 -0500
Message-ID: <20140221015641.GB31047@thunk.org>
References: <1392902079-23416-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:60640 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754375AbaBUB4t (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Feb 2014 20:56:49 -0500
Content-Disposition: inline
In-Reply-To: <1392902079-23416-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 20, 2014 at 02:14:39PM +0100, Lukas Czerner wrote:
> ext2fs_free() does not set the ext2_filsys pointer to null so the caller
> is responsible to setting it himself if it is needed.
> 
> This patch fixes some places where caller did not set ext2_filsys
> pointer to NULL after ext2fs_free() which might result in use after
> free. Fix it.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Thanks, applied.

					- Ted
