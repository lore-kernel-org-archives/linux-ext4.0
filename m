From: tytso@mit.edu
Subject: Re: [PATCH] ext4: remove vestiges of nobh support
Date: Tue, 15 Jun 2010 12:16:21 -0400
Message-ID: <20100615161621.GA6463@thunk.org>
References: <20100607082054.GB29155@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:39859 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752650Ab0FOQQZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Jun 2010 12:16:25 -0400
Content-Disposition: inline
In-Reply-To: <20100607082054.GB29155@lst.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 07, 2010 at 10:20:54AM +0200, Christoph Hellwig wrote:
> The nobh option was only supported for writeback mode, but given that all
> write paths actually create buffer heads it effectively was a no-op already.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Added to the ext4 patch queue, thanks.

				- Ted
