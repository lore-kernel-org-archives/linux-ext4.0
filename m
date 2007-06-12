From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [RFC][PATCH 12/12] 48-bit block number for ACL in e2fsprogs
Date: Tue, 12 Jun 2007 04:17:06 -0600
Message-ID: <20070612101706.GQ5181@schatzie.adilger.int>
References: <466D7E5A.6080805@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Valerie Clement <valerie.clement@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:41861 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106AbXFLKRI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 Jun 2007 06:17:08 -0400
Content-Disposition: inline
In-Reply-To: <466D7E5A.6080805@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jun 11, 2007  18:54 +0200, Valerie Clement wrote:
> This patch is intended to contain the changes to support 48-bit block
> numbers for ACL. For now, it only contains modifications in the inode
> structure. It has to be completed.

This should go in ASAP, if just to reserve the fields.  If we are in
there, it probably makes sense to rename this "i_file_ea" and "i_file_ea_hi"?
And also replace i_dir_acl with i_size_hi?

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
