Return-Path: <SRS0=5TFS=QV=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCB7AC43381
	for <linux-ext4@archiver.kernel.org>; Thu, 14 Feb 2019 10:01:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB857222A1
	for <linux-ext4@archiver.kernel.org>; Thu, 14 Feb 2019 10:01:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="U+ByeJBJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395111AbfBNKBA (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 14 Feb 2019 05:01:00 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:43637 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393498AbfBNKA7 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Feb 2019 05:00:59 -0500
Received: by mail-pl1-f193.google.com with SMTP id f90so2893051plb.10
        for <linux-ext4@vger.kernel.org>; Thu, 14 Feb 2019 02:00:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Z2bkim4oALul+6F5qJgQ+hdQmsxKs2DCBYbBeQSsMyo=;
        b=U+ByeJBJKkKv7wQl+AkPzcCp2gG51NQeFSKJVvv5ak3wd2wJUPHFc3XUH8knY+Smr1
         MkN7O3zfIgH32rWH4NnPKCEdnvs8UcHHYMEW9Qv9AHJK04pclAndsmd8UgBNFIPYTE8s
         4Ph8Qd1uuBdhUcR64OQWfhEZxjzSUOUdHXR17r+558uuaBOF4EIFM1XPn1lfuy3HDKsv
         5Fa4tx4GIsUnuS0xLVEm30OxmLhtGKW1KO8bIKAqy+lwjXwm2W1qVdVMqWAIZ9oxiv0B
         4KujB8yaxuR7RSEz8GAY8Stlm4HiPRoIQYtrH76FfFfWZGhmRNQtx/CIATZ2lzrXdFwR
         Htnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Z2bkim4oALul+6F5qJgQ+hdQmsxKs2DCBYbBeQSsMyo=;
        b=VgXDFEdctKyXNYpMH71ay6oa9eOEn9mNpBP0ajXzNFQ/Dhrkoi7GkV6nw1xn2QNKhX
         jb/I/UMPvhLHE3OaDppqV9Z+NyrXBV+PdHUuZi4nWER5Q8/b5eh2PSPU3NgNB9AXcwT6
         GgitQARJYN4TV/RFy5hjKhCkHS4aFDz8KhUJYKZI9YF7ie/xEBlC/wdGkv3FA3SW+ixL
         P73v+cU9UiRcQQ9ZvCUsi/pGQegBjHV3GqsdPD57AEDVVzwAmUzyrF6wCJBvbGigeZO4
         NQ4O2seEXtqOxRxIBEg1WZL2FPwKGXJcRdhym98Ym3QoJfJqIkZPsDQIChs8dZuzhDbk
         IdVQ==
X-Gm-Message-State: AHQUAubdGAmx3BZpC0pFRMHKApwg6Y0sisOYb83nzr+8KNZNXrJcvnDU
        65CZ8Ie+Y6/umqxMRjbH7Py6qg==
X-Google-Smtp-Source: AHgI3IZ029eRAvLpKuBfBDOBD2fGCcZenX7szd7aNopMbnHOR619jQy9tKbWmQYngGXkmvpLlA0Rzw==
X-Received: by 2002:a17:902:2dc3:: with SMTP id p61mr3206016plb.166.1550138458576;
        Thu, 14 Feb 2019 02:00:58 -0800 (PST)
Received: from vader.thefacebook.com ([2620:10d:c090:180::1:5849])
        by smtp.gmail.com with ESMTPSA id i184sm2686952pfc.41.2019.02.14.02.00.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Feb 2019 02:00:57 -0800 (PST)
From:   Omar Sandoval <osandov@osandov.com>
To:     linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Cc:     kernel-team@fb.com, linux-api@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org
Subject: [RFC PATCH 0/6] Allow setting file birth time with utimensat()
Date:   Thu, 14 Feb 2019 02:00:07 -0800
Message-Id: <cover.1550136164.git.osandov@fb.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Omar Sandoval <osandov@fb.com>

Hi,

Since statx was added in 4.11, userspace has had an interface for
reading btime (file creation time), but no way to set it. This RFC patch
series adds support for changing btime with utimensat(). Patch 1 adds
the VFS infrastructure, patch 2 adds the support to utimensat() with a
new flag, and the rest of the patches add filesystem support; I excluded
CIFS for now because I don't have a CIFS setup to test it on.

Updating btime is useful for at least a couple of use cases:

- Backup/restore programs (my motivation for this feature is btrfs send)
- File servers which interoperate with operating systems that allow
  updating file creation time, including Mac OS [1] and Windows [2]

I've also included a man page patch, xfs_io support, and an xfstest.

Thoughts on the implementation or the interface?

Thanks!

1: https://developer.apple.com/library/archive/documentation/System/Conceptual/ManPages_iPhoneOS/man2/setattrlist.2.html
2: https://docs.microsoft.com/en-us/windows/desktop/api/fileapi/nf-fileapi-setfiletime

Omar Sandoval (6):
  fs: add btime to struct iattr
  fs: add AT_UTIME_BTIME for utimensat()
  Btrfs: add support for setting btime
  ext4: add support for setting btime
  f2fs: add support for setting btime
  xfs: add support for setting btime

 fs/attr.c                      |  6 +++
 fs/btrfs/inode.c               |  2 +
 fs/btrfs/super.c               |  4 +-
 fs/ext4/inode.c                | 15 +++++-
 fs/ext4/super.c                |  2 +-
 fs/f2fs/file.c                 | 19 ++++++--
 fs/f2fs/super.c                |  2 +-
 fs/utimes.c                    | 86 +++++++++++++++++++++-------------
 fs/xfs/libxfs/xfs_format.h     |  2 +-
 fs/xfs/libxfs/xfs_log_format.h |  2 +-
 fs/xfs/xfs_iops.c              | 11 ++++-
 fs/xfs/xfs_super.c             |  2 +-
 include/linux/fs.h             |  4 ++
 include/uapi/linux/fcntl.h     |  2 +
 14 files changed, 111 insertions(+), 48 deletions(-)

-- 
2.20.1

