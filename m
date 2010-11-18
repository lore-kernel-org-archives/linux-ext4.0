From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] fix up lock order reversal in writeback
Date: Thu, 18 Nov 2010 09:10:53 -0800
Message-ID: <20101118091053.c275e1f2.akpm@linux-foundation.org>
References: <20101116110058.GA4298@amd>
	<20101116130146.GG4757@quack.suse.cz>
	<4CE35A6D.2040906@redhat.com>
	<20101117043845.GA3586@amd>
	<4CE362B0.6040607@redhat.com>
	<20101117061057.GA3989@amd>
	<20101118030613.GQ3290@thunk.org>
	<20101117192900.da859ac7.akpm@linux-foundation.org>
	<20101118060000.GA3509@amd>
	<20101117222834.2bb36ee1.akpm@linux-foundation.org>
	<4CE53E56.4090501@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Nick Piggin <npiggin@kernel.dk>, "Ted Ts'o" <tytso@mit.edu>,
	Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32792 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932120Ab0KRRPR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Nov 2010 12:15:17 -0500
In-Reply-To: <4CE53E56.4090501@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 18 Nov 2010 08:55:18 -0600 Eric Sandeen <sandeen@redhat.com> wrote:

> > Can we just delete writeback_inodes_sb_nr_if_idle() and
> > writeback_inodes_sb_if_idle()?  The changelog for 17bd55d037a02 is
> > pretty handwavy - do we know that deleting these things would make a
> > jot of difference?
> 
> Really?  I thought it was pretty decent ;)
> 
> Anyway, xfstests 204, "Test out ENOSPC flushing on small filesystems."
> shows the problem clearly, IIRC.  I should have included that in the
> changelog, I suppose, sorry.

Your email didn't really impart any information :(

I suppose I could accidentally delete those nasty little functions in a
drivers/parport patch then wait and see if anyone notices.

