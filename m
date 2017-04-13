From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] libext2fs: apply LDFLAGS when building tst_inline_data
Date: Thu, 13 Apr 2017 11:49:42 -0400
Message-ID: <20170413154942.q56fhnziwjdo7rp2@thunk.org>
References: <20170317223836.61289-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Eric Biggers <ebiggers@google.com>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34258 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751463AbdDMPto (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 13 Apr 2017 11:49:44 -0400
Content-Disposition: inline
In-Reply-To: <20170317223836.61289-1-ebiggers3@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 17, 2017 at 03:38:36PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> If libext2fs was compiled with an external libblkid pointed to by
> LDFLAGS, then linking the tst_inline_data program failed because the
> requested linker flags were not used.  Fix this by adding $(ALL_LDFLAGS)
> to the build rule, as is done for the other test programs.
> 
> Fixes: 31253488385a ("libext2fs: add a unit test for inline data")
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Thanks, applied.

					- Ted
