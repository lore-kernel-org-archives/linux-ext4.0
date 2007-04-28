From: Bill Huey (hui) <billh@gnuppy.monkey.org>
Subject: Re: [ext3][kernels >= 2.6.20.7 at least] KDE going comatose when FS is under heavy write load (massive starvation)
Date: Sat, 28 Apr 2007 14:57:56 -0700
Message-ID: <20070428215756.GA13477@gnuppy.monkey.org>
References: <1177660767.6567.41.camel@Homer.simpson.net> <20070427013350.d0d7ac38.akpm@linux-foundation.org> <698310e10704270459t7663d39dp977cf055b8db9d2a@mail.gmail.com> <alpine.LFD.0.98.0704270819500.9964@woody.linux-foundation.org> <20070427193130.GD5967@schatzie.adilger.int> <alpine.LFD.0.98.0704271246550.9964@woody.linux-foundation.org> <20070427201235.GA11170@gnuppy.monkey.org> <Pine.LNX.4.64.0704280708500.9055@artax.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Andreas Dilger <adilger@clusterfs.com>,
	Marat Buharov <marat.buharov@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Galbraith <efault@gmx.de>,
	LKML <linux-kernel@vger.kernel.org>,
	Jens Axboe <jens.axboe@oracle.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Alex Tomas <alex@clusterfs.com>,
	"Bill Huey (hui)" <billh@gnuppy.monkey.org>
To: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from adsl-69-232-92-238.dsl.sndg02.pacbell.net ([69.232.92.238]:45518
	"EHLO gnuppy.monkey.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754239AbXD1V6X (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 28 Apr 2007 17:58:23 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704280708500.9055@artax.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Apr 28, 2007 at 07:37:17AM +0200, Mikulas Patocka wrote:
> SpadFS doesn't write to unallocated parts like log filesystems (LFS) or 
> phase tree filesystems (TUX2); it writes inside normal used structures, 
> but it marks each structure with generation tags --- when it updates 
> global table of tags, it atomically makes several structures valid. I 
> don't know about this idea being used elsewhere.

So how is this generation structure organized ? paper ?

bill
