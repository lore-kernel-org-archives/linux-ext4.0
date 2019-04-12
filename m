Return-Path: <SRS0=VzNY=SO=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05525C10F0E
	for <linux-ext4@archiver.kernel.org>; Fri, 12 Apr 2019 19:40:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C747B20869
	for <linux-ext4@archiver.kernel.org>; Fri, 12 Apr 2019 19:40:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbfDLTks (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 12 Apr 2019 15:40:48 -0400
Received: from ec2-34-202-238-73.compute-1.amazonaws.com ([34.202.238.73]:40670
        "EHLO vps.thesusis.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726832AbfDLTkr (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Apr 2019 15:40:47 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Apr 2019 15:40:47 EDT
Received: from localhost (localhost [127.0.0.1])
        by vps.thesusis.net (Postfix) with ESMTP id 1783927527;
        Fri, 12 Apr 2019 15:34:06 -0400 (EDT)
Received: from vps.thesusis.net ([IPv6:::1])
        by localhost (ip-172-26-1-203.ec2.internal [IPv6:::1]) (amavisd-new, port 10024)
        with ESMTP id OQkHFKhq4Ymd; Fri, 12 Apr 2019 15:34:05 -0400 (EDT)
Received: from [192.168.1.145] (072-239-163-216.res.spectrum.com [72.239.163.216])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: psusi)
        by vps.thesusis.net (Postfix) with ESMTPSA id 8D9E02750A;
        Fri, 12 Apr 2019 15:34:05 -0400 (EDT)
From:   Phillip Susi <phill@thesusis.net>
Subject: defrag
To:     linux-ext4@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Message-ID: <5d46413a-b94f-a528-23a5-33aaae5cf642@thesusis.net>
Date:   Fri, 12 Apr 2019 15:34:04 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

So the other day I ran a dump of my root fs (ext4) to /dev/null and it
took 8.5 minutes.  This fs has been around for some time so I figured it
may be somewhat fragmented.  I formatted a fresh fs on a new (lvm)
volume and used dump | restore to clone my fs to that, and dumping that
to /dev/null took 3 minutes.  Quite an improvement.  I was curious so I
formatted the scratch volume with btrfs, dump|restore to clone, and used
btrfs-send to dump the volume to /dev/null and it took 3.5 minutes (
after our course dropping cache ).  Not bad.  I broke out the old defrag
utility and had to make a few fixes to get it to compile and run
properly again ( been several years since I touched it ), and after
using e2image to clone the fs to the scratch volume, and running
e2defrag on it, dumping that to null took 2m36s, so it seems that it
does still improve on the default allocation policy of a real mounted
filesystem, though not by a huge amount.

Next I went back and cloned the fs again with e2image and ran e4defrag
(as root) on it.  It said it had a bunch of failures so I ran it a
second time and it seemed to do some more work ( why didn't it do it all
the first time? ).  Or does it just print every file name ( no switches
) even if they are already not fragmented?  Anyhow, dumping the fs after
2 runs of e4defrag took 9m37s.  That seems to be no better than before
running e4defrag.  Odd.  I re-cloned the fs and dumped it without
e4defrag and it was 9m46 seconds, so this is probably due to the scratch
volume being located further down the disks in a slightly slower area
than the original, but it still is worth noting that running e4defrag
did not really improve the dump time, whereas e2defrag made a huge
difference.
