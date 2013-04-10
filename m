From: Tao Ma <tm@tao.ma>
Subject: [PATCH 0/2] ext4: fix readdir error with getdents.
Date: Wed, 10 Apr 2013 23:33:50 +0800
Message-ID: <1365608030-3806-1-git-send-email-tm@tao.ma>
Cc: zab@redhat.com, tm@tao.ma
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy9.bluehost.com ([69.89.24.6]:38903 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1763998Ab3DJPeL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Apr 2013 11:34:11 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

Hi all,
    This patch set just tries to fix the problem when we call getdents
against an inline dir.  As file->f_pos has quite different meaning in
case of dir_index enabled/disabled. So 2 separate patches are created
to resolve these 2 issues in different ways.

Thanks,
Tao
