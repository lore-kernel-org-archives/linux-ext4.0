Return-Path: <SRS0=HQ1C=RE=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF51BC43381
	for <linux-ext4@archiver.kernel.org>; Fri,  1 Mar 2019 14:05:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C5EB20850
	for <linux-ext4@archiver.kernel.org>; Fri,  1 Mar 2019 14:05:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KiTCO08p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388627AbfCAOFx (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 1 Mar 2019 09:05:53 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:34890 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387836AbfCAOFw (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Mar 2019 09:05:52 -0500
Received: by mail-pf1-f196.google.com with SMTP id j5so11496199pfa.2;
        Fri, 01 Mar 2019 06:05:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=rxf6mgVp6d1YHwZ1Z8EEdopyOJfX80ifj03EUHirz3g=;
        b=KiTCO08pIee97TA3kL7+uPYAyMFfmdGgqW6YdHBhquIEvqBVMffkjpiOhR/PEpyA1D
         biBpo5dQolheRGlAyPIyZBZqv9dXIrwmwb+fINPq+5DNQKoYEQ+ZJoKafWprYv8RzicZ
         88JsD/HKlarmaOgdvgR8NMl38w+Oei59Ulf6rwA8lUvC3IreHFwz7HOG9enMPJ3h9Fsx
         W7gQmOPQNQbPdC5V1W0Bnmchu3UhXf9QK3NJ/aBr+Q7Pg//CmQZIyGZr0Ir4bp3bCedY
         W6s7rDE2FTTQlSKKZomkl/kBCUDCmZcoVijX/GlAdfuZOwfMfo2TCAYO/nISW8GepWfB
         oacA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=rxf6mgVp6d1YHwZ1Z8EEdopyOJfX80ifj03EUHirz3g=;
        b=iPGIJ7QEwlWBZJ4++aI5g4r/ZW+eGdPl3vGPXyO6ncVMDLIhswcNBJrx73ZW5lWctm
         JGNBHggPpeGxmw+g/aLaXrYs++gMdIwfTdhBDI5RNXzJIKGdxInu9KnT1oJIbw4ztsyA
         d60EeysXdnnY9uAV6EMsHsvDDhcbyqQ7nBB6WOaZ9U/GBMgFJwO7C0jfe5ekpC9lNwto
         /IcZdkEPg0C1YnB1/D095tZWQOzKxN8CU36I7J/UXmK7HRpg9xVrUdVIQTHFxh8THYRC
         mTfSX145tQKGoDh2RXubbErCTFkwGlxUIRvQbdyaSWLL8stkgieeg13MEGkpY+HrptdV
         VLGw==
X-Gm-Message-State: APjAAAWNT7tCl+0g+XJN9dOwDOiavgCFXrP6VyUK+usE8xsnOvTreFNX
        18DyahClO2taftwU3eaTfRRGVC5W
X-Google-Smtp-Source: APXvYqywHSr0pXaKXg4q+46DpbHFk+82llKe8qqwu7XNF1rlswGqBWqqcKch8gNwNfaHo7aRgoAXyA==
X-Received: by 2002:a63:ed0b:: with SMTP id d11mr4944555pgi.435.1551449150864;
        Fri, 01 Mar 2019 06:05:50 -0800 (PST)
Received: from localhost.localdomain (fs276ec80e.tkyc203.ap.nuro.jp. [39.110.200.14])
        by smtp.gmail.com with ESMTPSA id a184sm12458089pge.68.2019.03.01.06.05.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 01 Mar 2019 06:05:49 -0800 (PST)
From:   Wang Shilong <wangshilong1991@gmail.com>
X-Google-Original-From: Wang Shilong <wshilong1991@gmail.com>
To:     linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Cc:     lixi@ddn.com, adilger@dilger.ca, Wang Shilong <wshilong@ddn.com>
Subject: [PATCH 0/8] add generic interface to set/get project
Date:   Fri,  1 Mar 2019 23:05:33 +0900
Message-Id: <1551449141-7884-1-git-send-email-wshilong1991@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Wang Shilong <wshilong@ddn.com>

Currently, Filesystem use FS_IOC_FS_SETXATTR ioctl
to change project ID of file. However we don't
support ioctl on symlink files, and it is desirable
to change symlink files' project ID just like uid/gid.

This patch try to reuse existed interface fchownat(),
use group id to set project ID if flag AT_FCHOWN_PROJID
passed in.

Also extend statx() calles to get symlink files' project
ID and inherit attribute.

Wang Shilong (8):
  fs: add support to change project ID
  ext4: support project ID in ext4_setattr()
  f2fs: support project ID in f2fs_setattr()
  xfs: support project ID in xfs_setattr()
  fs: add project support to statx
  ext4: support project in ext4_getattr()
  f2fs: support project in f2fs_getattr()
  xfs: support project in xfs_getattr()

 fs/attr.c                        | 26 +++++++++++++--
 fs/ext4/inode.c                  | 15 +++++++--
 fs/f2fs/file.c                   | 12 +++++--
 fs/open.c                        | 29 +++++++++++++----
 fs/quota/dquot.c                 | 23 ++++++++++++++
 fs/stat.c                        |  1 +
 fs/xfs/xfs_iops.c                | 54 ++++++++++++++++++++++++++------
 fs/xfs/xfs_linux.h               | 10 ++++++
 include/linux/fs.h               |  3 ++
 include/linux/quotaops.h         |  9 ++++++
 include/linux/stat.h             |  2 ++
 include/uapi/linux/fcntl.h       |  1 +
 include/uapi/linux/stat.h        |  8 +++--
 tools/include/uapi/linux/fcntl.h |  1 +
 tools/include/uapi/linux/stat.h  |  8 +++--
 15 files changed, 175 insertions(+), 27 deletions(-)

-- 
2.19.1

