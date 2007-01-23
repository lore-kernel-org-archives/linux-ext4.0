From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [RFC] [patch 0/3] i_version update for ext4
Date: Tue, 23 Jan 2007 11:46:11 -0700
Message-ID: <20070123184611.GF5236@schatzie.adilger.int>
References: <45B644AA.1070409@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, nfsv4@linux-nfs.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:38196 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933104AbXAWSqN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Jan 2007 13:46:13 -0500
To: Cordenner jean noel <jean-noel.cordenner@bull.net>
Content-Disposition: inline
In-Reply-To: <45B644AA.1070409@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jan 23, 2007  18:23 +0100, Cordenner jean noel wrote:
> I've updated what was previously the change attribute patch for ext4 
> initially posted by Alexandre Ratchov. The previous patch was 
> introducing a change_attribute field, now it uses the i_version field of 
> the inode.
> 
> The i_version field is a counter that is set on every inode creation and 
> that is incremented every time the inode data is modified (similarly to 
> the "ctime" time-stamp).
> The aim is to fulfill NFSv4 requirements for rfc3530.
> For the moent, the counter is only a 32bit value but it is planned to be 
> 64bit as required.
> 
> The patch is divided into 3 parts, the vfs layer, the ext4 specific code 
> and an user part to check i_version changes via stat.

Have you had a chance to look at the performance impact of this change
(possible with oprofile)?  Always marking the inodes dirty for ext3
may have some noticable overhead.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
