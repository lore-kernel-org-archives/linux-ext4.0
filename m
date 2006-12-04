From: Erik Mouw <erik@harddisk-recovery.nl>
Subject: Re: [PATCH] Update ext[23] mailing list address
Date: Mon, 4 Dec 2006 21:17:43 +0100
Message-ID: <20061204201739.GE7028@harddisk-recovery.nl>
References: <20061204180243.GD7028@harddisk-recovery.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: sct@redhat.com, akpm@osdl.org, adilger@clusterfs.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from dtp.xs4all.nl ([80.126.206.180]:25057 "HELO abra2.bitwizard.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S937364AbWLDURp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 4 Dec 2006 15:17:45 -0500
To: linux-ext4@vger.kernel.org
Content-Disposition: inline
In-Reply-To: <20061204180243.GD7028@harddisk-recovery.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

(This patch applies on top of my previous patch to this list.)

Now ext[23] have correct mailing list information, add information
about the ext4 filesystem to the MAINTAINERS file.

Signed-off-by: Erik Mouw <erik@harddisk-recovery.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index e21ba04..7ec9a0c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1100,6 +1100,12 @@ M:	sct@redhat.com, akpm@osdl.org, adilge
 L:	linux-ext4@vger.kernel.org
 S:	Maintained
 
+EXT4 FILE SYSTEM
+P:	Stephen Tweedie, Andrew Morton
+M:	sct@redhat.com, akpm@osdl.org, adilger@clusterfs.com
+L:	linux-ext4@vger.kernel.org
+S:	Maintained
+
 F71805F HARDWARE MONITORING DRIVER
 P:	Jean Delvare
 M:	khali@linux-fr.org
