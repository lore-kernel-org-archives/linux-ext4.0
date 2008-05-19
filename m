From: Pavel Machek <pavel@suse.cz>
Subject: Re: [PATCH 0/4] (RESEND) ext3[34] barrier changes
Date: Mon, 19 May 2008 11:04:01 +0200
Message-ID: <20080519090401.GB2013@elf.ucw.cz>
References: <482DDA56.6000301@redhat.com> <20080516130545.845a3be9.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	jamie@shareable.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:54415 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbYESJDE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 May 2008 05:03:04 -0400
Content-Disposition: inline
In-Reply-To: <20080516130545.845a3be9.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi!

On Fri 2008-05-16 13:05:45, Andrew Morton wrote:
> On Fri, 16 May 2008 14:02:46 -0500 Eric Sandeen <sandeen@redhat.com> wrote:
> 
> > A collection of patches to make ext3 & 4 use barriers by
> > default, and to call blkdev_issue_flush on fsync if they
> > are enabled.
> 
> Last time this came up lots of workloads slowed down by 30% so I
> dropped the patches in horror.
> 
> I just don't think we can quietly go and slow everyone's machines down
> by this much.  The overhead of journalling is already pretty horrid.
> 
> If we were seeing a significant number of "hey, my disk got wrecked"
> reports which attributable to this then yes, perhaps we should change
> the default.  But I've never seen _any_, although I've seen claims that
> others have seen reports.

Do you remember seeing "my disk was wrecked" for reiserfs?

I believe I got some corruption, but it was 

a) long time ago

b) took half a year of hard powerdowns to provoke

c) I did not report it anywhere because ... it just was not
reproducible.

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
