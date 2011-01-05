From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 6/6] ext4: Dynamically allocate the jbd2_inode in
 ext4_inode_info as necessary
Date: Wed, 5 Jan 2011 15:21:48 -0500
Message-ID: <20110105202148.GN2959@thunk.org>
References: <1294189270-16733-1-git-send-email-tytso@mit.edu>
 <1294189270-16733-7-git-send-email-tytso@mit.edu>
 <AANLkTinyCRL=Gu1eUG3gM6zyiKC+Jo87JoCgfwcpyB+f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:54551 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751683Ab1AEUVv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 5 Jan 2011 15:21:51 -0500
Content-Disposition: inline
In-Reply-To: <AANLkTinyCRL=Gu1eUG3gM6zyiKC+Jo87JoCgfwcpyB+f@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 05, 2011 at 11:26:05AM +0200, Amir Goldstein wrote:
> 
> if (jinode)
>     // ei->jinode was allocated after first test - can it happen?
>     // if not, then 2nd test under spinlock is not needed
>     jbd2_free_inode(jinode);

Good point; currently if there are two CPU's racing to open the file,
we could end up with a memory leak.  Thanks for pointing that out!

   	     	       	      	     	    - Ted
