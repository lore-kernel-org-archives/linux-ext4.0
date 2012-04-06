From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Commit c1a1e7fc24d6 causes segfault in ext2fs_new_inode
Date: Fri, 6 Apr 2012 11:57:59 -0700
Message-ID: <20120406185759.GA5584@thunk.org>
References: <20120330125726.GA26221@amd.home.annexia.org>
 <20120330131936.GB26221@amd.home.annexia.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Sami Liedes <sami.liedes@iki.fi>
To: "Richard W.M. Jones" <rjones@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60248 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757884Ab2DFTyN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 6 Apr 2012 15:54:13 -0400
Content-Disposition: inline
In-Reply-To: <20120330131936.GB26221@amd.home.annexia.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 30, 2012 at 02:19:36PM +0100, Richard W.M. Jones wrote:
> 
> A bit of further investigation:
> 
> I'm currently not passing EXT2_FLAG_64BITS when opening the
> filesystem.  Passing this flag fixes the issue, so I'm going to do
> that (are there any downsides?)

No, there are no downsides with passing in EXT2_FLAG_64BITS (and it's
actually a good idea in case Fedora ever supports booting on ext4 file
systems with block numbers > 32 bits).  Still, it should have worked.

I'll chain the patches which should fix this to this message.

     	       	       	     	    	- Ted
