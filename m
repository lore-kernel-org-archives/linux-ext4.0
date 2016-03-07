From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: misc: replace comparison macros with inline functions
Date: Sun, 6 Mar 2016 21:24:14 -0500
Message-ID: <20160307022414.GA6259@thunk.org>
References: <1457224216-71316-1-git-send-email-adilger@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38574 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341AbcCGCYR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 6 Mar 2016 21:24:17 -0500
Content-Disposition: inline
In-Reply-To: <1457224216-71316-1-git-send-email-adilger@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Mar 05, 2016 at 05:30:16PM -0700, Andreas Dilger wrote:
> Replace the EXT2FS_RB_EMPTY_ROOT(), EXT2FS_RB_EMPTY_NODE(),
> EXT2FS_RB_CLEAR_NODE(), IS_BLOCK_BM(), IS_INODE_BM(), and
> IS_INODE_TB() macros with static inline functions to avoid
> suprious compiler warnings with clang:
> 
> 	pass1.c:618:28: warning: equality comparison with extraneous
> 		parentheses [-Wparentheses-equality]
> 	if ((*((__u32 *)(entry)) == 0UL)) {
>              ~~~~~~~~~~~~~~~~~~~~^~~~~~
> 	pass1.c:618:28: note: remove extraneous parentheses
> 		around the comparison to silence this warning
> 	if ((*((__u32 *)(entry)) == 0UL)) {
> 				 ^~
> 	pass1.c:618:28: note: use '=' to turn this equality
> 		comparison into an assignment
> 	if ((*((__u32 *)(entry)) == 0UL)) {
> 				 ^~
> 				 =
> 
> The static inline functions should compile identically, and allow
> some extra compile-time checking for the arguments over macros.
> 
> Signed-off-by: Andreas Dilger <adilger@dilger.ca>

Thanks, applied.

						- Ted
