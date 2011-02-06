From: Coly Li <i@coly.li>
Subject: [PATCH 0/5] mballoc: trivial code cleanup
Date: Sun, 06 Feb 2011 12:53:34 +0800
Message-ID: <4D4E294E.4080507@coly.li>
Reply-To: i@coly.li
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Alex Tomas <alex@clusterfs.com>, Theodore Tso <tytso@google.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:50635 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752377Ab1BFE1J (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Feb 2011 23:27:09 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch set contains several trivial code cleanup to mballoc code.
A basic testing is done with Linux 2.6.38-rc3+ (commit 44f2c5c8).

Signed-off-by: Coly Li <bosong.ly@taobao.com>
Cc: Alex Tomas <alex@clusterfs.com>
Cc: Theodore Tso <tytso@google.com>
---
  fs/ext4/mballoc.c |   15 ++++++++++-----
  fs/ext4/mballoc.h |    2 +-
  2 files changed, 11 insertions(+), 6 deletions(-)
