From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: ext4: add meta_bg and bit64 support to online resizing
Date: Mon, 30 Jan 2012 00:01:02 +0800
Message-ID: <1327852866-4448-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: adilger@gmail.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38287 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756382Ab2CVNl1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 22 Mar 2012 09:41:27 -0400
Received: by iagz16 with SMTP id z16so3130313iag.19
        for <linux-ext4@vger.kernel.org>; Thu, 22 Mar 2012 06:41:27 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi List,

   This patch series adds meta_bg and bit64 support to online resizing,
the patches were tested with meta_bg, bit64 feature is not tested.

   Could anyone can test the patch with device whose size beyonds 16TB?

Yongqiang.

