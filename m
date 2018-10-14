Return-Path: <SRS0=nu1L=M2=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-it1-f194.google.com ([209.85.166.194]:35642 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726309AbeJNWll (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 14 Oct 2018 18:41:41 -0400
Received: by mail-it1-f194.google.com with SMTP id p64-v6so24221668itp.0
        for <linux-ext4@vger.kernel.org>; Sun, 14 Oct 2018 08:00:27 -0700 (PDT)
From: nicholas.clark@gmail.com
To: linux-ext4@vger.kernel.org
Cc: Nick Clark <nicholas.clark@gmail.com>
Subject: [PATCH RESEND 0/2] e2fsprogs: fuse2fs bugfix and new 'fakeroot' feature
Date: Sun, 14 Oct 2018 09:00:23 -0600
Message-Id: <20181014150025.6477-1-nicholas.clark@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Nick Clark <nicholas.clark@gmail.com>

Hi all,

I wrote a couple of patches for fuse2fs (from the e2fsprogs collection).
One is a minor bugfix to the displayed name in the mount command's output,
and the other is a new 'fakeroot' mount option, as described below.

When building cross-compiled Linux systems (for use on routers, consumer
devices, etc), it's often necessary to build rootfs filesystem images.
This commit adds a new 'fakeroot' mount option that gives a user full
control over the mounted filesystem, within the confines of FUSE.

When used, the new option allows treats allowed users as uid 0 for the
purposes of permission checks (within the mounted filesystem). This
allows the owner of a .img file to mount the file and make whatever
changes they want to any files inside of the image.

If the option is left disabled at mount-time, fuse2fs acts the same as
before - only root can edit "root"-owned files inside of the image. But
when enabled, fuse2fs becomes a powerful tool to build/modify filesystem
images.

What do you all think?

-Nick

Nicholas Clark (2):
  Fuse2fs: fix 'mount' entry in some cases.
  Fuse2fs: add fakeroot option.

 acinclude.m4      |  47 ++++++++++++++++
 configure         | 134 ++++++++++++++++++++++++++++++++++++++++++++++
 configure.ac      |   4 ++
 lib/config.h.in   |   6 +++
 misc/fuse2fs.1.in |   3 ++
 misc/fuse2fs.c    |  31 ++++++++---
 6 files changed, 217 insertions(+), 8 deletions(-)

-- 
2.17.1
