From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] tune2fs: remove dire warning about check intervals
Date: Tue, 18 Jul 2017 16:10:49 -0500
Message-ID: <ce6bff3e-49f4-2bed-67ce-a7be604ce1cf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: =?UTF-8?B?THVrw6HFoSBDemVybmVy?= <lczerner@redhat.com>
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55746 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751557AbdGRVKu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 18 Jul 2017 17:10:50 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D0A417D0DB
        for <linux-ext4@vger.kernel.org>; Tue, 18 Jul 2017 21:10:49 +0000 (UTC)
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Time & mount-count based checks have been off by default for quite some
time now, but the dire warning about disabling them remains in the
tune2fs manpage, which is confusing.  We did "strongly consider
the consequences" and disabled it by default, no need to scare the
user about it now.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/misc/tune2fs.8.in b/misc/tune2fs.8.in
index 5c885f9..a8cacc7 100644
--- a/misc/tune2fs.8.in
+++ b/misc/tune2fs.8.in
@@ -134,17 +134,6 @@ Staggering the mount-counts at which filesystems are forcibly
 checked will avoid all filesystems being checked at one time
 when using journaled filesystems.
 .sp
-You should strongly consider the consequences of disabling
-mount-count-dependent checking entirely.  Bad disk drives, cables,
-memory, and kernel bugs could all corrupt a filesystem without
-marking the filesystem dirty or in error.  If you are using
-journaling on your filesystem, your filesystem will
-.B never
-be marked dirty, so it will not normally be checked.  A
-filesystem error detected by the kernel will still force
-an fsck on the next reboot, but it may already be too late
-to prevent data loss at that point.
-.sp
 See also the
 .B \-i
 option for time-dependent checking.
