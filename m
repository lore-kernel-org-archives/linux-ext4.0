From: Theodore Tso <tytso@mit.edu>
Subject: Re: [patch] Null dereference in ext4_ext_migrate()
Date: Sun, 15 Feb 2009 20:06:47 -0500
Message-ID: <20090216010647.GA22619@mini-me.lan>
References: <alpine.DEB.2.00.0901302346430.12904@bikeee>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: aneesh.kumar@linux.vnet.ibm.com, linux-ext4@vger.kernel.org,
	adilger@sun.com
To: Dan Carpenter <error27@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:37196 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755427AbZBPC4f (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 15 Feb 2009 21:56:35 -0500
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0901302346430.12904@bikeee>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 03, 2009 at 10:49:22AM +0300, Dan Carpenter wrote:
> There is a potential null dereference of tmp_inode.
>
> The patch also removes an unnecessary check for whether tmp_inode is null.
>
> This was found through a code checker (http://repo.or.cz/w/smatch.git/).  
> It looks like you might be able to trigger the error by trying to migrate 
> a readonly file system.  I have only compile tested though, sorry.

Thanks, I've included this in the ext4 patch queue to be pushed to Linus.

	     	      	      	       	     	   - Ted
