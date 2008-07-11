From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Ext4 patchqueue corrupted ?
Date: Fri, 11 Jul 2008 09:16:06 +0530
Message-ID: <20080711034606.GA779@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>, Ming Ming Cao <cmm@us.ibm.com>,
	pasky@suse.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:59252 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609AbYGKDra (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Jul 2008 23:47:30 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp04.au.ibm.com (8.13.1/8.13.1) with ESMTP id m6B3kYjA023850
	for <linux-ext4@vger.kernel.org>; Fri, 11 Jul 2008 13:46:34 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6B3jjCv4747314
	for <linux-ext4@vger.kernel.org>; Fri, 11 Jul 2008 13:45:45 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6B3kCmn008180
	for <linux-ext4@vger.kernel.org>; Fri, 11 Jul 2008 13:46:13 +1000
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi All,

[master@ext4-patch-queue]$ git pull
warning: no common commits
remote: Total 0 (delta 0), reused 0 (delta 0)
error: unable to find ec90e41198ede71d186bb7075e2edea7a6daae5a
fatal: object ec90e41198ede71d186bb7075e2edea7a6daae5a not found

kvaneesh@skywalker:/tmp$git clone git://repo.or.cz/ext4-patch-queue.git
Initialized empty Git repository in /tmp/ext4-patch-queue/.git/
remote: Total 0 (delta 0), reused 0 (delta 0)
remote: aborting due to possible repository corruption on the remote side.
error: waitpid (async) failed
fatal: error in sideband demultiplexer

The web interface doesn't list any commits.

-aneesh
