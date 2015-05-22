From: Albino Biasutti Neto <bino@riseup.net>
Subject: Re: [PATCH 0/4] e2fsprogs: Support for orphan file feature
Date: Fri, 22 May 2015 12:51:51 -0300
Message-ID: <CAHAf8Wm7CqhHWTN-4sfcLrqAYSsXvOTRFXZZyoMbcHmN03Wc1w@mail.gmail.com>
References: <1432294137-26078-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:56504 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757227AbbEVPwO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 May 2015 11:52:14 -0400
Received: from plantcutter.riseup.net (plantcutter-pn.riseup.net [10.0.1.121])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
	by mx1.riseup.net (Postfix) with ESMTPS id E7CAD41F3E
	for <linux-ext4@vger.kernel.org>; Fri, 22 May 2015 15:52:13 +0000 (UTC)
Received: by wichy4 with SMTP id hy4so51756069wic.1
        for <linux-ext4@vger.kernel.org>; Fri, 22 May 2015 08:52:11 -0700 (PDT)
In-Reply-To: <1432294137-26078-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2015-05-22 8:28 GMT-03:00 Jan Kara <jack@suse.cz>:
>   this is support orphan file feature in e2fsprogs. mke2fs and tune2fs support
> should be fine, e2fsck support still has bugs so use with care. I'm posting
> this mainly so that people can easily create filesystem with orphan file
> feature for testing the kernel patches.

How ?

Albino
