From: Jiri Slaby <jirislaby@gmail.com>
Subject: [2.6.25-rc2-mm1] Oops in __kmalloc
Date: Tue, 26 Feb 2008 16:18:55 +0100
Message-ID: <47C42DDF.3060506@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>,
	Linux kernel mailing list <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Jan Sonnek <xsonnek@fi.muni.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.186]:38875 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755994AbYBZPST (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 26 Feb 2008 10:18:19 -0500
Received: by nf-out-0910.google.com with SMTP id g13so1139846nfb.21
        for <linux-ext4@vger.kernel.org>; Tue, 26 Feb 2008 07:18:17 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

while booting up a notebook on 32 bit, this oopses appeared on the console
after ext3 fsck:
http://www.fi.muni.cz/~xslaby/sklad/mem_oops/

It's 2.6.25-rc2-mm1, I can't find similar reports, is this known or hardware
issue (unlikely, 2.6.24.2 seems to be OK)?
