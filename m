From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/6][TAKE5] fallocate system call
Date: Fri, 29 Jun 2007 08:20:17 +0100
Message-ID: <20070629072017.GA13192@infradead.org>
References: <20070512080157.GF85884050@sgi.com> <20070612061652.GA6320@amitarora.in.ibm.com> <20070613235217.GS86004887@sgi.com> <20070614091458.GH5181@schatzie.adilger.int> <20070614120413.GD86004887@sgi.com> <20070614193347.GN5181@schatzie.adilger.int> <20070625132810.GA1951@amitarora.in.ibm.com> <20070628025543.9467216f.akpm@linux-foundation.org> <20070628175757.GA1674@amitarora.in.ibm.com> <20070628113342.c9c0f49c.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, David Chinner <dgc@sgi.com>,
	Andreas Dilger <adilger@clusterfs.com>, suparna@in.ibm.com,
	cmm@us.ibm.com, xfs@oss.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:42695 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932617AbXF2HU1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 29 Jun 2007 03:20:27 -0400
Content-Disposition: inline
In-Reply-To: <20070628113342.c9c0f49c.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jun 28, 2007 at 11:33:42AM -0700, Andrew Morton wrote:
> I think Mingming was asking that Ted move the current quilt tree into git,
> presumably because she's working off git.
> 
> I'm not sure what to do, really.  The core kernel patches need to be in
> Ted's tree for testing but that'll create a mess for me.

Could we please stop this stupid ext4-centrism?  XFS is ready so we can
put in the syscalls backed by XFS.  We have already done this with the xattr
syscalls in 2.4, btw.

Then again I don't think we should put it in quite yet, because this thread
has degraded into creeping featurism, please give me some more time to
preparate a semi-coheret rants about this..
