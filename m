From: =?UTF-8?B?7ZmN7IugIHNoaW4gaG9uZw==?= <hongshin@gmail.com>
Subject: BUG? a suspected deadlock bug at ext4_fill_super()
Date: Thu, 30 Jul 2009 12:09:56 +0900
Message-ID: <2014bcab0907292009y425f746aub389c406ab2dda8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gx0-f213.google.com ([209.85.217.213]:47407 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413AbZG3DR5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 29 Jul 2009 23:17:57 -0400
Received: by gxk9 with SMTP id 9so2250586gxk.13
        for <linux-ext4@vger.kernel.org>; Wed, 29 Jul 2009 20:17:57 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi. I found a suspected deadlock bug from ext4.

ext4_fill_super() releases and re-takes BKL while s_umount is held.
Lock ordering at the point where BKL is re-taken is s_umount-> BKL.

However, at do_remount(), locking ordering is BKL->s_umount.
Therefore, concurrent execution of do_remount() and ext4_fill_super()
may result deadlock.

Please examine this report. Thank you.


p.s. I found this suspected bug by the motivation from
       commit 5f22ca9b13551debea77a407a8d06cd9c6f15238.
