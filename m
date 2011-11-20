From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] dumpe2fs: dump blocks count used by super and GDT
Date: Sat, 19 Nov 2011 23:43:10 -0500
Message-ID: <20111120044310.GJ4130@thunk.org>
References: <1321405328-5298-1-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:53973 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755138Ab1KTEnP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 19 Nov 2011 23:43:15 -0500
Content-Disposition: inline
In-Reply-To: <1321405328-5298-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 16, 2011 at 09:02:07AM +0800, Yongqiang Yang wrote:
> Blocks count used by super and GDT is dumped so that users
> can know how many blocks are taken up by super and GDT.
> 
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>

I'm not convinced this is sufficiently useful to be worth adding to
dumpe2fs.  How many users really need to know this?

	       	    	  	      - Ted
