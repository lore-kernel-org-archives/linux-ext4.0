Return-Path: <SRS0=EtEF=SK=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A107BC282CE
	for <linux-ext4@archiver.kernel.org>; Mon,  8 Apr 2019 06:35:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B15320833
	for <linux-ext4@archiver.kernel.org>; Mon,  8 Apr 2019 06:35:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YeQgskWO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726201AbfDHGe7 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 8 Apr 2019 02:34:59 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60432 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbfDHGe7 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Apr 2019 02:34:59 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x386XUqQ060619;
        Mon, 8 Apr 2019 06:34:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2018-07-02;
 bh=H0vqoOz8epCaobFUGaoKtOzRdXDak6MMeaftzW+ovCw=;
 b=YeQgskWOWgaCoM5KfAda0stbHjwimjyXcmQtG37EWyK/jIc35Go1piPKiTp7ctLjCNs+
 REYIYDoMBZ+mDoMatyrlJT12IoHwFQ5co+dMVgPs8xBIeLTBY81AZcWusWLa6UuaX9il
 ObC21i7VINFbc6vxm0I3AHyY24hgxM5eR+hBCaOs3j5Acg2JJd12EYj9M6CJD5ZW4t/+
 lFleav4DgfapOJU/6hmioCQE64abC+pA2BHDz/tBFZhB8WZCQbTLWpqLhnZ8CZpfifrV
 yk/vneUeaXXHi2XJa3QE1K7p0DafTvWTYaVTWKuBRYPeIwF6J7Y6oWwRVyoKFOd20RUA ow== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2rpkhsm7xu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 08 Apr 2019 06:34:53 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x386Xomg094886;
        Mon, 8 Apr 2019 06:34:52 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2rpkehhsk8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 08 Apr 2019 06:34:52 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x386YpfP008216;
        Mon, 8 Apr 2019 06:34:52 GMT
Received: from kadam (/41.202.241.3)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 07 Apr 2019 23:34:51 -0700
Date:   Mon, 8 Apr 2019 09:34:43 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     kbuild@01.org, Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Cc:     kbuild-all@01.org, linux-ext4@vger.kernel.org,
        "Theodore Ts'o" <tytso@mit.edu>
Subject: [ext4:unicode 8/10] fs/ext4/hash.c:286 ext4fs_dirhash() warn:
 returning -1 instead of -ENOMEM is sloppy
Message-ID: <20190408063443.GE6070@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9220 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904080061
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9220 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904080061
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git unicode
head:   c0ae3a05c89c497446d6e208b68623993b5afc3c
commit: 6ca9bcdef8a4bc83fe8499ab47e29b849ea94bfb [8/10] ext4: support encoding-aware file name lookups

smatch warnings:
fs/ext4/hash.c:286 ext4fs_dirhash() warn: returning -1 instead of -ENOMEM is sloppy

# https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git/commit/?id=6ca9bcdef8a4bc83fe8499ab47e29b849ea94bfb
git remote add ext4 https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git
git remote update ext4
git checkout 6ca9bcdef8a4bc83fe8499ab47e29b849ea94bfb
vim +286 fs/ext4/hash.c

6ca9bcdef Gabriel Krisman Bertazi 2019-03-18  273  
6ca9bcdef Gabriel Krisman Bertazi 2019-03-18  274  int ext4fs_dirhash(const struct inode *dir, const char *name, int len,
6ca9bcdef Gabriel Krisman Bertazi 2019-03-18  275  		   struct dx_hash_info *hinfo)
6ca9bcdef Gabriel Krisman Bertazi 2019-03-18  276  {
6ca9bcdef Gabriel Krisman Bertazi 2019-03-18  277  #ifdef CONFIG_UNICODE
6ca9bcdef Gabriel Krisman Bertazi 2019-03-18  278  	const struct unicode_map *um = EXT4_SB(dir->i_sb)->s_encoding;
6ca9bcdef Gabriel Krisman Bertazi 2019-03-18  279  	int r, dlen;
6ca9bcdef Gabriel Krisman Bertazi 2019-03-18  280  	unsigned char *buff;
6ca9bcdef Gabriel Krisman Bertazi 2019-03-18  281  	struct qstr qstr = {.name = name, .len = len };
6ca9bcdef Gabriel Krisman Bertazi 2019-03-18  282  
6ca9bcdef Gabriel Krisman Bertazi 2019-03-18  283  	if (len && um) {
6ca9bcdef Gabriel Krisman Bertazi 2019-03-18  284  		buff = kzalloc(sizeof(char) * PATH_MAX, GFP_KERNEL);
6ca9bcdef Gabriel Krisman Bertazi 2019-03-18  285  		if (!buff)
6ca9bcdef Gabriel Krisman Bertazi 2019-03-18 @286  			return -1;

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
