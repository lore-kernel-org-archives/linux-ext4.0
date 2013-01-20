From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Resize2fs corrupts ext4 fs with bigalloc [Was: Re: Release
 candidate for e2fsprogs 1.42.7]
Date: Sun, 20 Jan 2013 00:27:44 -0500
Message-ID: <20130120052744.GC9874@thunk.org>
References: <201301182047.53924.jon@severinsson.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jon Severinsson <jon@severinsson.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44377 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890Ab3ATFdi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 20 Jan 2013 00:33:38 -0500
Content-Disposition: inline
In-Reply-To: <201301182047.53924.jon@severinsson.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 18, 2013 at 08:47:16PM +0100, Jon Severinsson wrote:
> 
> In both versions resize2fs corrupts a clean ext4 fs if bigalloc is
> enabled.
> 

Thanks for the bug report.  From what I can tell, resize2fs never
worked correctly on bigalloc file systems.  The following patches seem
to fix it, but we need to do more careful testing before I'd trust
resize2fs to resize bigalloc file systems containing production data.

	     	    	     	  - Ted
