From: Robin Dong <hao.bigrat@gmail.com>
Subject: Question about BIGALLOC
Date: Fri, 5 Aug 2011 15:59:01 +0800
Message-ID: <CAFZ0FUUH85yWoVZ3XpMMYjhiaDrV9QQRSrLsAomXhH8uG_duBg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:41283 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908Ab1HEH7D (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 5 Aug 2011 03:59:03 -0400
Received: by qyk38 with SMTP id 38so172325qyk.19
        for <linux-ext4@vger.kernel.org>; Fri, 05 Aug 2011 00:59:01 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi, Ted

I am doing some test of BIGALLOC using "next" branch of e2fsprogs and
kernel (3.0) with 23 bigalloc-patches.

Everything seems to work, but I have a question:
the "ee_len" of "struct ext4_extent" is used to indicate block numbers
not cluster,
an ext4_extent in 4K-block-size filesystem can only hold 128MB space at most
even with BIGALLOC feature enabled, so we don't have any benefit from
this for a file with large number of blocks.

Is this the design behavior or you will change it in the next version?


-- 
--
Best Regard
Robin Dong
