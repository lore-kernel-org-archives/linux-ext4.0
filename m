From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] tune2fs: fix quota enablement regression
Date: Sun, 5 Feb 2017 21:01:29 -0500
Message-ID: <20170206020129.gzqofbyqjilsdllr@thunk.org>
References: <20170204032334.GA6952@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36148 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751862AbdBFCBe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 5 Feb 2017 21:01:34 -0500
Content-Disposition: inline
In-Reply-To: <20170204032334.GA6952@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 03, 2017 at 10:23:34PM -0500, Eric Whitney wrote:
> Commit 5c2a665afa (Avoid dereferencing beyond allocated memory in quota
> handling) induced a quota enablement regression in tune2fs.  Attempts
> to enable a particular quota type (tune2fs -O project <dev>, for
> example) set the appropriate feature flag in the superblock but the
> quota file for the type is not initialized.
> 
> The regression prevents the current version of xfstests from running
> generic/383, 384, 385, and 386 (all project quota tests) with e2fsprogs
> 1.43.4.  These tests exit with the message "Installed kernel does not
> support project quotas", but the actual problem is that the project
> quota file is not present.
> 
> Signed-off-by: Eric Whitney <enwlinux@gmail.com>

Thanks, applied.

						- Ted
