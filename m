From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [patch] fix up lock order reversal in writeback
Date: Fri, 19 Nov 2010 07:07:38 -0500
Message-ID: <FDB6A6D0-A671-48B1-BA96-4917BE8A3390@mit.edu>
References: <4CE35A6D.2040906@redhat.com> <20101117043845.GA3586@amd> <4CE362B0.6040607@redhat.com> <20101117061057.GA3989@amd> <20101118030613.GQ3290@thunk.org> <20101117192900.da859ac7.akpm@linux-foundation.org> <20101118060000.GA3509@amd> <20101117222834.2bb36ee1.akpm@linux-foundation.org> <20101118081822.GA9186@amd> <20101118095831.b9331e93.akpm@linux-foundation.org> <20101119051004.GD3284@amd>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Eric Sandeen <sandeen@redhat.com>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org
To: Nick Piggin <npiggin@kernel.dk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-2.MIT.EDU ([18.9.25.13]:54643 "EHLO
	dmz-mailsec-scanner-2.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751096Ab0KSMHt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Nov 2010 07:07:49 -0500
In-Reply-To: <20101119051004.GD3284@amd>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Nov 19, 2010, at 12:10 AM, Nick Piggin wrote:

> But asynch writeout needs a mutex rather than refcount so the umount
> has something to block against and not just fail.

Or we use a completion handler instead of a mutex for umount?

- Ted

