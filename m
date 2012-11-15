From: Andrey Sidorov <qrxd43@motorola.com>
Subject: Re: ext4 settings in an embedded system
Date: Thu, 15 Nov 2012 13:01:12 +0300
Message-ID: <CAA0+VHyODd+hsSL6FBqcLGb_r3ViHmL78ay=8k5CJeP0=Z2k7A@mail.gmail.com>
References: <C0489DC3A08C21449F8FE865472DC75204834F08@BUDMLVEM03.e2k.ad.ge.com>
	<1352968933.2221.16.camel@sauron.fi.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "Ohlsson, Fredrik (GE Healthcare, consultant)"
	<Fredrik.Ohlsson@ge.com>, linux-ext4@vger.kernel.org
To: dedekind1@gmail.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from exprod5og115.obsmtp.com ([64.18.0.246]:37009 "EHLO
	exprod5og115.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756017Ab2KOKBO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 15 Nov 2012 05:01:14 -0500
Received: from il93mgrg01.am.mot-mobility.com ([10.22.94.167])
	by il93mgrg01.am.mot-mobility.com (8.14.3/8.14.3) with ESMTP id qAF9pOQP002190
	for <linux-ext4@vger.kernel.org>; Thu, 15 Nov 2012 04:51:24 -0500 (EST)
Received: from mail-vc0-f174.google.com (mail-vc0-f174.google.com [209.85.220.174])
	by il93mgrg01.am.mot-mobility.com (8.14.3/8.14.3) with ESMTP id qAF9oL21001785
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=OK)
	for <linux-ext4@vger.kernel.org>; Thu, 15 Nov 2012 04:51:24 -0500 (EST)
Received: by mail-vc0-f174.google.com with SMTP id fk26so1431859vcb.19
        for <linux-ext4@vger.kernel.org>; Thu, 15 Nov 2012 02:01:13 -0800 (PST)
In-Reply-To: <1352968933.2221.16.camel@sauron.fi.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 15, 2012 at 12:42 PM, Artem Bityutskiy <dedekind1@gmail.com> wrote:

> We conducted some 3 years ago. Results were quite good for ext4 - in
> many cases it could recover without a need to run ckfs.ext4, sometimes
> it was not mountable, but ckfs.ext4 helped.
>
> On the opposite, ext3 constantly required ckfs.ext3, and sometimes died
> so badly that even ckfs.ext3 could not recover it.

We ran about 6000 cycles of power resets with linux 2.6.37. The test
was to run 3 tar processes unpacking linux kernel archive and power
off after about 15 seconds. There were only 3 failures when file
system couldn't be mounted, but that was due to HDD failure
(unreadable sector in journal area). e2fsck successfully recovered
those corruptions. As for software itself, there was no single issue
and we never needed to run fsck after power loss. So I'd say that ext4
is very tolerant to power losses at least in 2.6.37 assuming barriers
and ordered data mode. I however understand this test is quite basic
and any way results can be different for different kernels.
