From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: return FIEMAP_EXTENT_UNKNOWN if an extent is
 delayed allocations
Date: Tue, 18 Jun 2013 11:08:22 -0400
Message-ID: <20130618150822.GB7359@thunk.org>
References: <51B08F45.1050605@oracle.com>
 <20130607115422.GA12217@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Jeff Liu <jeff.liu@oracle.com>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:59029 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932227Ab3FRPIY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 18 Jun 2013 11:08:24 -0400
Content-Disposition: inline
In-Reply-To: <20130607115422.GA12217@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 07, 2013 at 07:54:22PM +0800, Zheng Liu wrote:
> On Thu, Jun 06, 2013 at 09:31:49PM +0800, Jeff Liu wrote:
> > From: Jie Liu <jeff.liu@oracle.com>
> > 
> > Return the FIEMAP_EXTENT_UNKNOWN flag as well except the
> > FIEMAP_EXTENT_DELALLOC because the data location of an
> > delayed allocation extent is unknown.
> > 
> > Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> 
> Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>

Thanks, applied.

					- Ted
