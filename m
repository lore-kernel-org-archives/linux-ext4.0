From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: why online shrink is not supported with EXT4_IOC_RESIZE_FS?
Date: Mon, 27 Aug 2012 11:51:41 -0600
Message-ID: <651BBBE5-D7E1-43C5-BC21-7E56CF12848C@dilger.ca>
References: <CAMTyv-FXzP-r3Eq3kuUQQsE221aNR1nGsfyEZ=w8eHo1eBL1SQ@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: raphel johnson <iraphel78@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:2281 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753767Ab2H0Rvm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Aug 2012 13:51:42 -0400
In-Reply-To: <CAMTyv-FXzP-r3Eq3kuUQQsE221aNR1nGsfyEZ=w8eHo1eBL1SQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-08-27, at 7:30 AM, raphel johnson wrote:
> I was referring EXT4_IOC_RESIZE_FS ioctl implementation in linux
> kernel ver 3.3.8.
> 
> It is given in the code that online shrinking not supported.
> 
> if (n_blocks_count < o_blocks_count) {
> /* On-line shrinking not supported */
> ext4_warning(sb, "can't shrink FS - resize aborted");
> return -EINVAL;
> }
> 
> I am new to ext4 file system. Could you please tell online shrinking
> issues in ext4.
> 
> Thanks in adavance.

There are several reasons for this:
- if blocks are in use beyond the new end of the filesystem, potentially
  all inodes in the filesystem need to be scanned to find the owner
- this also causes consistency issues with the page cache, since moving
  in-use disk blocks is tricky, and it isn't always possible to remove
  them from memory
- if in-use inodes are beyond the end of the new filesystem, potentially
  all of the directories in the filesystem need to be scanned to find the
  parent directory
- moving inodes in ext4 will also cause the inode number to change, which
  would break NFS and potentially other programs

In the end, rarely do users need to shrink a filesystem while mounted, so
the effort and complexity of doing this isn't worthwhile.

Cheers, Andreas





