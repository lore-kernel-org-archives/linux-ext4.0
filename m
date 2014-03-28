From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: ext4: Introduce FALLOC_FL_ZERO_RANGE flag for fallocate
Date: Fri, 28 Mar 2014 11:03:56 +0300
Message-ID: <20140328080356.GB25192@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: lczerner@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24146 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbaC1IEQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 28 Mar 2014 04:04:16 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello Lukas Czerner,

The patch 1f0e51771281: "ext4: Introduce FALLOC_FL_ZERO_RANGE flag
for fallocate" from Mar 18, 2014, leads to the following static
checker warning:

	fs/ext4/extents.c:3653 ext4_split_convert_extents()
	warn: odd binop '0x4 & 0x10'

fs/ext4/extents.c
  3650          } else if (flags | EXT4_GET_BLOCKS_CONVERT) {
  3651                  split_flag |= ee_block + ee_len <= eof_block ?
  3652                                EXT4_EXT_MAY_ZEROOUT : 0;
  3653                  split_flag |= (EXT4_EXT_MARK_UNINIT2 & EXT4_EXT_DATA_VALID2);
                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
This statement is a no-op.  Probably | was intended?

  3654          }
  3655          flags |= EXT4_GET_BLOCKS_PRE_IO;

regards,
dan carpenter
