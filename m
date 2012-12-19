From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH RFC] jbd: don't wake kjournald unnecessarily
Date: Wed, 19 Dec 2012 09:13:34 +0100
Message-ID: <20121219081334.GB20163@quack.suse.cz>
References: <50D0A1FD.7040203@redhat.com>
 <20121219012710.GF5987@quack.suse.cz>
 <20121219020526.GG5987@quack.suse.cz>
 <50D12FC3.6090209@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46801 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751997Ab2LSINp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 Dec 2012 03:13:45 -0500
Content-Disposition: inline
In-Reply-To: <50D12FC3.6090209@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 18-12-12 21:08:51, Eric Sandeen wrote:
> On 12/18/12 8:05 PM, Jan Kara wrote:
> > On Wed 19-12-12 02:27:10, Jan Kara wrote:
> >>> With a u8 tid_t, the "else" clause from commit d9b0193 fires
> >>> frequently; I really think the underlying problem is that tid_geq()
> >>> etc does not properly handle wraparounds - if, say, target is 255
> >>> and j_commit_request is 0, we don't know if j_commit_request
> >>> is 255 tids behind, or 1 tid ahead.  I have to think about that
> >>> some more, unless it's obvious to someone else.
> >>   Well, there's no way to handle wraps better AFAICT. Tids eventually wrap
> >> and if someone has stored away tid of a transaction he wants committed and
> >> keeps it for a long time before using it, it can end up being anywhere
> >> before / after current j_commit_request. The hope was that it takes long
> >> enough to wrap around 32-bit tids. If this happens often in practice we may
> >> have to switch to 64-bit tids (in memory, on disk 32-bit tids are enough
> >> because of limited journal size).
> 
> I was wondering if, since the tid_g*() functions only work if the
> distance is half the unsigned int space, we can force a commit at some
> point if j_transaction_sequence has gotten too far ahead?  I'm not sure
> where or if that could be done...
  I don't quiete understand. If someone stores tid = transaction->t_tid and
in two weeks calls log_start_commit(tid), I don't see how any forcing of
commits could solve that tid may now look ahead of the log...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
