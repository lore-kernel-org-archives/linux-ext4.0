From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH e2fsprogs] UPDATED: ignore "safe" flag differences when
 fsck compares superblocks
Date: Sat, 26 Jan 2008 22:51:10 -0600
Message-ID: <479C0DBE.4000606@redhat.com>
References: <479629DF.7090500@redhat.com> <479A2AA6.1020002@redhat.com> <20080127042216.GB24842@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:34088 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753217AbYA0Ev3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 26 Jan 2008 23:51:29 -0500
In-Reply-To: <20080127042216.GB24842@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> This is what I've checked in.  See the comment about why we can't
> ignore a difference for the extended attribute feature.

Ok.  Unfortunately, that one really hurts on fedora, or any distro which
writes xattrs during install.

The installer mkfs's, mounts, installs with selinux, reboots => force
recheck of the entire filesystem, because the kernel wrote extended
attributes for selinux, but only to the primary superblock.

Solely having this set in primary but not in the backups should hardly
be a trigger for a full filesystem check, should it?

-Eric

>           	     	  	       	       - Ted
> 
> commit a8cde73acbf6e0f9c0a3601e4f5fac2b01a27bd2
> Author: Theodore Ts'o <tytso@mit.edu>
> Date:   Sat Jan 26 23:17:50 2008 -0500
> 
>     Ignore "safe" flag differences when e2fsck compares superblocks
