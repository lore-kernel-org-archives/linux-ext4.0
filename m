From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: new corruption pattern on ext4
Date: Thu, 20 Oct 2011 13:40:15 +0400
Message-ID: <87sjmorog0.fsf@dmbot.sw.ru>
References: <1319020189-13584-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
	linux-ext4@vger.kernel.org, jack@suse.cz, hch@infradead.org,
	aelder@sgi.com, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62054 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755119Ab1JTJkH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 20 Oct 2011 05:40:07 -0400
In-Reply-To: <1319020189-13584-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 19 Oct 2011 14:29:41 +0400, Dmitry Monakhov <dmonakhov@openvz.org> wrote:
> xfstests: fsstress should kill children tasks before exit
> xfstests: add different logging option to fsstress
> xfstests: add fallocate support to fsstress
> xfstests: fsstress add FS_IOC_{SET,GET}FLAGS operations
> xfstests: Dump inode info when possible
> xfstests: add fiemap operation
> 
> # Following testcase will fail on recent kernel in case of ext4
> # Some fixes are already available here:
> # http://www.spinics.net/lists/linux-ext4/msg27857.html
> xfstests: add new stress test
FYI: i've run 264'th test on recent tytso/ext4.git(dcf2d804ed6ffe)
and have got new type of fs-corruption, i haven't seen this before,
at this moment I dont have a fix for that:
Pass 1: Checking inodes, blocks, and sizes
Inode 176 has an invalid extent
      (logical block 236, invalid physical block 0, len 0)
Clear? no

Inode 22293 has an invalid extent
      (logical block 531, invalid physical block 0, len 0)
Clear? no

Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
...

> 
> # Following testcase will fail on recent kernel in case of ext3/4 
> # Fixes available here:
> #  http://patchwork.ozlabs.org/patch/120581/
> #  http://patchwork.ozlabs.org/patch/120582/
> xfstests: add new quota stress test
> 
> P.S: ext4 still contains bugs caused by ordered_mode=>journal_mode
> switch for didicated inode (chattr +j ./afile), so you temproraly
> disable this test by adding "-f setattr=0" to $FSSTRESS_AVOID var.
>      
