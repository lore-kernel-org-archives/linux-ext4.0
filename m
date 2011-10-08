From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsck: Recover revoke blocks on 64bit filesystems
 correctly
Date: Sat, 8 Oct 2011 13:37:39 -0400
Message-ID: <20111008173739.GD7948@thunk.org>
References: <20111008072909.16622.37880.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60489 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753209Ab1JHRhp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 8 Oct 2011 13:37:45 -0400
Content-Disposition: inline
In-Reply-To: <20111008072909.16622.37880.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Oct 08, 2011 at 12:29:09AM -0700, Darrick J. Wong wrote:
> Since the advent of 64bit filesystems, revoke blocks store 64-bit block numbers
> instead of 32-bit block numbers.  Therefore we need to be able to handle that
> case.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>

Thanks, applied.

						- Ted
