From: Eric Sandeen <esandeen@redhat.com>
Subject: Re: e2fsck doesn't finish
Date: Mon, 17 Apr 2017 14:16:26 -0500
Message-ID: <059b964a-facb-cfd5-6691-4cc1d66fea61@redhat.com>
References: <f604727f-967c-0b49-a71c-f8adcaeb8945@gmail.com>
Reply-To: sandeen@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: Julius Schwartzenberg <julius.schwartzenberg@gmail.com>,
        linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41156 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757328AbdDQTQc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 17 Apr 2017 15:16:32 -0400
In-Reply-To: <f604727f-967c-0b49-a71c-f8adcaeb8945@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 4/16/17 12:07 PM, Julius Schwartzenberg wrote:
> Hi all,
> 
> I'm running into an e2fsck issue which seems to occur with one
> particular filesystem. The version from Ubuntu, Fedora and the latest
> release compiled from source all exhibit the same issue.
> 
> On one filesystem I have, when I run e2fsck, it prints it's doing step 1
> and then after a while just:
> "e2fsck: aborted"
> Nothing else is printed. I tried a badblock scan on the partition, but
> that didn't reveal any badblocks.
> 
> Here is the output of dumpe2fs:
> https://schwart6.home.xs4all.nl/dumpe2fs.sda4.gz
> 
> I suspect there's some condition with that filesystem that e2fsck
> doesn't handle. What would be the best way to figure out more about this
> problem?

When I look at your image, it's finding tons of corruption - much
more than just "step 1" followed by "e2fsck: aborted"

If you didn't see that, then I wonder if e2image is not properly
handling your filesystem...

You might try running with the '-v' flag and see if it gives any
more hints about where it's at when it fails, and attach the
full e2fsck output to the next reply.

-Eric
