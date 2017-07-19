From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH V2] tune2fs: edit dire warning about check intervals
Date: Wed, 19 Jul 2017 12:26:19 -0500
Message-ID: <3d574f21-a93c-e1ae-2b92-d4b1d1156fb4@redhat.com>
References: <ce6bff3e-49f4-2bed-67ce-a7be604ce1cf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: =?UTF-8?B?THVrw6HFoSBDemVybmVy?= <lczerner@redhat.com>
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54718 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755094AbdGSR0U (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 19 Jul 2017 13:26:20 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EC211C0272DC
        for <linux-ext4@vger.kernel.org>; Wed, 19 Jul 2017 17:26:19 +0000 (UTC)
In-Reply-To: <ce6bff3e-49f4-2bed-67ce-a7be604ce1cf@redhat.com>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Time & mount-count based checks have been off by default for quite some
time now, but the dire warning about disabling them remains in the
tune2fs manpage, which is confusing.  We did "strongly consider
the consequences" and disabled it by default, no need to scare the
user about it now.  Inform the user of the consequences in a more
measured tone.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: explain that the default of no-check is a tradeoff.
    Edit the -i section as well.


diff --git a/misc/tune2fs.8.in b/misc/tune2fs.8.in
index 5c885f9..eccf277 100644
--- a/misc/tune2fs.8.in
+++ b/misc/tune2fs.8.in
@@ -134,7 +134,9 @@ Staggering the mount-counts at which filesystems are forcibly
 checked will avoid all filesystems being checked at one time
 when using journaled filesystems.
 .sp
-You should strongly consider the consequences of disabling
+Mount-count-dependent checking is disabled by default to avoid
+unanticipated long reboots while e2fsck does its work.  However,
+you may wish to consider the consequences of disabling
 mount-count-dependent checking entirely.  Bad disk drives, cables,
 memory, and kernel bugs could all corrupt a filesystem without
 marking the filesystem dirty or in error.  If you are using
@@ -289,15 +291,10 @@ as months, and
 .B w
 as weeks.  A value of zero will disable the time-dependent checking.
 .sp
-It is strongly recommended that either
+There are pros and cons to disabling these periodic checks; see the
+discussion under the
 .B \-c
-(mount-count-dependent) or
-.B \-i
-(time-dependent) checking be enabled to force periodic full
-.BR e2fsck (8)
-checking of the filesystem.  Failure to do so may lead to filesystem
-corruption (due to bad disks, cables, memory, or kernel bugs) going
-unnoticed, ultimately resulting in data loss or corruption.
+(mount-count-dependent check) option for details.
 .TP
 .B \-I
 Change the inode size used by the file system.   This requires rewriting
