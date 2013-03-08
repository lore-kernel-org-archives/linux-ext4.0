From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] mke2fs: restore verbose message for BLKDISCARD
Date: Fri, 8 Mar 2013 14:06:35 -0500
Message-ID: <20130308190635.GC12008@thunk.org>
References: <1362515118-30344-1-git-send-email-swarren@wwwdotorg.org>
 <alpine.LFD.2.00.1303060753500.24359@localhost>
 <5138EEBD.5000705@wwwdotorg.org>
 <alpine.LFD.2.00.1303080818510.24359@localhost>
 <513A1D56.1010402@wwwdotorg.org>
 <20130308190019.GB12008@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	Chris Ball <cjb@laptop.org>, linux-ext4@vger.kernel.org,
	Stephen Warren <swarren@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:52024 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751157Ab3CHTGj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 8 Mar 2013 14:06:39 -0500
Content-Disposition: inline
In-Reply-To: <20130308190019.GB12008@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Here's an idea.  What if we set a timer when send the first probing
discard, and if it takes too long, we print an error message and then
try to recover.

More generally, if we can't trust a device's advertised discard
parameters, maybe it makes sense to create a userspace program that
benchmarks the device to determine various critical flash parameters,
including "does discard really work?"  "Is it hopelessly slow"', and
"what is the erase block size"?  This program can then send the
appropriate parameters to a filesystem's mkfs program.

   	      	      	  	   - Ted
