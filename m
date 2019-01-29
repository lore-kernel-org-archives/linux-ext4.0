Return-Path: <SRS0=tjTT=QF=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15BE9C169C4
	for <linux-ext4@archiver.kernel.org>; Tue, 29 Jan 2019 17:51:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D454A2175B
	for <linux-ext4@archiver.kernel.org>; Tue, 29 Jan 2019 17:51:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ESZoSDSA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727751AbfA2Rv5 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 29 Jan 2019 12:51:57 -0500
Received: from mail-it1-f195.google.com ([209.85.166.195]:39756 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727100AbfA2Rv5 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 29 Jan 2019 12:51:57 -0500
Received: by mail-it1-f195.google.com with SMTP id a6so5878158itl.4
        for <linux-ext4@vger.kernel.org>; Tue, 29 Jan 2019 09:51:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=YSmygC0B3he4pEp016Z1rvrEbu+L59zkh2F64ZgcTsQ=;
        b=ESZoSDSAPUneoEeeu7Nwzs2cpdQack30wwDCBj6qm9MppyyZkYhZ0r1yymuQHN/f5c
         DAUsID2nCTXvnrZyzQq/ow/xelu+1wdYE/TbZ76CIOqKvhCl9ChTu80blghFyVijvPu7
         Si3sXd1Z4DUdED9EMz1OokXCl1iOP5yiwmoE3+j9dUtukiQG+D7i/FSnvT4zNsU6v2wE
         8JkwDcohIbLgg6fj862jYMthmm9fFFNdSl96bJsMX6+2+32Hzz0QaseWYWabjIHGzEfS
         soJdGsb4m7KQCSJ5vTjSELTZiuwcdhI3PrLex4K4d8Wim/g2//WVi+K0wXiBdmpFr+WT
         +63w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=YSmygC0B3he4pEp016Z1rvrEbu+L59zkh2F64ZgcTsQ=;
        b=nQd54iWNbuwt1/LJA7DLFBVwn1IduVqaEwXKQ3CmO+rLCzJaZSQ8f/Ruh45x4ZWxTo
         oKGjZSHZx4TNXdeoJIP81FLpbZ+RRPeqRBpJPyDkq0Y8FEMRWTY+82+y8Fsl9u3oJUSk
         aWhXHWMVIot+4OQXXSF7Jl7hORfJ4eYZsjydRm8V/zPiipfAD9pywwAIjBzYtlWUoAps
         9MwKbJayObCpJ0kb/IoXuwSnkJIhNjmRfvoKcYWEE4bkdQbSwmGtEZIoQDHjlY8Qo5SC
         gapkbPxxdCKBoslMfRla7wQWm/h/OcB/zUHbGXqqeaiAUvm4/3KNQVjonxtDSrnrifP2
         0IZw==
X-Gm-Message-State: AJcUukfD54PelgZ5RyPFMEQcD9sf+iM5dmBP80jiu1AnxNMp7IrqBN2g
        nQJvt0qTsbHyG3dCJcmPEOTFuvhWkvI=
X-Google-Smtp-Source: AHgI3IbjBs5Qa7WzNlKqFbdo1xy6p0hNqiQ45jvtTtUS5b/hXt566EKijAe4JWp+qeduH5MSwNIC+g==
X-Received: by 2002:a24:7596:: with SMTP id y144mr14701719itc.68.1548784316349;
        Tue, 29 Jan 2019 09:51:56 -0800 (PST)
Received: from C02TN4C6HTD6.us.cray.com ([63.239.150.218])
        by smtp.gmail.com with ESMTPSA id b5sm15838778ioc.21.2019.01.29.09.51.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Jan 2019 09:51:55 -0800 (PST)
From:   Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <c17828@cray.com>
To:     linux-ext4@vger.kernel.org
Cc:     adilger.kernel@dilger.ca
Subject: [PATCH v7 0/4] e2image -b option to pass superblock number
Date:   Tue, 29 Jan 2019 20:51:30 +0300
Message-Id: <20190129175134.26652-1-c17828@cray.com>
X-Mailer: git-send-email 2.14.3
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

There was a discussion about possibility of using
superblock backup for creating images with e2image.

https://www.spinics.net/lists/linux-ext4/msg30583.html

Now our customer faced with situation then it would be
useful to have image file from partition with broken
superblock.

Here is set of patches that adds this functionality.

This is 7th version of the patch set.

Changes from previous version:

* Only two cases in try_open_fs() now: with and without passed
  superblock size.
* Some minor code style and comments issues are fixed.

Artem Blagodarenko (4):
  ext2fs: opening filesystem code refactoring
  e2image: add -b and -B options to use supperblock backup
  tests: add test for e2image -b option
  ext2fs: automaticlly open backup superblocks

 e2fsck/e2fsck.h             |   2 -
 e2fsck/message.c            |   3 +-
 e2fsck/unix.c               |  42 ++++---------
 e2fsck/util.c               |  73 -----------------------
 lib/ext2fs/openfs.c         |  39 ++++++++++--
 lib/support/Makefile.in     |   8 ++-
 lib/support/sb_backup.c     | 140 ++++++++++++++++++++++++++++++++++++++++++++
 lib/support/sb_backup.h     |  20 +++++++
 misc/dumpe2fs.c             |  17 +-----
 misc/e2image.8.in           |  33 +++++++++++
 misc/e2image.c              |  50 ++++++++++++++--
 tests/i_zero_super/expect.1 |  22 +++++++
 tests/i_zero_super/image.gz | Bin 0 -> 13262 bytes
 tests/i_zero_super/script   |  11 ++++
 14 files changed, 328 insertions(+), 132 deletions(-)
 create mode 100644 lib/support/sb_backup.c
 create mode 100644 lib/support/sb_backup.h
 create mode 100644 tests/i_zero_super/expect.1
 create mode 100644 tests/i_zero_super/image.gz
 create mode 100644 tests/i_zero_super/script

-- 
2.14.3

