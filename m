From: Eduard Rozenberg <edrozenberg@gmail.com>
Subject: Suggestion: don't default to ext4 lazy init (or warn about it)
Date: Mon, 13 Nov 2017 07:00:38 -0800
Message-ID: <CDF2F321-7726-417D-8163-2909B9DB9B19@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.11\))
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f180.google.com ([209.85.192.180]:54146 "EHLO
        mail-pf0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753160AbdKMPAm (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 13 Nov 2017 10:00:42 -0500
Received: by mail-pf0-f180.google.com with SMTP id b6so11746246pff.10
        for <linux-ext4@vger.kernel.org>; Mon, 13 Nov 2017 07:00:41 -0800 (PST)
Received: from [192.168.1.119] (c-67-180-167-218.hsd1.ca.comcast.net. [67.180.167.218])
        by smtp.gmail.com with ESMTPSA id y197sm32261754pfg.103.2017.11.13.07.00.39
        for <linux-ext4@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 Nov 2017 07:00:39 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

My first post to lkml so please go easy on me :).

After mkfs.ext4 on a 20TB volume, the process
ext4lazyinit is now grinding away on the disks
for several hours, and potentially days more
according to other threads I've read. By design 
it is using very little I/O (500-1000 K/s) even
though the volume is capable of 200-500 MB/s
and the system is doing nothing ATM.

The constant grinding noise (with HDD's) that
this causes is disruptive in a home or office 
environment. Lazy init may also cause undue 
worry to users running systems 'at home' -
"could the fs get corrupted if power goes out
while lazy init is going on?"

As I understand:
* There is no way to monitor its % completion
* There is no way to force it to speed up
* Would require a reformat to disable the lazy feature

If I knew I would have disabled lazy init during mkfs
but now I've copied TB's of data to the drive and
would much rather not have to start over.

Would suggest either a clear warning at mkfs ("using 
lazy init by default...") or default lazy init to off.
Defaulting to off will cause the least surprise to
most Linux users. For those who have some real
issue with the standard upfront init times they can
easily search for and enable the lazy init feature.

Personally have never had an issue with upfront
init even on 10-30 TB volumes. Enterprises with
PB volumes can do a bit of reading and enable
lazy init even if it defaults to off.

Thank you,
--Ed
