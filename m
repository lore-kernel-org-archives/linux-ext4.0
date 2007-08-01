From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: e2fsprogs patches
Date: Wed, 1 Aug 2007 17:05:13 -0600
Message-ID: <20070801230513.GD5692@schatzie.adilger.int>
References: <11859824513552-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:60600 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbXHBPJx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 2 Aug 2007 11:09:53 -0400
Content-Disposition: inline
In-Reply-To: <11859824513552-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Aug 01, 2007  21:04 +0530, Aneesh Kumar K.V wrote:
> Regarding the naming of tdb file i decided to go with
> mke2fs-<device_name> instead of mke2fs-<device_name>-<time-stamp>.
> I guess having multiple version of this file in the tdb_dir will confuse
> the user.

I thought about this also - it might make sense to allow multiple undo
files if e.g. e2fsck is run several times in a row, and the user doesn't
like the outcome.  I think this also means that we should call the files
"undoe2fs-*" as having undo files for e2fsck is probably desirable.

I guess that also suggests we should save the s_lastcheck (last e2fsck)
time into the tdb, so we can be sure to undo them in the right order.

As for putting them into /var/lib/e2fsprogs, it might make sense to put
them into /var/tmp/e2fsprogs instead, because the files will be obsolete
as soon as the filesystem is mounted...  Alternately, e2fsprogs should
install something like /etc/cron.daily/e2fsprogs to clean up
/var/lib/e2fsprogs in a timely manner, like:

	tmpwatch -m 128 -d /var/lib/e2fsprogs

I also looked at logrotate, but it uses a fixed filename instead of
a regexp.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
