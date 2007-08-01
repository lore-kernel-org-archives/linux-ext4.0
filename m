From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH 2/4] e2fsprogs: Add undoe2fs
Date: Wed, 1 Aug 2007 01:02:11 -0500
Message-ID: <20070801060211.GO5469@schatzie.adilger.int>
References: <bee58d48110eee4d5cd133167245b99644148d96.1185933778.git.aneesh.kumar@linux.vnet.ibm.com> <47f96570519d76b8d59f92b729a0a48c4a1b68d8.1185933778.git.aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:54481 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755707AbXHAGCz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Aug 2007 02:02:55 -0400
Content-Disposition: inline
In-Reply-To: <47f96570519d76b8d59f92b729a0a48c4a1b68d8.1185933778.git.aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Aug 01, 2007  07:34 +0530, Aneesh Kumar K.V wrote:
> undoe2fs can be used to replay the transaction saved
> in the transaction file using undo I/O Manager

This should save the mtime of the superblock, and only do the undo
step if the filesystem hasn't changed.  Otherwise it could seriously
corrupt the filesystem.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
