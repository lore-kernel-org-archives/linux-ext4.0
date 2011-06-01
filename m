From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsck: don't check/clone duplicate xattr blocks in fs
 without xattr feature
Date: Tue, 31 May 2011 20:00:16 -0400
Message-ID: <20110601000016.GB2629@thunk.org>
References: <4D52DFE7.4050301@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:36894 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161005Ab1FACW0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 31 May 2011 22:22:26 -0400
Content-Disposition: inline
In-Reply-To: <4D52DFE7.4050301@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 09, 2011 at 12:41:43PM -0600, Eric Sandeen wrote:
> I had an extremely corrupted customer filesystem which, after thousands
> of lines of e2fsck output, found one more problem on an immediately
> subsequent e2fsck.  In short, a file had had its i_file_acl block
> cloned due to being a duplicate.  That ultimately got cleared
> because the fs did not have the xattr feature, and the inode
> was subsequently removed due to invalid mode.
> 
> The 2nd e2fsck pass found the cloned xattr block as in use, but
> not owned by any file, and had to fix up the block bitmaps.
> 
> Simply skipping the processing of duplicate xattr blocks on a
> non-xattr filesystem seems reasonable, since they will be cleared
> later in any case.
> 
> (also fix existing brace misalignment)
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Applied, sorry for the delay.

						- Ted
