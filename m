From: "Leon Woestenberg" <leon.woestenberg@gmail.com>
Subject: commit only journal entries older than commit period?
Date: Wed, 9 May 2007 15:31:29 +0200
Message-ID: <c384c5ea0705090631v1fa61e73kc54e8173b73c25d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.235]:7176 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449AbXEINb3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 May 2007 09:31:29 -0400
Received: by wx-out-0506.google.com with SMTP id h31so180599wxd
        for <linux-ext4@vger.kernel.org>; Wed, 09 May 2007 06:31:29 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello all,

this is something I have long wondered about but have been afraid to ask.

When my system is chewing away on builds, the disk I/O write access
pattern of my ext3 root filesystem (using CFQ, Intel SATA controller,
hard disk) when visualized by GNOME System Monitor clearly shows a
repetitive landscape of large peaks, 5 seconds apart, which not much
activity inbetween.

I understand that's due to the ex3 journal commit interval (defaults
to 5 seconds).

But why isn't the filesystem continuously committing only that part of
the journal that is older than 5 seconds?

I would then expect the write requests to be smoothened over time,
which can only be good in terms of performance and low latency.

Regards,
-- 
Leon
