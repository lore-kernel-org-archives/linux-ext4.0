From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH, RFC V3] ext4: limit block allocations for
	indirect-block files to < 2^32
Date: Thu, 10 Sep 2009 17:33:37 -0400
Message-ID: <20090910213337.GC6705@mit.edu>
References: <4AA1920C.9040406@redhat.com> <4AA1D94F.8060703@redhat.com> <20090905164535.GL4197@webber.adilger.int> <4AA92307.4010304@redhat.com> <20090910211006.GF9372@webber.adilger.int> <4AA96CB0.3090309@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:38167 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752643AbZIJVdo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Sep 2009 17:33:44 -0400
Content-Disposition: inline
In-Reply-To: <4AA96CB0.3090309@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 10, 2009 at 04:16:32PM -0500, Eric Sandeen wrote:
> Ok, fine by me.  I can send an update.
> 
> Any suggestions on the naming issues?  (what's the official name for a
> "not-extent-based-file?")

What I normally use is "extent-mapped file" and "indirect block mapped
file", or "non-extent-mapped file".

						- Ted
