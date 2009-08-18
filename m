From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH V2] reject too-large filesystems on 32-bit kernels
Date: Mon, 17 Aug 2009 23:47:24 -0400
Message-ID: <20090818034724.GA27339@mit.edu>
References: <4A833CED.2010708@redhat.com> <4A83427F.60106@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:38500 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750802AbZHRDr0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 Aug 2009 23:47:26 -0400
Content-Disposition: inline
In-Reply-To: <4A83427F.60106@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 12, 2009 at 05:30:23PM -0500, Eric Sandeen wrote:
> ext4 will happily mount a > 16T filesystem on a 32-bit box, but
> this is not safe; writes to the block device will wrap past 16T
> and the page cache can't index past 16T (232 index * 4k pages).

Applied in the ext4 patch queue, with minor changes to take into
account the use of ext4_msg().

					- Ted
