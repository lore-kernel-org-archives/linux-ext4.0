From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] Attempt to sync the fsstress writes to a frozen F.S
Date: Tue, 24 May 2011 17:42:23 -0400
Message-ID: <20110524214222.GF26055@thunk.org>
References: <4DCA3583.7010904@canonical.com>
 <1305097841-2308-1-git-send-email-surbhi.palande@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: sandeen@redhat.com, jack@suse.cz, marco.stornelli@gmail.com,
	adilger.kernel@dilger.ca, toshi.okajima@jp.fujitsu.com,
	m.mizuma@jp.fujitsu.com, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Surbhi Palande <surbhi.palande@canonical.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:42014 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933674Ab1EXVmf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 May 2011 17:42:35 -0400
Content-Disposition: inline
In-Reply-To: <1305097841-2308-1-git-send-email-surbhi.palande@canonical.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 11, 2011 at 10:10:41AM +0300, Surbhi Palande wrote:
> While the fsstress background writes are busy dirtying the page cache, if a
> fsfreeze happens then the background writes should stall. A sync should then
> not have any data to sync to the FS. If it does have any data to sync then
> sync will cause a deadlock by holding the s_umount write semaphore and waiting
> in the wait queue for the FS to thaw, whereas the F.S can never thaw without
> getting the s_umount write semaphore.
> 
> Signed-off-by: Surbhi Palande <surbhi.palande@canonical.com>

Hi Surbhi,

Have you tried out Jan Kara's patches?

[1/3] fs: Create __block_page_mkwrite() helper passing error values back
[2/3] vfs: Block mmapped writes while the fs is frozen
[3/3] ext4: Rewrite ext4_page_mkwrite() to return locked page

Do these patches fix the problem you've been trying to fix with your
patches?  I believe they should, but I would appreciate confirmation
that with these patches, you're no longer able to reproduce the
problem you've been concerned about.

Thanks, regards,

						- Ted
