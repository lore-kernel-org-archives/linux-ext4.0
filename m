From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH 0/6][TAKE5] fallocate system call
Date: Thu, 28 Jun 2007 10:36:47 -0700
Message-ID: <1183052207.4420.17.camel@localhost.localdomain>
References: <20070510005926.GT85884050@sgi.com>
	 <20070510115620.GB21400@amitarora.in.ibm.com>
	 <20070510223950.GD86004887@sgi.com> <20070511110301.GB28425@in.ibm.com>
	 <20070512080157.GF85884050@sgi.com>
	 <20070612061652.GA6320@amitarora.in.ibm.com>
	 <20070613235217.GS86004887@sgi.com>
	 <20070614091458.GH5181@schatzie.adilger.int>
	 <20070614120413.GD86004887@sgi.com>
	 <20070614193347.GN5181@schatzie.adilger.int>
	 <20070625132810.GA1951@amitarora.in.ibm.com>
	 <20070628025543.9467216f.akpm@linux-foundation.org>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, David Chinner <dgc@sgi.com>,
	Andreas Dilger <adilger@clusterfs.com>, suparna@in.ibm.com,
	xfs@oss.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:38160 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754309AbXF1Og6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 Jun 2007 10:36:58 -0400
In-Reply-To: <20070628025543.9467216f.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 2007-06-28 at 02:55 -0700, Andrew Morton wrote:

> Please drop the non-ext4 patches from the ext4 tree and send incremental
> patches against the (non-ext4) fallocate patches in -mm.
> 
The ext4 fallocate() patches are dependent on the core fallocate()
patches, so ext4 patch-queue and git tree won't compile (it's not based
on mm tree) without the core changes.

We can send ext4 fallocate patches (incremental patches against mm tree)
and drop the full fallocate patches(ext4 and non ext4 part) from ext4
patch queue if you prefer this way.

> And try to get the code finished?  Time is pressing.
> 
I looked at the mm tree, there are other ext4 features/changes that are
currently in ext4-patch-queue(not ext4 git tree) that not in part of
ext4 series yet. Ted, can you merge those patches to your git tree?
Thanks!


Thanks for your patience.

Mingming.
