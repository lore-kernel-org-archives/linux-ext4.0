From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] tune2fs: allow removal of dirty journal with two "-f"
 options
Date: Thu, 20 Feb 2014 20:34:49 -0500
Message-ID: <20140221013449.GA31047@thunk.org>
References: <52CF01AB.7030704@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	james.faulkner@yale.edu
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:60632 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753670AbaBUBe5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Feb 2014 20:34:57 -0500
Content-Disposition: inline
In-Reply-To: <52CF01AB.7030704@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 09, 2014 at 02:08:11PM -0600, Eric Sandeen wrote:
> Jim pointed out that "tune2fs -f -O ^has_journal" won't remove the
> journal if the needs_recovery flag is set; the manpage seems to indicate
> that it should.  And if you've lost an external journal and can no longer
> replay it, how should one proceed?
> 
> Change tune2fs so that two "-f" options will allow removal of a dirty
> journal from a filesystem, even if the filesystem needs recovery.
> 
> e2fsck can then do its best to pick up the pieces.
> 
> Reported-by: Jim Faulkner <james.faulkner@yale.edu>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Thanks, applied.

					- Ted
