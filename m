From: Alex Tomas <alex@clusterfs.com>
Subject: Re: [RFC] basic delayed allocation in VFS
Date: Sun, 29 Jul 2007 23:51:07 +0400
Message-ID: <46ACEFAB.1010709@clusterfs.com>
References: <46A8628D.6070103@clusterfs.com> <46A87858.40005@garzik.org> <20070728195114.GA5952@infradead.org> <20070729173035.GU5992@schatzie.adilger.int> <20070729192437.GB14530@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20070729192437.GB14530@infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I'm a bit worried about one thing ... it looks like XFS and ext4
use different techniques to order data and metadata referencing
them. now I'm not that optimistic that we can separate ordering
from delalloc itself clean and reasonable way. In general, I'd
prefer common code in fs/ (mm/?) of course, for number of reasons.

thanks, Alex


Christoph Hellwig wrote:
> I'm a big proponent of having proper common delalloc code, but the
> one proposed here is not generic for the existing filesystem using
> delalloc.  It's still on my todo list to revamp the xfs code to get
> rid of some of the existing mess and make it useable genericly.  If
> the ext4 users are fine with the end result we could move to generic
> code.
> 
> Note that moving to VFS is bullshit either way, writeback code is
> nowhere near the VFS nor should it.


