From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [LSF/MM TOPIC] Drop ext2/ext3 codebase? When?
Date: Thu, 03 Feb 2011 09:08:18 -0600
Message-ID: <4D4AC4E2.701@redhat.com>
References: <20110203144011.GA28409@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: lsf-pc@lists.linuxfoundation.org, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4976 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752404Ab1BCPJ0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 3 Feb 2011 10:09:26 -0500
In-Reply-To: <20110203144011.GA28409@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2/3/11 8:40 AM, Jan Kara wrote:
>   Hi,
> 
>   I'm not completely sure this is interesting for enough people but maybe
> it is...
> 
> As you well know, there are three independent code bases in kernel
> implementing ext-based filesystems - ext2, ext3, and ext4. Of course it
> costs some effort to maintain them all in a reasonably good condition so
> once in a while someone comes and proposes we should drop one of ext2, ext3
> or both. So I'd like to gather input what people think about this - should
> we ever drop ext2 / ext3 codebases? If yes, under what condition do we deem
> it is OK to drop it?
> 
> To give some facts:
> Feature-wise, ext4 should now be almost a superset of both ext2 and
> ext3. ext4 has nojournal mode to simulate ext2, looking at the code I only
> don't see XIP support in ext4, arguably also nobh-mode but I personally
> feel that these days the complication in the code isn't worth it. As far as
> I know it should be backward compatible to writeably mount ext2/ext3
> filesystem with ext4 (i.e., no incompatible features should be turned on
> magically).
> 
> On the other hand there are differences noticeable under some conditions -
> e.g. delayed allocation, data=ordered mode of ext3 gives better data
> integrity than that of ext4 in practice (it's just a side effect we never
> promised but app developers somehow got used to it ;), different allocation
> decisions, and I believe there are more of these subtle differences.

I think that ext4 with nodelalloc should mostly mimic ext3 in those
cases, no?

> Then of course there is the factor of the codebase itself: Ext2 - ~9k
> lines, Ext3+JBD - 24k lines, Ext4+JBD2 - 43k lines. Ext2 codebase is so
> simple that it sometimes serves as a "model filesystem". But arguably it
> also bitrots slowly so copy-and-pasting from ext2 need not be clever idea
> anymore.

Yep at one point it was asserted that ext2 was a model filesystem and should
therefore be kept around, but I agree with you that it may not really 
serve that purpose too well.

While I'm no fan of having 3 kinda-similar codebases that must be maintained,
my concerns would be:

1) ext4 is still in active development, and may introduce instabilities
   that ext3 would otherwise avoid.

2) ext4's more, um ... unique option combinations probably get next to
   no testing in the real world.  So while we can say that noextent,
   nodelalloc is mostly like ext3, in practice, does that ever really
   get much testing?

If we can have a real plan for moving in this direction though, I'd
support it.  I'm just not sure how we get enough real testing under
our belts to be comfortable with dropping ext[23], especially as
most distros now default to ext4 anyway.

-Eric

> 								Honza

