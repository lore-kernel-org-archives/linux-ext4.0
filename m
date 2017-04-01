From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsck: fix type mismatches in quota warning message
Date: Sat, 1 Apr 2017 12:16:15 -0400
Message-ID: <20170401161615.wmxq6rvprif7bgvk@thunk.org>
References: <20170331232159.GA12986@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47956 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751726AbdDAQQT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 1 Apr 2017 12:16:19 -0400
Content-Disposition: inline
In-Reply-To: <20170331232159.GA12986@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 31, 2017 at 07:21:59PM -0400, Eric Whitney wrote:
> The conversion operations in the format control strings found in the
> fprintf call used to print the quota warning message do not match the
> types of their corresponding arguments.  Although this probably hasn't
> generally been a problem, it obfuscates a bigalloc quota accounting bug
> where the reported actual quota goes negative.
> 
> Clean up the mismatches and some unnecessary casts.  While we're at it,
> fix a spelling nit in a related comment.
> 
> Signed-off-by: Eric Whitney <enwlinux@gmail.com>

Thanks, applied.

					- Ted
