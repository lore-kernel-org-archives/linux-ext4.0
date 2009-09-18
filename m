From: Theodore Tso <tytso@mit.edu>
Subject: Re: git svn clone freezes the pc on ext4
Date: Fri, 18 Sep 2009 15:38:11 -0400
Message-ID: <20090918193811.GB27303@mit.edu>
References: <20090917131356.GG9393@kubieziel.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jens Kubieziel <maillist@kubieziel.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:41949 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758069AbZIRTiM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Sep 2009 15:38:12 -0400
Content-Disposition: inline
In-Reply-To: <20090917131356.GG9393@kubieziel.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 17, 2009 at 03:13:56PM +0200, Jens Kubieziel wrote:
> 
> I recently changed my /home-partition to ext4 and wanted to clone a SVN
> repository. After calling "git svn clone https://...", git began
> fetching old revisions and at every try the complete pc freezes. It
> doesn't respond to any keyboard presses nor to SysRq. I tried the same
> command on different filesystems (ext3, reiser) and with different git
> versions. Only git on ext4 causes this freeze.
> 
> The system logs have no uncommon messages. I found only:
> EXT4 FS on sda3, internal journal on sda3:8
> EXT4-fs: deleayed allocation enabled
> EXT4-fs: file extents enabled
> EXT4-fs: mballoc enabled
> EXT4-fs: mounted filesystem with ordered data mode
> Linux version is 2.6.28-15 (default installation from Ubuntu jaunty).

This sounds like the classic Ubuntu Jaunty's default kernel freezes
when deleting large numbers of files.  It didn't occur with stock
mainline 2.6.28, nor with stock mainline 2.6.29, and it bisected to
one of Ubuntu's ext4 patch backports.  No one was able to debug it
further, and I was never able to replicate it on my test systems, so
we ultimately just told people to use a mainstream kernel or a Karmic
beta kernel for people who wanted to use ext4 with Ubuntu Jaunty.

     	    	       	   	     	 - Ted
