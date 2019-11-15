Return-Path: <SRS0=LoK8=ZH=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C09B9C432C3
	for <linux-ext4@archiver.kernel.org>; Fri, 15 Nov 2019 10:19:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 93E092075E
	for <linux-ext4@archiver.kernel.org>; Fri, 15 Nov 2019 10:19:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nHuYle8X"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727406AbfKOKT3 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 15 Nov 2019 05:19:29 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:49056 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725829AbfKOKT3 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 15 Nov 2019 05:19:29 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAFAEITu047434;
        Fri, 15 Nov 2019 10:16:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=aUmmUofXeDq4ex4OiGNZ0rOva3H7BkAtzGPYlS55bLk=;
 b=nHuYle8Xty0AFSNWkPzS01umuJvgDfPs7wnJsKEkmb3wEmAFZA9m6ADpCi3xqoLsGtGd
 Z3KnGAiwTZMsrWUq/ifEwPFsT0E3obZCRX9/N3WhhOAIuRtzQ5vY93ewLEo9ZTkmE5Wd
 NNLKVjfN3sx2Et9XcM1iaqY5JWvKEToHIyJKQuA4a6y41COXAtwq4FF+A++Sv4ah0sbf
 HOsNmQHNnNTbXM82dvkXlDuAQ2tlz7f3bqBUUH6pfVL+qMpuchnyZd50ClZt/dh31VK4
 oxZMn3cgvHjQ9WB1wgbUElqNpPmYoYqCjrzVdViSDriL7uxELP/adwQHlnVPos5kki9N uw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2w9gxpje6f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Nov 2019 10:16:48 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAFADDrC007930;
        Fri, 15 Nov 2019 10:16:47 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2w9h148fhj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Nov 2019 10:16:47 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAFAGi6e007575;
        Fri, 15 Nov 2019 10:16:44 GMT
Received: from dhcp-10-175-208-51.vpn.oracle.com (/10.175.208.51)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 15 Nov 2019 02:16:44 -0800
From:   Alan Maguire <alan.maguire@oracle.com>
To:     brendanhiggins@google.com, skhan@linuxfoundation.org,
        linux-kselftest@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, kunit-dev@googlegroups.com,
        keescook@chromium.org, yzaikin@google.com,
        akpm@linux-foundation.org, yamada.masahiro@socionext.com,
        catalin.marinas@arm.com, joe.lawrence@redhat.com,
        penguin-kernel@i-love.sakura.ne.jp, schowdary@nvidia.com,
        urezki@gmail.com, andriy.shevchenko@linux.intel.com,
        corbet@lwn.net, tytso@mit.edu, adilger.kernel@dilger.ca,
        mcgrof@kernel.org, changbin.du@intel.com,
        linux-ext4@vger.kernel.org, linux-doc@vger.kernel.org,
        sboyd@kernel.org, Alan Maguire <alan.maguire@oracle.com>,
        Knut Omang <knut.omang@oracle.com>
Subject: [PATCH v4 linux-kselftest-test 5/6] kunit: allow kunit to be loaded as a module
Date:   Fri, 15 Nov 2019 10:16:11 +0000
Message-Id: <1573812972-10529-6-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1573812972-10529-1-git-send-email-alan.maguire@oracle.com>
References: <1573812972-10529-1-git-send-email-alan.maguire@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9441 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911150096
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9441 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911150096
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Making kunit itself buildable as a module allows for "always-on"
kunit configuration; specifying CONFIG_KUNIT=m means the module
is built but only used when loaded.  Kunit test modules will load
kunit.ko as an implicit dependency, so simply running
"modprobe my-kunit-tests" will load the tests along with the kunit
module and run them.

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
Signed-off-by: Knut Omang <knut.omang@oracle.com>
---
 lib/kunit/Kconfig  |  2 +-
 lib/kunit/Makefile |  4 +++-
 lib/kunit/test.c   | 13 +++++++++++++
 3 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/lib/kunit/Kconfig b/lib/kunit/Kconfig
index 9ebd5e6..065aa16 100644
--- a/lib/kunit/Kconfig
+++ b/lib/kunit/Kconfig
@@ -3,7 +3,7 @@
 #
 
 menuconfig KUNIT
-	bool "KUnit - Enable support for unit tests"
+	tristate "KUnit - Enable support for unit tests"
 	help
 	  Enables support for kernel unit tests (KUnit), a lightweight unit
 	  testing and mocking framework for the Linux kernel. These tests are
diff --git a/lib/kunit/Makefile b/lib/kunit/Makefile
index bc6e5e54..fab5564 100644
--- a/lib/kunit/Makefile
+++ b/lib/kunit/Makefile
@@ -1,4 +1,6 @@
-obj-$(CONFIG_KUNIT) +=			test.o \
+obj-$(CONFIG_KUNIT) +=			kunit.o
+
+kunit-objs +=				test.o \
 					string-stream.o \
 					assert.o \
 					try-catch.o
diff --git a/lib/kunit/test.c b/lib/kunit/test.c
index 87b5cf1..41ef71a 100644
--- a/lib/kunit/test.c
+++ b/lib/kunit/test.c
@@ -486,3 +486,16 @@ void kunit_cleanup(struct kunit *test)
 	}
 }
 EXPORT_SYMBOL_GPL(kunit_cleanup);
+
+static int kunit_init(void)
+{
+	return 0;
+}
+late_initcall(kunit_init);
+
+static void __exit kunit_exit(void)
+{
+}
+module_exit(kunit_exit);
+
+MODULE_LICENSE("GPL");
-- 
1.8.3.1

