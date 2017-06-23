From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Possible regression in e2fsprogs-1.43.4
Date: Fri, 23 Jun 2017 15:53:18 -0400
Message-ID: <20170623195318.cfs4ftpmy5nhcccy@thunk.org>
References: <B2DFC17F-1CFC-410E-9449-2393D51C700B@illumenos.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, grub-devel@gnu.org
To: Felipe A Rodriguez <far@illumenos.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:37812 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754814AbdFWTxX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 23 Jun 2017 15:53:23 -0400
Content-Disposition: inline
In-Reply-To: <B2DFC17F-1CFC-410E-9449-2393D51C700B@illumenos.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

+grub-devel

On Sat, Jun 10, 2017 at 04:00:20PM +0200, Felipe A Rodriguez wrote:
> Upgrading from e2fsprogs-1.42.13 to e2fsprogs-1.43.4 causes the boot
> loader to fail (unknown filesystem error) on the x86_64 VM I use for
> initial testing.  I traced the problem to changes in the e2fsprogs
> configuration file which now sets 64 bit flags.  I tried upgrading
> to GRUB 2.02 but that did not resolve the problem.  Reverting the
> changes per the patch below fixes the problem.

Hmm, my laptop has been using a file system with the 64-bit feature
enabled for quite some time, and my Debian Stretch system has been
using Grub 2.02 to boot my system without any difficulties.

I've done a quick check of the Debian patches and none of them seem to
modify Grub's ext2/ext4 file system implementation.  So I don't know
what to tell you.  Are you sure you properly reinstalled grub on the
boot device after you upgraded to grub 2.02?

Cheers,

						- Ted
