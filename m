From: Kazuto Miyoshi <miyoshi@linux.bs1.fc.nec.co.jp>
Subject: Re: [RFC] ext3 freeze feature
Date: Fri, 01 Feb 2008 12:03:59 +0900 (JST)
Message-ID: <20080201.120359.51771100.miyoshi@linux.bs1.fc.nec.co.jp>
References: <20080125121851.GA3361@dmon-lap.sw.ru>
	<20080125133329.GB8184@mit.edu>
	<01cb01c861af$8515d230$41a8400a@bsd.tnes.nec.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: tytso@MIT.EDU, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: t-sato@yk.jp.nec.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:46974 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652AbYBADEZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 31 Jan 2008 22:04:25 -0500
In-Reply-To: <01cb01c861af$8515d230$41a8400a@bsd.tnes.nec.co.jp>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Sato-san,

> > What you *could* do is to start putting processes to sleep if they
> > attempt to write to the frozen filesystem, and then detect the
> > deadlock case where the process holding the file descriptor used to
> > freeze the filesystem gets frozen because it attempted to write to the
> > filesystem --- at which point it gets some kind of signal (which
> > defaults to killing the process), and the filesystem is unfrozen and
> > as part of the unfreeze you wake up all of the processes that were put
> > to sleep for touching the frozen filesystem.
> 
> I don't think close() usually writes to journal and the deadlock occurs.
> Is there the special case which close() writes to journal in case of
> getting signal?

I am afraid that Ted-san is concerning about the fact that the freeze
program can touch the target filesystem by mistake (rather than just
close() and its journal behavior)

# cd /mnt
# freeze /mnt > ./logfile

This is more unclear to admins than "rm -rf /" case.
So we need to implement some bail-out mechanism as he pointed out,
such that if kernel noticed that the freezer is trying to touch
the target filesystem, kernel would kill the freezer and
automatically unfreeze the filesystem again.

Regards, 
