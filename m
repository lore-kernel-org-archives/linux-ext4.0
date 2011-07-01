From: Tao Ma <tm@tao.ma>
Subject: [PATCH 0/5 RESEND V2] ext4: trim bug fixes and improvements.
Date: Fri, 01 Jul 2011 23:22:34 +0800
Message-ID: <4E0DE63A.7030103@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Ted Ts'o <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>, tm@tao.ma
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:35605 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753090Ab1GAPWs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Jul 2011 11:22:48 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

changelog from v1 to v2:
1. integrated comments form Lukas.
2. add another trivial fix reported by Andreas.

Patch 1/5 is a fix for the 'len' overflow. As we have decided that we
don't adjust start to s_first_data_block, this patch is still needed.
Patch 2/5 is a speedup for trim in one group.
Patch 3/5 adds trace points for the functions used in FITRIM.
Patch 4/5 is a speedup for trim for the whole volume.
Patch 5/5 is a trivial fix for the comment of ext4_trim_all_free.

Thanks,
Tao
