From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: ext4-patch-queue rebased to 2.6.22
Date: Tue, 10 Jul 2007 14:26:45 -0600
Message-ID: <20070710202645.GC6417@schatzie.adilger.int>
References: <E1I7xBM-00044G-2v@candygram.thunk.org> <20070710145422.GA1636@amitarora.in.ibm.com> <20070710170939.GA6417@schatzie.adilger.int> <20070710175558.GA15345@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 74-0-229-162.T1.lbdsl.net ([74.0.229.162]:52021 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763277AbXGJU0s (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Jul 2007 16:26:48 -0400
Content-Disposition: inline
In-Reply-To: <20070710175558.GA15345@amitarora.in.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jul 10, 2007  23:25 +0530, Amit K. Arora wrote:
> On Tue, Jul 10, 2007 at 11:09:39AM -0600, Andreas Dilger wrote:
> > It might even make sense to change the other #define to be called
> > EXT_INIT_MAX_LEN so people have to think about this when using the #define.
> 
> Done. Changes are in ext4 patch queue.
> Can you please have a quick look and see if this is what you preferred ?

Yes, it looks good, though I wonder if it also makes sense to change the
ext4_ext_*_uninitialized() code to use EXT_INIT_MAX_LEN instead of 0x8000,
since that makes it a bit clearer that the two are related.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
