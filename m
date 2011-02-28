From: Ted Ts'o <tytso@mit.edu>
Subject: Re: ext4 corruption
Date: Sun, 27 Feb 2011 23:43:07 -0500
Message-ID: <20110228044307.GQ2924@thunk.org>
References: <AANLkTin5hN-gnpmgntApSSrWVWJPQqK99tPJtfmFn5++@mail.gmail.com>
 <C5B8C496-E8F1-4BF7-9A51-373C0C63E357@mit.edu>
 <AANLkTimcKiKgKTVft9N+OVHd5-N+-AscSoimdOfkoBt9@mail.gmail.com>
 <AANLkTik22qfqzi4nPhvXRinzEDPDZ+UQFYT98eKK+aau@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Bill Huey (hui)" <bill.huey@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:49775 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755063Ab1B1QFb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Feb 2011 11:05:31 -0500
Content-Disposition: inline
In-Reply-To: <AANLkTik22qfqzi4nPhvXRinzEDPDZ+UQFYT98eKK+aau@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Feb 26, 2011 at 03:16:38AM -0800, Bill Huey (hui) wrote:
> Just to clarify, it did clear the problems, but the continued use of
> the file system resulted in more corruption. It's no longer usable. I
> have to remake the file system and copy the data again.

You didn't say what version of the kernel you were using, but there
hasn't been any ext4 bugs that have caused this much corruption this
quickly; it sure smells like a hardware problem....

							- Ted
