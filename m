From: Mike Galbraith <efault@gmx.de>
Subject: Re: [ext3][kernels >= 2.6.20.7 at least] KDE going comatose when
	FS is under heavy write load (massive starvation)
Date: Fri, 27 Apr 2007 21:44:57 +0200
Message-ID: <1177703097.7088.17.camel@Homer.simpson.net>
References: <1177660767.6567.41.camel@Homer.simpson.net>
	 <20070427013350.d0d7ac38.akpm@linux-foundation.org>
	 <698310e10704270459t7663d39dp977cf055b8db9d2a@mail.gmail.com>
	 <alpine.LFD.0.98.0704270819500.9964@woody.linux-foundation.org>
	 <20070427193130.GD5967@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Marat Buharov <marat.buharov@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Jens Axboe <jens.axboe@oracle.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Alex Tomas <alex@clusterfs.com>
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:39203 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755975AbXD0TpA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 27 Apr 2007 15:45:00 -0400
In-Reply-To: <20070427193130.GD5967@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 2007-04-27 at 13:31 -0600, Andreas Dilger wrote:
> I believe
> Alex has a patch to have it checkpoint much smaller chunks to the fs.

I wouldn't be averse to test driving such a patch (understatement). You
have a pointer?

	-Mike
