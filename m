From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [patch] fix up lock order reversal in writeback
Date: Thu, 18 Nov 2010 05:51:49 -0500
Message-ID: <CAD89104-98EE-4205-8C5B-3F0F60514A0B@mit.edu>
References: <20101116110058.GA4298@amd> <20101116130146.GG4757@quack.suse.cz> <4CE35A6D.2040906@redhat.com> <20101117043845.GA3586@amd> <4CE362B0.6040607@redhat.com> <20101117061057.GA3989@amd> <20101118030613.GQ3290@thunk.org> <20101117192900.da859ac7.akpm@linux-foundation.org> <20101118060000.GA3509@amd> <20101117222834.2bb36ee1.akpm@linux-foundation.org> <20101118081822.GA9186@amd>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Eric Sandeen <sandeen@redhat.com>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org
To: Nick Piggin <npiggin@kernel.dk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-1.MIT.EDU ([18.9.25.12]:60514 "EHLO
	dmz-mailsec-scanner-1.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751016Ab0KRKvz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Nov 2010 05:51:55 -0500
In-Reply-To: <20101118081822.GA9186@amd>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Nov 18, 2010, at 3:18 AM, Nick Piggin wrote:

> s_count just prevents it from going away, but s_umount is still needed
> to keep umount, remount,ro, freezing etc activity away. I don't think
> there is an easy way to do it.

Hmm.... what about encoding the fact that we are in the process of unmounting the file system as a flag to keep remount, freeing, etc. away?    The equivalent of the inode's I_FREEING flag?

After all, it's not like we want freeze to wait until the umount is finished, and then continue on its merry way with the remount operation.  We want it to fail, because we're unmounting the file system.   So maybe the real problem is a mutex really isn't the right abstraction?

-- Ted

