Return-Path: <SRS0=gd00=QI=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 066E2C169C4
	for <linux-ext4@archiver.kernel.org>; Fri,  1 Feb 2019 00:14:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF7AF218A6
	for <linux-ext4@archiver.kernel.org>; Fri,  1 Feb 2019 00:14:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=intel-com.20150623.gappssmtp.com header.i=@intel-com.20150623.gappssmtp.com header.b="wwh1cEsv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728824AbfBAAOV (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 31 Jan 2019 19:14:21 -0500
Received: from mail-it1-f175.google.com ([209.85.166.175]:51690 "EHLO
        mail-it1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728696AbfBAAOU (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 31 Jan 2019 19:14:20 -0500
Received: by mail-it1-f175.google.com with SMTP id w18so6695172ite.1
        for <linux-ext4@vger.kernel.org>; Thu, 31 Jan 2019 16:14:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:from:date:message-id:subject:to;
        bh=/ikGVur2BTna97J6i165vB4u7wCyrtv7CxkPfqopJ+o=;
        b=wwh1cEsvhapaDB/sRyGBk9Q5yehvXZBX+LjdpqRtgZjhQM4U8PHgq95Ed9kJ6b5eea
         WztXdv3RR/Oj/lMs2hV5Wx9vu7YwlXkXWepMuT4zK0T8SylgFTVuVer/Skkd5aBk+QFv
         HdMCGXZqROdvjaVGE5qTHzhV4nIMUGcaTGLAqnlbGrc11z7KrZjghPP8eSvP5gk6mF3v
         01ETmFGpHYSe4nPuKQs8WMh1fTnWAap7gj+zVEzUnB5uYcIxTtjMZoXSSydOjZ87eYTW
         zZJHqyrlPDNp/aCBQpHe4uI5gsdkOD/3ws2P11txkAPv2vxwU3ujhcVpdWfdUa/1uC/A
         oJZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=/ikGVur2BTna97J6i165vB4u7wCyrtv7CxkPfqopJ+o=;
        b=GyPEyBAF1yzBxD2nwK1rG40SHCycUuiUFf9UtaZHOBauUVNvlukPbtwanI/Jxruwzr
         YqxPDIBtlWmHWq4DI+j4qhGstRrV9N98IoqZSt3VAwfJEB/QXphOHKOv8SQzrU0VhaaX
         Syf0Hl9R/UoTHqZAHBDy294AUDZKZ0wYjp/zU1G1k62BalK04SfH52s95uI1HMCbFXey
         3ESWo54r6SBdXwIuiIirvI8LI7LtFFRzYhL1QcdxRcQq0SE1kZmv/gSC4H8qrU6W+AUq
         gDSUTU87VzCobcmY4ebQAM0Dd44zfhLZ+DHTX3egJt+BZHyqPElfSbK4cuDky4dn8o6b
         1H+Q==
X-Gm-Message-State: AJcUukfZvr4BB6DsUnzX6y5UkMQIxdpHEO5SMmGGjQP6Sf0c7p7jJByp
        lFguvOvFqZLo/fWDjZOjirjeW56gZ1Mft8RWcSvL457KSZ4=
X-Google-Smtp-Source: ALg8bN5xF6oSKxY8ab7/PWeMSD9u/9c0ZdAEGUcSY0a6th8w3/b0PJTz3bGTa5K0RhL35DKm7RksrdZIRBeaiVaQBko=
X-Received: by 2002:a02:1bc5:: with SMTP id 66mr24528906jas.105.1548980059560;
 Thu, 31 Jan 2019 16:14:19 -0800 (PST)
MIME-Version: 1.0
From:   "Burton, Ross" <ross.burton@intel.com>
Date:   Fri, 1 Feb 2019 00:14:08 +0000
Message-ID: <CAJTo0LYhwc978ywMkZ1v3xZHsW4DVwrszKnPoewvzvNixD_Pcg@mail.gmail.com>
Subject: Writing large files into a ext4 with mkfs is truncating files
To:     linux-ext4 <linux-ext4@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hi,

We're creating file systems using mkfs.ext4 -d /path/to/fs, but I'm
seeing file corruption when adding a large file, which appears to
trigger if the file is over 4GB.

For example, 3GB of random data:
$ mkdir fs
$ dd if=/dev/urandom of=fs/foo status=progress bs=1M count=3K
$ md5sum fs/foo
e3c7e0243208b49b55dd8e4f7681302f  fs/foo
$ truncate -s 6G foo.ext4
$ /sbin/mkfs.ext4  foo.ext4 -d fs/
$ sudo mount foo.ext4 /mnt
$ md5sum /mnt/foo
e3c7e0243208b49b55dd8e4f7681302f  /mnt/foo

But by just changing count=3K to count=5K:

...
a2c04fdb5e717f3b79f6989390e1ce50  fs/foo
e5e54aec74285b3e750fe0b877363e1d  /mnt/foo

A little sleuthing:

$ cmp fs/foo  /mnt/foo
fs/foo /mnt/foo differ: byte 1073741825, line 4194938

Okay that's not the 4GB boundary. But dumping the values 10 bytes
either side of that point:

$ dd if=fs/foo skip=1073741815 bs=1 count=20|od -b -Anone
 333 024 335 134 327 122 306 256 064 107 345 031 037 125 107 355
$ dd if=/mnt/foo skip=1073741815 bs=1 count=20|od -b -Anone
 333 024 335 134 327 122 306 256 064 000 000 000 000 000 000 000

At some point mkfs.ext4 stopped copying content and simply padded with zeros.

This is e2fsprogs 1.43.4 and 1.44.3.  I've not yet tried 1.44.5 or git master.

Ross
