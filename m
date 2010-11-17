From: Nick Piggin <npiggin@kernel.dk>
Subject: Re: [patch] fix up lock order reversal in writeback
Date: Wed, 17 Nov 2010 17:10:57 +1100
Message-ID: <20101117061057.GA3989@amd>
References: <20101116110058.GA4298@amd>
 <20101116130146.GG4757@quack.suse.cz>
 <4CE35A6D.2040906@redhat.com>
 <20101117043845.GA3586@amd>
 <4CE362B0.6040607@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Nick Piggin <npiggin@kernel.dk>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:5990 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933117Ab0KQGLC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Nov 2010 01:11:02 -0500
Content-Disposition: inline
In-Reply-To: <4CE362B0.6040607@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 16, 2010 at 11:05:52PM -0600, Eric Sandeen wrote:
> On 11/16/10 10:38 PM, Nick Piggin wrote:
> >> as for the locking problems ... sorry about that!
> > 
> > That's no problem. So is that an ack? :)
> > 
> 
> I'd like to test it with the original case it was supposed to solve; will
> do that tomorrow.

OK, but it shouldn't make much difference, unless there is a lot of
strange activity happening on the sb (like mount / umount / remount /
freeze / etc).

