Return-Path: <SRS0=EtEF=SK=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CA93C282CE
	for <linux-ext4@archiver.kernel.org>; Mon,  8 Apr 2019 06:29:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2BF432084F
	for <linux-ext4@archiver.kernel.org>; Mon,  8 Apr 2019 06:29:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UgyZWitK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726403AbfDHG3h (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 8 Apr 2019 02:29:37 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:54744 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726201AbfDHG3h (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Apr 2019 02:29:37 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x386TIQ4057157;
        Mon, 8 Apr 2019 06:29:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2018-07-02;
 bh=wHnQae8zV371jPoNo37e1GN5wixRF4jtuZ2OwOMBq0g=;
 b=UgyZWitKAPynT9bc0t7rgxNJQdPgMss2d+aoDJ5WuYJVXSSGNsxj/SSiS+5gFHVWuKYY
 7lbWBgbDIZK/zbE8ZMYgknpMMeS29lPucKW69dF3sn2M+waVVbm93NZcVd3unlmMyz/s
 PMs9L/CjlqtdTBBQg9CbNCVYCtFq5mZ3rmVmpZux/ihVo8cU2Dch+yuLezGYm+ldmIGx
 sa73pggyYKqLx3aqHj2JX+p+M3F0mah9yJVGQnLhbGzBjJ7YUmK2QCg7Yof5aZKpZpPV
 i2p4mTY4GWnwx360WXKddK7CmgyHcRMQPTe5kJaoaUunNMtRySC4hye9izFRVreypxOd Ug== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2rpkhsm78q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 08 Apr 2019 06:29:31 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x386SRhE073323;
        Mon, 8 Apr 2019 06:29:31 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2rph7ru9mg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 08 Apr 2019 06:29:31 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x386TUKN010284;
        Mon, 8 Apr 2019 06:29:30 GMT
Received: from kadam (/41.202.241.3)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 07 Apr 2019 23:29:29 -0700
Date:   Mon, 8 Apr 2019 09:29:20 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     kbuild@01.org, Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Cc:     kbuild-all@01.org, linux-ext4@vger.kernel.org,
        "Theodore Ts'o" <tytso@mit.edu>
Subject: [ext4:unicode 4/10] fs/unicode/utf8-core.c:90 utf8_casefold() warn:
 impossible condition '(dest[nlen] == -1) => (0-255 == (-1))'
Message-ID: <20190408062919.GC6070@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9220 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904080060
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9220 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904080060
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git unicode
head:   c0ae3a05c89c497446d6e208b68623993b5afc3c
commit: 45568caefa60a247ce9ecee3f4a57d1f81f5dd0e [4/10] unicode: implement higher level API for string handling

smatch warnings:
fs/unicode/utf8-core.c:90 utf8_casefold() warn: impossible condition '(dest[nlen] == -1) => (0-255 == (-1))'
fs/unicode/utf8-core.c:112 utf8_normalize() warn: impossible condition '(dest[nlen] == -1) => (0-255 == (-1))'

# https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git/commit/?id=45568caefa60a247ce9ecee3f4a57d1f81f5dd0e
git remote add ext4 https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git
git remote update ext4
git checkout 45568caefa60a247ce9ecee3f4a57d1f81f5dd0e
vim +90 fs/unicode/utf8-core.c

45568cae Gabriel Krisman Bertazi 2019-03-18   75  
45568cae Gabriel Krisman Bertazi 2019-03-18   76  int utf8_casefold(const struct unicode_map *um, const struct qstr *str,
45568cae Gabriel Krisman Bertazi 2019-03-18   77  		  unsigned char *dest, size_t dlen)
45568cae Gabriel Krisman Bertazi 2019-03-18   78  {
45568cae Gabriel Krisman Bertazi 2019-03-18   79  	const struct utf8data *data = utf8nfdicf(um->version);
45568cae Gabriel Krisman Bertazi 2019-03-18   80  	struct utf8cursor cur;
45568cae Gabriel Krisman Bertazi 2019-03-18   81  	size_t nlen = 0;
45568cae Gabriel Krisman Bertazi 2019-03-18   82  
45568cae Gabriel Krisman Bertazi 2019-03-18   83  	if (utf8ncursor(&cur, data, str->name, str->len) < 0)
45568cae Gabriel Krisman Bertazi 2019-03-18   84  		return -EINVAL;
45568cae Gabriel Krisman Bertazi 2019-03-18   85  
45568cae Gabriel Krisman Bertazi 2019-03-18   86  	for (nlen = 0; nlen < dlen; nlen++) {
45568cae Gabriel Krisman Bertazi 2019-03-18   87  		dest[nlen] = utf8byte(&cur);
45568cae Gabriel Krisman Bertazi 2019-03-18   88  		if (!dest[nlen])
45568cae Gabriel Krisman Bertazi 2019-03-18   89  			return nlen;
45568cae Gabriel Krisman Bertazi 2019-03-18  @90  		if (dest[nlen] == -1)
                                                                    ^^^^^^^^^^^^^^^^

45568cae Gabriel Krisman Bertazi 2019-03-18   91  			break;
45568cae Gabriel Krisman Bertazi 2019-03-18   92  	}
45568cae Gabriel Krisman Bertazi 2019-03-18   93  	return -EINVAL;
45568cae Gabriel Krisman Bertazi 2019-03-18   94  }
45568cae Gabriel Krisman Bertazi 2019-03-18   95  
45568cae Gabriel Krisman Bertazi 2019-03-18   96  EXPORT_SYMBOL(utf8_casefold);
45568cae Gabriel Krisman Bertazi 2019-03-18   97  
45568cae Gabriel Krisman Bertazi 2019-03-18   98  int utf8_normalize(const struct unicode_map *um, const struct qstr *str,
45568cae Gabriel Krisman Bertazi 2019-03-18   99  		   unsigned char *dest, size_t dlen)
45568cae Gabriel Krisman Bertazi 2019-03-18  100  {
45568cae Gabriel Krisman Bertazi 2019-03-18  101  	const struct utf8data *data = utf8nfdi(um->version);
45568cae Gabriel Krisman Bertazi 2019-03-18  102  	struct utf8cursor cur;
45568cae Gabriel Krisman Bertazi 2019-03-18  103  	ssize_t nlen = 0;
45568cae Gabriel Krisman Bertazi 2019-03-18  104  
45568cae Gabriel Krisman Bertazi 2019-03-18  105  	if (utf8ncursor(&cur, data, str->name, str->len) < 0)
45568cae Gabriel Krisman Bertazi 2019-03-18  106  		return -EINVAL;
45568cae Gabriel Krisman Bertazi 2019-03-18  107  
45568cae Gabriel Krisman Bertazi 2019-03-18  108  	for (nlen = 0; nlen < dlen; nlen++) {
45568cae Gabriel Krisman Bertazi 2019-03-18  109  		dest[nlen] = utf8byte(&cur);
45568cae Gabriel Krisman Bertazi 2019-03-18  110  		if (!dest[nlen])
45568cae Gabriel Krisman Bertazi 2019-03-18  111  			return nlen;
45568cae Gabriel Krisman Bertazi 2019-03-18 @112  		if (dest[nlen] == -1)
                                                                    ^^^^^^^^^^^^^^^^

45568cae Gabriel Krisman Bertazi 2019-03-18  113  			break;
45568cae Gabriel Krisman Bertazi 2019-03-18  114  	}
45568cae Gabriel Krisman Bertazi 2019-03-18  115  	return -EINVAL;
45568cae Gabriel Krisman Bertazi 2019-03-18  116  }
45568cae Gabriel Krisman Bertazi 2019-03-18  117  

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
