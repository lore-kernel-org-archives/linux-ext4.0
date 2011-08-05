From: Julia Lawall <julia@diku.dk>
Subject: Re: [PATCH 1/4] fs/ext3/balloc.c: delete useless initialization
Date: Fri, 5 Aug 2011 21:08:13 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.1108052104320.4636@ask.diku.dk>
References: <1312453774-23333-1-git-send-email-julia@diku.dk>
 <1312453774-23333-2-git-send-email-julia@diku.dk> <20110804104003.GH17196@quack.suse.cz>
 <4E3C275D.1030307@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mgw2.diku.dk ([130.225.96.92]:57627 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752966Ab1HETIT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 5 Aug 2011 15:08:19 -0400
In-Reply-To: <4E3C275D.1030307@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 5 Aug 2011, Eric Sandeen wrote:

> On 8/4/11 5:40 AM, Jan Kara wrote:
> > On Thu 04-08-11 12:29:31, Julia Lawall wrote:
> >> From: Julia Lawall <julia@diku.dk>
> >>
> >> Delete nontrivial initialization that is immediately overwritten by the
> >> result of an allocation function.
> >   Thanks. Merged.
> 
> Just FWIW, I was curious how this ended up here.
> 
> It looks like this has been there since 2005, and both
> lines went in in the same commit (i.e. it didn't creep in over time).
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/old-2.6-bkcvs.git;a=commitdiff;h=a66d457d8878fe8d09bc81f0d5e6ac40caec6eb7

Actually, the old code had the same property, for the rsv variable...

julia
