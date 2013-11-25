From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: kernel panic using external journal and snapshots
Date: Mon, 25 Nov 2013 11:32:16 +0800
Message-ID: <20131125033216.GA20772@gmail.com>
References: <5281A8A3.80604@gmail.com>
 <20131122071145.GA5936@gmail.com>
 <52911078.40207@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Gordon Messmer <gordon.messmer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:36587 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431Ab3KYD32 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 24 Nov 2013 22:29:28 -0500
Received: by mail-pd0-f178.google.com with SMTP id y10so4612857pdj.9
        for <linux-ext4@vger.kernel.org>; Sun, 24 Nov 2013 19:29:28 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <52911078.40207@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Nov 23, 2013 at 12:30:48PM -0800, Gordon Messmer wrote:
> On 11/21/2013 11:11 PM, Zheng Liu wrote:
> >For the first question, I haven't a LVM device on my hand.  Hence I am
> >not sure whether there is a bug or not.
> >
> >For the second one, I do a test on my sand box against Linux-3.12-rc5,
> >and it works well.  So I think maybe you can try it again on a newer
> >kernel.
> 
> The problem manifests when a filesystem which uses external journal
> and its snapshot are simultaneously mounted.  If you don't have an
> LVM device with which to create a snapshot, I'm not sure what you're
> testing.  Could you clarify?

Ah, sorry, I don't clarify my test.  I just split two partitions on a
hard disk and create a ext4 file system with external journal.  Then I
use tune2fs with '-O ^has_journal' to remove external journal.  After
that I try to mount this file system on 3.12-rc5, and it work well.
That's all I have done.

Thanks,
                                                - Zheng
