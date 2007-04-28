From: Matthias Andree <matthias.andree@gmx.de>
Subject: Re: [ext3][kernels >= 2.6.20.7 at least] KDE going comatose when
	FS is under heavy write load (massive starvation)
Date: Sat, 28 Apr 2007 10:45:42 +0200
Message-ID: <20070428084542.GB31196@merlin.emma.line.org>
References: <1177660767.6567.41.camel@Homer.simpson.net> <20070427013350.d0d7ac38.akpm@linux-foundation.org> <698310e10704270459t7663d39dp977cf055b8db9d2a@mail.gmail.com> <alpine.LFD.0.98.0704270819500.9964@woody.linux-foundation.org> <20070427193130.GD5967@schatzie.adilger.int> <alpine.LFD.0.98.0704271246550.9964@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@clusterfs.com>,
	Marat Buharov <marat.buharov@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Galbraith <efault@gmx.de>,
	LKML <linux-kernel@vger.kernel.org>,
	Jens Axboe <jens.axboe@oracle.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Alex Tomas <alex@clusterfs.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:35867 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1161725AbXD1Ipt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 28 Apr 2007 04:45:49 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0704271246550.9964@woody.linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 27 Apr 2007, Linus Torvalds wrote:

> Oh, well.. Journalling sucks.
> 
> I was actually _really_ hoping that somebody would come along and tell 
> everybody that this whole journal-logging is stupid, and that it's just 
> better to not ever re-write blocks on disk, but instead write to new 
> blocks with version numbers (and not re-use old blocks until new versions 
> are stable on disk).

Only that you need direct-overwrite support to be able to safely trash
data you no longer need...

-- 
Matthias Andree
