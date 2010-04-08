From: Nebojsa Trpkovic <trx.lists@gmail.com>
Subject: Re: "data=writeback" and TRIM don't get along
Date: Thu, 08 Apr 2010 13:47:46 +0200
Message-ID: <4BBDC262.7060504@gmail.com>
References: <4BBD285B.9000603@gmail.com> <4BBD2FDF.4040407@redhat.com>	<4BBD3365.90306@gmail.com> <8739z6v2ew.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:52400 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768Ab0DHLrv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 8 Apr 2010 07:47:51 -0400
Received: by bwz1 with SMTP id 1so1702089bwz.21
        for <linux-ext4@vger.kernel.org>; Thu, 08 Apr 2010 04:47:49 -0700 (PDT)
In-Reply-To: <8739z6v2ew.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 04/08/10 09:17, Dmitry Monakhov wrote:
> Nebojsa Trpkovic <trx.lists@gmail.com> writes:
>> Intel X25-V 40GB (latest firmware)
> can you please provide an actual version of firmware.
> As soon as i know X25 zeroing was disabled.
> Can you please post an output of your queue flags 
> cat /sys/block/sdXXX/queue/discard_zeroes_data 

======================
cat /sys/block/sda/queue/discard_zeroes_data
1
cat /sys/block/sda/queue/discard_granularity
512
======================

Short history (you're probably talking about Intel's firmware problems):

- Intel releases X25-M (80 and 160GB) G1. G1 doesn't support TRIM.
- Intel releases X25-M (80 and 160GB) G2. G2's initial firmware doesn't
support TRIM.
- Intel makes TRIM-enabled firmware for G2 and publishes it.
- Customers hammer some of their G2 SSDs by flashing new firmware.
- Intel withdraws new firmware.
- Intel fixes firmware and releases new one (this time without nasty
behaviour). Read 2 updates on the start of first page:
http://www.anandtech.com/show/2865
- Intel sells it's technology to Kingston and Kingston starts to produce
40GB version of G2 named Kingston BootDrive SNV125-S2/40GB that doesn't
support TRIM. (Kingston produced some full-grown G1 and G2, but that is
not a point here. SNM125 and SNM225).
http://www.anandtech.com/show/2865/4
- Intel starts selling it's own 40GB G2 named X25-V with TRIM enabled
out of the box.
http://www.anandtech.com/show/2968/intel-s-x25-v-kingston-s-30gb-ssdnow-v-series-battle-of-the-125-ssds
- (guess) Intel needs too much royalties from Kingston for TRIM enabled
firmware, so Kingston SNV125-S2/40GB doesn't get (official) TRIM enabled
firmware and Kingston stops selling Intel-based SSDs.


Anyways, all X25-V are shipped with TRIM enabled firmware.
My current firmware is 2CV102HD.
hdparm -I /dev/sda gives this, too:
        Enabled Supported:
           *    Data Set Management TRIM supported
           *    Deterministic read ZEROs after TRIM

Nebojsa

