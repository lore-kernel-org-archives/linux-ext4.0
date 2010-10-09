From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [RESEND][PATCH] ext4: create own llseek function to handle 2
 maxbytes
Date: Sat, 9 Oct 2010 16:38:12 -0400
Message-ID: <20101009203812.GA5914@thunk.org>
References: <20100917143225.3e0d856a.toshi.okajima@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
To: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:44838 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757112Ab0JIUiR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 9 Oct 2010 16:38:17 -0400
Content-Disposition: inline
In-Reply-To: <20100917143225.3e0d856a.toshi.okajima@jp.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 17, 2010 at 02:32:25PM +0900, Toshiyuki Okajima wrote:
> From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
> 
> If the file has no "EXT4_EXTENTS_FL" flag, the maximum size which can be 
> written (write systemcall) is different from the maximum size which can be 
> sought (lseek systemcall).

Thanks, applied.  My apologies for the delay in getting back to you.

BTW, directories are not allowed to grow beyond 2**32 bytes; it's
harmless to allow llseek to offsets beyond that, though.  One thing
I'm not sure about is what happens if we use extents (which allow for
offsets greater than 2**32) and use a file system with htree's not
enabled.  I'm not sure we have the correct checks to make sure the
directory size doesn't grow beyond 2**32 bytes.  This is largely
theoretical, though, since performance of the system will be quite
horrible long before we hit that limit, and I think the main problem
will be with NFSv2.  Still, if someone has time, this might be a good
thing to sanity check....

I did rewrite the commit description somewhat.  Attached see my
rewrite...

					- Ted

ext4: improve llseek error handling for overly large seek offsets

From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>

The llseek system call should return EINVAL if passed a seek offset
which results in a write error.  What this maximum offset should be
depends on whether or not the huge_file file system feature is set,
and whether or not the file is extent based or not.


If the file has no "EXT4_EXTENTS_FL" flag, the maximum size which can be 
written (write systemcall) is different from the maximum size which can be 
sought (lseek systemcall).

For example, the following 2 cases demonstrates the differences
between the maximum size which can be written, versus the seek offset
allowed by the llseek system call:

#1: mkfs.ext3 <dev>; mount -t ext4 <dev>
#2: mkfs.ext3 <dev>; tune2fs -Oextent,huge_file <dev>; mount -t ext4 <dev>

Table. the max file size which we can write or seek
       at each filesystem feature tuning and file flag setting
+============+===============================+===============================+
| \ File flag|                               |                               |
|      \     |     !EXT4_EXTENTS_FL          |        EXT4_EXTETNS_FL        |
|case       \|                               |                               |
+------------+-------------------------------+-------------------------------+
| #1         |   write:      2194719883264   | write:       --------------   |
|            |   seek:       2199023251456   | seek:        --------------   |
+------------+-------------------------------+-------------------------------+
| #2         |   write:      4402345721856   | write:       17592186044415   |
|            |   seek:      17592186044415   | seek:        17592186044415   |
+------------+-------------------------------+-------------------------------+

The differences exist because ext4 has 2 maxbytes which are sb->s_maxbytes
(= extent-mapped maxbytes) and EXT4_SB(sb)->s_bitmap_maxbytes (= block-mapped 
maxbytes).  Although generic_file_llseek uses only extent-mapped maxbytes.
(llseek of ext4_file_operations is generic_file_llseek which uses
sb->s_maxbytes.)

Therefore we create ext4 llseek function which uses 2 maxbytes.

The new own function originates from generic_file_llseek().
If the file flag, "EXT4_EXTENTS_FL" is not set, the function alters 
inode->i_sb->s_maxbytes into EXT4_SB(inode->i_sb)->s_bitmap_maxbytes.

Signed-off-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>

