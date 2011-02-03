From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [LSF/MM TOPIC] Drop ext2/ext3 codebase? When?
Date: Thu, 03 Feb 2011 13:49:03 -0600
Message-ID: <4D4B06AF.6000106@redhat.com>
References: <20110203144011.GA28409@quack.suse.cz> <4D4AC4E2.701@redhat.com> <AANLkTi=YxSpgm9vYHBKdASpLOaY_U3=ggsE8yTg_G0Bc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, lsf-pc@lists.linuxfoundation.org,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Michael Rubin <mrubin@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61129 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756728Ab1BCTtO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 3 Feb 2011 14:49:14 -0500
In-Reply-To: <AANLkTi=YxSpgm9vYHBKdASpLOaY_U3=ggsE8yTg_G0Bc@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2/3/11 1:32 PM, Michael Rubin wrote:
> On Thu, Feb 3, 2011 at 7:08 AM, Eric Sandeen <sandeen@redhat.com> wrote:
>> If we can have a real plan for moving in this direction though, I'd
>> support it.  I'm just not sure how we get enough real testing under
>> our belts to be comfortable with dropping ext[23], especially as
>> most distros now default to ext4 anyway.
> 
> Eric what sort of testing are you looking for?

Anything, the more formal or more widespread the better.

I just don't think it's used much this way today...

We can start with xfstests etc but I'd be more concerned about
unexpected behavioral or performance changes.

> I admit I like having ext2 around for comparisons in bug situations.
> It really helps to isolate the problem area. How painful is the
> upkeep?

since ext4 was merged, about 450 commits to ext2 & ext3 files.

since 2.6.32, about 150 commits.

Translating that into pain units, I dunno.  In distro-land, I often
have bugfixes that need to hit 2 or 3 of the filesystems as well.

-Eric

> mrubin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

