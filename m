From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH v2] ext4: Deprecate data=journal mount option
Date: Fri, 12 Aug 2011 18:08:21 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1108121803210.3088@dhcp-27-109.brq.redhat.com>
References: <1309260363-19012-1-git-send-email-lczerner@redhat.com> <alpine.LFD.2.00.1108111700500.29009@dhcp-27-109.brq.redhat.com> <BEF6D87F-AEA5-4BF8-B71D-6BBA540C3731@dilger.ca> <alpine.LFD.2.00.1108121013280.4535@dhcp-27-109.brq.redhat.com>
 <4E44E374.7080103@redhat.com> <CAO81RMYcvpd2--Y-u2xOb2+3U=fOK2UtaW7d9iP43_u38hYgZA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1065660080-1313165306=:3088"
Cc: Ric Wheeler <rwheeler@redhat.com>,
	Lukas Czerner <lczerner@redhat.com>,
	Andreas Dilger <adilger@dilger.ca>,
	linux-ext4 List <linux-ext4@vger.kernel.org>,
	"Theodore Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	Eric Sandeen <sandeen@redhat.com>
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36906 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944Ab1HLQIn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 12 Aug 2011 12:08:43 -0400
In-Reply-To: <CAO81RMYcvpd2--Y-u2xOb2+3U=fOK2UtaW7d9iP43_u38hYgZA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1065660080-1313165306=:3088
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Fri, 12 Aug 2011, Curt Wohlgemuth wrote:

> I don't know much about data=journal, but I've been running xfstests
> with it, and it's a disaster, given that data=journal doesn't support
> O_DIRECT.  What kind of testing do people do on data=journal?

Short answer is probably none :). Even though that it seems like an
radical answer I believe that it is mostly true, because simply said
almost no-one care. But I think that Ted mentioned that he actually do
some tests with that mode, but I am not sure about that.

> 
> And worse, I consistently crash my machine running xfstests 074 on a
> data=journal partition.  I just repeated this to make sure, on
> 3.1.0-rc1; I've also seen it with 3.0.0.  There's a BUG_ON firing in
> jbd2_journal_dirty_metadata():
> 
> [ 2174.697692] ------------[ cut here ]------------
> [ 2174.698627] kernel BUG at fs/jbd2/transaction.c:1112!
> [ 2174.698627] invalid opcode: 0000 [#1] SMP
> [ 2174.698627] CPU 11
> ...
> [ 2174.698627] Call Trace:
> [ 2174.698627]  [<ffffffff8127f9a3>] __ext4_handle_dirty_metadata+0x83/0x120
> [ 2174.698627]  [<ffffffff8127fd1e>] ? __ext4_journal_get_write_access+0x3e/0x80
> [ 2174.698627]  [<ffffffff81253a78>] __ext4_journalled_writepage+0x338/0x3e0
> [ 2174.698627]  [<ffffffff81254244>] ext4_writepage+0x234/0x2f0
> [ 2174.698627]  [<ffffffff81158327>] __writepage+0x17/0x40
> [ 2174.698627]  [<ffffffff811597ae>] write_cache_pages+0x1fe/0x650
> 
> This is at the J_ASSERT_JH below:
> 
> 	/*
> 	 * Metadata already on the current transaction list doesn't
> 	 * need to be filed.  Metadata on another transaction's list must
> 	 * be committing, and will be refiled once the commit completes:
> 	 * leave it alone for now.
> 	 */
> 	if (jh->b_transaction != transaction) {
> 		JBUFFER_TRACE(jh, "already on other transaction");
> 		J_ASSERT_JH(jh, jh->b_transaction ==
> 					journal->j_committing_transaction);      <===============
> 		J_ASSERT_JH(jh, jh->b_next_transaction == transaction);
> 		/* And this case is illegal: we can't reuse another
> 		 * transaction's data buffer, ever. */
> 		goto out_unlock_bh;
> 	}

Wow, that backtrace seems like a flash-back to me I believe that I have
seen it several times, probably in different modes and probably already
fixed. Do no know about this one though.

Thanks!
-Lukas

> 
> Curt
> 
> On Fri, Aug 12, 2011 at 1:25 AM, Ric Wheeler <rwheeler@redhat.com> wrote:
> > On 08/12/2011 09:16 AM, Lukas Czerner wrote:
> >>
> >> On Thu, 11 Aug 2011, Andreas Dilger wrote:
> >>
> >>> On 2011-08-11, at 9:01 AM, Lukas Czerner wrote:
> >>>>
> >>>> On Tue, 28 Jun 2011, Lukas Czerner wrote:
> >>>>>
> >>>>> Data journalling mode (data=journal) is known to be neglected by
> >>>>> developers and only minority of people is actually using it. This
> >>>>> mode is also less tested than the other two modes by the developers.
> >>>>>
> >>>>> This creates a dangerous combination, because the option which seems
> >>>>> *safer* is actually less safe the others. So this commit adds a warning
> >>>>> message in case that data=journal mode is used, so the user is informed
> >>>>> that the mode might be removed in the future.
> >>>>
> >>>> Any comments on this ? Is that feasible to remove is someday ?
> >>>
> >>> I'm less in favour of removing data=journal.  Jan made some fixes to
> >>> data=journal mode in the last few weeks, which means that people are
> >>> still using this.
> >>
> >> I think that Jan was actually the one who was in favour of this change
> >> IIRC. But you're right that there are still some (very little possibly?)
> >> users of this. But this change does not remove it, but just let the
> >> users know that it might be removed someday, hence discouraging them from
> >> using it.
> >>
> >> Also we were discussing that several times, so I think that letting
> >> users know that we are considering it is a good thing.
> >>
> >> Thanks!
> >> -Lukas
> >
> > I think that this will be very useful to have - users should definitely
> > chime in when they see this warning if they are using data journal mode.
> >
> > The only work load that I know that benefits from a performance point of
> > view is one which involves an fsync() heavy, small file creation workload.
> >  Any workload with larger files tends to lose roughly 50% of the write
> > bandwidth under streaming writes since we end up writing everything twice.
> >
> > Regards,
> >
> > Ric
> >
> >
> >>
> >>>>> Signed-off-by: Lukas Czerner<lczerner@redhat.com>
> >>>>> ---
> >>>>> fs/ext4/super.c |    5 +++++
> >>>>> 1 files changed, 5 insertions(+), 0 deletions(-)
> >>>>>
> >>>>> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> >>>>> index 9ea71aa..9d189cf 100644
> >>>>> --- a/fs/ext4/super.c
> >>>>> +++ b/fs/ext4/super.c
> >>>>> @@ -1631,6 +1631,11 @@ static int parse_options(char *options, struct
> >>>>> super_block *sb,
> >>>>>                        sbi->s_min_batch_time = option;
> >>>>>                        break;
> >>>>>                case Opt_data_journal:
> >>>>> +                       ext4_msg(sb, KERN_WARNING,
> >>>>> +                                "Using data=journal may be removed in
> >>>>> the "
> >>>>> +                                "future. Please, contact "
> >>>>> +                                "linux-ext4@vger.kernel.org if you are
> >>>>> "
> >>>>> +                                "using this feature.");
> >>>>>                        data_opt = EXT4_MOUNT_JOURNAL_DATA;
> >>>>>                        goto datacheck;
> >>>>>                case Opt_data_ordered:
> >>>>>
> >>>> --
> >>>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> >>>> the body of a message to majordomo@vger.kernel.org
> >>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>>
> >>> Cheers, Andreas
> >>>
> >>>
> >>>
> >>>
> >>>
> >>>
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 

-- 
--8323328-1065660080-1313165306=:3088--
