From: Pol Hallen <ext4@fuckaround.org>
Subject: EXT4-fs (dm-0): unsupported inode size: 0
Date: Tue, 2 Nov 2010 14:29:06 +0100
Message-ID: <201011021429.06471.ext4@fuckaround.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from vsmtp1.tin.it ([212.216.176.141]:48558 "EHLO vsmtp1.tin.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752559Ab0KBNex (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Nov 2010 09:34:53 -0400
Received: from lorna.homeunix.org (87.15.143.204) by vsmtp1.tin.it (8.0.022)
        id 4B9917F0147CF5A3 for linux-ext4@vger.kernel.org; Tue, 2 Nov 2010 14:29:07 +0100
Received: from pollon.localnet (pollon [192.168.1.3])
	by lorna.homeunix.org (Postfix) with ESMTP id 277BD64C02A
	for <linux-ext4@vger.kernel.org>; Tue,  2 Nov 2010 14:28:29 +0100 (CET)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi folks :-)

on a backup usb disk I've formatted ext4 (debian stable, kernel (2.6.32 
vanilla).

Later sometimes when i try to mount this disk in syslog I see:

EXT4-fs (dm-0): unsupported inode size: 0

the health how disk is good..

tune2fs -l /dev/disk is:

tune2fs 1.41.12 (17-May-2010)
tune2fs: Filesystem revision too high while trying to open /dev/mapper/pp
Couldn't find valid filesystem superblock.

what is the problem? Is an ext4 problem?

what can I do to fix the problem?
thanks :-)

Pol
