From: Andreas Dilger <adilger@clusterfs.com>
Subject: Rename i_dir_acl -> i_size_high permanently?
Date: Sat, 25 Nov 2006 02:28:59 -0700
Message-ID: <20061125092859.GA4279@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:9118 "EHLO
	mail.clusterfs.com") by vger.kernel.org with ESMTP id S966111AbWKYJ3A
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 25 Nov 2006 04:29:00 -0500
To: Theodore Ts'o <tytso@mit.edu>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Ted,
what do you think about renaming the i_dir_acl field to i_size_high
permanently?  That is what it is used for, and there isn't a point
to use a macro for it everywhere when we never use it as i_dir_acl.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
