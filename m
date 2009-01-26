From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] : make sure the buffer head members are zeroed out before using them.
Date: Mon, 26 Jan 2009 13:32:03 +0100
Message-ID: <20090126123203.GB18681@atrey.karlin.mff.cuni.cz>
References: <ea11fea30901200906m4dfb5060ya82104519b4984bb@mail.gmail.com> <ea11fea30901250753j6db5158dj9082d57aa9469685@mail.gmail.com> <497C903E.5080108@redhat.com> <ea11fea30901250822n7b1e9c3ck1959d2e42e47ce76@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 <linux-ext4@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>,
	cmm@us.ibm.com
To: Manish Katiyar <mkatiyar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54484 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbZAZMcF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Jan 2009 07:32:05 -0500
Content-Disposition: inline
In-Reply-To: <ea11fea30901250822n7b1e9c3ck1959d2e42e47ce76@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> On Sun, Jan 25, 2009 at 9:45 PM, Eric Sandeen <sandeen@redhat.com> wrote:
> > Manish Katiyar wrote:
> >> On Tue, Jan 20, 2009 at 10:36 PM, Manish Katiyar <mkatiyar@gmail.com> wrote:
> >>> ext2_quota_read doesn't bzeroes tmp_bh before calling ext2_get_block()
> >>> where we access the b_size of it. Since it is a local variable it
> >>> might contain some garbage. Make sure it is filled with zero before
> >>> passing.
> >>
> >> Hi Ted/mingming,
> >>
> >> Any feedback on this ??
> >
> > This looks ok to me, Manish.  I'm curious, did you see this fail in real
> > life, and if so, what'd the failure look like?
> 
> Actually no......I realised this while going through the code. I was
> also wondering why we haven't hit this till now. Since ext{3,4} don't
> have this issue, the only reason I can think of is because ext2 with
> quota is not very much used or somehow we are lucky.
  Well, I think ext2 with quotas is not used very often. But also note
that if a random garbage is passed in it has high chances that maxblocks
is >= 1. And that is all what is needed for ext2_get_blocks() to return
what we want.

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
