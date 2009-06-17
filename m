From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Something wrong with extent-based journal creation
Date: Wed, 17 Jun 2009 09:45:09 -0500
Message-ID: <4A390175.9010003@redhat.com>
References: <4A381EC8.4010202@redhat.com> <20090617080432.GC13073@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:47626 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755410AbZFQOpQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Jun 2009 10:45:16 -0400
In-Reply-To: <20090617080432.GC13073@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:
> On Jun 16, 2009  17:38 -0500, Eric Sandeen wrote:
>> I've narrowed it down to the commit (961306d3) which creates the journal
>> with extent format; if that's commented out, it works fine.
> 
> Hmm, this seems like it might be a troublesome feature...  Are we sure
> that there is proper kernel/tool compatibility for an extent-mapped
> journal?  At least none of the Lustre code has any support for this,
> though they can handle the INCOMPAT_EXTENTS feature, and I don't think
> this was present in older kernels either.
> 
> I haven't looked at the code for this yet, so it may be that it will
> "just work", but if this is a new feature I would urge caution w.r.t.
> compatibility before this is merged upstream (in either e2fsprogs or
> the kernel).

It's already upstream.... :)

But I found the problem I was looking for, at least, see the [PATCH] in
reply to my original email.  (which is actually a pretty bad bug, likely
causing problems during e2fsck etc as well)

-Eric
