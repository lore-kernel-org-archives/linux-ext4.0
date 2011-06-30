From: Tao Ma <tm@tao.ma>
Subject: [PATCH 0/4 RESEND]  ext4 trim bug fixes and improvement.
Date: Thu, 30 Jun 2011 22:42:52 +0800
Message-ID: <4E0C8B6C.8030403@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: tm@tao.ma
To: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:41235 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751174Ab1F3OnO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 30 Jun 2011 10:43:14 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,
	I just found these patches haven't been included yet, so resend them
and hope they can be included in 3.1.

    Patch 1/4 is a fix for the 'len' overflow. As we have decided that
we don't adjust start to s_first_data_block, this patch is still needed.
    Patch 2/4 is a speedup for trim in one group.
    Patch 3/4 adds trace points for the functions used in FITRIM.
    Patch 4/4 is a speedup for trim for the whole volume.

Thanks,
Tao
