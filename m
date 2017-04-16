From: Julius Schwartzenberg <julius.schwartzenberg@gmail.com>
Subject: e2fsck doesn't finish
Date: Sun, 16 Apr 2017 19:07:23 +0200
Message-ID: <f604727f-967c-0b49-a71c-f8adcaeb8945@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:34583 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756061AbdDPRH0 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 16 Apr 2017 13:07:26 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

I'm running into an e2fsck issue which seems to occur with one
particular filesystem. The version from Ubuntu, Fedora and the latest
release compiled from source all exhibit the same issue.

On one filesystem I have, when I run e2fsck, it prints it's doing step 1
and then after a while just:
"e2fsck: aborted"
Nothing else is printed. I tried a badblock scan on the partition, but
that didn't reveal any badblocks.

Here is the output of dumpe2fs:
https://schwart6.home.xs4all.nl/dumpe2fs.sda4.gz

I suspect there's some condition with that filesystem that e2fsck
doesn't handle. What would be the best way to figure out more about this
problem?

Best regards,
Julius
