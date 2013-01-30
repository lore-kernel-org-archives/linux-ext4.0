From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: jbd2: don't wake kjournald unnecessarily
Date: Wed, 30 Jan 2013 00:26:58 -0500
Message-ID: <20130130052658.GE25006@thunk.org>
References: <CA+icZUVy-=jJkRsEKmX+ZGRjiGr4wwp3pqdxuLCRHeqW_H0x9Q@mail.gmail.com>
 <CA+icZUVAP4ArN+j34GTUwMxte5DtLPJSrLmK9T6Na8Qy+aM0Rg@mail.gmail.com>
 <20130121140738.GI5588@quack.suse.cz>
 <CA+icZUXLcdnNPvA9o8d5msOQ0MkMci8mPXujLZ3zcYjYcVZ7JQ@mail.gmail.com>
 <20130121231130.GB12410@thunk.org>
 <20130122235041.GA7497@quack.suse.cz>
 <50FF3EEA.2030408@redhat.com>
 <20130123094421.GB9821@quack.suse.cz>
 <50FFFFC6.8070308@redhat.com>
 <20130123192911.GB21112@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	Sedat Dilek <sedat.dilek@gmail.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	mszeredi@suse.cz
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46143 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732Ab3A3F1F (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Jan 2013 00:27:05 -0500
Content-Disposition: inline
In-Reply-To: <20130123192911.GB21112@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 23, 2013 at 08:29:11PM +0100, Jan Kara wrote:
> > old JBD: AIM7 jobs/min 97624.39;  got 78193 jbd wakeups
> > new JBD: AIM7 jobs/min 85929.43;  got 6306999 jbd wakeups, 6264684 extra wakeups
>   Yeah, that's a lot. My guess would be *a lot* of processes are hanging in
> start_this_handle() and waiting for transaction commit. Each of them calls
> __log_start_commit() and things add up. Thanks for getting these numbers.

Yeah, wow.  That would imply that there are a huge number of processes
that get hung up in start_this_handle(), and they are waking up the
journal before the kjournald has a chance to set T_LOCKED (since then
they would get blocked earlier in start_this_handle).

Given that, I wonder if the following change would actually help or
hurt things.  Eric, would you be willing to ask your perf team to try
testing out these patches?

						- Ted
