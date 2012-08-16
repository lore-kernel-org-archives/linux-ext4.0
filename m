From: Javier Marcet <jmarcet@gmail.com>
Subject: Fwd: Far too long mount time
Date: Thu, 16 Aug 2012 09:54:23 +0200
Message-ID: <CAAnFQG9esXovsAYkCS5Lw5JGpc5dW2PLccvYjN7NvaHLQDqGmA@mail.gmail.com>
References: <CAAnFQG_O051svcCZftDefebVEds+P1zAceteh=B18HOqmoqitg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Linux Ext4 Mailing List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49683 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507Ab2HPHyo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 16 Aug 2012 03:54:44 -0400
Received: by obbuo13 with SMTP id uo13so3328203obb.19
        for <linux-ext4@vger.kernel.org>; Thu, 16 Aug 2012 00:54:43 -0700 (PDT)
In-Reply-To: <CAAnFQG_O051svcCZftDefebVEds+P1zAceteh=B18HOqmoqitg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I'm in the process of setting up a new software raid with four 3TB disks.
So far I'm doing the tests using also bcache on a 60GB partition on a 120GB
SSD. Everything is protected by a UPS.

On the software side: self compiled kernel 3.5.1 and util-linux 2.20.1

Thus far, ext4 is doing really really well but for one thing, the mount
time. At the
moment I'm testing a RAID5 which makes the partition 8.2TB.

ext4 takes:
$ time mount /mnt/raid
0.00s user 79.49s system 92% cpu 1:26.25 total

xfs, OTOH, is way faster:
time mount /mnt/raid
0.00s user 0.01s system 0% cpu 1.869 total

I'v tried everything I could think of but the mount time remains constant.
Is
there anything I can do to speed up the mount time?


--
Javier Marcet <jmarcet@gmail.com>
