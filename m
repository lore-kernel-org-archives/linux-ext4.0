From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: zero out blocks of freed user data for operation a virtual
 machine environment
Date: Sun, 24 May 2009 10:15:51 -0700
Message-ID: <20090524101551.57b706e9@infradead.org>
References: <20090524170045.GC24753@cip.informatik.uni-erlangen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: tytso@thunk.org, LKML <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: Thomas Glanzmann <thomas@glanzmann.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:48181 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278AbZEXRPw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 24 May 2009 13:15:52 -0400
In-Reply-To: <20090524170045.GC24753@cip.informatik.uni-erlangen.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, 24 May 2009 19:00:45 +0200
Thomas Glanzmann <thomas@glanzmann.de> wrote:

> Hello Ted,
> I would like to know if there is already a mount option or feature in
> ext3/ext4 that automatically overwrites freed blocks with zeros? If
> this is not the case I would like to know if you would consider a
> patch for upstream? I'm asking this because I currently do some
> research work on data deduplication in virtual machine environments
> and corresponding backups. It would be a huge space saver if there is
> such a feature because todays and tomorrows backup tools for virtual
> machine environments work on the block layer (VMware Consolidated
> Backup, VMware Data Recovery, and NetApp Snapshots). This is not only
> true for backup tools but also for running Virtual machines. The case
> that this future addresses is the following: A huge file is
> downloaded and later delted. The backup and datadeduplication that is
> operating on the block level can't identify the block as unused. This
> results in backing up the amount of the data that was previously
> allocated by the file and as such introduces an performance overhead.
> If you're interested in real live data, I'm able to provide them.
> 
> If you don't intend to have such an optional feature in ext3/ext4 I
> would like to know if you know a tool that makes it possible to zero
> out unused blocks?
> 

wouldn't it be better if the VM's would just support the TRIM command?


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
