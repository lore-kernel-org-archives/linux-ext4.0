From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] jbd: Lower severity of aborted journal from EMERG to CRIT
Date: Thu, 21 Nov 2013 11:50:33 +0100
Message-ID: <20131121105033.GB23049@quack.suse.cz>
References: <1384527412-23349-1-git-send-email-lkundrak@v3.sk>
 <20131118164533.GF3921@quack.suse.cz>
 <1384794395.28980.14.camel@hobbes.kokotovo>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Lubomir Rintel <lkundrak@v3.sk>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1384794395.28980.14.camel@hobbes.kokotovo>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon 18-11-13 18:06:35, Lubomir Rintel wrote:
> On Mon, 2013-11-18 at 17:45 +0100, Jan Kara wrote:
> > On Fri 15-11-13 15:56:52, Lubomir Rintel wrote:
> > > According to Documentation/kernel-parameters.txt, KERN_EMERG is reserved for
> > > events that render system unusable.
> > > 
> > > This is hardly the case in case of flash memory stick hardware removal without
> > > umounting. Syslog is often configured to forward messages with EMERG severity
> > > to all logged-in terminals, often causing unnecessary noise.
> >   The logic behind using KERN_EMERG in that place is that the filesystem is
> > dead. If it was an important filesystem in your system, the whole system is
> > unusable. In kernel, we don't know whether the filesystem was important or
> > not. So KERN_EMERG isn't adequate in all the cases but KERN_CRIT is
> > neither. What if we made that message print also device name (it would be
> > more useful anyway in that case) and you could then filter out messages for
> > unimportant devices in syslogd?
> 
> In case there's a failure on a filesystem, there are other better means
> in place to communicate the issue than a message in message buffer; in
> such case the accesses to the filesystem will result in EIO (that is for
> important filesystems; for the memory sticks that disappear from system
> I presume userspace would just umount them).
  Memory stick or your root disk, the application will get EIO in both
cases. Userspace cannot umount the disk until all applications using the
disk close their file descriptors. So there is no difference AFAICS.

So which better means do you have in mind to communicate root disk
filesystem is having problems? You could have a system like nagios monitor
whether the system is alive but then you don't need to bother with kernel
messages at all.

> Therefore I don't think it makes sense to differentiate between
> important and less important file systems in this particular place and I
> can't think of a good way do do that either. Even if there were devices
> for which EMERG level here would make sense I don't think replacing the
> stock syslog configurations with a quirk for this particular message is
> feasible; and to my knowledge at least rsyslog is not able to understand
> structured logs it the way journald does.
> 
> That said I don't mind replacing the printk(KERN_*) with dev_*() (maybe
> even other occurrences, checkpatch.pl suggests that anyway and it seems
> rather useful) but I'd still like it to be kern_crit().
> 
> What do you think about that?
  Well, my current opinion is that although in some cases having the
messages KERN_EMERG doesn't make sense, in other case it makes sense. So I
don't feel a strong reason to change what we have.

OTOH I wonder if that particular message in log_wait_commit() is useful
at all. The journal is aborted but we already informed user about that when
aborting it so there's no good reason to spam logs with information the
journal is still aborted... So I guess I'll just remove the message and we
will be both happy :)

								Honza

> > > Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
> > > ---
> > >  fs/jbd/journal.c  |    2 +-
> > >  fs/jbd2/journal.c |    2 +-
> > >  2 files changed, 2 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
> > > index 2d04f9a..9dbc1b6 100644
> > > --- a/fs/jbd/journal.c
> > > +++ b/fs/jbd/journal.c
> > > @@ -605,7 +605,7 @@ out_unlock:
> > >  	spin_unlock(&journal->j_state_lock);
> > >  
> > >  	if (unlikely(is_journal_aborted(journal))) {
> > > -		printk(KERN_EMERG "journal commit I/O error\n");
> > > +		printk(KERN_CRIT "journal commit I/O error\n");
> > >  		err = -EIO;
> > >  	}
> > >  	return err;
> > > diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> > > index 5203264..2d1f53c 100644
> > > --- a/fs/jbd2/journal.c
> > > +++ b/fs/jbd2/journal.c
> > > @@ -719,7 +719,7 @@ int jbd2_log_wait_commit(journal_t *journal, tid_t tid)
> > >  	read_unlock(&journal->j_state_lock);
> > >  
> > >  	if (unlikely(is_journal_aborted(journal))) {
> > > -		printk(KERN_EMERG "journal commit I/O error\n");
> > > +		printk(KERN_CRIT "journal commit I/O error\n");
> > >  		err = -EIO;
> > >  	}
> > >  	return err;
> > > -- 
> > > 1.7.1
> > > 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
