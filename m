From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Segmentation fault in mke2fs
Date: Sat, 14 Dec 2013 01:59:50 -0500
Message-ID: <20131214065950.GB24998@thunk.org>
References: <CAO_L5k9iSm88wrs9W_yNCD1i8sy0SXfXJdbCwL840Hnn6Ef-0g@mail.gmail.com>
 <CAO_L5k_cLUdXNOhsAP6TkxtTHWv5hafx1dTmruaZnVmyGG0oKg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Srivatsan Canchivaram <crsrivatstechnical@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39868 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751516Ab3LNG7x (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 14 Dec 2013 01:59:53 -0500
Content-Disposition: inline
In-Reply-To: <CAO_L5k_cLUdXNOhsAP6TkxtTHWv5hafx1dTmruaZnVmyGG0oKg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 13, 2013 at 06:33:22PM -0500, Srivatsan Canchivaram wrote:
> Hello,
> 
> I found that the segmentation fault occurs in optimized code (-O2). It
> does not happen when optimization is turned off. I am not sure what
> exactly happened but mke2fs is now able to get past that point.

This is really starting to smell like a compiler bug.  Are you sure
you are using a stable version of gcc?

> The command now fails at a different point:
> 
> ext2fs_mkdir: EXT2 directory corrupted while creating /lost+found
> 
> Tracing from the ext2fs_mkdir() function, I found that the code
> returns an error here:
> ext2fs_read_dir_block3(): returns EXT2_ET_DIR_CORRUPTED

The mke2fs program has just created the root directory, and when it is
trying to link the newly created lost+found directory to the root
directory, when it reads in the just-created root directory, when it
tries to byte-swap the directory block, the values found the root
directory were insane.

Combined with the fact that the other failure was someplace completely
diferent, I'm at this point deeply suspicious about your compiler tool
chain and/or your hardware where you are conducting your tests.

      	     	  	   	     	 - Ted
