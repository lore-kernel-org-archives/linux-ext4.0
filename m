From: number9652@yahoo.com
Subject: e2fsprogs bmap problem
Date: Fri, 15 May 2009 13:49:38 -0700 (PDT)
Message-ID: <382524.16755.qm@web43505.mail.sp1.yahoo.com>
Reply-To: number9652@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from n71.bullet.mail.sp1.yahoo.com ([98.136.44.36]:42512 "HELO
	n71.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752736AbZEOU4F (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 15 May 2009 16:56:05 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


I am running into a problem with the output of the function ext2fs_bmap in the ext2fs library version 1.41.5: when I send it an inode structure pointer as the third argument and the number of a deleted inode as the second argument, it seems to end up trying to read the deleted inode from disk (and results in the returned value block number being 0), when I expected it to just get the values from the inode structure I send to it.  This only happens if the inode contains an extent structure within it; when it has the indirect block structure it behaves as I expected.

I couldn't find the documentation for this function, so is this the right behavior for this function?  If so, is there a better way to retrieve the block numbers pointed to by an inode structure provided by the ext2fs library?

Thanks,
N






      

