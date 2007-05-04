From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC/PATCH] ext3: remove inode constructor
Date: Fri, 4 May 2007 13:02:41 -0700
Message-ID: <20070504130241.c436eb43.akpm@linux-foundation.org>
References: <Pine.LNX.4.64.0705041311230.1455@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	sct@redhat.com, adilger@clusterfs.com, clameter@sgi.com
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52563 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031503AbXEDUD2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 May 2007 16:03:28 -0400
In-Reply-To: <Pine.LNX.4.64.0705041311230.1455@sbz-30.cs.Helsinki.FI>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 4 May 2007 13:14:35 +0300 (EEST)
Pekka J Enberg <penberg@cs.helsinki.fi> wrote:

> As explained by Christoph Lameter, ext3_alloc_inode() touches the same
> cache line as init_once() so we gain nothing from using slab
> constructors.  The SLUB allocator will be more effective without it
> (free pointer can be placed inside the free'd object), so move inode
> initialization to ext3_alloc_inode completely.

I got 100% rejects against this because Christoph has already had
his paws all over the slab constructor code everywhere.

Was going to fix it up but then decided that we ought to make changes
like this to ext4 as well.  Ideally beforehand, but simultaneously is
OK as long as it's simple enough.

btw, for a benchmark I'd suggest just a silly create-10000-files
tight loop rather than something more complex like postmark.
