From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH, RFC V3] ext4: limit block allocations for
	indirect-block files to < 2^32
Date: Thu, 10 Sep 2009 12:53:27 -0400
Message-ID: <20090910165327.GB23700@mit.edu>
References: <4AA1920C.9040406@redhat.com> <4AA1D94F.8060703@redhat.com> <20090905164535.GL4197@webber.adilger.int> <4AA92307.4010304@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:45583 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858AbZIJQxb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Sep 2009 12:53:31 -0400
Content-Disposition: inline
In-Reply-To: <4AA92307.4010304@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 10, 2009 at 11:02:15AM -0500, Eric Sandeen wrote:
> Today, the ext4 allocator will happily allocate blocks past
> 232 for indirect-block files, which results in the block
> numbers getting truncated, and corruption ensues.

Everywhere where you say 232, you mean 2^32, right?

	   	     	      	       	     - Ted
