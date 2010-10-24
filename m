From: Jesus Sanchez Melendro <melendro@terra.es>
Subject: How to remove a corrupted dir in an ext4 FS?
Date: Sun, 24 Oct 2010 13:12:53 +0200
Message-ID: <201010241312.53784.melendro@terra.es>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from impaqm3.telefonica.net ([213.4.129.23]:51690 "EHLO
	IMPaqm3.telefonica.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932492Ab0JXLVK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 24 Oct 2010 07:21:10 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

After a corruption in an ext4 filesystem, I've checked and moved to the 
correct position all the files and dirs in lost+found, but one of the dirs is 
corrupted.

The "ls -l" command says:
d????????? ? ? ? ? ? /lost+found/#90116

If I try to remove it with "rmdir" or "rm -rf" or "mv" or "unlink", all 
commands say:
<command used>: failed to remove `#90116': Input/output error

Running "fsck" says that the filesystem is OK.

Is there a way to remove that corrupted dir?
