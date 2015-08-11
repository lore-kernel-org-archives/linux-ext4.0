From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: A question about EXT4_INODE_JOURNAL_DATA flag with delalloc
Date: Tue, 11 Aug 2015 16:00:15 -0400
Message-ID: <20150811200015.GC20658@thunk.org>
References: <854180411.692591439262776858.JavaMail.weblogic@epmlwas07d>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"daehojng@gmail.com" <daehojng@gmail.com>
To: Daeho Jeong <daeho.jeong@samsung.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53303 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932241AbbHKUAS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Aug 2015 16:00:18 -0400
Content-Disposition: inline
In-Reply-To: <854180411.692591439262776858.JavaMail.weblogic@epmlwas07d>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 11, 2015 at 03:12:56AM +0000, Daeho Jeong wrote:
> Hi, I am seeing in the ext4_change_inode_flag() function and found a patch to allocate
> physical blocks for delalloc blocks in that function.
> (=> http://repo.or.cz/w/ext4-patch-queue.git/blob/20f7782b1f50eb1d5cba5e085d01fbce89fce881:/allocate-delalloc-blocks-before-changing-journal-mode)
> 
> I think this is an idea to resolve kernel OOPS concerned with enabling/disabling
> data journaling of a file in delayed allocation mode. Actually, I want to utilize per file
> data journaling with delayed allocation, so this patch seemed to be very helpful for me.
> 
> But, after 1 month from when the patch was applied, another patch was submitted
> and EXT4_INODE_JOURNAL_DATA flag with delalloc was ignored.
> (=> http://repo.or.cz/w/ext4-patch-queue.git/blob/17f3a9c17473d0b5925118a75ba7363c79e3fdc3:/ignore-JOURNAL_DATA-flag-with-delalloc)
> 
> I don't understand the reason of that EXT4_INODE_JOURNAL_DATA flag with delalloc was
> ignored because I think the previous patch can handle the problem which the above URL describes.
> 
> Am I missing something and could you share your idea about this? :-)

For doing code archeology, it's generally better to use the git
commits of the patches as they landed in the mainline kernel.  The two
commits you are talking about are 3d2b15826282 and 2aff57b0c052, and
it does appear that the earlier patch may have addressed the issue
that was solved by disabling support of the per-file data journalling
flag if delalloc is enabled at the file system level.

It may be possible to make small change to allow a single file to be
in data journalling mode (where delayed allocation would be disabled
for that file), while allowing the rest of the file system to be using
delalloc.  If you are courious, I'd suggest making that change and
then running xfstests and see if it triggers any regressions.

Cheers,

						- Ted


