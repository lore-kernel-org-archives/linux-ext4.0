From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] libss: add newer libreadline to dlopen path
Date: Mon, 25 Jan 2010 22:19:38 -0600
Message-ID: <4B5E6D5A.9000900@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57091 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939Ab0AZETm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Jan 2010 23:19:42 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o0Q4Jgug010422
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Mon, 25 Jan 2010 23:19:42 -0500
Received: from Liberator.local (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o0Q4JckB030589
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 25 Jan 2010 23:19:41 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Rawhide now has libreadline.so.6 ... add it to the ever-expanding
list of libs to look for.

Unfortunately without commit 06ef971be505678ee462ae1844204ed24f14aedc
this fails in a rather cryptic way.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/lib/ss/get_readline.c b/lib/ss/get_readline.c
index 16679a3..4421052 100644
--- a/lib/ss/get_readline.c
+++ b/lib/ss/get_readline.c
@@ -36,7 +36,7 @@ static void ss_release_readline(ss_data *info)
 }
 
 /* Libraries we will try to use for readline/editline functionality */
-#define DEFAULT_LIBPATH "libreadline.so.5:libreadline.so.4:libreadline.so:libedit.so.2:libedit.so:libeditline.so.0:libeditline.so"
+#define DEFAULT_LIBPATH "libreadline.so.6:libreadline.so.5:libreadline.so.4:libreadline.so:libedit.so.2:libedit.so:libeditline.so.0:libeditline.so"
 
 void ss_get_readline(int sci_idx)
 {


