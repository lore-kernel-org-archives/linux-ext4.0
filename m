From: Taesoo Kim <taesoo@gatech.edu>
Subject: Re: [PATCH 1/1] jbd2: fix incorrect unlock on j_list_lock
Date: Wed, 18 Mar 2015 13:39:31 -0400
Message-ID: <20150318173931.GJ29195@taesoo.org>
References: <1426644518-29680-1-git-send-email-tsgatesv@gmail.com>
 <alpine.LFD.2.00.1503181142160.23465@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Taesoo Kim <tsgatesv@gmail.com>, tytso@mit.edu,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	changwoo@gatech.edu, sanidhya@gatech.edu, blee@gatech.edu,
	csong84@gatech.edu
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1503181142160.23465@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> The patch looks good, thanks.

Thank you.
 
> Reviewed-by: Lukas Czerner <lczerner@redhat.com>
> 
> Btw, were you able to reproduce the problem, or have you seen the
> problem in the wild ? Or did you just spot it in the code ?

We are developing a static checker to spot inconsistent programming
patterns; our first goal is to scan over existing filesystems and
figure out how they are implemented differently (or similarly). We
will report bugs in sequence as soon as our team confirm (just start
sending patches to other fs).

Thanks,
Taesoo

> Thanks!
> -Lukas
> 
> > 
> > Signed-off-by: Taesoo Kim <tsgatesv@gmail.com>
> > ---
> >  fs/jbd2/transaction.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
> > index 5f09370..edb7f59 100644
> > --- a/fs/jbd2/transaction.c
> > +++ b/fs/jbd2/transaction.c
> > @@ -1091,6 +1091,7 @@ int jbd2_journal_get_create_access(handle_t *handle, struct buffer_head *bh)
> >  		JBUFFER_TRACE(jh, "file as BJ_Reserved");
> >  		spin_lock(&journal->j_list_lock);
> >  		__jbd2_journal_file_buffer(jh, transaction, BJ_Reserved);
> > +		spin_unlock(&journal->j_list_lock);
> >  	} else if (jh->b_transaction == journal->j_committing_transaction) {
> >  		/* first access by this transaction */
> >  		jh->b_modified = 0;
> > @@ -1098,8 +1099,8 @@ int jbd2_journal_get_create_access(handle_t *handle, struct buffer_head *bh)
> >  		JBUFFER_TRACE(jh, "set next transaction");
> >  		spin_lock(&journal->j_list_lock);
> >  		jh->b_next_transaction = transaction;
> > +		spin_unlock(&journal->j_list_lock);
> >  	}
> > -	spin_unlock(&journal->j_list_lock);
> >  	jbd_unlock_bh_state(bh);
> > 
> >  	/*
> > --
> > 2.3.3
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
