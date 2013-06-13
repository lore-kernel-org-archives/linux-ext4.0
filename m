From: Autif Khan <autif.mlist@gmail.com>
Subject: /dev/disk/by-label missing after upgrade to 1.42.7
Date: Thu, 13 Jun 2013 14:55:18 -0400
Message-ID: <CADzUK1+bAEXgXag+frRJBBH8A0rgbu-YUHOp0KG9jNJ_a0OG2A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f50.google.com ([209.85.215.50]:44956 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454Ab3FMSzU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Jun 2013 14:55:20 -0400
Received: by mail-la0-f50.google.com with SMTP id dy20so7074417lab.37
        for <linux-ext4@vger.kernel.org>; Thu, 13 Jun 2013 11:55:18 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

We are using /dev/disk/by-label/OURLABEL to mount USB disk partitions.

We were using Ubuntu 12.04 with 1.42 version of e2fsprogs - where we
encountered SSD corruption issues on unclean powerdown. It was
suggested that we upgrade to the latest e2fsprogs
(http://marc.info/?l=linux-ext4&m=137035378614543&w=2).

After the upgrade to 1.42.7, we do not have /dev/disk/by-label

I am not sure if this is the right place to ask this - but I thought
that I should start here and ask in udev mailing list later - (that
whole thing about correlation mumble causation).

I am still researching how /dev/disk/by-label comes into existence -
please advice if there is something obvious that I am missing.

Thanks

Autif
