From: Frank Mayhar <fmayhar@google.com>
Subject: Problem with ext4_sync_file in no-journal mode.
Date: Tue, 25 Aug 2009 10:44:05 -0700
Message-ID: <1251222245.20219.25.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:62601 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755056AbZHYRoJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Aug 2009 13:44:09 -0400
Received: from zps35.corp.google.com (zps35.corp.google.com [172.25.146.35])
	by smtp-out.google.com with ESMTP id n7PHi8tX006727
	for <linux-ext4@vger.kernel.org>; Tue, 25 Aug 2009 18:44:09 +0100
Received: from [172.29.60.126] (bobble.smo.corp.google.com [172.29.60.126])
	(authenticated bits=0)
	by zps35.corp.google.com with ESMTP id n7PHi6wo009326
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Tue, 25 Aug 2009 10:44:06 -0700
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Our powerfail testing turned up an odd regression when using fsync() in
no-journal mode to force data to the device.  We saw loss rates (both
file and data) that were much higher than the same test using ext2 (60+%
loss versus <10%).  We've done some investigation and one thing that
stood out was that in the no-journal case, ext4_sync_file() was just
calling sync_inode() (and nothing else), while ext2_sync_file(), for
comparison, was also calling sync_mapping_buffers() to actually push the
data out.

I therefore hacked ext4_sync_file() to call sync_mapping_buffers() in
the no-journal case; when we reran the test we saw that the loss rate
dropped from 60+% to around 50%.  While it's clear that we have more
work to do in this area, this is a significant improvement.  It appears
that this was just missed when we did the no-journal work.  Do you guys
concur?

The other interesting bit of this is that ext4 no-journal without using
fsync() has, apparently, basically the same loss rate as ext2 with
fsync().
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

