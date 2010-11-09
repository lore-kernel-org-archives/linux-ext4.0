From: =?big5?B?vGU=?= <l021220a@yahoo.com.tw>
Subject: How can I do online resize from 14TB to 30TB?
Date: Tue, 9 Nov 2010 18:06:15 +0800 (CST)
Message-ID: <855286.34705.qm@web74212.mail.tp2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=big5
Content-Transfer-Encoding: 8BIT
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nm3-vm0.bullet.mail.tp2.yahoo.com ([203.188.200.200]:38550 "HELO
	nm3-vm0.bullet.mail.tp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754494Ab0KIKS7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Nov 2010 05:18:59 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I saw the mail "E2fsprogs master branch now has all 64-bit patch applied" written by Ted.  Ext4 with 64bit couldn't do online resize which is larger than 16TB, because "meta_bg" in kernel is not ready.

However, it really took lots of time to do off-line resizing.  Could I do online resize without meta_bg?  Or what can I do for e2fsprogs to support online resize for larger than 16TB?

Best regards,
Chien-kuan.



      
