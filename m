From: "Takashi Sato" <t-sato@yk.jp.nec.com>
Subject: Re: [RFC] ext3 freeze feature
Date: Thu, 7 Feb 2008 10:05:12 +0900
Message-ID: <004901c86925$7e3d1d60$41a8400a@bsd.tnes.nec.co.jp>
References: <20080125195938t-sato@mail.jp.nec.com> <20080125121851.GA3361@dmon-lap.sw.ru> <20080125133329.GB8184@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Cc: <linux-ext4@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
To: "Theodore Tso" <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:52921 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754686AbYBGBG7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Feb 2008 20:06:59 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

> What you *could* do is to start putting processes to sleep if they
> attempt to write to the frozen filesystem, and then detect the
> deadlock case where the process holding the file descriptor used to
> freeze the filesystem gets frozen because it attempted to write to the
> filesystem --- at which point it gets some kind of signal (which
> defaults to killing the process), and the filesystem is unfrozen and
> as part of the unfreeze you wake up all of the processes that were put
> to sleep for touching the frozen filesystem.
> 
> The other approach would be to say, "oh well, the freeze ioctl is
> inherently dangerous, and root is allowed to himself in the foot, so
> who cares".  :-)

Currently the XFS freezer doesn't solve a deadlock automatically
and we rely on administrators for ensuring that the freezer will not
access the filesystem.
And even if the wrong freezer causes a deadlock, it can be solved
by other unfreeze process(unfreeze command).

So I don't think the freezer itself needs to solve the deadlock.
I think the timeout is effective for a unexpected deadlock
and the timeout extending feature is very useful
as Dmitri proposed.

Cheers, Takashi
