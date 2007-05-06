From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [RFC][take 4] e2fsprogs: Add ext4migrate
Date: Sat, 5 May 2007 23:17:59 -0600
Message-ID: <20070506051759.GP6220@schatzie.adilger.int>
References: <11782700042368-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:35647 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754597AbXEFFSD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 6 May 2007 01:18:03 -0400
Content-Disposition: inline
In-Reply-To: <11782700042368-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On May 04, 2007  14:43 +0530, Aneesh Kumar K.V wrote:
> Changes from from my previous patches are as follows:
> a) support for files with holes
> b) use the block iterator present in libext2fs
> c) don't mark  the indirect blocks as unused early. If we mark the
>    the blocks unused, they can be resued for extent index. If we later
>    fail to migrate, the indirect blocks content would be overwritten.

If this code could also (or optionally just) increase the size of inodes
it would be very useful.  AFAIK right now it will only change the inodes
from block-mapped to extent-mapped?


Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
