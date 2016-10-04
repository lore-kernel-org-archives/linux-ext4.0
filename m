From: Johannes Bauer <dfnsonfsduifb@gmx.de>
Subject: Re: Frequent ext4 oopses with 4.4.0 on Intel NUC6i3SYB
Date: Tue, 4 Oct 2016 21:55:58 +0200
Message-ID: <087b53e5-b23b-d3c2-6b8e-980bdcbf75c1@gmx.de>
References: <fcb653b9-cd9e-5cec-1036-4b4c9e1d3e7b@gmx.de>
 <20161004084136.GD17515@quack2.suse.cz>
 <90dfe18f-9fe7-819d-c410-cdd160644ab7@gmx.de>
 <2b7d6bd6-7d16-3c60-1b84-a172ba378402@gmx.de>
 <CABYiri-UUT6zVGyNENp-aBJDj6Oikodc5ZA27Gzq5-bVDqjZ4g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
        linux-mm@kvack.org
To: Andrey Korolyov <andrey@xdel.ru>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:60097 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751223AbcJDT4N (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 4 Oct 2016 15:56:13 -0400
In-Reply-To: <CABYiri-UUT6zVGyNENp-aBJDj6Oikodc5ZA27Gzq5-bVDqjZ4g@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 04.10.2016 20:45, Andrey Korolyov wrote:
>> Damn bad idea to build on the instable target. Lots of gcc segfaults and
>> weird stuff, even without a kernel panic. The system appears to be
>> instable as hell. Wonder how it can even run and how much of the root fs
>> is already corrupted :-(
>>
>> Rebuilding 4.8 on a different host.
> 
> Looks like a platform itself is somewhat faulty: [1]. Also please bear
> in mind that standalone memory testers would rather not expose certain
> classes of memory failures, I`d suggest to test allocator`s work
> against gcc runs on tmpfs, almost same as you did before. Frequency of
> crashes due to wrong pointer contents of an fs cache is most probably
> a direct outcome from its relative memory footprint.

So there's some interesting new data points that I couldn't make sense
of. Maybe you can.

First off, 4.8.0 shows the same symptoms. When I try to build 4.8.0 in
/usr/src/linux using make -j4, I get bus errors and segfaults in gcc
pretty soon.

Doing the same thing in /dev/shm, however, builds like a charm. Three
kernels built, all ran through perfectly. Not one try in /usr/src did
that, all my attempts failed.

What could cause this? Faulty hard drive? It's brand new:

Model Family:     Western Digital Red
Device Model:     WDC WD10JFCX-68N6GN0
Firmware Version: 82.00A82

ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail  Always
      -       0
  3 Spin_Up_Time            0x0027   182   181   021    Pre-fail  Always
      -       1858
  4 Start_Stop_Count        0x0032   100   100   000    Old_age   Always
      -       17
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail  Always
      -       0
  7 Seek_Error_Rate         0x002e   200   200   000    Old_age   Always
      -       0
  9 Power_On_Hours          0x0032   100   100   000    Old_age   Always
      -       178

Or faulty AHCI controller or driver?

[    9.746277] ahci 0000:00:17.0: version 3.0
[    9.746499] ahci 0000:00:17.0: AHCI 0001.0301 32 slots 1 ports 6 Gbps
0x1 impl SATA mode
[    9.746501] ahci 0000:00:17.0: flags: 64bit ncq pm led clo only pio
slum part deso sadm sds apst
[    9.753844] scsi host0: ahci
[    9.754648] ata1: SATA max UDMA/133 abar m2048@0xdf14d000 port
0xdf14d100 irq 275

I'm super puzzled right now :-(

Cheers,
Johannes
