From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Subject: Re: [ext3][kernels >= 2.6.20.7 at least] KDE going comatose when FS
 is under heavy write load (massive starvation)
Date: Sat, 28 Apr 2007 22:46:27 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0704282242280.16099@artax.karlin.mff.cuni.cz>
References: <1177660767.6567.41.camel@Homer.simpson.net>
 <20070427013350.d0d7ac38.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Mike Galbraith <efault@gmx.de>,
	LKML <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Jens Axboe <jens.axboe@oracle.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from artax.karlin.mff.cuni.cz ([195.113.31.125]:34629 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091AbXD1Uq3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 28 Apr 2007 16:46:29 -0400
In-Reply-To: <20070427013350.d0d7ac38.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> hm, fsync.
>
> Aside: why the heck do applications think that their data is so important
> that they need to fsync it all the time.  I used to run a kernel on my
> laptop which had "return 0;" at the top of fsync() and fdatasync().  Most
> pleasurable.
>
> But wedging for 20 minutes is probably excessive punishment.

I most wonder, why vim fsyncs its swapfile regularly (blocking typing 
during that) and doesn't fsync the resulting file on :w  :-/

Mikulas
