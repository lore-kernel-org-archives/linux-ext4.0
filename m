From: Renaud Mariana <rmariana@online.net>
Subject: Re: HUGE slowdown when doing dpkg with ext4 over nbd
Date: Wed, 7 Dec 2016 10:52:48 +0100 (CET)
Message-ID: <1339224178.8897979.1481104368542.JavaMail.zimbra@online.net>
References: <1621417488.8583313.1481030030711.JavaMail.zimbra@online.net> <78AEFE7B-685B-4B4E-A15E-E3F6D99DD343@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.online.net ([62.210.16.11]:55191 "EHLO mail.online.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751512AbcLGJxW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 7 Dec 2016 04:53:22 -0500
In-Reply-To: <78AEFE7B-685B-4B4E-A15E-E3F6D99DD343@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Here are my answers, hope it will help solve this issue, thanks.

Recap:
dpkg kibana on ext4 over a nbd device takes 10 minutes 
with xfs it's only 30s.
with ext4 no extends only 30s.


kernels :
4.5.7 has this issue as older kernel like 4.4.34 
The issue is also when nbd client & server run on same host 


How small are the files?
here is the histogram of file sizes : http://pasteboard.co/6HC3nKyk2.png
We can see 5000 files around 512 Bytes.

dpkg using fallocate() ?
Yes, there are 16044 calls by the same process
what are these uninitialized extents ?


Cheers, Renaud
