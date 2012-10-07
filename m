From: "George Spelvin" <linux@horizon.com>
Subject: Re: metadata_csum + unclean shutdown = failure to boot
Date: 7 Oct 2012 16:18:30 -0400
Message-ID: <20121007201830.29646.qmail@science.horizon.com>
References: <20121007181025.GA30198@thunk.org>
Cc: linux-ext4@vger.kernel.org, tm@tao.ma
To: linux@horizon.com, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from science.horizon.com ([71.41.210.146]:21631 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752870Ab2JGUSd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 7 Oct 2012 16:18:33 -0400
In-Reply-To: <20121007181025.GA30198@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> I just had a random thought.  Which bootloader are you using?  Is it
> grub, or grub2 per chance?

Nope,
# lilo -V
LILO version 23.2 (released 09-Apr-2011)
(Debian GNU/Linux)

It's a 32-bit Debian/unstable (sid) userland, on a 64-bit kernel,
running on a 2nd gen i7-2xxx and a Gigabyte Z68A-D3H-B3 motherboard.
The drives are using the motherboard AHCI controller.

Thanks for the idea, though.
