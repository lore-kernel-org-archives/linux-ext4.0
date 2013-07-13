From: Subranshu Patel <spatel.ml@gmail.com>
Subject: Re: Bad sectors in metadata area
Date: Sat, 13 Jul 2013 21:54:29 +0530
Message-ID: <CAEUQcegN5Nqq+LaNuJFsm--U+p5Vpbw6bRZGk2JKVB7tNmiFmg@mail.gmail.com>
References: <CAEUQcehgmcsCStLG6XinU+9G6E7eWGko26A_QEwGvTrefuwjhw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qc0-f176.google.com ([209.85.216.176]:34681 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926Ab3GMQYa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 13 Jul 2013 12:24:30 -0400
Received: by mail-qc0-f176.google.com with SMTP id z10so5453838qcx.21
        for <linux-ext4@vger.kernel.org>; Sat, 13 Jul 2013 09:24:29 -0700 (PDT)
In-Reply-To: <CAEUQcehgmcsCStLG6XinU+9G6E7eWGko26A_QEwGvTrefuwjhw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Can fsck detect that  a block (metadata) corresponding to a bad LBA
sector is not readable and then a new sector will  be allocated.
