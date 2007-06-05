From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [RFC PATCH ext3/ext4] orphan list corruption due bad inode
Date: Mon, 4 Jun 2007 21:52:32 -0600
Message-ID: <20070605035232.GC5181@schatzie.adilger.int>
References: <4663A0CE.102@sw.ru> <20070604190340.dba85bb0.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Vasily Averin <vvs@sw.ru>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	devel@openvz.org, linux-ext4@vger.kernel.org,
	Stephen Tweedie <sct@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:39626 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760205AbXFEDwe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Jun 2007 23:52:34 -0400
Content-Disposition: inline
In-Reply-To: <20070604190340.dba85bb0.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jun 04, 2007  19:03 -0700, Andrew Morton wrote:
> What caused those inodes to be bad, anyway?  Memory allocation failures?

This can happen if e.g. NFS has a stale file handle - it will look up
the inode by inum, but ext3_read_inode() will create a bad inode due to
i_nlink = 0.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
