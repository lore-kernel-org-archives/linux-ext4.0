From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 1/2] ext4: use variables not types in sizeofs() for
	allocations
Date: Tue, 25 Aug 2009 22:40:29 -0400
Message-ID: <20090826024029.GC32712@mit.edu>
References: <4A8C5DA4.3050002@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:52269 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756493AbZHZCk3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Aug 2009 22:40:29 -0400
Content-Disposition: inline
In-Reply-To: <4A8C5DA4.3050002@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 19, 2009 at 03:16:36PM -0500, Eric Sandeen wrote:
> Precursor to changing some types; to keep things in sync, it 
> seems better to allocate/memset based on the size of the 
> variables we are using rather than on some disconnected 
> basic type like "unsigned short"
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Thanks, applied.

					- Ted
