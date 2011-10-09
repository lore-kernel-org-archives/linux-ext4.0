From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Bug In ext4 in kernels > 2.6.39 - Not mounting with
 arguments/options I specify in fstab on root remount
Date: Sun, 9 Oct 2011 19:44:33 -0400
Message-ID: <20111009234433.GU7948@thunk.org>
References: <4E6F1B49.3010803@gmail.com>
 <CABeR262=5V1wuXPDVr_qLTeFTc4zDSFKVYKvO_+1w60XmwJvKA@mail.gmail.com>
 <4E6F6D89.5040905@redhat.com>
 <CABeR260PEDEF1cyX5JPs3VC0hpThmKNtDAhDd-sPDZ2grtL+=g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Matt Parnell <mparnell@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45951 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024Ab1JIXoe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 9 Oct 2011 19:44:34 -0400
Content-Disposition: inline
In-Reply-To: <CABeR260PEDEF1cyX5JPs3VC0hpThmKNtDAhDd-sPDZ2grtL+=g@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Oct 09, 2011 at 05:10:54PM -0500, Matt Parnell wrote:
> 
> /proc/mounts (as you can see it's not being remounted rw for some
> reason - /dev/sdc1 is the flash drive I used to pipe this info onto):
> 
> rootfs / rootfs rw 0 0
> /dev/root / ext4 ro,relatime,barrier=1 0 0

Can you send me the output of /proc/cmdline?  It looks like the
rootflags command line option isn't getting passed to the kernel for
some reason.  That would explain why data=writeback isn't showing up
in /proc/mounts.

						- Ted
