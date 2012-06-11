From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 5/4] exofs: Handle error from d_splice_alias()
Date: Mon, 11 Jun 2012 15:01:08 -0400
Message-ID: <20120611190108.GF16086@thunk.org>
References: <1338322067-17566-1-git-send-email-jack@suse.cz>
 <4FC5F8CC.20400@panasas.com>
 <20120608215950.GQ30000@ZenIV.linux.org.uk>
 <4FD611AA.5010006@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:49140 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750788Ab2FKTB2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Jun 2012 15:01:28 -0400
Content-Disposition: inline
In-Reply-To: <4FD611AA.5010006@panasas.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 11, 2012 at 06:41:30PM +0300, Boaz Harrosh wrote:
> 
> My point being that please any changes made to ext2, in this area please also
> apply to exofs, since it is just another copy/paste of ext2. I'll ACK any
> which way you guys decide to properly go with, as part of the VFS changes.

Well, I already have this quick and dirty fix to address the problem
in ext4.  See commit 7e936b7372.  If we need to make changes to all of
the file systems to accomodate some new VFS abstraction, it might be
worth considering whether it's easier/simpler to just put in a quick
check like I did for ext4 (just so I could plug the security hole[1]
quickly).

[1] It's a denial of service attack for kiosks that do automounts of
USB sticks; granted, it's not that big a of a security deal, but some
people care about such things.

Of course, if the new/changed VFS abstraction solves other problems,
that's cool, but if not, sometimes a simple brute force check is
better than something complicated if elegant.  :-)

      	    	     	    	 	   - Ted
