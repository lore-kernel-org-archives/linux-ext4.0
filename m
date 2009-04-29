From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH -V4 2/2] ext4: Use -1 as the fake block number for
	delayed new buffer_head
Date: Wed, 29 Apr 2009 12:52:10 -0400
Message-ID: <20090429165210.GD14264@mit.edu>
References: <1240980441-8105-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1240980441-8105-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20090429153521.GC14264@mit.edu> <49F8743E.7090201@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	cmm@us.ibm.com, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:41958 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755567AbZD2QwT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 29 Apr 2009 12:52:19 -0400
Content-Disposition: inline
In-Reply-To: <49F8743E.7090201@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 29, 2009 at 10:37:34AM -0500, Eric Sandeen wrote:
> Theodore Tso wrote:
> > On Wed, Apr 29, 2009 at 10:17:21AM +0530, Aneesh Kumar K.V wrote:
> >> Block number '0' should not be used as the fake block number for
> >> the delayed new buffer. This will result in vfs calling umap_underlying_metadata for
> >> block number '0'. So  use -1 instead.
> > 
> > sector_t is an unsigned type, so we probably want to use ~0 instead of
> > -1.  I can fix this up before we apply into the patch queue.
> 
> I don't think that helps.  The point is to have a block number which is
> invalid, therefore won't get unmapped or accidentally written to ...

This is more of a type-safety thing to eliminate compiler warnings.
We could use something like s_blocks_count instead, which has less
chance of wrapping, but by the time we get to the bh level, the risk
of wrapping should be minimal, and ~0 (or -1) is more distinctive when
debugging/tracing.

					- Ted
