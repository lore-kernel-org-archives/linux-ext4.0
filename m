From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: 3.10 GA: ext4 crash on power7
Date: Sat, 6 Jul 2013 07:52:00 -0400
Message-ID: <20130706115200.GC32062@thunk.org>
References: <2044908741.7743522.1372746883931.JavaMail.root@redhat.com>
 <1598633085.7744466.1372747320569.JavaMail.root@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: CAI Qian <caiqian@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:35460 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753103Ab3GFL5y (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 6 Jul 2013 07:57:54 -0400
Content-Disposition: inline
In-Reply-To: <1598633085.7744466.1372747320569.JavaMail.root@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 02, 2013 at 02:42:00AM -0400, CAI Qian wrote:
> This has never been seen during either 3.10-rc7 or the last year's ext4
> devel tree testing. Maybe because I have recently upgraded the distro
> of the Fedora to the latest. This has happened using the fs_mark test and
> reproduced on all power7 systems.

Can you reproduce it with the newer Fedora userspace and the 3.10-rc7
kernel?   If so, perhaps this is something we could bisect?

Thanks,

	     	 	      	 	   - Ted
