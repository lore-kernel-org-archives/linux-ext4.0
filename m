From: Phil Susi <psusi@ubuntu.com>
Subject: Re: Unused block group, but all blocks not free?
Date: Fri, 22 May 2015 08:37:26 -0400
Message-ID: <555F2306.8010607@ubuntu.com>
References: <555BDEF4.1020704@ubuntu.com> <20150520151007.GK2871@thunk.org> <555CA52F.3010109@ubuntu.com> <20150520163148.GA23989@thunk.org> <555D0541.1000804@ubuntu.com> <20150521235940.GB2750@thunk.org> <555E7371.9060207@ubuntu.com> <20150522022837.GC2750@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qg0-f47.google.com ([209.85.192.47]:34426 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757129AbbEVMiN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 22 May 2015 08:38:13 -0400
Received: by qgez61 with SMTP id z61so7295615qge.1
        for <linux-ext4@vger.kernel.org>; Fri, 22 May 2015 05:38:12 -0700 (PDT)
In-Reply-To: <20150522022837.GC2750@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 5/21/2015 10:28 PM, Theodore Ts'o wrote:
> On Thu, May 21, 2015 at 08:08:17PM -0400, Phillip Susi wrote:
> The change was that for uninitialized block bitmaps, dumpe2fs used to
> display incorrect information (that is, it would claim all of the
> blocks were free, even though in fact that was not true).

It seems to have actually been a change on disk, since e2defrag *used* 
to count the number of free blocks assuming an uninitialized bitmap 
meant that they were all free, and get the same number reported in the 
superblock.  This was probably prior to the change you are thinking of.

IIRC, when I looked using debugfs, the block groups containing metadata 
always had their bitmaps initialized.

