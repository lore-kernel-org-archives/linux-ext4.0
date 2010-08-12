From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] mke2fs: make "invalid blocks count" error more clear
Date: Thu, 12 Aug 2010 14:40:44 -0400
Message-ID: <4C64402C.3050205@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59858 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753956Ab0HLSks (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Aug 2010 14:40:48 -0400
Received: from int-mx04.intmail.prod.int.phx2.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.17])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o7CIelWv021963
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Thu, 12 Aug 2010 14:40:47 -0400
Received: from Liberator.local (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx04.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o7CIeiev005896
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 12 Aug 2010 14:40:47 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Mistakes on the commandline can lead to odd error messages:

# mke2fs -t ext4 -E stride=128 stripe-width=512 /dev/sda1
mke2fs: invalid blocks count - /dev/sda1

Making it a bit more explicit is more obvious:

mke2fs: invalid blocks count '/dev/sda1' on device 'stripe-width=512'

(hint, the mistake was no comma separation for -E)

Reported-by: Adam Huffman <bloch@verdurin.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index add7c0c..a34c1ba 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -1415,8 +1415,9 @@ static void PRS(int argc, char *argv[])
 		fs_blocks_count = parse_num_blocks2(argv[optind++],
 						   fs_param.s_log_block_size);
 		if (!fs_blocks_count) {
-			com_err(program_name, 0, _("invalid blocks count - %s"),
-				argv[optind - 1]);
+			com_err(program_name, 0,
+				_("invalid blocks count '%s' on device '%s'"),
+				argv[optind - 1], device_name);
 			exit(1);
 		}
 	}


