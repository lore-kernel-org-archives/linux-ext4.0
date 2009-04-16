From: Karel Zak <kzak@redhat.com>
Subject: Re: [PATCH] blkid: add --disable-libblkid (v2)
Date: Thu, 16 Apr 2009 12:22:41 +0200
Message-ID: <20090416102241.GA3290@nb.net.home>
References: <20090224084434.GF6020@nb.net.home> <20090324121147.GA22386@zelda.netsplit.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Scott James Remnant <scott@ubuntu.com>,
	Kay Sievers <kay.sievers@vrfy.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:60539 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752204AbZDPKWr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Apr 2009 06:22:47 -0400
Content-Disposition: inline
In-Reply-To: <20090324121147.GA22386@zelda.netsplit.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 24, 2009 at 12:11:47PM +0000, Scott James Remnant wrote:
> Karel Zak wrote:
> 
> > I found some bugs in my previous patches. Please, use the patch
> > below. This patch includes all necessary changes. Sorry.
> > 
> When putting together an Ubuntu package with this patch, I found that it
> ends up putting the pkg-config output into the make dependency variables
> and thus fails because it can't make the "-L/lib" target.
> 
> The attached patch fixes that, and includes your previous patch.

 Ted, ping ping ping... :-) Please, we need your feedback.

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
