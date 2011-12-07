From: Andreas Dilger <adilger@whamcloud.com>
Subject: [PATCH 00/02] ext2: Reserve feature flags
Date: Tue, 6 Dec 2011 17:05:34 -0700
Message-ID: <BC7EBC84-486E-4BD5-A952-51C2B71BF455@whamcloud.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Liang Zhen <liang@whamcloud.com>, Tao Ma <tm@tao.ma>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:49983 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754920Ab1LGAFi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Dec 2011 19:05:38 -0500
Received: by yenm1 with SMTP id m1so3524381yen.19
        for <linux-ext4@vger.kernel.org>; Tue, 06 Dec 2011 16:05:37 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The following patches reserve feature flags for e2fsprogs to avoid conflicts in the future.

1 - reserve a new INCOMPAT_INLINEDATA flag for storing small files in
    the inode itself
2 - reserve a new INCOMPAT_LARGEDIR flag for allowing directories over
    2GB in size and with an htree depth larger than 2 levels

Cheers, Andreas
--
Andreas Dilger 
Principal Engineer
Whamcloud, Inc.



