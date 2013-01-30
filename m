From: Jan Kara <jack@suse.cz>
Subject: Re: jbd2: don't wake kjournald unnecessarily
Date: Wed, 30 Jan 2013 11:41:10 +0100
Message-ID: <20130130104110.GC22091@quack.suse.cz>
References: <CA+icZUXLcdnNPvA9o8d5msOQ0MkMci8mPXujLZ3zcYjYcVZ7JQ@mail.gmail.com>
 <20130121231130.GB12410@thunk.org>
 <20130122235041.GA7497@quack.suse.cz>
 <50FF3EEA.2030408@redhat.com>
 <20130123094421.GB9821@quack.suse.cz>
 <50FFFFC6.8070308@redhat.com>
 <20130123192911.GB21112@quack.suse.cz>
 <20130130052658.GE25006@thunk.org>
 <20130130100740.GA22091@quack.suse.cz>
 <CA+icZUVR-GG0UYcq=tciCYun+Ayn9YTQAMvcHRu3J1yDDYSsHA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>,
	Eric Sandeen <sandeen@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	mszeredi@suse.cz
To: Sedat Dilek <sedat.dilek@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42116 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754149Ab3A3KlY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Jan 2013 05:41:24 -0500
Content-Disposition: inline
In-Reply-To: <CA+icZUVR-GG0UYcq=tciCYun+Ayn9YTQAMvcHRu3J1yDDYSsHA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 30-01-13 11:29:02, Sedat Dilek wrote:
> On Wed, Jan 30, 2013 at 11:07 AM, Jan Kara <jack@suse.cz> wrote:
> > On Wed 30-01-13 00:26:58, Ted Tso wrote:
> >> On Wed, Jan 23, 2013 at 08:29:11PM +0100, Jan Kara wrote:
> >> > > old JBD: AIM7 jobs/min 97624.39;  got 78193 jbd wakeups
> >> > > new JBD: AIM7 jobs/min 85929.43;  got 6306999 jbd wakeups, 6264684 extra wakeups
> >> >   Yeah, that's a lot. My guess would be *a lot* of processes are hanging in
> >> > start_this_handle() and waiting for transaction commit. Each of them calls
> >> > __log_start_commit() and things add up. Thanks for getting these numbers.
> >>
> >> Yeah, wow.  That would imply that there are a huge number of processes
> >> that get hung up in start_this_handle(), and they are waking up the
> >> journal before the kjournald has a chance to set T_LOCKED (since then
> >> they would get blocked earlier in start_this_handle).
> >>
> >> Given that, I wonder if the following change would actually help or
> >> hurt things.  Eric, would you be willing to ask your perf team to try
> >> testing out these patches?
> >   Umm, I don't see anything. Forgot to attach them?
> >
> 
> Here I catched the two patches:
> 
> http://patchwork.ozlabs.org/patch/216768/
> http://patchwork.ozlabs.org/patch/216767/
  Ah, OK. Thanks for the pointer.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
