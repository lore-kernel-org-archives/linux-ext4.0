From: Eric Sesterhenn <snakebyte@gmx.de>
Subject: Re: BUG_ON at mballoc.c:3752
Date: Fri, 8 Feb 2008 16:07:05 +0100
Message-ID: <20080208150705.GA9111@alice>
References: <20080131140137.GA20780@alice> <20080131154207.GA22201@alice> <20080204060055.GC7494@skywalker> <1202335188.6886.15.camel@norville.austin.ibm.com> <20080207125548.GA8701@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-ext4@vger.kernel.org,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	Eric Sandeen <sandeen@redhat.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:34730 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757481AbYBHPHG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 8 Feb 2008 10:07:06 -0500
Content-Disposition: inline
In-Reply-To: <20080207125548.GA8701@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Eric ,
> can you run the test with below patch and see if this makes any
> difference ?. I know we are not fixing any bugs in the below patch.

ok, i checked out the old version again and applied both patches,
the BUG is gone (no surprise)
In the case where it would have hit the BUG i now get the following message:

[  740.400288] Aborting journal on device loop0.
[  740.405032] ext4_abort called.
[  740.405097] EXT4-fs error (device loop0): ext4_journal_start_sb: Detected aborted journal
[  740.405178] Remounting filesystem read-only
[  740.410974] EXT4-fs error (device loop0) in ext4_ordered_write_end: IO failure
[  740.414300] EXT4-fs error (device loop0) in ext4_reserve_inode_write: Journal has aborted
[  740.414422] pa cba56990: logic 16, phys. 1953, len 16
[  740.414447] EXT4-fs error (device loop0): ext4_mb_release_inode_pa: free 4, pa_free 3
[  740.414548] EXT4-fs error (device loop0) in ext4_mb_free_blocks: Journal has aborted


Greetings, Eric
