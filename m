From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: ext4: call out CRC and corruption errors with specific error
 codes
Date: Tue, 17 May 2016 16:15:24 +0300
Message-ID: <20160517131524.GA14581@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24264 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427AbcEQNPm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 17 May 2016 09:15:42 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id u4HDFevR008826
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Tue, 17 May 2016 13:15:41 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
	by aserv0022.oracle.com (8.13.8/8.13.8) with ESMTP id u4HDFeKR020346
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Tue, 17 May 2016 13:15:40 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
	by userv0121.oracle.com (8.13.8/8.13.8) with ESMTP id u4HDFdcm032419
	for <linux-ext4@vger.kernel.org>; Tue, 17 May 2016 13:15:40 GMT
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello Darrick J. Wong,

The patch 6a797d273783: "ext4: call out CRC and corruption errors
with specific error codes" from Oct 17, 2015, leads to the following
static checker warning:

	fs/ext4/xattr.c:854 ext4_xattr_block_set()
	warn: error is never (-117)

fs/ext4/xattr.c
  837                          /*
   838                           * This must happen under buffer lock for
   839                           * ext4_xattr_block_set() to reliably detect modified
   840                           * block
   841                           */
   842                          mb_cache_entry_delete_block(ext4_mb_cache, hash,
   843                                                      bs->bh->b_blocknr);
   844                          ea_bdebug(bs->bh, "modifying in-place");
   845                          error = ext4_xattr_set_entry(i, s);
   846                          if (!error) {
   847                                  if (!IS_LAST_ENTRY(s->first))
   848                                          ext4_xattr_rehash(header(s->base),
   849                                                            s->here);
   850                                  ext4_xattr_cache_insert(ext4_mb_cache,
   851                                          bs->bh);
   852                          }
   853                          unlock_buffer(bs->bh);
   854                          if (error == -EFSCORRUPTED)

We changed this from -EIO to -EFSCORRUPTED but actually
ext4_xattr_set_entry() doesn't return either of those.

   855                                  goto bad_block;
   856                          if (!error)
   857                                  error = ext4_handle_dirty_xattr_block(handle,
   858                                                                        inode,
   859                                                                        bs->bh);
   860                          if (error)
   861                                  goto cleanup;
   862                          goto inserted;
   863                  } else {

regards,
dan carpenter
