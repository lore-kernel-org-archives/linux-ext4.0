From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: Repost (from LKML): EXT3 FS and 64K blocks error
Date: Fri, 9 Jul 2010 08:03:35 -0400
Message-ID: <7D7CBABC-08DF-4D5D-9655-D378529882B0@mit.edu>
References: <469D2D911E4BF043BFC8AD32E8E30F5B24AEE9@wdscexbe07.sc.wdc.com>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: <linux-ext4@vger.kernel.org>
To: "Daniel Taylor" <Daniel.Taylor@wdc.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-3.MIT.EDU ([18.9.25.14]:50672 "EHLO
	dmz-mailsec-scanner-3.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753849Ab0GIMDj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Jul 2010 08:03:39 -0400
In-Reply-To: <469D2D911E4BF043BFC8AD32E8E30F5B24AEE9@wdscexbe07.sc.wdc.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Jul 8, 2010, at 8:10 PM, Daniel Taylor wrote:

> We're getting the following error with an EXT3 file sytem that
> has 64K blocks (2.6.32.12, on a powerpc), although I don't see
> any fixes for later kernels in a diff against 2.6.35-rc3):
> 
> ext3_readdir: bad entry in directory #11: rec_len is smaller than minimal -
> offset=0, inode=0, rec_len=0, name_len=0
> 
> That message is generated in fs/ext3/dir.c:ext3_check_dir_entry()
> when called from fs/ext3/dir.c:ext3_readdir(), AFAICT.
> 
> Did something get missed when EXT3 handling for 64K blocks was
> implemented or when a new feature was added?
> 
> FWIW, I do NOT see this on EXT4.

I very much doubt anyone has ever tested 64k blocks on ext3.  There were
some extensions made to support 64k blocks with ext4, that had to do
with encoding the directory entry rec_len fields (which is 16 bits and will
overflow when trying to store the value 65536, as you have discovered).

Bottom line, it's not so much that EXT3 handling for 64k blocks was ever
*implemented*, as much as no one really thought about it much when
they set the #define's for maximum block size supported.  :-)

64k block sizes hasn't received much testing on ext4 as far as I know, but 
there was one developer who noted the dirent encoding problem and
proposed a fix.

Is there a particular reason why you care about this with ext3?   Ext4 does
provide a superset of the features in ext3...

-- Ted

