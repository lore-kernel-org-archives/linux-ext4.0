From: Albino Biasutti Neto <bino@riseup.net>
Subject: Re: [PATCH 4/8] ext4 crypto: encrypt tmpfile located in encryption
 protected directory
Date: Fri, 29 May 2015 08:09:01 -0300
Message-ID: <CAHAf8Wm6n+32+HDjqnnNiV5vDWxsMBEzLS-qcdvnoODquWQ_ew@mail.gmail.com>
References: <1432856867-5710-1-git-send-email-tytso@mit.edu> <1432856867-5710-4-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	jaegeuk@kernel.org, mhalcrow@google.com
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:43654 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754472AbbE2LJX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 29 May 2015 07:09:23 -0400
Received: from berryeater.riseup.net (berryeater-pn.riseup.net [10.0.1.120])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
	by mx1.riseup.net (Postfix) with ESMTPS id 4FC1640B82
	for <linux-ext4@vger.kernel.org>; Fri, 29 May 2015 11:09:23 +0000 (UTC)
Received: by wicmc15 with SMTP id mc15so12913624wic.1
        for <linux-ext4@vger.kernel.org>; Fri, 29 May 2015 04:09:21 -0700 (PDT)
In-Reply-To: <1432856867-5710-4-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2015-05-28 20:47 GMT-03:00 Theodore Ts'o <tytso@mit.edu>:
> +static inline struct ext4_crypt_info *ext4_encryption_info(struct in=
ode *inode)
> +{
> +       return NULL;
> +}
>  #endif

Ts=C2=B4o, this code can not return anything be empty or not ?


Albino
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
