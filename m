From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] ext4: optimize ext4_ext_convert_to_initialized()
Date: Thu, 27 Oct 2011 11:46:16 -0400
Message-ID: <20111027154616.GF31921@thunk.org>
References: <1317020069-16355-1-git-send-email-egouriou@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Gouriou <egouriou@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46628 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752650Ab1J0PqU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 27 Oct 2011 11:46:20 -0400
Content-Disposition: inline
In-Reply-To: <1317020069-16355-1-git-send-email-egouriou@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Sep 25, 2011 at 11:54:28PM -0700, Eric Gouriou wrote:
> This patch introduces a fast path in ext4_ext_convert_to_initialized()
> for the case when the conversion can be performed by transferring
> the newly initialized blocks from the uninitialized extent into
> an adjacent initialized extent. Doing so removes the expensive
> invocations of memmove() which occur during extent insertion and
> the subsequent merge.
> 
> In practice this should be the common case for clients performing
> append writes into files pre-allocated via
> fallocate(FALLOC_FL_KEEP_SIZE). In such a workload performed via
> direct IO and when using a suboptimal implementation of memmove()
> (x86_64 prior to the 2.6.39 rewrite), this patch reduces kernel CPU
> consumption by 32%.
> 
> Two new trace points are added to ext4_ext_convert_to_initialized()
> to offer visibility into its operations. No exit trace point has
> been added due to the multiplicity of return points. This can be
> revisited once the upstream cleanup is backported.
> 
> Signed-off-by: Eric Gouriou <egouriou@google.com>

Thanks, applied.

						- Ted
