From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: ext4: make the bitmap read routines return real error codes
Date: Tue, 3 Nov 2015 15:04:45 +0300
Message-ID: <20151103120445.GA20788@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44224 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447AbbKCMEx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Nov 2015 07:04:53 -0500
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id tA3C4qRC015327
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Tue, 3 Nov 2015 12:04:53 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
	by aserv0022.oracle.com (8.13.8/8.13.8) with ESMTP id tA3C4qoX031671
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-ext4@vger.kernel.org>; Tue, 3 Nov 2015 12:04:52 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
	by userv0121.oracle.com (8.13.8/8.13.8) with ESMTP id tA3C4pXd003583
	for <linux-ext4@vger.kernel.org>; Tue, 3 Nov 2015 12:04:51 GMT
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello Darrick J. Wong,

The patch 7d6232775976: "ext4: make the bitmap read routines return
real error codes" from Oct 17, 2015, leads to the following static
checker warning:

	fs/ext4/mballoc.c:2989 ext4_mb_mark_diskspace_used()
	error: 'bitmap_bh' dereferencing possible ERR_PTR()

fs/ext4/mballoc.c
  2899          bitmap_bh = ext4_read_block_bitmap(sb, ac->ac_b_ex.fe_group);
  2900          if (IS_ERR(bitmap_bh)) {
  2901                  err = PTR_ERR(bitmap_bh);
  2902                  goto out_err;
  2903          }
  2904  

[ snip ]

  2987  
  2988  out_err:
  2989          brelse(bitmap_bh);
  2990          return err;
  2991  }

Also:

fs/ext4/mballoc.c:4894 ext4_free_blocks() error: 'bitmap_bh' dereferencing possible ERR_PTR()
fs/ext4/mballoc.c:5028 ext4_group_add_blocks() error: 'bitmap_bh' dereferencing possible ERR_PTR()

This is One Err style error handling where one error label handles every
possible error so it's error prone (handling every error is more
complicated than doing a specific thing).

The old code relied on the sanity check in brelse() to avoid NULL
dereferences but now we are passing ERR_PTRs so it's not enough.
Probably the fix is to update the sanity check in brelse().  Another
idea would be to not free things until they have been allocated.

regards,
dan carpenter
