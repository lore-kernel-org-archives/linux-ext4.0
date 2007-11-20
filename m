From: Theodore Tso <tytso@mit.edu>
Subject: Re: e2fsprogs-interim scm tree?
Date: Mon, 19 Nov 2007 22:11:28 -0500
Message-ID: <20071120031127.GB13125@thunk.org>
References: <alpine.DEB.0.99999.0711200128130.7426@sheep.housecafe.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Christian Kujau <lists@nerdbynature.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:59146 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751960AbXKTDL6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Nov 2007 22:11:58 -0500
Content-Disposition: inline
In-Reply-To: <alpine.DEB.0.99999.0711200128130.7426@sheep.housecafe.de>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Nov 20, 2007 at 01:42:58AM +0100, Christian Kujau wrote:
> Hi,
>
> I just started to use ext4 and wondered if there is some git/svn/hg/etc 
> repository for the e2fsprogs-interim? And, is there any timeframe when ext4 
> support will make it into the mainline tree for e2fsprogs? Will
> there be a mkfs.ext4 too?

There is a git tree.  It's at:

http://git.kernel.org/?p=fs/ext2/e2fsprogs.git;a=summary

The bleeding edge branch is the 'pu' (proposed updates), which you
need if you want the full ext4 features.  Note that the userspace code
still needs a lot of work.  It's for this reason that I haven't been
recommending people use it for production systems just yet.

In the next few weeks I will hopefully have more time to work on
e2fsprogs, so it should be much better by after the holidays.

	      	 	    	 	- Ted
