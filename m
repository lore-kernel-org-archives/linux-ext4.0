From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: dereference before check in ext4_move_extents()
Date: Tue, 15 May 2012 13:51:00 +0300
Message-ID: <20120515105100.GG16999@mwanda>
References: <20120513184321.GA16541@elgon.mountain>
 <4FB0C29F.2080403@rs.jp.nec.com>
 <20120514085151.GC16999@mwanda>
 <4FB1B913.8070300@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:42352 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104Ab2EOKrV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 May 2012 06:47:21 -0400
Content-Disposition: inline
In-Reply-To: <4FB1B913.8070300@rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 15, 2012 at 11:01:55AM +0900, Akira Fujita wrote:
> > Sorry, I apologize for that.  It's some new Smatch stuff I'm working
> > on.  I haven't pushed it yet.
> 
> Ok, I'll make a patch when new Smatch appears.
> 

That works.  The fix would be to remove the unnecessary NULL check
so there is no rush.

regards,
dan carpenter

