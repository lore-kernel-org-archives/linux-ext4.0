From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] libext2fs: fix i_blocks for extent leaf create/delete
Date: Sun, 10 Jun 2012 23:53:01 -0400
Message-ID: <20120611035301.GA1437@thunk.org>
References: <1338489118-13483-1-git-send-email-adityakali@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Aditya Kali <adityakali@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:48979 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753244Ab2FKDxD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 10 Jun 2012 23:53:03 -0400
Content-Disposition: inline
In-Reply-To: <1338489118-13483-1-git-send-email-adityakali@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 31, 2012 at 11:31:58AM -0700, Aditya Kali wrote:
> When libext2fs allocates/deletes an extent leaf, the i_blocks
> value is incremented/decremented by fs->blocksize / 512. This
> is incorrect in case of bigalloc. The correct way here is to
> use cluster_size / 512.
> The problem is seen if we try to create a large inode using
> libext2fs (say using ext2fs_block_iterate3()) on a bigalloc
> filesystem. fsck catches this and complains.
> 
> Signed-off-by: Aditya Kali <adityakali@google.com>

Applied, thanks.

					- Ted
