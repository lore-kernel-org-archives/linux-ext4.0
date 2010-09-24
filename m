From: Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: Performance testing of various barrier reduction patches [was:	Re: [RFC v4] ext4: Coordinate fsync requests]
Date: Fri, 24 Sep 2010 00:24:04 -0600
Message-ID: <B0A8EB94-E2F7-4268-AE99-C4A7402E880D@dilger.ca>
References: <1273002566.3755.10.camel@mingming-laptop> <20100629205102.GM15515@tux1.beaverton.ibm.com> <20100805164008.GH2901@thunk.org> <20100805164504.GI2901@thunk.org> <20100806070424.GD2109@tux1.beaverton.ibm.com> <20100809195324.GG2109@tux1.beaverton.ibm.com> <4D5AEB7F-32E2-481A-A6C8-7E7E0BD3CE98@dilger.ca> <20100809233805.GH2109@tux1.beaverton.ibm.com> <20100819021441.GM2109@tux1.beaverton.ibm.com> <20100823183119.GA28105@tux1.beaverton.ibm.com> <20100923232527.GB25624@tux1.beaverton.ibm.com>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Ted Ts'o <tytso@mit.edu>, Mingming Cao <cmm@us.ibm.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Keith Mannthey <kmannth@us.ibm.com>,
	Mingming Cao <mcao@us.ibm.com>, Tejun Heo <tj@kernel.org>,
	hch@lst.de
To: djwong@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:42822 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137Ab0IXGYH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 24 Sep 2010 02:24:07 -0400
In-Reply-To: <20100923232527.GB25624@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-09-23, at 17:25, Darrick J. Wong wrote:
> To try to find an explanation, I started looking for connections between fsync delay values and average flush times.  I noticed that the setups with low (< 8ms) flush times exhibit better performance when fsync coordination is not attempted, and the setups with higher flush times exhibit better performance when fsync coordination happens.  This also is no surprise, as it seems perfectly reasonable that the more time consuming a flush is, the more desirous it is to spend a little time coordinating those flushes across CPUs.
> 
> I think a reasonable next step would be to alter this patch so that ext4_sync_file always measures the duration of the flushes that it issues, but only enable the coordination steps if it detects the flushes taking more than about 8ms.  One thing I don't know for sure is whether 8ms is a result of 2*HZ (currently set to 250) or if 8ms is a hardware property.

Note that the JBD/JBD2 code will already dynamically adjust the journal flush interval based on the delay seen when writing the journal commit block.  This was done to allow aggregating sync journal operations for slow devices, and allowing fast (no delay) sync on fast devices.  See jbd2_journal_stop() for details.

I think the best approach is to just depend on the journal to do this sync aggregation, if at all possible, otherwise use the same mechanism in ext3/4 for fsync operations that do not involve the journal (e.g. nojournal mode, data sync in writeback mode, etc).

Using any fixed threshold is the wrong approach, IMHO.

Cheers, Andreas





