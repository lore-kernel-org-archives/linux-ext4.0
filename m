From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [RFC] ext4: off by one check in ext4_ext_convert_to_initialized()
Date: Sat, 23 Jun 2012 12:15:20 +0300
Message-ID: <20120623091520.GB26923@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, kernel-janitors@vger.kernel.org,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:27398 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091Ab2FWJPc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 23 Jun 2012 05:15:32 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I am not very familiar with this code, but I think that we should be
using "<= EXT4_EXT_ZERO_LEN" here instead of "< EXT4_EXT_ZERO_LEN".

1)  The other comparisons with EXT4_EXT_ZERO_LEN use "<=".

2)  On the first side of the if else statement we do:
	if (allocated <= EXT4_EXT_ZERO_LEN ...
		split_map.m_len = allocated;
    On this side, it would match to do:
	if (map->m_lblk - ee_block + map->m_len <= EXT4_EXT_ZERO_LEN ...
		split_map.m_len = map->m_lblk - ee_block + map->m_len;

It's not the most air tight of arguments, so I've submitted this with a
big warning message.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 91341ec..2df32a4 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3208,7 +3208,7 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 				goto out;
 			split_map.m_lblk = map->m_lblk;
 			split_map.m_len = allocated;
-		} else if ((map->m_lblk - ee_block + map->m_len <
+		} else if ((map->m_lblk - ee_block + map->m_len <=
 			   EXT4_EXT_ZERO_LEN) &&
 			   (EXT4_EXT_MAY_ZEROOUT & split_flag)) {
 			/* case 2 */
