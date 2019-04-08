Return-Path: <SRS0=EtEF=SK=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C65FC282CE
	for <linux-ext4@archiver.kernel.org>; Mon,  8 Apr 2019 06:28:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 389D92084F
	for <linux-ext4@archiver.kernel.org>; Mon,  8 Apr 2019 06:28:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IwCsgQDZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726081AbfDHG22 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 8 Apr 2019 02:28:28 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38182 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725871AbfDHG22 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Apr 2019 02:28:28 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x386Ndfk063408;
        Mon, 8 Apr 2019 06:28:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2018-07-02;
 bh=m4zq2u2C/uSQSFRjMkS0Ae7uE2wGEXjuyJmdq2mF7c8=;
 b=IwCsgQDZWQztnvEI1kQwduCZV9KiW3r4acbHbjHxYEJ6fi0Ig/pMMo9MPoZVuSr9ZQXV
 epcH7WuKv6Rou/YmCGHvKOUynFpcQx+GXaIlox6IBswhIoUJE6/PpPPt3wVrAli7d0eY
 yXOqOJScTUu3L/QSDl+zibnVW4IxjDo9bSWp+9aS8Z3hsmlg9x6YbODK/VBf+lM/QVNm
 XINTtveVM7zK7uw1YpH2YGTj0goG6jnPXet24hg0tXyk2YhqG6GAN4hAOeM07dHxZ9pc
 gqW0DlQ70lI8jRX6cs+z2Hg8bKSVZWwzpq0fmVuLeb/FvmKubz1L4VquvxgPD/gaiYWt rw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2rpmrpv49b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 08 Apr 2019 06:28:17 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x386RX8x148050;
        Mon, 8 Apr 2019 06:28:17 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2rpytavdgg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 08 Apr 2019 06:28:17 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x386SDwr004583;
        Mon, 8 Apr 2019 06:28:13 GMT
Received: from kadam (/41.202.241.3)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 07 Apr 2019 23:28:12 -0700
Date:   Mon, 8 Apr 2019 09:28:03 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     kbuild@01.org, Olaf Weber <olaf@sgi.com>
Cc:     kbuild-all@01.org, linux-ext4@vger.kernel.org,
        "Theodore Ts'o" <tytso@mit.edu>,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: [ext4:unicode 2/10] fs/unicode/utf8-norm.c:199 utf8nlookup() warn:
 variable dereferenced before check 'data' (see line 193)
Message-ID: <20190408062803.GB6070@kadam>
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
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904080059
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git unicode
head:   c0ae3a05c89c497446d6e208b68623993b5afc3c
commit: e57d9d28d2810e8db572cb2720fd6024c0b11de4 [2/10] unicode: introduce code for UTF-8 normalization

smatch warnings:
fs/unicode/utf8-norm.c:199 utf8nlookup() warn: variable dereferenced before check 'data' (see line 193)

# https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git/commit/?id=e57d9d28d2810e8db572cb2720fd6024c0b11de4
git remote add ext4 https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git
git remote update ext4
git checkout e57d9d28d2810e8db572cb2720fd6024c0b11de4
vim +/data +199 fs/unicode/utf8-norm.c

e57d9d28 Olaf Weber 2019-03-18  181  
e57d9d28 Olaf Weber 2019-03-18  182  /*
e57d9d28 Olaf Weber 2019-03-18  183   * Use trie to scan s, touching at most len bytes.
e57d9d28 Olaf Weber 2019-03-18  184   * Returns the leaf if one exists, NULL otherwise.
e57d9d28 Olaf Weber 2019-03-18  185   *
e57d9d28 Olaf Weber 2019-03-18  186   * A non-NULL return guarantees that the UTF-8 sequence starting at s
e57d9d28 Olaf Weber 2019-03-18  187   * is well-formed and corresponds to a known unicode code point.  The
e57d9d28 Olaf Weber 2019-03-18  188   * shorthand for this will be "is valid UTF-8 unicode".
e57d9d28 Olaf Weber 2019-03-18  189   */
e57d9d28 Olaf Weber 2019-03-18  190  static utf8leaf_t *utf8nlookup(const struct utf8data *data, const char *s,
e57d9d28 Olaf Weber 2019-03-18  191  			       size_t len)
e57d9d28 Olaf Weber 2019-03-18  192  {
e57d9d28 Olaf Weber 2019-03-18 @193  	utf8trie_t	*trie = utf8data + data->offset;
                                                                           ^^^^^^^^^^^^

e57d9d28 Olaf Weber 2019-03-18  194  	int		offlen;
e57d9d28 Olaf Weber 2019-03-18  195  	int		offset;
e57d9d28 Olaf Weber 2019-03-18  196  	int		mask;
e57d9d28 Olaf Weber 2019-03-18  197  	int		node;
e57d9d28 Olaf Weber 2019-03-18  198  
e57d9d28 Olaf Weber 2019-03-18 @199  	if (!data)
                                             ^^^^
Too late.

e57d9d28 Olaf Weber 2019-03-18  200  		return NULL;
e57d9d28 Olaf Weber 2019-03-18  201  	if (len == 0)
e57d9d28 Olaf Weber 2019-03-18  202  		return NULL;
e57d9d28 Olaf Weber 2019-03-18  203  	node = 1;
e57d9d28 Olaf Weber 2019-03-18  204  	while (node) {

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
