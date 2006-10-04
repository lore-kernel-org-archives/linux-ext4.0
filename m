From: Vasily Averin <vvs@sw.ru>
Subject: [PATCH 2.6.18] ext3: errors behaviour fix
Date: Wed, 04 Oct 2006 11:50:31 +0400
Message-ID: <452367C7.70302@sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Kirill Korotaev <dev@openvz.org>, Dmitry Mishin <dim@openvz.org>,
	Eric Sandeen <sandeen@sandeen.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.233.200]:2932 "EHLO relay.sw.ru")
	by vger.kernel.org with ESMTP id S1161134AbWJDHug (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Oct 2006 03:50:36 -0400
To: Theodore Tso <tytso@mit.edu>, Stephen Tweedie <sct@redhat.com>,
	Andrew Morton <akpm@osdl.org>, adilger@clusterfs.com,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, devel@openvz.org, cmm@us.ibm.com
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Dmitry Mishin <dim@openvz.org>

EXT3_ERRORS_CONTINUE should be taken from the superblock as default value for
error behaviour.

Signed-off-by:	Dmitry Mishin <dim@openvz.org>
Acked-by:	Vasily Averin <vvs@sw.ru>
Acked-by: 	Kirill Korotaev <dev@openvz.org>

--- linux-2.6.18/fs/ext3/super.c.e3erop	2006-09-20 07:42:06.000000000 +0400
+++ linux-2.6.18/fs/ext3/super.c	2006-10-03 15:51:44.000000000 +0400
@@ -1466,6 +1466,8 @@ static int ext3_fill_super (struct super
 		set_opt(sbi->s_mount_opt, ERRORS_PANIC);
 	else if (le16_to_cpu(sbi->s_es->s_errors) == EXT3_ERRORS_RO)
 		set_opt(sbi->s_mount_opt, ERRORS_RO);
+	else
+		set_opt(sbi->s_mount_opt, ERRORS_CONT);

 	sbi->s_resuid = le16_to_cpu(es->s_def_resuid);
 	sbi->s_resgid = le16_to_cpu(es->s_def_resgid);
