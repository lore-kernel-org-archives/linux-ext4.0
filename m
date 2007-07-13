From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [EXT4 set 5][PATCH 1/1] expand inode i_extra_isize to support features in larger inode
Date: Fri, 13 Jul 2007 09:43:43 -0600
Message-ID: <20070713154343.GG5880@schatzie.adilger.int>
References: <1183275482.4010.133.camel@localhost.localdomain> <20070710163247.5c8bfa3f.akpm@linux-foundation.org> <20070713020529.1486491f.akpm@linux-foundation.org> <1184333621.20032.85.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>, cmm@us.ibm.com,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, Andy Whitcroft <apw@shadowen.org>
To: Peter Zijlstra <peterz@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 74-0-229-162.T1.lbdsl.net ([74.0.229.162]:50006 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761569AbXGMPnq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 13 Jul 2007 11:43:46 -0400
Content-Disposition: inline
In-Reply-To: <1184333621.20032.85.camel@twins>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jul 13, 2007  15:33 +0200, Peter Zijlstra wrote:
> On Fri, 2007-07-13 at 02:05 -0700, Andrew Morton wrote:
> Or can journal_stop() be done by a different task than the one that did
> journal_start()? - in which case nothing much can be done :-/

The call to journal_stop() has to be in the same process, since the
journal handle is also held in current->journal_info so the handle
does not need to be passed as an argument all over the VFS.

> This seems to boot... albeit I did not push it hard.

Can you please also make a patch for jbd2.


Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
