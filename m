From: Daniel Drake <dsd@laptop.org>
Subject: Determining if an ext4 fs uses the whole partition
Date: Mon, 30 Apr 2012 11:19:31 -0600
Message-ID: <CAMLZHHSi=1U=-V+qMOOunPnuSWDcTm81aSjXdnc51kvYk=n_vA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f51.google.com ([209.85.210.51]:48982 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755985Ab2D3RTb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Apr 2012 13:19:31 -0400
Received: by dadz8 with SMTP id z8so4346228dad.10
        for <linux-ext4@vger.kernel.org>; Mon, 30 Apr 2012 10:19:31 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

OLPC has started using ext4 online resizing to grow our filesystems to
use the whole SD card on first boot - something we never did before.
Working very nicely, thanks!

I'm trying to simplify/improve the scripts involved in doing this.

How can I programatically check if an ext4 fs already fills its
partition, or if it has room to grow?


The numbers produced by dumpe2fs (e.g. block count) or "df" don't seem
to exactly line up with the sizes produced by fdisk.
One easy solution, if possible, would be to find out the number of the
last sector used by the filesystem. I could then very easily compare
this to the "end" information found in sysfs for the partition. Then I
can make the decision on whether to grow or not.

Thanks
Daniel
