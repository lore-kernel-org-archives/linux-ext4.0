From: mspang@csclub.uwaterloo.ca (Michael Spang)
Subject: panic on boot at ext4_mb_poll_new_transaction
Date: Thu, 16 Oct 2008 03:07:35 -0400
Message-ID: <20081016070735.GA28486@csclub.uwaterloo.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:56399 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752501AbYJPHHg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Oct 2008 03:07:36 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I switched my laptop over to ext4 yesterday. Then I used tune2fs to
enable the features from mke2fs.conf's defaults for ext4 (some failed).

It worked fine initially but today I am getting a panic when the machine
boots: http://csclub.uwaterloo.ca/~mspang/panic.jpg .

Let me know if there's anything I can do to rescue it. Otherwise I'll
just reinstall.

Thanks.
Michael Spang
