From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/4] (RESEND) ext3[34] barrier changes
Date: Fri, 16 May 2008 13:05:45 -0700
Message-ID: <20080516130545.845a3be9.akpm@linux-foundation.org>
References: <482DDA56.6000301@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, jamie@shareable.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43003 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752197AbYEPUG4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 May 2008 16:06:56 -0400
In-Reply-To: <482DDA56.6000301@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 16 May 2008 14:02:46 -0500
Eric Sandeen <sandeen@redhat.com> wrote:

> A collection of patches to make ext3 & 4 use barriers by
> default, and to call blkdev_issue_flush on fsync if they
> are enabled.

Last time this came up lots of workloads slowed down by 30% so I
dropped the patches in horror.

I just don't think we can quietly go and slow everyone's machines down
by this much.  The overhead of journalling is already pretty horrid.

If we were seeing a significant number of "hey, my disk got wrecked"
reports which attributable to this then yes, perhaps we should change
the default.  But I've never seen _any_, although I've seen claims that
others have seen reports.

There are no happy solutions here, and I'm inclined to let this dog
remain asleep and continue to leave it up to distributors to decide
what their default should be.

Do we know which distros are enabling barriers by default?
