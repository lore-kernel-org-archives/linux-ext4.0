From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH v1 00/30] Ext4 snapshots
Date: Thu, 9 Jun 2011 09:59:50 +0800
Message-ID: <BANLkTikUXdvMQROYEdxnyfcPuB0e9ozMOg@mail.gmail.com>
References: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>
	<alpine.LFD.2.00.1106071735100.11385@dhcp-27-109.brq.redhat.com>
	<BANLkTikAB-RDDS8PMMrFK-OuY6PuavBixA@mail.gmail.com>
	<alpine.LFD.2.00.1106081114240.5026@dhcp-27-109.brq.redhat.com>
	<BANLkTi=T1OtyRSWNTA6xhkTy5uaHWqA_XA@mail.gmail.com>
	<alpine.LFD.2.00.1106081716200.6609@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "Amir G." <amir73il@users.sourceforge.net>,
	linux-ext4@vger.kernel.org, tytso@mit.edu,
	linux-kernel@vger.kernel.org, sandeen@redhat.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-px0-f179.google.com ([209.85.212.179]:45393 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890Ab1FIB7u (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 8 Jun 2011 21:59:50 -0400
In-Reply-To: <alpine.LFD.2.00.1106081716200.6609@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> But I do understand the difference. And also, when it comes to fs level
> snapshotting I would suspect that it would do something we can not do
> with the current solutions, for example per-file or per-directory snapshots,
> cat ext4 snapshots do that ?
Hi Lukas,

I noticed that there is no answer to this question in the thread.  I
can give the question the answer that ext4 can snapshot per-file or
per-directory, and can exclude some files or directories from being
snapshotted.

-- 
Best Wishes
Yongqiang Yang
