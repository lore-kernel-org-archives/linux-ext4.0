From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: Segmentation fault in e4defrag -c
Date: Mon, 29 Jun 2009 15:03:21 +0900
Message-ID: <4A485929.7010403@rs.jp.nec.com>
References: <20090625105558.GA21773@uio.no> <4A4487B0.9080000@sx.jp.nec.com> <20090626093816.GA3175@uio.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: Kazuya Mio <k-mio@sx.jp.nec.com>, linux-ext4@vger.kernel.org
To: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:44413 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230AbZF2GDw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Jun 2009 02:03:52 -0400
In-Reply-To: <20090626093816.GA3175@uio.no>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

Steinar H. Gunderson wrote:
>> 3. stat "/home/sesse/Mika - Life In Cartoon Motion/11 - Ring Ring (Bonus Track).mp3"
> 
> pannekake:~# stat "/home/sesse/Mika - Life In Cartoon Motion/11 - Ring Ring (Bonus Track).mp3" 
>   File: `/home/sesse/Mika - Life In Cartoon Motion/11 - Ring Ring (Bonus Track).mp3'
>   Size: 4050385   	Blocks: 0          IO Block: 4096   regular file
> Device: fd12h/64786d	Inode: 688755      Links: 1
> Access: (0644/-rw-r--r--)  Uid: ( 1000/   sesse)   Gid: ( 1000/   sesse)
> Access: 2009-05-30 03:08:38.724454316 +0200
> Modify: 2008-09-01 20:38:26.135589449 +0200
> Change: 2008-09-01 20:38:26.135589449 +0200

Thank you for information.

File size is "4050385" but Blocks is "0"
probably means blocks are not allocated yet or file is *corrupted*.
Is your mp3 file available?

Anyway, with this patch, 0 blocks file is skipped,
therefore the segmentation fault you had will not happen.

Thanks and Regards,
Akira Fujita

Signed-off-by Akira Fujita <a-fujita@rs.jp.nec.com>
---
 online-defrag-cmd |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)
--- online-defrag-cmd	2009-06-29 13:07:16.000000000 +0900
+++ online-defrag-cmd-20090629	2009-06-29 13:07:41.000000000 +0900
@@ -1303,6 +1303,15 @@ int file_statistic(const char *file, con
 		return 0;
 	}

+	/* Has no blocks */
+	if (buf->st_blocks == 0) {
+		if (mode_flag & DETAIL) {
+			PRINT_FILE_NAME(file);
+			STATISTIC_ERR_MSG("File has no blocks");
+		}
+		return 0;
+	}
+
 	fd = open64(file, O_RDONLY);
 	if (fd < 0) {
 		if (mode_flag & DETAIL) {
@@ -1624,6 +1633,15 @@ int file_defrag(const char *file, const
 		return 0;
 	}

+	/* Has no blocks */
+	if (buf->st_blocks == 0) {
+		if (mode_flag & DETAIL) {
+			PRINT_FILE_NAME(file);
+			STATISTIC_ERR_MSG("File has no blocks");
+		}
+		return 0;
+	}
+
 	fd = open64(file, O_RDONLY);
 	if (fd < 0) {
 		if (mode_flag & DETAIL) {
