From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Fix memory leak in ext4_fill_super()
Date: Mon, 18 May 2009 00:09:36 -0400
Message-ID: <20090518040936.GH32019@mit.edu>
References: <ea11fea30905141137t4c35c029k3ed746af8de84407@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 <linux-ext4@vger.kernel.org>
To: Manish Katiyar <mkatiyar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:34040 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753283AbZEREJk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 May 2009 00:09:40 -0400
Content-Disposition: inline
In-Reply-To: <ea11fea30905141137t4c35c029k3ed746af8de84407@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 15, 2009 at 12:07:27AM +0530, Manish Katiyar wrote:
> We forget to free up the space allocated for s_blockgroup_lock in case
> of failed mounts.
> Below patch fixes up the memory leak.

Thanks, I've applied the ext2, ext3, and ext4 patches into the patch
queue for submission to Linus at the next merge window.

      	  	     	      	 - Ted
