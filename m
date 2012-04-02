From: Daniel Drake <dsd@laptop.org>
Subject: ext4 online resize and robustness to interruption
Date: Mon, 2 Apr 2012 09:17:19 -0600
Message-ID: <CAMLZHHSJG8a9Yco7c=Hzd_-HWdSXcHOqMqB5Tvh-U35DDGwMQw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Yongqiang Yang <xiaoqiangnk@gmail.com>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:54652 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219Ab2DBPRU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Apr 2012 11:17:20 -0400
Received: by vbbff1 with SMTP id ff1so1754698vbb.19
        for <linux-ext4@vger.kernel.org>; Mon, 02 Apr 2012 08:17:19 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I think this question has been asked before, but I'd like to revisit
it given the recent rework of ext4 online resizing:

How robust is ext4 online resize in the face of unexpected
interruption (i.e. sudden loss of power)?

The context here is that OLPC will now performing an online resize
upon first boot of the system. Our laptops are frequently used in very
remote places with unreliable power, and given that we work in large
numbers, we're going to see some cases where the system lost power
during the resize operation. What is the expected effect here - will
the system boot up again just fine (perhaps with the original
partition size), and is then repeating the resize operation expected
to be safe and reliable?

Thanks,
Daniel
