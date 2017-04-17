From: Eric Sandeen <esandeen@redhat.com>
Subject: Re: e2fsck doesn't finish
Date: Mon, 17 Apr 2017 10:18:02 -0500
Message-ID: <3183b5cf-ca1a-6c84-a277-9cb8d0f67790@redhat.com>
References: <f604727f-967c-0b49-a71c-f8adcaeb8945@gmail.com>
 <f5fb3216-c52c-fc63-d90b-e6f670843882@redhat.com>
 <deffb0af-1aaf-bad9-a7e5-64ea39171aa1@gmail.com>
Reply-To: sandeen@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Julius Schwartzenberg <julius.schwartzenberg@gmail.com>,
        linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42074 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754218AbdDQPSN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 17 Apr 2017 11:18:13 -0400
In-Reply-To: <deffb0af-1aaf-bad9-a7e5-64ea39171aa1@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 4/17/17 10:11 AM, Julius Schwartzenberg wrote:
> Eric Sandeen wrote:
>> Providing an e2image might allow developers to analyze the problem.
>> If it's a large filesystem, the qcow output format is most portable.
> 
> Here is the e2image:
> https://schwart6.home.xs4all.nl/sda4.e2i.bz2
> 
> The file is around 150M.
> It's made with -s as the file system concerned is actually /home on my
> notebook.

Got it, you may wish to delete it now just to err on the side of
privacy.

Thanks,
-Eric
