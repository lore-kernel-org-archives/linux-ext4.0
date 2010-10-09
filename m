From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] fix oops in ext4_mb_release_group_pa tracing
Date: Sat, 9 Oct 2010 18:26:28 -0400
Message-ID: <20101009222628.GB11237@thunk.org>
References: <4C6D7116.2080905@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Josef Bacik <josef@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:51795 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753212Ab0JIW02 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 9 Oct 2010 18:26:28 -0400
Content-Disposition: inline
In-Reply-To: <4C6D7116.2080905@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 19, 2010 at 12:59:50PM -0500, Eric Sandeen wrote:
> Our QA reported an oops in the ext4_mb_release_group_pa tracing,
> and Josef Bacik pointed out that it was because we may have a
> non-null but uninitialized ac_inode in the allocation context.
> 
> I can reproduce it when running xfstests with ext4 tracepoints on, 
> on a CONFIG_SLAB_DEBUG kernel.
> 
> We call trace_ext4_mb_release_group_pa from 2 places, 
> ext4_mb_discard_group_preallocations and 
> ext4_mb_discard_lg_preallocations
> 
> In both cases we allocate an ac as a container just for tracing (!)
> and never fill in the ac_inode.  There's no reason to be assigning,
> testing, or printing it as far as I can see, so just remove it from
> the tracepoint.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Thanks for the ping; I've added it to the ext4 patch tree.

       	       	     	  	      - Ted
