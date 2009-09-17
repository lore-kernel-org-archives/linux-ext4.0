From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] replace MAX_DEFRAG_SIZE with EXT_MAX_BLOCK
Date: Thu, 17 Sep 2009 11:57:32 -0400
Message-ID: <20090917155731.GE24438@mit.edu>
References: <4AAEA7AF.6080801@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:33983 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753449AbZIQP5d (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 Sep 2009 11:57:33 -0400
Content-Disposition: inline
In-Reply-To: <4AAEA7AF.6080801@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 14, 2009 at 03:29:35PM -0500, Eric Sandeen wrote:
> There's no reason to redefine the maximum allowable offset
> in an extent-based file just for defrag; 
> EXT_MAX_BLOCK already does this.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Thanks, added to the ext4 patch queue.

						- Ted
