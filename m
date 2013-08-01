From: Felipe Monteiro de Carvalho <felipemonteiro.carvalho@gmail.com>
Subject: Re: File permissions in ext4
Date: Thu, 1 Aug 2013 14:34:57 +0200
Message-ID: <CACyNnZM51RDcyzah_nbQA+tSYDVAXsduzDkGAK-gjfBfo1NWDg@mail.gmail.com>
References: <CACyNnZM5iCC+A_RPM90jr-UUNP5VVnm=+59w6ip0oABqNbFXvQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:35048 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754630Ab3HAMe5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Aug 2013 08:34:57 -0400
Received: by mail-pb0-f41.google.com with SMTP id rp2so1554950pbb.28
        for <linux-ext4@vger.kernel.org>; Thu, 01 Aug 2013 05:34:57 -0700 (PDT)
In-Reply-To: <CACyNnZM5iCC+A_RPM90jr-UUNP5VVnm=+59w6ip0oABqNbFXvQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

Ok, I found that the permissions that I was looking for are stored in
ext4_inode.i_mode ... but still there is the question: What is ACL
used for then, and when is it different than zero?

thanks =)
-- 
Felipe Monteiro de Carvalho
