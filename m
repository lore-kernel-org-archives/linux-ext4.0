From: tytso@mit.edu
Subject: Re: [PATCH] ext4: Add a missing trace hook
Date: Tue, 25 May 2010 10:09:54 -0400
Message-ID: <20100525140954.GI5556@thunk.org>
References: <4BFA37FC.1000709@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:45993 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755010Ab0EYOJ5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 May 2010 10:09:57 -0400
Content-Disposition: inline
In-Reply-To: <4BFA37FC.1000709@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 24, 2010 at 04:25:32PM +0800, Li Zefan wrote:
> Commit f8ec9d6837241865cf99bed97bb99f4399fd5a03 added a
> trace event ext4_da_release_space, but didn't add some
> corresponding trace hook.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Thanks for pointing this out, added to the ext4 tree.

       	   	    	      	       - Ted
