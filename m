From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] destroy ext4_es_cachep on module unload
Date: Thu, 25 Jul 2013 21:19:58 -0500
Message-ID: <51F1DCCE.6060405@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55826 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756932Ab3GZCT7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 25 Jul 2013 22:19:59 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r6Q2Jxiw020439
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Thu, 25 Jul 2013 22:19:59 -0400
Received: from Liberator.local (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r6Q2Jw3e019056
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 25 Jul 2013 22:19:59 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Without this, module can't be reloaded.

[  500.521980] kmem_cache_sanity_check (ext4_extent_status): Cache name already exists.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index bca26f3..59c0c03 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5481,6 +5483,7 @@ static void __exit ext4_exit_fs(void)
 	kset_unregister(ext4_kset);
 	ext4_exit_system_zone();
 	ext4_exit_pageio();
+	ext4_exit_es();
 }
 
 MODULE_AUTHOR("Remy Card, Stephen Tweedie, Andrew Morton, Andreas Dilger, Theodore Ts'o and others");


