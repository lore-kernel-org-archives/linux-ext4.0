From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] Ext4: Update ext4 documentation
Date: Mon, 21 Feb 2011 20:24:45 -0500
Message-ID: <20110222012444.GA2924@thunk.org>
References: <C9957B84-6B84-435F-83FF-8932ED36678A@dilger.ca>
 <1295547028-6858-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, sandeen@redhat.com, adilger@dilger.ca
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:35862 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751757Ab1BVBYs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Feb 2011 20:24:48 -0500
Content-Disposition: inline
In-Reply-To: <1295547028-6858-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 20, 2011 at 07:10:28PM +0100, Lukas Czerner wrote:
> bz 9432
> https://bugzilla.kernel.org/show_bug.cgi?id=9423
> 
> Since Documentation/filesystem/ext4.txt has not been updated for a
> while, there were some missing information. This commit add not yet
> documented mount options and ioctls. Also it adds sysfs documentation
> from Documentation/ABI/testing/sysfs-fs-ext4 which was really well
> hidden, as you can see.
> 
> Some typo fixes in sysfs-fs-ext4 as well.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Thanks, added to the ext4 patch queue.

						- Ted
