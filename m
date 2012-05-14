From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: dereference before check in ext4_move_extents()
Date: Mon, 14 May 2012 11:51:51 +0300
Message-ID: <20120514085151.GC16999@mwanda>
References: <20120513184321.GA16541@elgon.mountain>
 <4FB0C29F.2080403@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:36770 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755158Ab2ENIsQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 May 2012 04:48:16 -0400
Content-Disposition: inline
In-Reply-To: <4FB0C29F.2080403@rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 14, 2012 at 05:30:23PM +0900, Akira Fujita wrote:
> I'll fix above compile warning surely, but it's not the original
> you reported. Hmm, how can I reproduce yours?
> 

Sorry, I apologize for that.  It's some new Smatch stuff I'm working
on.  I haven't pushed it yet.

regards,
dan carpenter

