From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: e2fsck not fixing deleted inode referenced errors?
Date: Tue, 30 Sep 2014 11:30:12 -0700
Message-ID: <20140930183012.GA9942@birch.djwong.org>
References: <542AEED4.5050303@bitsync.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Zlatko Calusic <zcalusic@bitsync.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:37681 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbaI3SaY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Sep 2014 14:30:24 -0400
Content-Disposition: inline
In-Reply-To: <542AEED4.5050303@bitsync.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 30, 2014 at 07:56:36PM +0200, Zlatko Calusic wrote:
> Hope this is the right list to ask this question.
> 
> I have an ext4 filesystem that has a few errors like this:
> 
> Sep 30 19:14:09 atlas kernel: EXT4-fs error (device md2):
> ext4_lookup:1448: inode #7913865: comm find: deleted inode
> referenced: 7912058
> Sep 30 19:14:09 atlas kernel: EXT4-fs error (device md2):
> ext4_lookup:1448: inode #7913865: comm find: deleted inode
> referenced: 7912055
> 
> Yet, when I run e2fsck -fy on it, I have a clean run, no errors are
> found and/or fixed. Is this the expected behaviour? What am I
> supposed to do to get rid of errors like the above?

[I should hope not.]

> The filesystem is on a md mirror device, the kernel is 3.17.0-rc7,
> e2progs 1.42.12-1 (Debian sid). Could md device somehow interfere? I
> ran md check yesterday, but there were no errors.
> 
> BTW, this all started when I got ata2.00: failed command: FLUSH
> CACHE EXT error yesterday morning. I did several runs of e2fsck
> before the filesystem came up clean, yet errors like the above are
> popping constantly.

Normally that kernel message only happens if a dir refers to an inode with
link_count and mode set to 0.

Is the disk attached to ata2.00 one of the RAID1 mirrors?  What was the full
error message, and does smartctl -a report anything?

It would be interesting to see what "debugfs -R 'stat <7912058>' /dev/md2"
returns.

--D

> 
> Thanks for any info. [and please Cc:, I'm not subscribed]
> 
> -- 
> Zlatko
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
