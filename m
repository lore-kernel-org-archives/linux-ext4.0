From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: ext4+quota fixes patch series [V2]
Date: Tue, 24 Nov 2009 01:55:47 +0300
Message-ID: <876390svf0.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.2ka.mipt.ru ([194.85.80.4]:56008 "EHLO mail.2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752872AbZKWWzm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Nov 2009 17:55:42 -0500
Received: from dmon-lp ([unknown] [10.55.93.124])
 by mail.2ka.mipt.ru (Sun Java(tm) System Messaging Server 7u2-7.02 64bit
 (built Apr 16 2009)) with ESMTPA id <0KTL00DKP3WIE510@mail.2ka.mipt.ru> for
 linux-ext4@vger.kernel.org; Tue, 24 Nov 2009 02:00:20 +0300 (MSK)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello, I've prepared patch-set which fixes some issues
in quota related code. With this patch-set applied i've
got success pass from all quota tests I use.
