From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix overhead calculations in ext4_stats, again
Date: Thu, 8 Nov 2012 10:34:31 -0500
Message-ID: <20121108153431.GA766@thunk.org>
References: <50896FD6.1010807@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60072 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756768Ab2KHWLB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 8 Nov 2012 17:11:01 -0500
Content-Disposition: inline
In-Reply-To: <50896FD6.1010807@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 25, 2012 at 11:59:02AM -0500, Eric Sandeen wrote:
> "overhead" was a write-only variable in this function after commit
> 952fc18e; we set it to 0 for minixdf, or to sbi->s_overhead if !minixdf,
> but never read it again after that.
> 
> We need to use it, not sbi->s_overhead, when subtracting out overhead
> for f_blocks, or we get the wrong answer for minixdf.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Thanks, applied.

					- Ted
