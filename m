From: Subranshu Patel <spatel.ml@gmail.com>
Subject: Large buffer cache in EXT4
Date: Sun, 17 Feb 2013 09:34:15 +0530
Message-ID: <CAEUQcegw=gq9ndo=Zd4xC2gJDZrRzNpS2hAZW9x5Lh=KL_YDHQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-we0-f195.google.com ([74.125.82.195]:37046 "EHLO
	mail-we0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755366Ab3BQEER (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 16 Feb 2013 23:04:17 -0500
Received: by mail-we0-f195.google.com with SMTP id k14so998487wer.10
        for <linux-ext4@vger.kernel.org>; Sat, 16 Feb 2013 20:04:15 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I created 2 filesystem on my system (RHEL 6.3, kernel version 2.6.32)
- XFS and EXT4 and mounted them.

On both the filesystem I executed the mdtest tool(opensource tool) for
64 concurrent process. Each process performed the following:
- Create large number of directories
- Remove all the directories

During this time I monitored the memory usage of the system using sar
command. I checked the 3 components - kbmemused, kbbuffers and
kbcached

kbmemused - Amount of used memory in kilobytes. This does not take
into account memory used by the kernel itself.
kbbuffers - buffer cache
kbcached - page cache

While the kbmemused and kbcached component was almost similar in EXT4
and XFS (XFS being a little higher), the kbbuffer showed a totally
different trend.

For EXT4, kbbuffers was:
390999KB for dir creation
364803KB for dir removal
For XFS, kbbuffers was:

1701KB for dir creation
2738KB for dir removal

In kernel 2.6, both buffer cache and page cache are merged. The page
cache caches pages of files. The buffer cache caches disk blocks which
consists of mainly metadata (not file data).

Why is the buffer cache large in case of EXT4 and what is stored in
the buffer cache?
