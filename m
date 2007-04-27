From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [ext3][kernels >= 2.6.20.7 at least] KDE going comatose when FS
 is under heavy write load (massive starvation)
Date: Fri, 27 Apr 2007 12:50:34 -0700 (PDT)
Message-ID: <alpine.LFD.0.98.0704271246550.9964@woody.linux-foundation.org>
References: <1177660767.6567.41.camel@Homer.simpson.net>
 <20070427013350.d0d7ac38.akpm@linux-foundation.org>
 <698310e10704270459t7663d39dp977cf055b8db9d2a@mail.gmail.com>
 <alpine.LFD.0.98.0704270819500.9964@woody.linux-foundation.org>
 <20070427193130.GD5967@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Cc: Marat Buharov <marat.buharov@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Galbraith <efault@gmx.de>,
	LKML <linux-kernel@vger.kernel.org>,
	Jens Axboe <jens.axboe@oracle.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Alex Tomas <alex@clusterfs.com>
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53055 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755938AbXD0Tvv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 27 Apr 2007 15:51:51 -0400
In-Reply-To: <20070427193130.GD5967@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



On Fri, 27 Apr 2007, Andreas Dilger wrote:
>
> It's true that this is a "feature" of ext3 with data=ordered (the default),
> but I suspect the same thing is now true in reiserfs too.

Oh, well.. Journalling sucks.

I was actually _really_ hoping that somebody would come along and tell 
everybody that this whole journal-logging is stupid, and that it's just 
better to not ever re-write blocks on disk, but instead write to new 
blocks with version numbers (and not re-use old blocks until new versions 
are stable on disk).

There was even somebody who did something like that for a PhD thesis, I 
forget the details (and it apparently died when the thesis was presumably 
accepted ;).

			Linus
