From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] fix up lock order reversal in writeback
Date: Mon, 22 Nov 2010 15:43:04 -0800
Message-ID: <20101122154304.5f78f907.akpm@linux-foundation.org>
References: <20101116110058.GA4298@amd>
	<20101116130146.GG4757@quack.suse.cz>
	<4CE35A6D.2040906@redhat.com>
	<20101117043845.GA3586@amd>
	<4CE362B0.6040607@redhat.com>
	<20101117061057.GA3989@amd>
	<4CE49AF5.1080104@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Nick Piggin <npiggin@kernel.dk>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45248 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757791Ab0KVXn0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 22 Nov 2010 18:43:26 -0500
In-Reply-To: <4CE49AF5.1080104@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 17 Nov 2010 21:18:13 -0600
Eric Sandeen <sandeen@redhat.com> wrote:

> On 11/17/10 12:10 AM, Nick Piggin wrote:
> > On Tue, Nov 16, 2010 at 11:05:52PM -0600, Eric Sandeen wrote:
> >> On 11/16/10 10:38 PM, Nick Piggin wrote:
> >>>> as for the locking problems ... sorry about that!
> >>>
> >>> That's no problem. So is that an ack? :)
> >>>
> >>
> >> I'd like to test it with the original case it was supposed to solve; will
> >> do that tomorrow.
> > 
> > OK, but it shouldn't make much difference, unless there is a lot of
> > strange activity happening on the sb (like mount / umount / remount /
> > freeze / etc).
> > 
> 
> Ok, good point.  And since I failed in my promise anyway, I won't
> hold you up;
> 
> Acked-by: Eric Sandeen <sandeen@redhat.com>

That patch still sucks!

We all breathlessly await v2, which will have a complete changelog and
approximately correct comments.

