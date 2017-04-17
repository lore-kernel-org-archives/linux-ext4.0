From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/3] e2fsck: allow extent tree optimization to be disabled
Date: Mon, 17 Apr 2017 01:45:05 -0400
Message-ID: <20170417054505.ggou3yocbnqviqim@thunk.org>
References: <20170415134118.17808-1-tytso@mit.edu>
 <20170415134118.17808-3-tytso@mit.edu>
 <20170416192430.GB5185@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:42706 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751030AbdDQF5H (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 17 Apr 2017 01:57:07 -0400
Content-Disposition: inline
In-Reply-To: <20170416192430.GB5185@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Apr 16, 2017 at 12:24:30PM -0700, Darrick J. Wong wrote:
> 
> /me wonders if there's a way to detect that we're being run by
> initscripts/systemd/whatever on a device that is mounted ro, and skip
> the optimization step to avoid the reboot.

That wasn't actually the reason for this option; but adding feature
where which does this for the root file system mounted read-only, the
optimization is avoided would make sense, yes.

> OTOH I wonder why the initramfs (if available) doesn't just build in
> e2fsck and fsck the root device before mounting the fs...

Debian does this already.  RHEL is just behind the times.  :-)

       	    	 	   	   	- Ted
