Return-Path: <SRS0=tE3u=M7=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35004 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725945AbeJSIWX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 19 Oct 2018 04:22:23 -0400
Date: Thu, 18 Oct 2018 20:18:49 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Nathan Peterson <nathan@uwgrads.com>
Cc: linux-ext4@vger.kernel.org
Subject: Re: Unable to mount an ext4 RAID6 array
Message-ID: <20181019001849.GC2407@thunk.org>
References: <CAAQ4vX2wrzxzP6=bP9Bbt89Hvs_JRJuZxSQGfPw2vUrtOqh3UA@mail.gmail.com>
 <20180913223252.GD30588@thunk.org>
 <CAAQ4vX2nujND+s7mK-3EztS+MtLeNsNgmd=kwFQmVSa1ABjrKQ@mail.gmail.com>
 <CAAQ4vX3a5RrD_Dt7tFJ23cof=FAK3fd5jrF+c45YujbjwNcKmw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAQ4vX3a5RrD_Dt7tFJ23cof=FAK3fd5jrF+c45YujbjwNcKmw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

Sorry I didn't get back to you sooner.  This e-mail thread got lost in
my inbox, so thanks for pinging me about it.

These lines in the logs clearly show that it is a hardware problem.
It could be an issue with the SATA controller, or cables, or even
something in the motherboard.

[  +0.000006] ata1: irq_stat 0x00400040, connection status changed
[  +0.000004] ata1: SError: { HostInt PHYRdyChg 10B8B DevExch }
[  +0.000005] ata1: hard resetting link
[  +5.634542] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[  +0.001809] ata1.00: configured for UDMA/133
[  +0.000003] ata1: EH complete
[Sep13 19:47] ata1: exception Emask 0x50 SAct 0x0 SErr 0x4090800

The following article (found via Google) on Serverfault might be
helpful:

https://serverfault.com/questions/749433/hard-resetting-link-exception-emask-0x50-sact-0x0-serr-0x4090800-action-0xe-froz

Good luck,

					- Ted
