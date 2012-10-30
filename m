From: Ashish Sangwan <ashishsangwan2@gmail.com>
Subject: How to use new "native 4k sector sized" HDD with ext4
Date: Tue, 30 Oct 2012 18:27:52 +0530
Message-ID: <CAOiN93kV079jkdzY-R7jMVGQq4nN4c-sdswCq-XRaOpZm=ttwA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, adilger@dilger.ca, sandeen@redhat.com,
	Namjae Jeon <linkinjeon@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:41782 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756950Ab2J3M5x (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Oct 2012 08:57:53 -0400
Received: by mail-vc0-f174.google.com with SMTP id fk26so223816vcb.19
        for <linux-ext4@vger.kernel.org>; Tue, 30 Oct 2012 05:57:52 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We have a 2TB HDD having native 4k sector size but emulated as 512bytes.
And we want to use this device with sector size 4k and not 512bytes.

In mkfs.xfs there is option "-s", using which, one can set the sector size.
What is the use case of this option?

Also, such option is not present for ext4. So, apart from aligining the
 partition on multiple of 8 sector numbers do we have to do something else
 for using 4k sectors?

We measured the write performance of XFS/EXT4 with sector size 512bytes and 4KB.

XFS With 512 byte sector size=>
 RecSize    WriteSpeed  RanReadSpeed RanWriteSpeed
  524288   22.12MB/sec    0.00MB/sec    0.00MB/sec
  262144   18.87MB/sec    0.00MB/sec    0.00MB/sec
  131072   18.25MB/sec    0.00MB/sec    0.00MB/sec
   65536   18.90MB/sec    0.00MB/sec    0.00MB/sec
   32768   23.26MB/sec    0.00MB/sec    0.00MB/sec
   16384   18.21MB/sec    0.00MB/sec    0.00MB/sec
    8192   21.23MB/sec    0.00MB/sec    0.00MB/sec
    4096   20.58MB/sec    0.00MB/sec    0.00MB/sec

XFS after setting 4KB sector size (-s size 4096) =>
RecSize    WriteSpeed  RanReadSpeed RanWriteSpeed
  524288   21.93MB/sec    0.00MB/sec    0.00MB/sec
  262144   28.49MB/sec    0.00MB/sec    0.00MB/sec
  131072   25.64MB/sec    0.00MB/sec    0.00MB/sec
   65536   24.27MB/sec    0.00MB/sec    0.00MB/sec
   32768   26.39MB/sec    0.00MB/sec    0.00MB/sec
   16384   28.49MB/sec    0.00MB/sec    0.00MB/sec
    8192   22.83MB/sec    0.00MB/sec    0.00MB/sec
    4096   24.88MB/sec    0.00MB/sec    0.00MB/sec

Ext4 with default mkfs.ext4 options =>
 RecSize    WriteSpeed  RanReadSpeed RanWriteSpeed
  524288   31.95MB/sec    0.00MB/sec    0.00MB/sec
  262144   26.88MB/sec    0.00MB/sec    0.00MB/sec
  131072   23.04MB/sec    0.00MB/sec    0.00MB/sec
   65536   25.91MB/sec    0.00MB/sec    0.00MB/sec
   32768   24.69MB/sec    0.00MB/sec    0.00MB/sec
   16384   24.27MB/sec    0.00MB/sec    0.00MB/sec
    8192   32.05MB/sec    0.00MB/sec    0.00MB/sec
    4096   30.21MB/sec    0.00MB/sec    0.00MB/sec

Ext4 performed little better than XFS (-s size 4096).
Seeing this, we are tempted to believe that ext4 is already
using 4k sectors.

Is there any way to make sure that ext4 is indeed using 4k sectors?
