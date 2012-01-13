From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/4] fs: Improve filesystem freezing handling
Date: Fri, 13 Jan 2012 11:12:20 +0100
Message-ID: <20120113101220.GA13641@quack.suse.cz>
References: <1326331253-6497-1-git-send-email-jack@suse.cz>
 <1326331253-6497-2-git-send-email-jack@suse.cz>
 <20120113012643.GF2806@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
	Surbhi Palande <csurbhi@gmail.com>,
	Kamal Mostafa <kamal@canonical.com>,
	Eric Sandeen <sandeen@sandeen.net>,
	LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com,
	Christoph Hellwig <hch@infradead.org>,
	Dave Chinner <dchinner@redhat.com>, linux-ext4@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45340 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751658Ab2AMKMX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 Jan 2012 05:12:23 -0500
Content-Disposition: inline
In-Reply-To: <20120113012643.GF2806@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 13-01-12 12:26:43, Dave Chinner wrote:
> On Thu, Jan 12, 2012 at 02:20:50AM +0100, Jan Kara wrote:
> > + *
> > + * Decrement number of writers to the filesystem and wake up possible
> > + * waiters wanting to freeze the filesystem.
> > + */
> > +void sb_end_write(struct super_block *sb)
> > +{
> > +#ifdef CONFIG_SMP
> > +	this_cpu_dec(sb->s_writers);
> > +#else
> > +	preempt_disable();
> > +	sb->s_writers--;
> > +	preempt_enable();
> > +#endif
> 
> I really dislike this type of open coded per-cpu counter
> implementation. I can't see that there is no good reason to use it
> over percpu_counters here which abstract all this mess away.
> 
> i.e. it is relatively rare that the per-cpu count will nest
> greater than the percpu_counter batch size (needs more than 32
> concurrent blocked active writes per CPU), so there is no
> significant overhead to using the percpu_counters here.
> 
> Indeed, if there are that many blocked writes per CPU, then the
> overhead of an occasional global counter update is going to be lost
> in the noise of everything else that is going on.
  Well, I just did it the way mnt_want_write / mnt_put_write does it. But
you are right that it's unnecessary so it's a good idea to switch the code
to using per-cpu counters. Thanks for the idea.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
