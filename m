From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH v1 0/5] ext4: Shut down block groups when damage is
 detected
Date: Sun, 21 Jul 2013 22:32:26 +0800
Message-ID: <20130721143226.GA13473@gmail.com>
References: <20130719235532.24017.31896.stgit@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>,
	Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64570 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755519Ab3GUOcf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 21 Jul 2013 10:32:35 -0400
Received: by mail-pb0-f46.google.com with SMTP id rq2so6103924pbb.5
        for <linux-ext4@vger.kernel.org>; Sun, 21 Jul 2013 07:32:34 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20130719235532.24017.31896.stgit@blackbox.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 19, 2013 at 04:55:32PM -0700, Darrick J. Wong wrote:
> Right now, ext4 doesn't do quite a good enough job shutting off allocation and
> freeing activity in block groups when damage is detected, which means that ext4
> can obliviously load a corrupt bitmap, base allocation decisions off of that,
> and trash the filesystem.  We'd like to be able to freeze the block group when
> this happens, so hopefully the next fsck can repair the damage.
> 
> The first patch fixes the behavior that a corrupt bitmap can be returned to
> mballoc as if it was accurate.  The second patch is a trivial fix, and the two
> after it provide for detecting damage in either the block bitmap or the inode
> bitmap, and disabling all allocation/deallocation activity in the block group.
> The final patch changes runtime block group descriptor validation failure
> behavior to use the corruption flag to mark off the block group.
> 
> This patchset has been tested (albeit lightly) against 3.11-rc1 on x64.  I'm
> wondering about a few things -- if we detect corrupt *inodes*, should we invoke
> this mechanism as well?  Second, as I mentioned a few days ago, maybe it's time
> for block_validity to be set always, since it seems to have a low speed impact?
> Third, the block bitmap corruption flag patch is based off of Aditya Kali's
> patch that you forwarded; can a proper Signed-off-by be attached since I mostly
> just massaged that one into 3.11?
> 
> Comments and questions are, as always, welcome.

Wow, it seems to me that I have missed a very important thread [1] after
serveral crazy busy weeks.  There is an idea that is in my mind for a
while and I still can not have a proper time to try it.

My idea is to let file system can ignore the currurted block.  Namely,
when we meet a currupted block, we will track it as bad block in bad
block inode and find another block to save data.  This currupted block
will never be used.  The first step in my mind is to detect a currpted
block and mark it as bad block.  After reading the thread and Darrick's
original patch, I think Darrick's patch is a good start.

At Taobao, we have a large CDN system.  These servers are a cache for
web site, and this system can tolerate the data loss.  So we hope when
we detect a currupted block, we can just ignore it and use another block
until the whole disk currupted or the server is dropped.

I will take a closer look at these patches later.

Thanks,
                                                - Zheng

1. http://www.spinics.net/lists/linux-ext4/msg39053.html
