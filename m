From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/5 v2] e2fsprogs: Use punch hole as "discard" on
 regular files
Date: Thu, 15 Sep 2011 23:50:56 -0400
Message-ID: <20110916035056.GT28181@thunk.org>
References: <1313167380-3283-1-git-send-email-lczerner@redhat.com>
 <1313167380-3283-2-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, adilger@dilger.ca
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56175 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780Ab1IPDu6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 Sep 2011 23:50:58 -0400
Content-Disposition: inline
In-Reply-To: <1313167380-3283-2-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 12, 2011 at 06:42:57PM +0200, Lukas Czerner wrote:
> If e2fsprogs tools (mke2fs, e2fsck) is run on regular file instead of
> on block device, we can use punch hole instead of regular discard
> command which would not work on regular file anyway. This gives us
> several advantages. First of all when e2fsck is run with '-E discard'
> parameter it will punch out all ununsed space from the image, hence
> trimming down the file system image. And secondly, when creating an
> file system on regular file (with '-E discard' which is default), we
> can use punch hole to clear the file content, hence we can skip inode
> table initialization, because reads from sparse area returns zeros. This
> will result in faster file system creation (without the need to specify
> lazy_itable_init) and smaller images.
> 
> This commit also fixes some tests that would fail due to mke2fs showing
> discard progress, hence the output would differ.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Applied to the next branch, thanks.  (I combined the following patch
which added the configure.in test for linux/falloc.h, since it's
needed by this patch.)

					- Ted
