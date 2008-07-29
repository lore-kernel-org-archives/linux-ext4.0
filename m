From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH] jbd2: don't abort if flushing file data failed
Date: Tue, 29 Jul 2008 08:35:13 -0400
Message-ID: <20080729123513.GG9378@mit.edu>
References: <1217118414-18636-1-git-send-email-tytso@mit.edu> <1217118414-18636-2-git-send-email-tytso@mit.edu> <1217118414-18636-3-git-send-email-tytso@mit.edu> <1217118414-18636-4-git-send-email-tytso@mit.edu> <488EB060.7080303@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	sugita <yumiko.sugita.yf@hitachi.com>,
	Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>
To: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:53205 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751398AbYG2MfT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 Jul 2008 08:35:19 -0400
Content-Disposition: inline
In-Reply-To: <488EB060.7080303@hitachi.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 29, 2008 at 02:53:36PM +0900, Hidehiro Kawai wrote:
> Hello, Ted
> 
> > [PATCH] ext4: don't read inode block if the buffer has a write error
> > [PATCH] jbd2: don't abort if flushing file data failed
> 
> Thank you for porting my ext3/jbd patches to ext4/jbd2.
> I would appreciate if you port the remained two patch set (haven't
> been posted yet), too.  Although I'll try to port them by myself. 

If they are the ones which I think you are referring to, I don't
believe they apply to ext4 since we are now using the
generic_writepages routines to flush data pages to disk during a
journal commit.  I've checked those code paths, and I believe they do
set AS_EIO correctly; I would appreciate it though if you could double
check to make sure they are do everything that needs to be done to
handle write errors correctly.

Thanks, regards,

						- Ted
