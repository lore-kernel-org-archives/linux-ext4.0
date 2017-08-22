From: Geert Lorang <geert.lorang@luciad.com>
Subject: ext4_mb_generate_buddy block bitmap and bg descriptor inconsistent
Date: Tue, 22 Aug 2017 15:25:46 +0200
Message-ID: <8e22ed00-f290-04de-15ba-eb6580e66ce8@luciad.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from relay.luciad.com ([91.216.20.195]:53502 "EHLO relay.luciad.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932791AbdHVNZs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 22 Aug 2017 09:25:48 -0400
Received: from [IPv6:2001:67c:1cc:152:9122:f2ca:1601:4ba4] (unknown [IPv6:2001:67c:1cc:152:9122:f2ca:1601:4ba4])
        by relay.luciad.com (Postfix) with ESMTPSA id AFB0317E1F
        for <linux-ext4@vger.kernel.org>; Tue, 22 Aug 2017 15:25:46 +0200 (CEST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

We have some QEMU virtual machines that go randomly into read-only state 
where the ext4 filesystem aborts with:
ext4_mb_generate_buddy:757: group X, block bitmap and bg descriptor 
inconsistent: Y vs 32768 free clusters

I know this has been discussed extensively already in the past e.g.

https://bugzilla.kernel.org/show_bug.cgi?id=102731
https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=818502
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1423672

Now the difference with those reports and our case is that the last 
number of the inconsistency (grp->bb_free) is *always* 32768 + We're 
sure the proposed patch is applied on both host & guest.

Is there anyone that can provide some insights in what /might/ be going 
on? E.g. what does this error actually mean and/or why it would always 
be exactly 32768?
It think it's unlikely something is wrong in the ext4 code - I'm just 
trying to reproduce the problem so we can figure out what's going on here.

My apologies if this does not belong on this list.

Thanks,
Geert
