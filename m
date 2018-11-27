Return-Path: <SRS0=F3Rs=OG=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-pf1-f196.google.com ([209.85.210.196]:44502 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726345AbeK1BaS (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Nov 2018 20:30:18 -0500
Subject: ext4 file system corruption with v4.19.3 / v4.19.4
From: Guenter Roeck <linux@roeck-us.net>
To: Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <065643a0-f9aa-a361-715a-03ca978d9228@roeck-us.net>
Message-ID: <b43fb902-9b64-22d9-25ca-c970b3842a43@roeck-us.net>
Date: Tue, 27 Nov 2018 06:32:08 -0800
MIME-Version: 1.0
In-Reply-To: <065643a0-f9aa-a361-715a-03ca978d9228@roeck-us.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

[trying again, this time with correct kernel.org address]

Hi,

I have seen the following and similar problems several times,
with both v4.19.3 and v4.19.4:

Nov 23 04:32:25 mars kernel: [112668.673671] EXT4-fs error (device sdb1): ext4_iget:4831: inode #12602889: comm git: bad extra_isize 33661 (inode size 256)
Nov 23 04:32:25 mars kernel: [112668.675217] Aborting journal on device sdb1-8.
Nov 23 04:32:25 mars kernel: [112668.676681] EXT4-fs (sdb1): Remounting filesystem read-only
Nov 23 04:32:25 mars kernel: [112668.808886] EXT4-fs error (device sdb1): ext4_iget:4831: inode #12602881: comm rm: bad extra_isize 33685 (inode size 256)
...

Nov 25 00:12:43 saturn kernel: [59377.725984] EXT4-fs error (device sda1): ext4_lookup:1578: inode #238034131: comm updatedb.mlocat: deleted inode referenced: 238160407
Nov 25 00:12:43 saturn kernel: [59377.766638] Aborting journal on device sda1-8.
Nov 25 00:12:43 saturn kernel: [59377.779372] EXT4-fs (sda1): Remounting filesystem read-only
...

Nov 24 01:52:31 saturn kernel: [189085.240016] EXT4-fs error (device sda1): ext4_lookup:1578: inode #52038457: comm nfsd: deleted inode referenced: 52043796
Nov 24 01:52:31 saturn kernel: [189085.263427] Aborting journal on device sda1-8.
Nov 24 01:52:31 saturn kernel: [189085.275313] EXT4-fs (sda1): Remounting filesystem read-only


The same systems running v4.18.6 never experienced a problem.

Has anyone else seen similar problems ? Is there anything I can do
to help tracking down the problem ?

Thanks,
Guenter
