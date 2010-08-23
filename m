From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Performance testing of various barrier reduction patches [was: Re:
	[RFC v4] ext4: Coordinate fsync requests]
Date: Mon, 23 Aug 2010 11:31:19 -0700
Message-ID: <20100823183119.GA28105@tux1.beaverton.ibm.com>
References: <4BE02C45.6010608@redhat.com> <1273002566.3755.10.camel@mingming-laptop> <20100629205102.GM15515@tux1.beaverton.ibm.com> <20100805164008.GH2901@thunk.org> <20100805164504.GI2901@thunk.org> <20100806070424.GD2109@tux1.beaverton.ibm.com> <20100809195324.GG2109@tux1.beaverton.ibm.com> <4D5AEB7F-32E2-481A-A6C8-7E7E0BD3CE98@dilger.ca> <20100809233805.GH2109@tux1.beaverton.ibm.com> <20100819021441.GM2109@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Ted Ts'o" <tytso@mit.edu>, Mingming Cao <cmm@us.ibm.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Keith Mannthey <kmannth@us.ibm.com>,
	Mingming Cao <mcao@us.ibm.com>, Tejun Heo <tj@kernel.org>,
	hch@lst.de
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e9.ny.us.ibm.com ([32.97.182.139]:39952 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751618Ab0HWSbY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Aug 2010 14:31:24 -0400
Content-Disposition: inline
In-Reply-To: <20100819021441.GM2109@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

I retested the ext4 barrier mitigation patchset against a base of 2.6.36-rc1 +
Tejun's flush_fua tree + Christoph's patches to change FS barrier semantics,
and came up with this new spreadsheet:
http://bit.ly/bWpbsT

Here are the previous 2.6.35 results for convenience: http://bit.ly/c22grd

The machine configurations are the same as with the previous (2.6.35)
spreadsheet.  It appears to be the case that Tejun and Christoph's patches to
change barrier use into simpler cache flushes generally improve the speed of
the fsync-happy workload in buffered I/O mode ... if you have a bunch of
spinning disks.  Results for the SSD array (elm3c44) and the single disk
systems (elm3c65/elm3c75) decreased slightly.  For the case where direct I/O
was used, the patchset improved the results in nearly all cases.  The speed
with barriers on is getting closer to the speed with barriers off, thankfully!

Unfortunately, one thing that became /much/ less clear in these new results is
the impact of the other patch sets that we've been working on to make ext4
smarter with regards to barrier/flush use.  In most cases I don't really see
the fsync-delay patch having much effect for directio, and it seems to have
wild effects when buffered mode is used.  Jan Kara's barrier generation patch
still generally helps with directio loads.  I've also concluded that my really
old dirty-flag patchset from ages ago no longer has any effect.

What does everyone else think of these results?

--D
