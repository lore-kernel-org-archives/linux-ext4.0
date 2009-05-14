From: Theodore Tso <tytso@mit.edu>
Subject: Re: More ext4 acl/xattr corruption - 4th occurence now
Date: Thu, 14 May 2009 08:30:43 -0400
Message-ID: <20090514123043.GF11352@mit.edu>
References: <20090513062634.GE4972@kulgan> <20090514044011.GC11352@mit.edu> <20090514110659.GA5146@kulgan> <ea11fea30905140417i53c252cbra7c8041021d425e1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kevin Shanahan <kmshanah@ucwb.org.au>, linux-ext4@vger.kernel.org
To: Manish Katiyar <mkatiyar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:53999 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753127AbZENMau (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 May 2009 08:30:50 -0400
Content-Disposition: inline
In-Reply-To: <ea11fea30905140417i53c252cbra7c8041021d425e1@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 14, 2009 at 04:47:14PM +0530, Manish Katiyar wrote:
> 
> Hi Ted,
> 
> If we have the possibility of applying patches why not apply this too
> and try http://markmail.org/message/e3uwzxrd42isxczg . After all it
> originated from this bug only.

Because I implemented this functionality already in
fs/ext4/inode.c:ext4_iget().  Check out commit 563bdd61 in the kernel
mainline.  (It's not yet in stable release, as it was merged after the
2.6.29 merge window.)

							- Ted
