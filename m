From: Xiang Wang <xiangw@google.com>
Subject: Options for migrating existing files on ext2 partitions to ext4
Date: Wed, 11 Feb 2009 12:18:09 -0800
Message-ID: <d5ca277e0902111218l1b568724l2557315d2945637a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org, ext4-team <ext4-team@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:57928 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755342AbZBKUSN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Feb 2009 15:18:13 -0500
Received: from wpaz13.hot.corp.google.com (wpaz13.hot.corp.google.com [172.24.198.77])
	by smtp-out.google.com with ESMTP id n1BKIBQG010977
	for <linux-ext4@vger.kernel.org>; Wed, 11 Feb 2009 20:18:11 GMT
Received: from yx-out-1718.google.com (yxn6.prod.google.com [10.190.4.70])
	by wpaz13.hot.corp.google.com with ESMTP id n1BKHxAZ003388
	for <linux-ext4@vger.kernel.org>; Wed, 11 Feb 2009 12:18:10 -0800
Received: by yx-out-1718.google.com with SMTP id 6so243862yxn.36
        for <linux-ext4@vger.kernel.org>; Wed, 11 Feb 2009 12:18:10 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hey,

Since we are thinking of switching into using the ext4 file systems on
some of our machines with purely ext2 partitions, we face the problem
of how to migrate all those existing files on ext2 partitions. Seems
like there are two major directions to go:

1) do a backup, umount, mke2fs into ext4, and restore
In this approach, we may actually take advantage of the layout changes
so as to benefit from some features of ext4.

2) umount, tune2fs to add the 'extent' feature, mount back using type
ext4, migrate the existing files(directories) one by one through the
ioctl EXT4_IOC_MIGRATE
Motivated by the ext4 ioctl interface for migration, we are also
looking into this in-place approach. But we are mostly concerned with
the fact that if the existing files are highly fragmented, will we
still get benefit from the extents? Or will we even get hurt by
turning the files into being extents-based?

Before we do more detailed experiments on both approaches, we are here
to ask for advice, suggestion and comments.

So If you have ever run into either direction or even both, do you
have any experience you can share with us? Or simply express your
feeling:

Does it work? What could go wrong?
Does it take very long to complete the migration(of course, it could
depends on the number of files and their data block locations)?
Are you happy with the resulting files being migrated?
Has anyone every tried approach 2)? How did that work for you?

Thanks,
Xiang
