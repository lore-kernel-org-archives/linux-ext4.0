From: Phillip Susi <psusi@ubuntu.com>
Subject: [PATCH 0/4] Add handy fs move features
Date: Tue,  8 Oct 2013 11:56:28 -0400
Message-ID: <1381247792-22508-1-git-send-email-psusi@ubuntu.com>
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rrcs-67-78-168-186.se.biz.rr.com ([67.78.168.186]:47916 "EHLO
	iriserv.iradimed.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732Ab3JHP4e (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Oct 2013 11:56:34 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The following patches add some handy features to e2image related
to moving the filesystem.  They can be useful for converting between
disks and images where one is partitioned and the other is not.
It will also allow gparted to more efficiently move ext[234]
partitions by skipping unused blocks.


Phillip Susi (4):
  e2image: add offset switches
  e2image: perform in-place move
  e2image: add progress indicator
  e2image: handle SIGINT safely

 misc/e2image.8.in |  45 +++++++++++++-
 misc/e2image.c    | 182 ++++++++++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 213 insertions(+), 14 deletions(-)

-- 
1.8.1.2

