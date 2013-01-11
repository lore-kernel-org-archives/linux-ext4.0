From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH RFC] jbd: don't wake kjournald unnecessarily
Date: Fri, 11 Jan 2013 13:06:27 -0600
Message-ID: <50F062B3.6070104@redhat.com>
References: <20121219012710.GF5987@quack.suse.cz> <20121219020526.GG5987@quack.suse.cz> <50D12FC3.6090209@redhat.com> <20121219081334.GB20163@quack.suse.cz> <20121219153725.GD7795@thunk.org> <20121219171401.GB28042@quack.suse.cz> <20121219202734.GA18804@thunk.org> <50D49606.3020708@redhat.com> <20121221174602.GA31731@thunk.org> <50F040D8.6060801@redhat.com> <20130111190351.GA19912@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51522 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753679Ab3AKTHM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 Jan 2013 14:07:12 -0500
In-Reply-To: <20130111190351.GA19912@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 1/11/13 1:03 PM, Jan Kara wrote:
> On Fri 11-01-13 10:42:00, Eric Sandeen wrote:

...

>> TBH though, this is somewhat opposite of what I'd expect; I thought more
>> wakes might mean smaller transactions - except the wakes were "pointless"
>> - so I'm not quite sure what's going on yet.  We can certainly see the
>> difference, though, and that my change gets us back to the prior
>> behavior.
>   Yes, that's what I'd expect if the difference was really in IO. But
> apparently the benchmark is CPU bound on the machine and so the higher
> amount of work we do under j_state_lock (wake_up() has some small
> cost after all - it disables interrupts and takes q->lock) results in
> kjournald taking longer to wake and do its work. It might be interesting to
> know about how many useless wakeups are we speaking here?

Yeah, I want to get that next.

I think I'll need to instrument the module to get that, the fear is that
systemtap might have too much overhead (but I can try both ways).

Thanks,
-Eric

> 								Honza
> 

