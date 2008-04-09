From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: e2fsck (git) on ext4: unsupported feature(s): huge_file
Date: Wed, 9 Apr 2008 15:06:34 -0400
Message-ID: <20080409190634.GA9430@mit.edu>
References: <47FBB24D.90807@yahoo.de> <47FBBB13.7060501@redhat.com> <47FBCB44.1050500@yahoo.de> <20080408210048.GA16108@mit.edu> <47FC892C.5080000@yahoo.de> <20080409161117.GB26924@mit.edu> <47FD0724.4060307@yahoo.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: supersud501 <supersud501@yahoo.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:61583 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753847AbYDITG6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Apr 2008 15:06:58 -0400
Content-Disposition: inline
In-Reply-To: <47FD0724.4060307@yahoo.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 09, 2008 at 08:12:52PM +0200, supersud501 wrote:
>
> with this patch (and huge_files enabled) i get much more errors (>1000++) 
> of the following type:
>
> inode x, i_blocks is y, should be y/8
> inoda x+1, iblocks is z, should be z/8
> .....
>
> for example:
>
> Inode 32538663, i_blocks is 8, should be 1.  Fix? no
> Inode 32538664, i_blocks is 8, should be 1.  Fix? no

Can you send me the output of debugfs's "stat <32538663>", "stat
<32538664>", etc?   And also the output of dumpe2fs -h for the filesystem?

	     	    	     	 	   - Ted
