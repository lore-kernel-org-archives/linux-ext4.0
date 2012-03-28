From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] ext3: update documentation with barrier=1 default
Date: Wed, 28 Mar 2012 14:49:32 +0200
Message-ID: <20120328124932.GA16026@lst.de>
References: <1332923552-9854-1-git-send-email-stefanha@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-doc@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
	Christoph Hellwig <hch@lst.de>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1332923552-9854-1-git-send-email-stefanha@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Mar 28, 2012 at 09:32:32AM +0100, Stefan Hajnoczi wrote:
> Commit 00eacd6 ("ext3: make ext3 mount default to barrier=1") changed
> the default barrier mount option for ext3.  The documentation needs to
> be updated, so this patch does that.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
