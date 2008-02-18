From: Frans Pop <elendil@planet.nl>
Subject: Re: [BUG] Linux 2.6.25-rc2 - Kernel Ooops while running dbench
Date: Mon, 18 Feb 2008 17:11:41 +0100
Message-ID: <E1JR8aj-0004bH-Er@faramir.fjphome.nl>
References: <alpine.LFD.1.00.0802151302210.9496@woody.linux-foundation.org> <47B6784E.2090401@linux.vnet.ibm.com> <20080218045954.50503fb1.akpm@linux-foundation.org> <20080218045954.50503fb1.akpm@linux-foundation.org> <47B9956B.8060506@garzik.org>
Cc: akpm@linux-foundation.org, apw@shadowen.org,
	balbir@linux.vnet.ibm.com, clameter@sgi.com,
	kamalesh@linux.vnet.ibm.com, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
To: Jeff Garzik <jeff@garzik.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1759520AbYBRQL5@vger.kernel.org>
In-reply-To: <47B9956B.8060506@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Jeff Garzik wrote:
> Two x86-64 boxes here lock up here on 2.6.25-rc2, shortly after boot.
> One running Fedora 8 + X (GNOME) and one a headless file server.
> configs and lspci attached.  Unable to capture any splatter so far.

Sounds like it may be http://lkml.org/lkml/2008/2/17/78.

Suggest you try reverting that before doing the bisect.

Cheers,
FJP
