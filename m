From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext3: update documentation with barrier=1 default
Date: Thu, 29 Mar 2012 17:29:26 +0200
Message-ID: <20120329152926.GC19400@quack.suse.cz>
References: <1332923552-9854-1-git-send-email-stefanha@linux.vnet.ibm.com>
 <20120328124932.GA16026@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>,
	linux-doc@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44851 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932609Ab2C2P3o (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 29 Mar 2012 11:29:44 -0400
Content-Disposition: inline
In-Reply-To: <20120328124932.GA16026@lst.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 28-03-12 14:49:32, Christoph Hellwig wrote:
> On Wed, Mar 28, 2012 at 09:32:32AM +0100, Stefan Hajnoczi wrote:
> > Commit 00eacd6 ("ext3: make ext3 mount default to barrier=1") changed
> > the default barrier mount option for ext3.  The documentation needs to
> > be updated, so this patch does that.
> 
> Looks good,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
  Thanks. I've added the patch to my tree.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
