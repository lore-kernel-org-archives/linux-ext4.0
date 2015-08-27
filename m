From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Running fsck of huge ext4 partition takes weeks
Date: Thu, 27 Aug 2015 15:05:48 -0400
Message-ID: <20150827190548.GC3357@thunk.org>
References: <CAETWcfs0iLzwPmg-JY5B79rme+g0Zi2VMYoNHm+4_Pc_yRR-kQ@mail.gmail.com>
 <28A25D6A-DA5A-42D2-9BFE-9F6C95B51BE7@dilger.ca>
 <CAETWcfti7NL3N96K1pEAX9ezKUrZn0QeGTwjn0qUni0u6i=Gcg@mail.gmail.com>
 <CAETWcfvtjF6bh_V64LgJ1QCyW=OKjzvV+HT5zFTThS574rWfgA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: Alexander Afonyashin <a.afonyashin@madnet-team.ru>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51013 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752456AbbH0TFu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 27 Aug 2015 15:05:50 -0400
Content-Disposition: inline
In-Reply-To: <CAETWcfvtjF6bh_V64LgJ1QCyW=OKjzvV+HT5zFTThS574rWfgA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 27, 2015 at 05:23:58PM +0300, Alexander Afonyashin wrote:
> Hi,
> 
> I've restarted fsck ~6 hours ago. It's again occupied ~30GB RAM and
> strace shows that number of syscalls per second becomes fewer and
> fewer.

Can you run it under "script" so we can get a transcript of the run?

It sounds like your file system has gotten very badly damaged, so the
question is figuring out what happened so we can advise you about how
to recover.

Can you also send the output of dumpe2fs?

Thanks,

					- Ted
