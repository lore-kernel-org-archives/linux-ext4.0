From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: >16TB issues
Date: Tue, 11 Aug 2009 23:21:56 -0500
Message-ID: <4A824364.20709@redhat.com>
References: <150c16850907021523p25ddae32v2eeea54418d2e6d5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Justin Maggard <jmaggard10@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:42923 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751091AbZHLEVx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Aug 2009 00:21:53 -0400
In-Reply-To: <150c16850907021523p25ddae32v2eeea54418d2e6d5@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Justin Maggard wrote:
> I've been toying with ext4 and e2fsprogs pu branch (pulled from git
> yesterday) on very large volumes, and I've run into some issues.  What
> I've found so far with an 19TB MD RAID0 volume, running 2.6.29.4 (I'm
> planning on trying 2.6.30 soon):
> 
> -  mkfs.ext4 *appears* to work fine, reporting no errors.  Examining
> the superblock info with dumpe2fs -h looks normal -- although I'm
> unfamiliar with "Lifetime writes" field, and I'm not sure why it's at
> 73GB immediately after doing mkfs, before ever mount it.

Guessing that's how much metadata actually gets written during mkfs.

> -  Immediately running e2fsck on the volume before ever mounting it
> will not complete, and results in the following:
> # e2fsck -n /dev/md2
> e2fsck 1.41.7 (29-June-2009)
> Error reading block 2435874816 (Attempt to read block from filesystem
> resulted in short read).  Ignore error? no

This is roughly halfway through the filesystem; the journal is roughly
in the middle of the filesystem; this is just over 2^31 blocks.  I bet
there are still ints or longs in the userspace journal code.  I'll take
a look.

-Eric
