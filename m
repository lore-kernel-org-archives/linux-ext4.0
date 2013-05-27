From: Bert De Jonghe <Bert.DeJonghe@amplidata.com>
Subject: delayed allocation blocks not flushed?
Date: Mon, 27 May 2013 09:54:13 +0200
Message-ID: <51A31125.1070100@amplidata.com>
References: <51A31052.4030507@amplidata.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030804030902040505060301"
Cc: Bastiaan Stougie <bstougie@amplidata.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:39825 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756676Ab3E0HyU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 May 2013 03:54:20 -0400
Received: by mail-we0-f181.google.com with SMTP id u57so4244691wes.40
        for <linux-ext4@vger.kernel.org>; Mon, 27 May 2013 00:54:19 -0700 (PDT)
In-Reply-To: <51A31052.4030507@amplidata.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030804030902040505060301
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On an otherwise idle system, create an ext4 filesystem on /dev/sdi, 
mount it and wait more than dirty_writeback_centisecs.

Then create a small file (echo something > file);  wait 
(dirty_expire_centisecs x 2), expect delayed_allocation_blocks to fall 
to zero but it remains at 2 over here.

Create another small file (echo something_else > file2); again wait 
(dirty_expire_centisecs x 2); check delayed_allocation_blocks which is 
now at 4.

Wait a weekend more:

    # date; cat /sys/fs/ext4/sdi/delayed_allocation_blocks
    Fri May 24 15:33:21 UTC 2013
    4

    # date; cat /sys/fs/ext4/sdi/delayed_allocation_blocks
    Mon May 27 07:14:30 UTC 2013
    4

Doing a manual sync flushes out all blocks, also adding a sync after 
mounting solves the not flushing behaviour (possible patch attached).

Has anyone noticed this before and is this expected behaviour? It looks 
like these blocks are not flushed out to disk thus remain in memory and 
will be lost upon power failure?

Please Cc on reply as we're not on the list.

Many thanks & best regards,
Bert.





--------------030804030902040505060301
Content-Type: text/x-patch;
 name="sync_filesystem.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="sync_filesystem.patch"

--- fs/super.c.org	2013-05-22 09:45:55.061590168 +0200
+++ fs/super.c	2013-05-22 09:46:03.933589947 +0200
@@ -993,6 +993,7 @@
 		bdev->bd_super = s;
 	}
 
+	sync_filesystem(s); 
 	return dget(s->s_root);
 
 error_s:


--------------030804030902040505060301--
