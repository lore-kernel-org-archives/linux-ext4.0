From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: ext4+quota patch series
Date: Mon, 23 Nov 2009 21:13:52 +0300
Message-ID: <87my2d5ctb.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.2ka.mipt.ru ([194.85.80.4]:47937 "EHLO mail.2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753235AbZKWSNt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Nov 2009 13:13:49 -0500
Received: from dmon-lp ([unknown] [10.55.93.124])
 by mail.2ka.mipt.ru (Sun Java(tm) System Messaging Server 7u2-7.02 64bit
 (built Apr 16 2009)) with ESMTPA id <0KTK00DXIQUO4B00@mail.2ka.mipt.ru> for
 linux-ext4@vger.kernel.org; Mon, 23 Nov 2009 21:18:27 +0300 (MSK)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello, I've prepared patch-set which fixes some issues
in quota related code. With this patch-set applied i've
got success pass from all quota tests I use.
