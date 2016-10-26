From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [Bug 182261] New: Deleted files reappear
Date: Wed, 26 Oct 2016 16:40:50 -0400
Message-ID: <20161026204050.2zlztjxnickfmz7k@thunk.org>
References: <bug-182261-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47700 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754127AbcJZUlv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 26 Oct 2016 16:41:51 -0400
Content-Disposition: inline
In-Reply-To: <bug-182261-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 25, 2016 at 01:10:15PM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> Hi I have been noticing this problem intermittently for a while now starting
> with kernel 3.14. Files I delete days/weeks ago reappear mysteriously and they
> are fully intact. My most recent encounter is using my Xubuntu system with the
> following config:
> 
> I deleted 4.7.6 / 4.8.0 kernels from my boot and also the /lib/modules for each
> and compiled and installed 4.8.4 only to notice that the files reappeared.

Did you uninstall the relevant Ubuntu package, or did you just delete
the fils using rm?  It could just simply be that Ubuntu was updating
to a newer version of that kernel version as it was updating other
packages on your system.

						- Ted
