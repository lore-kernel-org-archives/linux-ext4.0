From: Renaud Mariana <rmariana@online.net>
Subject: HUGE slowdown when doing dpkg with ext4 over nbd
Date: Tue, 6 Dec 2016 14:13:50 +0100 (CET)
Message-ID: <1621417488.8583313.1481030030711.JavaMail.zimbra@online.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.online.net ([62.210.16.11]:43163 "EHLO mail.online.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751592AbcLFNVy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 6 Dec 2016 08:21:54 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.online.net (Postfix) with ESMTP id 6A26FBCC7C4
        for <linux-ext4@vger.kernel.org>; Tue,  6 Dec 2016 14:13:51 +0100 (CET)
Received: from mail.online.net ([127.0.0.1])
        by localhost (mail.online.net [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id GpwRVUiYNARb for <linux-ext4@vger.kernel.org>;
        Tue,  6 Dec 2016 14:13:50 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by mail.online.net (Postfix) with ESMTP id D6CBEBCC7C3
        for <linux-ext4@vger.kernel.org>; Tue,  6 Dec 2016 14:13:50 +0100 (CET)
Received: from mail.online.net ([127.0.0.1])
        by localhost (mail.online.net [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id MQ2MfHXAqAVz for <linux-ext4@vger.kernel.org>;
        Tue,  6 Dec 2016 14:13:50 +0100 (CET)
Received: from mail.online.net (mail.online.net [62.210.16.11])
        by mail.online.net (Postfix) with ESMTP id B8375BCC7C4
        for <linux-ext4@vger.kernel.org>; Tue,  6 Dec 2016 14:13:50 +0100 (CET)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

We have noticed a HUGE slowdown when doing dpkg with ext4 over nbd (qemu-nbd as a server)

dpkg times with default mkfs & mount options is :

- ext4: 10 mn
- xfs : 30s.

Disabling extents : 
mkfs.ext4 -O ^extend
fixed the pb that is ext4 is as fast as xfs.

Any ideas ?
Renaud


Details :

xnbd-client  --blocksize 4096  qemu-nbd-ip 10000 /dev/nbd0
mkfs.ext4 /dev/nbd0
mount /dev/nbd0 /newroot

wget https://download.elastic.co/kibana/kibana/kibana-4.6.1-amd64.deb
time dpkg -i kibana-4.6.1-amd64.deb

kibana installs many small files (23209 entries) under /opt/kibana
