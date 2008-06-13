From: Theodore Tso <tytso@mit.edu>
Subject: Re: git-clone problem
Date: Fri, 13 Jun 2008 11:43:18 -0400
Message-ID: <20080613154318.GF24675@mit.edu>
References: <48522544.50306@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Shen Feng <shen@cn.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:34442 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757400AbYFMPn2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 13 Jun 2008 11:43:28 -0400
Content-Disposition: inline
In-Reply-To: <48522544.50306@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 13, 2008 at 03:44:04PM +0800, Shen Feng wrote:
> Hello,
> 
> When I try to clone the ext4 development tree, I got the following error.
> Is there anything wrong?
> 
> [fenian@localhost ~]$ git-clone http://www.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git

Dont use the http transport; it's not very efficient, and often
breaks.  I've fixed it for now (the hook to automatically run "git
update-server-info" was missing), but you'll get much faster and more
reliable results if you clone via the URL:

git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git

Actually the best thing to do is if you already have a local
repository of the kernel, to do:

git clone -s my-clone-of-linus-tree ext4

The edit the .git/config file so the url for [remote "master"] is:

    git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git

... and do a "git pull".  This will be much more efficient since you
limit the amount of data that you have to pull down over the network.

Note that the ext4 patch queue tends to have a much more dynamic and
bleeding-edge set of patches than the ext4 git tree.  The ext4 patch
queue is a quilt patch series maintained at this git repository:

      git://repo.or.cz/ext4-patch-queue.git

	      	     	     	      	       - Ted
