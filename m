From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: e2fsprogs: add exclude bitmap support in e2fsprogs
Date: Sun, 23 Oct 2011 15:21:20 +0800
Message-ID: <1319354488-6050-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: amir73il@users.sf.net
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58496 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818Ab1JWJKw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 23 Oct 2011 05:10:52 -0400
Received: by iaby12 with SMTP id y12so71200iab.19
        for <linux-ext4@vger.kernel.org>; Sun, 23 Oct 2011 02:10:52 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Hi,

  Exclude bitmap(also known as snapshot bitmap) feature is needed
  by ext4 snapshot.  This patch series add exlcude bitmap in e2fsprogs
  except resize.  Kernel-side patches for resize which can support
  exclude bitmap and bigalloc are still waiting for merging.


Yongqiang.
