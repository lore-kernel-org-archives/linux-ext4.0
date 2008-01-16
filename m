From: Martin Knoblauch <spamtrap@knobisoft.de>
Subject: Re: regression: 100% io-wait with 2.6.24-rcX
Date: Wed, 16 Jan 2008 06:15:49 -0800 (PST)
Message-ID: <230154.6549.qm@web32604.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mike Snitzer <snitzer@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>, jplatte@naasa.net,
	Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754689AbYAPOQH@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

----- Original Message ----
> From: Fengguang Wu <wfg@mail.ustc.edu.cn>
> To: Martin Knoblauch <knobi@knobisoft.de>
> Cc: Mike Snitzer <snitzer@gmail.com>; Peter Zijlstra <peterz@infradead.org>; jplatte@naasa.net; Ingo Molnar <mingo@elte.hu>; linux-kernel@vger.kernel.org; "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>; Linus Torvalds <torvalds@linux-foundation.org>
> Sent: Wednesday, January 16, 2008 1:00:04 PM
> Subject: Re: regression: 100% io-wait with 2.6.24-rcX
> 
> On Wed, Jan 16, 2008 at 01:26:41AM -0800, Martin Knoblauch wrote:
> > > For those interested in using your writeback improvements in
> > > production sooner rather than later (primarily with ext3); what
> > > recommendations do you have?  Just heavily test our own 2.6.24
> +
> 
 your
> > > evolving "close, but not ready for merge" -mm writeback patchset?
> > > 
> > Hi Fengguang, Mike,
> > 
> >  I can add myself to Mikes question. It would be good to know
> a
> 
 "roadmap" for the writeback changes. Testing 2.6.24-rcX so far has
> been
> 
 showing quite nice improvement of the overall writeback situation and
> it
> 
 would be sad to see this [partially] gone in 2.6.24-final.
> Linus
> 
 apparently already has reverted  "...2250b". I will definitely repeat my
> tests
> 
 with -rc8. and report.
> 
> Thank you, Martin. Can you help test this patch on 2.6.24-rc7?
> Maybe we can push it to 2.6.24 after your testing.
> 

 Will do tomorrow or friday. Actually a patch against -rc8 would be nicer for me, as I have not looked at -rc7 due to holidays and some of the reported problems with it.

Cheers
Martin

> Fengguang
> ---
>  fs/fs-writeback.c         |   17 +++++++++++++++--
>  include/linux/writeback.h |    1 +
>  mm/page-writeback.c       |    9 ++++++---
>  3 files changed, 22 insertions(+), 5 deletions(-)
> 
> --- linux.orig/fs/fs-writeback.c
> +++ linux/fs/fs-writeback.c
> @@ -284,7 +284,16 @@ __sync_single_inode(struct inode *inode,
>                   * soon as the queue becomes uncongested.
>                   */
>                  inode->i_state |= I_DIRTY_PAGES;
> -                requeue_io(inode);
> +                if (wbc->nr_to_write <= 0)
> +                    /*
> +                     * slice used up: queue for next turn
> +                     */
> +                    requeue_io(inode);
> +                else
> +                    /*
> +                     * somehow blocked: retry later
> +                     */
> +                    redirty_tail(inode);
>              } else {
>                  /*
>                   * Otherwise fully redirty the inode so that
> @@ -479,8 +488,12 @@ sync_sb_inodes(struct super_block *sb, s
>          iput(inode);
>          cond_resched();
>          spin_lock(&inode_lock);
> -        if (wbc->nr_to_write <= 0)
> +        if (wbc->nr_to_write <= 0) {
> +            wbc->more_io = 1;
>              break;
> +        }
> +        if (!list_empty(&sb->s_more_io))
> +            wbc->more_io = 1;
>      }
>      return;        /* Leave any unwritten inodes on s_io */
>  }
> --- linux.orig/include/linux/writeback.h
> +++ linux/include/linux/writeback.h
> @@ -62,6 +62,7 @@ struct writeback_control {
>      unsigned for_reclaim:1;        /* Invoked from the page
> allocator
> 
 */
>      unsigned for_writepages:1;    /* This is a writepages() call */
>      unsigned range_cyclic:1;    /* range_start is cyclic */
> +    unsigned more_io:1;        /* more io to be dispatched */
>  };
>  
>  /*
> --- linux.orig/mm/page-writeback.c
> +++ linux/mm/page-writeback.c
> @@ -558,6 +558,7 @@ static void background_writeout(unsigned
>              global_page_state(NR_UNSTABLE_NFS) < background_thresh
>                  && min_pages <= 0)
>              break;
> +        wbc.more_io = 0;
>          wbc.encountered_congestion = 0;
>          wbc.nr_to_write = MAX_WRITEBACK_PAGES;
>          wbc.pages_skipped = 0;
> @@ -565,8 +566,9 @@ static void background_writeout(unsigned
>          min_pages -= MAX_WRITEBACK_PAGES - wbc.nr_to_write;
>          if (wbc.nr_to_write > 0 || wbc.pages_skipped > 0) {
>              /* Wrote less than expected */
> -            congestion_wait(WRITE, HZ/10);
> -            if (!wbc.encountered_congestion)
> +            if (wbc.encountered_congestion || wbc.more_io)
> +                congestion_wait(WRITE, HZ/10);
> +            else
>                  break;
>          }
>      }
> @@ -631,11 +633,12 @@ static void wb_kupdate(unsigned long arg
>              global_page_state(NR_UNSTABLE_NFS) +
>              (inodes_stat.nr_inodes - inodes_stat.nr_unused);
>      while (nr_to_write > 0) {
> +        wbc.more_io = 0;
>          wbc.encountered_congestion = 0;
>          wbc.nr_to_write = MAX_WRITEBACK_PAGES;
>          writeback_inodes(&wbc);
>          if (wbc.nr_to_write > 0) {
> -            if (wbc.encountered_congestion)
> +            if (wbc.encountered_congestion || wbc.more_io)
>                  congestion_wait(WRITE, HZ/10);
>              else
>                  break;    /* All the old data is written */
> 
> 
> 


