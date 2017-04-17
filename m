From: Eric Sandeen <esandeen@redhat.com>
Subject: Re: e2fsck doesn't finish
Date: Mon, 17 Apr 2017 09:17:07 -0500
Message-ID: <f5fb3216-c52c-fc63-d90b-e6f670843882@redhat.com>
References: <f604727f-967c-0b49-a71c-f8adcaeb8945@gmail.com>
Reply-To: sandeen@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Julius Schwartzenberg <julius.schwartzenberg@gmail.com>,
        linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51402 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751874AbdDQORI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 17 Apr 2017 10:17:08 -0400
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

Providing an e2image might allow developers to analyze the problem.
If it's a large filesystem, the qcow output format is most portable.

-Eric
