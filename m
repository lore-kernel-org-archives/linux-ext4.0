From: Cryptooctoploid <cryptooctoploid@gmail.com>
Subject: Rtorrent Hash Failures
Date: Sat, 1 Nov 2008 21:15:57 +0100
Message-ID: <319012f0811011315p2bd3e60ch4d845eb3a307ff93@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.186]:53516 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397AbYKAUP6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 1 Nov 2008 16:15:58 -0400
Received: by rn-out-0910.google.com with SMTP id k40so1433272rnd.17
        for <linux-ext4@vger.kernel.org>; Sat, 01 Nov 2008 13:15:57 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Since I moved my file system to ext4 I get a lot of failed
chunks when I download torrents with rtorrent (happens
also with other torrent clients).
This manifests itself in a failed hash test once the torrent
download is finished.

The bug is 100% reproducible and switching to an ext3 partition
solves the problem.
