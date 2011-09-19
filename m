From: "Mohanan, Rajmohan" <rajmohan.mohanan@intel.com>
Subject: I'm getting a crash in journal_commit_transaction()
Date: Mon, 19 Sep 2011 04:31:58 -0700
Message-ID: <8EECBDCA81207E4DAF5CE05EFEA0AE754C823492@fmsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:26031 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753172Ab1ISLcD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Sep 2011 07:32:03 -0400
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

 I'm getting a crash in
 -000|journal_commit_transaction(journal = 0xC58B4600)
 -001|kjournald(?)
 -002|kthread(_create = 0xC5B0BD90)
 -003|kernel_thread_exit(asm)
  ---|end of frame
     |
     |
 I  have written a tty driver for serial operation and I'm doing
 Transferring data from my controller ... In between I gets the crash.

Could you help me to solve this issue.


Regards
Rajmohan


