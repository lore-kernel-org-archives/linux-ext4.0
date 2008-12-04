From: Jonathan Bastien-Filiatrault <joe@x2a.org>
Subject: Re: tune2fs -I seems dangerous
Date: Thu, 04 Dec 2008 18:14:36 -0500
Message-ID: <4938645C.5010601@x2a.org>
References: <49385927.9070003@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from metal.x2a.org ([206.248.189.157]:60261 "EHLO metal.x2a.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751768AbYLDXOk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Dec 2008 18:14:40 -0500
In-Reply-To: <49385927.9070003@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:
> As a small experiment...
> [snip]
> ... this yields 10031 lines of fsck output, and results in about 38% of
> the files that were on the filesystem going missing.
I have had a similar experience converting from 128 to 256 bytes inodes.
After a while, tune2fs -I would simply stop doing IO and using a lot of
CPU with a few IO bursts every half-hour or so. This is on a recent/fast
x86-64 computer. I had to cancel the thing after leaving it running for
over 24 hours.
> 
> I don't have the strong sense that tune2fs -I has been shaken out at
> all; should it be shipping as a useable option?
Maybe add a --accept-consequences-of-shooting-myself-in-the-foot flag ?

Cheers,
Jonathan
