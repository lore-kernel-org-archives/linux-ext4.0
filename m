From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] e2image: truncate raw image file to correct size
Date: Fri, 17 Feb 2012 09:30:26 -0500
Message-ID: <20120217143026.GA19606@thunk.org>
References: <1329428112-8911-1-git-send-email-psusi@ubuntu.com>
 <20120216225810.GB26473@thunk.org>
 <4F3D8D01.5040604@ubuntu.com>
 <20120216233031.GD26473@thunk.org>
 <alpine.LFD.2.00.1202171054320.6479@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Phillip Susi <psusi@ubuntu.com>, linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:55877 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751037Ab2BQOac (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 17 Feb 2012 09:30:32 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1202171054320.6479@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 17, 2012 at 11:04:22AM +0100, Lukas Czerner wrote:
> > lseek(5, 1048576, SEEK_CUR)             = 16105177088
>   ^^^^^^^^^^^^^^^^^^^^^^^^^^^
> So if blocks count ends right here^^, then the last write would not
> happen, because sparse == 0. The reason is that we will seek when the
> sparse >= 1024*1024 and then set sparse = 0

Yes, there are two cases when sparse can get set to zero.  I was
thinking of the other one; thanks for pointing that out.

> We can easily fix that by doing this instead:
> 
> if (sparse > 1024*1024) {
> 	write_block(fd, 0, 1024*1024, 0, 0);
> 	sparse -= 1024*1024;
> }

Yep, thanks for the suggestion; I like that.  I'll chain to this
message the two patches that I've put together which I think should
address this issue.  The first uses your suggestion so sparse never
gets set to zero when we are still extending the hole.

The second uses ftruncate64() if possible to set i_size (which saves
allocating a block, which is cool when it works).

What do folks think?

	     	    	     	       	  - Ted
