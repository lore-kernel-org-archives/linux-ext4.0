From: Subranshu Patel <spatel.ml@gmail.com>
Subject: Recovery and Journalling
Date: Sun, 17 Mar 2013 17:37:14 +0530
Message-ID: <CAEUQcehjR7cgmYdTZ5_Yv8VuVAdPsL8i1ido9agmu5CzfknJNg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qe0-f49.google.com ([209.85.128.49]:59363 "EHLO
	mail-qe0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755911Ab3CQMHP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 17 Mar 2013 08:07:15 -0400
Received: by mail-qe0-f49.google.com with SMTP id 1so2774763qec.22
        for <linux-ext4@vger.kernel.org>; Sun, 17 Mar 2013 05:07:14 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This question is related to recovery (fsck and xfs_repair) and journalling.

I powered off (improper shut down) the system when the IO was
undergoing on mounted EXT4 filesystem.

After that I powered on my machine and then used fsck on the unmounted
filesystem. fsck recovered it.

There are 2 things which I want to confirm:
1. Firstly fsck replays the journal for any unfinished inconsistent writes.
2. Secondly it checks/repairs the other filesystem corruption.

Correct my understanding if wrong.

Consider the above scenario for XFS as well. In XFS, i need to mount
the filesystem, and this automatically replays the journal. After this
I again unmount the filesystem and run xfs_repair.

But in EXT4, i have to run fsck mandatorily before mounting my
filesystem. Please confirm my understanding.
