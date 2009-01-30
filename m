From: Derkjan de Haan <haanjdj@gmail.com>
Subject: Re: can't get e4defrag to work
Date: Fri, 30 Jan 2009 14:07:51 +0100
Message-ID: <7a45233b0901300507y164dd475w4d96a5a47fed58d7@mail.gmail.com>
References: <7a45233b0901210704w5038d8b8g5c657e3a4746f34d@mail.gmail.com>
	 <49797056.7030607@rs.jp.nec.com>
	 <87f94c370901230751m107afe09w6df76e258c57eae3@mail.gmail.com>
	 <497D6843.50905@rs.jp.nec.com>
	 <37d33d830901260409y2cb01512u19646c477fa0e365@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: Akira Fujita <a-fujita@rs.jp.nec.com>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f12.google.com ([209.85.218.12]:56833 "EHLO
	mail-bw0-f12.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505AbZA3NSn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 30 Jan 2009 08:18:43 -0500
Received: by bwz5 with SMTP id 5so11788bwz.13
        for <linux-ext4@vger.kernel.org>; Fri, 30 Jan 2009 05:18:41 -0800 (PST)
In-Reply-To: <37d33d830901260409y2cb01512u19646c477fa0e365@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Akira,

I have downloaded the e4defrag patches of today, and I'm compiling a
kernel as we speak.
However, I can't compile e4defrag itself:

/tmp/ccHODC4D.o: In function `main':
3.c:(.text+0x393b): undefined reference to `powf'
collect2: ld returned 1 exit status

When I grep in /usr/include, powf only shows up in c++ include files.


regards,

Derkjan
