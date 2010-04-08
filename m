From: minskey <chaohong_guo@linux.intel.com>
Subject: binary search in ext4_ext_binsearch_idx()
Date: Thu, 08 Apr 2010 11:26:16 +0800
Message-ID: <1270697176.21760.27.camel@minskey-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga12.intel.com ([143.182.124.36]:37547 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755656Ab0DHDiE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Apr 2010 23:38:04 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



in ext4_ext_binsearch_idx() routine, there is the following code:

 while (l <= r) {
                m = l + (r - l) / 2;
                if (block < le32_to_cpu(m->ei_block))
                        r = m - 1;
                else
                        l = m + 1;
 }

 path->p_idx = l - 1;

The code always runs logN iterations to get the expected extent,
if 3-way comparison is used, we can save some iterations when 
(block == le32_to_cpu(m->ei_block)) at the first iteration.

some other routines, such as ext4_ext_binsearch() etc, use the
same algorithm (2-way comparison), Is there any special goal ? 



thanks,
-minskey




