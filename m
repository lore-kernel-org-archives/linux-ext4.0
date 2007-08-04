From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [Patch 4/13] Allow regular files to be preallocated on-disk.
Date: Sat, 4 Aug 2007 10:19:43 -0600
Message-ID: <20070804161943.GF6142@schatzie.adilger.int>
References: <1185275088.3789.69.camel@dhcp4.linsyssoft.com> <20070804004013.GF7449@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Girish Shilamkar <girish@clusterfs.com>,
	Ext4 Mailing List <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:47952 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759289AbXHDQTo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 4 Aug 2007 12:19:44 -0400
Content-Disposition: inline
In-Reply-To: <20070804004013.GF7449@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Aug 03, 2007  20:40 -0400, Theodore Tso wrote:
> I'm also a little concerned this patch doesn't solve the problem where
> a filesystem that had been previously mounted on an IA64 machine gets
> connected to an x86 machine and then e2fsck is run.  This patch
> doesn't make the problem any more worse, and to fix this for real
> would require stashing the largest blocksize ever used by the
> filesystem in the superblock, and I'm not entirely convinced it's
> worth it.

At worst we get some warnings in that case and the extra blocks beyond
EOF are removed.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
