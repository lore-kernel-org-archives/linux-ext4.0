From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 0/4] FS: userspace notification of errors
Date: Wed, 10 Jun 2009 23:03:48 +0200
Message-ID: <20090610210348.GE1381@ucw.cz>
References: <1244041518-32229-1-git-send-email-ext-denis.2.karpov@nokia.com> <20090603115611.6bbbaf55.akpm@linux-foundation.org> <4A276266.8000409@nokia.com> <20090604142735.GC28764@smart.research.nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: "Bityutskiy Artem (Nokia-D/Helsinki)" <Artem.Bityutskiy@nokia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"axboe@kernel.dk" <axboe@kernel.dk>,
	"hirofumi@mail.parknet.co.jp" <hiro
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46430 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757852AbZFJVDy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Jun 2009 17:03:54 -0400
Content-Disposition: inline
In-Reply-To: <20090604142735.GC28764@smart.research.nokia.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


> > > One part of the design which you didn't describe, but which I inferred
> > > is that you intend that userspace will see the FS_UNCLEAN=1 messages
> > > and will then poll all the /sys/block/<bdev>/<part>/fs_unclean files to
> > > work out which partition(s) got the error, correct?  Please spell all
> > > that out in the changelog.
> > 
> > I think this part of the design needs more thought. Not
> > all FSes have block devices (UBIFS, JFFS2), and some FSes
> > may (theoretically) span more than one block device (btrfs?).
> 
> Big thanks to everybody participating in this thread, for reviews and critiques.
> Here's a proposal/RFC for another way to implement this feature:
> 
> Taking into account Artem's and Kay's comments, indeed, having attributes
> like 'fs_error' tied to a block device does not seem right. 
> What we need is an object/entity that:
> 
> - is not associated to a block device
> - is not associated to a partition 
> - is not associated to a filesystem as a general entity
> - is uniquely associated to a filesystem's 'instance': a mounted volume
>   carying that filesystem
> - apperas at volume mount time and disappears with volume unmount

Add a ",errors " at the end of line to /proc/mounts when error is
detected? (...and make /proc/mounts pollable?)

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
