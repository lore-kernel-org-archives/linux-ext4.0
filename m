From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3 v5] XFS TESTS: Add ENOSPC Hole Punch Test
Date: Fri, 17 Jun 2011 08:08:38 -0400
Message-ID: <20110617120838.GA20714@infradead.org>
References: <4DED6405.7020104@vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	xfs-oss <xfs@oss.sgi.com>
To: Allison Henderson <achender@vnet.ibm.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4DED6405.7020104@vnet.ibm.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This one fails for me because my test system doesn't have sudo
installed.  I can't see any reason why a simple su wouldn't be enough.

We already have a helper to make su usable on both IRIX and Linux in
test 123, and it might be a good idea to add this to the common routines
and use it.

I'd also suggest to split this test off 252 into a new test case, as
unlike the other tests it actually requires a scratch devices, and in
general is pretty different from the simple xfs_io exercises in 252.

I'd also move the newly added helpers directly into the new testcase
as they really aren't common.

