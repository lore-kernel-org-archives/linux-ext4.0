From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [EXT4 set 4][PATCH 5/5] i_version: noversion mount option to disable inode version updates
Date: Wed, 11 Jul 2007 05:57:17 -0600
Message-ID: <20070711115716.GU6417@schatzie.adilger.int>
References: <1183275474.4010.132.camel@localhost.localdomain> <20070710163144.21b739f9.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 74-0-229-162.T1.lbdsl.net ([74.0.229.162]:39464 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756696AbXGKL5T (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Jul 2007 07:57:19 -0400
Content-Disposition: inline
In-Reply-To: <20070710163144.21b739f9.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jul 10, 2007  16:31 -0700, Andrew Morton wrote:
> On Sun, 01 Jul 2007 03:37:53 -0400
> Mingming Cao <cmm@us.ibm.com> wrote:
> > Add a "noversion" mount option to disable inode version updates.
> 
> Why is this option being offered to our users?  To reduce disk traffic,
> like noatime?
> 
> If so, what are the implications of this?  What would the user lose?

Ah, this is the patch to disable i_version updates for Lustre.  I don't
think any normal user would use this mount option, so I don't know if
there is a need to document it.  There are no performance implications,
unless we end up changing the mtime granularity JUST to update i_version,
in which case we can avoid some overhead if not exporting with NFSv4.

If we want to go in the direction of forcing extra inode updates just
for this, then we might even consider making i_version updates on disk
default to OFF unless NFSv4 has exported the filesystem at least once,
and then it should set a persistent flag in the superblock indicating
that i_version updates are needed.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
