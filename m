From: "Rishabh Singh B.Tech., CSE, IIT-BHU, Varanasi (INDIA)"
	<rishabh.singh.cse11@iitbhu.ac.in>
Subject: Testing performance of SSDs using ext4 and effect on parameters
Date: Mon, 23 Jun 2014 10:00:51 +0530
Message-ID: <CAHohGC-fW0CEALotEY_93t=n7a3URZYAsAp2G2EytuRgBBdgtw@mail.gmail.com>
Reply-To: rishabh.singh.cse11@iitbhu.ac.in
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:62110 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbaFWEaw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 23 Jun 2014 00:30:52 -0400
Received: by mail-wi0-f180.google.com with SMTP id hi2so3351547wib.13
        for <linux-ext4@vger.kernel.org>; Sun, 22 Jun 2014 21:30:51 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I am testing the performance of SSDs using the ext4 file system in
Ubuntu. I want to test the effects on performance by changing
parameters:
1.data=writeback or ordered
2.barriers
3.noatime
4.errors

Can you kindly suggest me how do I change the desired parameters for
testing? And some other resouces that are helpful.

Thanking you,
Rishabh Singh
