From: Ted Ts'o <tytso@mit.edu>
Subject: Re: ext4 corruption
Date: Mon, 28 Feb 2011 17:55:59 -0500
Message-ID: <20110228225559.GK28617@thunk.org>
References: <AANLkTin5hN-gnpmgntApSSrWVWJPQqK99tPJtfmFn5++@mail.gmail.com>
 <C5B8C496-E8F1-4BF7-9A51-373C0C63E357@mit.edu>
 <AANLkTimcKiKgKTVft9N+OVHd5-N+-AscSoimdOfkoBt9@mail.gmail.com>
 <AANLkTik22qfqzi4nPhvXRinzEDPDZ+UQFYT98eKK+aau@mail.gmail.com>
 <20110228044307.GQ2924@thunk.org>
 <AANLkTimoODjtQY2mmfgnPMisEA+kUNeEnGryL1CMgAFM@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Bill Huey (hui)" <bill.huey@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56217 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752675Ab1B1W4C (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Feb 2011 17:56:02 -0500
Content-Disposition: inline
In-Reply-To: <AANLkTimoODjtQY2mmfgnPMisEA+kUNeEnGryL1CMgAFM@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 28, 2011 at 12:18:16PM -0800, Bill Huey (hui) wrote:
> What ever is in the latest Ubuntu maverick, 2.6.35 for the kernel.
> 
> The only thing that makes it not looking like it was a storage problem
> is this line that comes before the SATA error:
> 
> -----
> Feb 25 04:41:26 finfin kernel: [206290.181230] JBD: Spotted dirty
> metadata buffer (dev = sdb1, blocknr = 0). There's a risk of
> filesystem corruption in case of system crash.
> -----

There are a few places where we update the superblock bypassing the
journal layer.  (For example, when we set the RO_COMPAT_LARGE_FILE
feature flag if it wasn't previously set).  Those should be cleaned
up, but it's not related to the rest of the scary-looking corruption
which you saw.  The worst that might happen is specific superblock
update might get lost (i.e., the RO_COMPAT_LARGE_FILE feature flag) on
a crash before we commit some other superblock change to the journal.

  	       	  	      	    	       - Ted
