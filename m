From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsck: don't try to stop mmp if there is no superblock
 set up
Date: Mon, 9 Sep 2013 10:33:48 -0400
Message-ID: <20130909143348.GC6059@thunk.org>
References: <520E5BF3.5090502@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Hubert Kario <hkario@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:57010 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752260Ab3IIOdv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Sep 2013 10:33:51 -0400
Content-Disposition: inline
In-Reply-To: <520E5BF3.5090502@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 16, 2013 at 12:05:55PM -0500, Eric Sandeen wrote:
> Under some failure cases, we can get to fatal_error()
> without even having a superblock set up.  In that case,
> ext2fs_mmp_stop() will segfault when it tries to dereference
> fs->super.
> 
> Check for the existence of a superblock before we go
> down the ext2fs_mmp_stop() path to avoid this problem.
> 
> Reported-by: Hubert Kario <hkario@redhat.com>
> Addresses-Red-Hat-Bugzilla: #997972
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Thanks, applied.

					- Ted
