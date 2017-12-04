From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix fdatasync(2) after fallocate(2) operation
Date: Sun, 3 Dec 2017 23:01:47 -0500
Message-ID: <20171204040147.mhe6zom6h4mbx7cg@thunk.org>
References: <20171115115419.21862-1-eguan@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:56924 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752970AbdLDEBv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 3 Dec 2017 23:01:51 -0500
Content-Disposition: inline
In-Reply-To: <20171115115419.21862-1-eguan@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 15, 2017 at 07:54:19PM +0800, Eryu Guan wrote:
> Currently, fallocate(2) with KEEP_SIZE followed by a fdatasync(2)
> then crash, we'll see wrong allocated block number (stat -c %b), the
> blocks allocated beyond EOF are all lost. fstests generic/468
> exposes this bug.
> 
> Commit 67a7d5f561f4 ("ext4: fix fdatasync(2) after extent
> manipulation operations") fixed all the other extent manipulation
> operation paths such as hole punch, zero range, collapse range etc.,
> but forgot the fallocate case.
> 
> So similarly, fix it by recording the correct journal tid in ext4
> inode in fallocate(2) path, so that ext4_sync_file() will wait for
> the right tid to be committed on fdatasync(2).
> 
> Signed-off-by: Eryu Guan <eguan@redhat.com>

Thanks, applied.

						- Ted
