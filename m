From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: ext4 crypto: filename encryption modifications
Date: Tue, 12 May 2015 15:17:14 +0300
Message-ID: <20150512121713.GA31379@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: mhalcrow@google.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20853 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932433AbbELMR0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 May 2015 08:17:26 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello Michael Halcrow,

The patch 1f3862b5575b: "ext4 crypto: filename encryption
modifications" from Apr 12, 2015, leads to the following static
checker warning:

	fs/ext4/namei.c:1269 ext4_search_dir()
	warn: bool is not less than zero.

fs/ext4/namei.c
  1264          while ((char *) de < dlimit) {
  1265                  /* this code is executed quadratically often */
  1266                  /* do minimal checking `by hand' */
  1267                  if ((char *) de + de->name_len <= dlimit) {
  1268                          res = ext4_match(fname, de);
  1269                          if (res < 0) {
                                    ^^^^^^^
The comments for ext4_match() say it only returns zero and one.

 * NOTE! unlike strncmp, ext4_match returns 1 for success, 0 for failure.

So you could just do "if (ext4_match(fname, de)) {".

  1270                                  res = -1;
  1271                                  goto return_result;
  1272                          }
  1273                          if (res > 0) {
  1274                                  /* found a match - just to be sure, do
  1275                                   * a full check */
  1276                                  if (ext4_check_dir_entry(dir, NULL, de, bh,
  1277                                                  bh->b_data,
  1278                                                   bh->b_size, offset)) {
  1279                                          res = -1;
  1280                                          goto return_result;
  1281                                  }
  1282                                  *res_dir = de;
  1283                                  res = 1;
  1284                                  goto return_result;
  1285                          }

regards,
dan carpenter
