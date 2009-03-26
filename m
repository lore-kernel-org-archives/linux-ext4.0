From: Jan Kara <jack@suse.cz>
Subject: Re: next-20090310: ext4 hangs
Date: Thu, 26 Mar 2009 01:25:55 +0100
Message-ID: <20090326002554.GD11024@duck.suse.cz>
References: <20090325151516.GB14881@atrey.karlin.mff.cuni.cz> <a4423d670903250818n512b1c67ja1b38db6d09ac7c@mail.gmail.com> <20090325152234.GN23439@duck.suse.cz> <a4423d670903250829w5e9304a7rce24f4220379620f@mail.gmail.com> <20090325161556.GP23439@duck.suse.cz> <a4423d670903251007r72058ca8m28275c1433ab2706@mail.gmail.com> <20090325194316.GQ23439@duck.suse.cz> <a4423d670903251538p3a7c180br1bcfe08c4f044c15@mail.gmail.com> <20090326000035.GB11024@duck.suse.cz> <49CAC982.4050507@gaisler.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alexander Beregalov <a.beregalov@gmail.com>,
	Theodore Tso <tytso@mit.edu>,
	"linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
	linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	sparclinux@vger.kernel.org
To: Jiri Gaisler <jiri@gaisler.com>
Return-path: <sparclinux-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <49CAC982.4050507@gaisler.com>
Sender: sparclinux-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu 26-03-09 01:17:06, Jiri Gaisler wrote:
> Jan Kara wrote:
> >   Hi,
> > 
> >   thanks for the updated disassembly.
> > 
> >>   55bab0:       82 10 60 01     or  %g1, 1, %g1
> >>                 spin_unlock(&journal->j_list_lock);
> >>   55bab4:       40 06 4b 20     call  6ee734 <_spin_unlock>
> >>   55bab8:       c2 24 e0 28     st  %g1, [ %l3 + 0x28 ]
> >   OK, so it really seems that:
> >   jinode->i_flags |= JI_COMMIT_RUNNING;
> >   spin_unlock(&journal->j_list_lock);
> > 
> >   has been compiled to
> >   ld [ %l3 + 0x28 ], %g1
> >   or  %g1, 1, %g1
> >   call  6ee734 <_spin_unlock>
> >   st  %g1, [ %l3 + 0x28 ]
> > 
> >   Which seems like a bug in the compiler or in the way implement compiler
> > barriers in spin_unlock() on UP sparc. Or is there some sparc magic by which
> > this is correct code? Any clever sparc guy?
> > 
> Looks fine to me - the store is made in the branch delay slot
> of the call, so it will occur before the first instruction at
> the call target address executes.
  Thanks for explanation. I knew sparc had some surprising features like
this ;).
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
