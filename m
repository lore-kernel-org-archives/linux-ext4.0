From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH -V2 4/4] ext4: Add WARN_ON on unmapped dirty
	buffer_heads in writepage
Date: Thu, 4 Jun 2009 09:50:45 -0400
Message-ID: <20090604135045.GJ21314@mit.edu>
References: <1244095805-17015-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1244095805-17015-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1244095805-17015-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1244095805-17015-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org,
	Jan Kara <jack@suse.cz>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:41484 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750787AbZFDNur (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Jun 2009 09:50:47 -0400
Content-Disposition: inline
In-Reply-To: <1244095805-17015-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 04, 2009 at 11:40:05AM +0530, Aneesh Kumar K.V wrote:
> Now we have block_lock_hole_extend clearing the dirty flag of
> buffer_heads outside i_size we should not find buffer_heads
> which are unmapped and dirty in writepage. If we find do a WARN_ON.
> We can still continue because block_write_full page look at the mapped
> flag only.

This is only true only *after* Jan's patches are applied, right?  So
that means it's only safe to apply this after Jan's patch series is
applied.  So I believe I need to queue this in the unstable portion of
the patch queue until the page_mkwrite() changes are applied;
otherwise we could have some spurious WARN_ON's.

					- Ted
