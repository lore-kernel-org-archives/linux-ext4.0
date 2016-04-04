From: Theodore Ts'o <tytso@mit.edu>
Subject: Refreshed rootfs.img for kvm-xfstests
Date: Mon, 4 Apr 2016 02:13:14 -0400
Message-ID: <20160404061314.GA3112@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36070 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810AbcDDGNQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 4 Apr 2016 02:13:16 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

There is an updated rootfs.img file available at:

    https://www.kernel.org/pub/linux/kernel/people/tytso/kvm-xfstests

It includes the latest updates from the xfstests-dev and quota
upstreams.  Some spurious test filaures in the encrypt and quota
configurations have been fixed.

In the gce-xfstests driver, we now also support DAX testing.  For more
information about this test framework, please see:

    http://thunk.org/gce-xfstests

Cheers,

						- Ted
