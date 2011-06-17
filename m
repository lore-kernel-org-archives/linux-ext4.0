From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3 v5] XFS TESTS: Add Punch Hole to FSX
Date: Fri, 17 Jun 2011 08:02:41 -0400
Message-ID: <20110617120241.GA20227@infradead.org>
References: <4DED63D1.5010600@vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	xfs-oss <xfs@oss.sgi.com>
To: Allison Henderson <achender@vnet.ibm.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4DED63D1.5010600@vnet.ibm.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I'm a bit worried about adding more and more local hacks to our FSX
version before resyncing with the official Apple variant that actual
has clear licensing.  But we didn't let other recent patches be affected
by that, so I guess I can't complain this time either and will put it
in.
