From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: remove block_device_ejected
Date: Thu, 2 Apr 2015 23:57:42 -0400
Message-ID: <20150403035742.GG10991@thunk.org>
References: <1423920462-20646-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:48536 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887AbbDCD5p (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 2 Apr 2015 23:57:45 -0400
Content-Disposition: inline
In-Reply-To: <1423920462-20646-1-git-send-email-hch@lst.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Feb 14, 2015 at 06:27:42AM -0700, Christoph Hellwig wrote:
> bdi->dev now never goes away, so this function became useless.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Thanks, applied.  Sorry for the delay.

						- Ted
