From: Theodore Tso <tytso@mit.edu>
Subject: Re: Ext4 corruption that will not go away
Date: Sun, 30 Aug 2009 11:41:44 -0400
Message-ID: <20090830154144.GC23828@mit.edu>
References: <E1LOG9D-0006h4-7R@closure.thunk.org> <20090119113300.GC9482@skywalker> <200908300025.48034.edt@aei.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Ed Tomlinson <edt@aei.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:43268 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753410AbZH3Plp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 30 Aug 2009 11:41:45 -0400
Content-Disposition: inline
In-Reply-To: <200908300025.48034.edt@aei.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Aug 30, 2009 at 12:25:47AM -0400, Ed Tomlinson wrote:
> Hi,
> 
> I am running 2.6.31-rc8+ and have ext4 corruption that will not go away.
> 
> My root fs is ext4 on sdb3.  I have moved the directory with corruption into lost+found and booted to a rescuse
> system (arch linux) and run fsck.ext4 on the filesystem, which then reports its clean...  Booting back into my
> gentoo system and attempting to remove the xx directory from lost+found gives:
> 
> [  172.408799] EXT4-fs error (device sdb3): ext4_ext_check_inode: bad header/extent in inode #706801: invalid magic - magic 0, entries 0, max 0(0), depth 0(0)

Can you send in the output of running fsck.ext4 on the filesystem, please?

    	     	    	      	      - Ted
