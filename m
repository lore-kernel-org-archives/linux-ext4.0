From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH, RFC] ext4: Rename ext4dev to ext4
Date: Fri, 10 Oct 2008 13:00:51 -0500
Message-ID: <48EF9853.8070202@redhat.com>
References: <1223356130-22006-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:51057 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760063AbYJJSAz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 10 Oct 2008 14:00:55 -0400
In-Reply-To: <1223356130-22006-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Ts'o wrote:
> The ext4 filesystem is getting stable enough that it's time to drop
> the "dev" prefix.  Also remove the requirement for the TEST_FILESYS
> flag.

What do you think of adding a MODULE_ALIAS("ext4dev"); to this change?

Poor Fedora users trying to boot a kernel with this rename and ext4(dev)
on root are failing to mount root at boot time.

mkinitrd looks at the existing fstab, sees that the rootfs is "ext4dev"
and tries to mount root as ext4dev.... this fails.

-Eric
