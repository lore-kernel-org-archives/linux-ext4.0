From: "Rishabh Singh B.Tech., CSE, IIT-BHU, Varanasi (INDIA)"
	<rishabh.singh.cse11@iitbhu.ac.in>
Subject: How to disable TRIM
Date: Tue, 1 Jul 2014 11:11:34 +0530
Message-ID: <CAHohGC8WtcfcsKFd2OjUbeQnUyw7qKmvUYuPtbCjPpQNfLxCaQ@mail.gmail.com>
Reply-To: rishabh.singh.cse11@iitbhu.ac.in
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:60334 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbaGAFlg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Jul 2014 01:41:36 -0400
Received: by mail-wi0-f173.google.com with SMTP id cc10so7125999wib.12
        for <linux-ext4@vger.kernel.org>; Mon, 30 Jun 2014 22:41:35 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I have enabled the TRIM option in SSDs by adding "discard" to the
/etc/fstab. But even after removing the "discard" the TRIM does not
appear to be disabled. This I can conclude from the write and read
speeds. How do I disable it?

Thanking You and Regards
