From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] ext4: optimize memmmove lengths in extent/index
 insertions
Date: Thu, 27 Oct 2011 11:56:40 -0400
Message-ID: <20111027155640.GG31921@thunk.org>
References: <1317020069-16355-1-git-send-email-egouriou@google.com>
 <1317020069-16355-2-git-send-email-egouriou@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Gouriou <egouriou@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:55274 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752970Ab1J0P4o (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 27 Oct 2011 11:56:44 -0400
Content-Disposition: inline
In-Reply-To: <1317020069-16355-2-git-send-email-egouriou@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Sep 25, 2011 at 11:54:29PM -0700, Eric Gouriou wrote:
> ext4_ext_insert_extent() (respectively ext4_ext_insert_index())
> was using EXT_MAX_EXTENT() (resp. EXT_MAX_INDEX()) to determine
> how many entries needed to be moved beyond the insertion point.
> In practice this means that (320 - I) * 24 bytes were memmove()'d
> when I is the insertion point, rather than (#entries - I) * 24 bytes.
> 
> This patch uses EXT_LAST_EXTENT() (resp. EXT_LAST_INDEX()) instead
> to only move existing entries. The code flow is also simplified
> slightly to highlight similarities and reduce code duplication in
> the insertion logic.
> 
> This patch reduces system CPU consumption by over 25% on a 4kB
> synchronous append DIO write workload when used with the
> pre-2.6.39 x86_64 memmove() implementation. With the much faster
> 2.6.39 memmove() implementation we still see a decrease in
> system CPU usage between 2% and 7%.
> 
> Note that the ext_debug() output changes with this patch, splitting
> some log information between entries. Users of the ext_debug() output
> should note that the "move %d" units changed from reporting the number
> of bytes moved to reporting the number of entries moved.
> 
> Signed-off-by: Eric Gouriou <egouriou@google.com>

Applied, although the patch needed to be tweaked slightly to apply
given recent changes to the surrounding code.  I think I merged in the
patch correctly, but I want to run some extended tests to make sure no
problems turn up.

      	      	       		      	 - Ted
