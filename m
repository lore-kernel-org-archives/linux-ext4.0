From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH 0/2] ext4: cache uninitialized extents
Date: Mon, 14 Nov 2011 11:07:04 +0800
Message-ID: <1321240026-844-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38112 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775Ab1KNF3e (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Nov 2011 00:29:34 -0500
Received: by iage36 with SMTP id e36so6824050iag.19
        for <linux-ext4@vger.kernel.org>; Sun, 13 Nov 2011 21:29:33 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

   Currently, ext4 caches holes and initialized extents in
ext4_ext_map_blocks() while it does not cache uninitialized
extents.  I noticed ext4 can cache uninitialized extents with
minor changes. ec_start is 0 means that the cached extent is
a hole, initialized extents' length is limited. So if ec_start
is not 0 and the cached extent's length is larger than EXT_MAX_LENGTH,
then the cached extent is uninitialized.

  This patch series tries to let ext4 cache uninitialized extents
with minor changes.

  The patches pass xfstests 1-268.  The xfstessts 268 and 272 meet
a bug in ext4 related to changing journal mode in flight.  I will
fix the bug in later patches.

  Any feedbacks and comments are welcome.

Yongqiang.

