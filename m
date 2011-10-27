From: Valerie Aurora <val@vaaconsulting.com>
Subject: Re: [RFC PATCH 0/3] VFS: Fix s_umount thaw/write deadlock
Date: Thu, 27 Oct 2011 15:08:53 -0700
Message-ID: <CAD-XujmonJPfq9zUaL-ZS6zz5dfgvxtcjJwxwrxpR33LohvK9g@mail.gmail.com>
References: <CAD-Xujmjai2evYC4a4CdNPtjh_9xhbELcZePtGSS54VPRGpznA@mail.gmail.com>
	<20111027213935.GA20902@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Dave Chinner <david@fromorbit.com>,
	Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>,
	Greg Freemyer <greg.freemyer@gmail.com>,
	linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
	Surbhi Palande <csurbhi@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40777 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057Ab1J0WIz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 27 Oct 2011 18:08:55 -0400
In-Reply-To: <20111027213935.GA20902@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 27, 2011 at 2:39 PM, Christoph Hellwig <hch@infradead.org> wrote:
> Any plans to resubmit these with the updates and in proper format?

Yes, coming tomorrow.  We found more bugs during testing which
fortunately Surbhi Palande already fixed and submitted patches for,
but got lost in the shuffle.

-VAL
