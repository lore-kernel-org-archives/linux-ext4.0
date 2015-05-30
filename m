From: Albino Biasutti Neto <bino@riseup.net>
Subject: Re: [PATCH 4/8] ext4 crypto: encrypt tmpfile located in encryption
 protected directory
Date: Sat, 30 May 2015 07:45:03 -0300
Message-ID: <CAHAf8Wnornki0J0e27Hesd6vnk9C0vJhqpH-qAL+vSYg+MNErg@mail.gmail.com>
References: <1432856867-5710-1-git-send-email-tytso@mit.edu>
 <1432856867-5710-4-git-send-email-tytso@mit.edu> <CAHAf8Wm6n+32+HDjqnnNiV5vDWxsMBEzLS-qcdvnoODquWQ_ew@mail.gmail.com>
 <20150529163325.GE18540@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	jaegeuk@kernel.org, Michael Halcrow <mhalcrow@google.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:39313 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757740AbbE3Kp0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 30 May 2015 06:45:26 -0400
Received: from plantcutter.riseup.net (plantcutter-pn.riseup.net [10.0.1.121])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
	by mx1.riseup.net (Postfix) with ESMTPS id 2B80541938
	for <linux-ext4@vger.kernel.org>; Sat, 30 May 2015 10:45:26 +0000 (UTC)
Received: by wicmx19 with SMTP id mx19so37800762wic.0
        for <linux-ext4@vger.kernel.org>; Sat, 30 May 2015 03:45:24 -0700 (PDT)
In-Reply-To: <20150529163325.GE18540@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2015-05-29 13:33 GMT-03:00 Theodore Ts'o <tytso@mit.edu>:
> I think what you are asking is why is this function always returning
> NULL?

Yes. Or empty, only function.

> That's because it's in the #else clause of an #ifdef
> CONFIG_EXT4_FS_ENCRYPTION.  In the case where
> CONFIG_EXT4_FS_ENCRYPTION is defined, it returns:
>
> static inline struct ext4_crypt_info *ext4_encryption_info(struct inode *inode)
> {
>         return EXT4_I(inode)->i_crypt_info;
> }
>
> The idea is to minimize the need for #ifdef's in the .c files.

Understand, thanks.


Albino
