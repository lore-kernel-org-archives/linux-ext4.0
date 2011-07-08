From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/3] jbd2,tracing,rcu: jbd2_dev_to_name() is not
 protect by RCU
Date: Fri, 8 Jul 2011 09:02:32 -0700
Message-ID: <20110708160232.GT6014@linux.vnet.ibm.com>
References: <ec67960d0864680d18a43ec5275baba3f6e1dd94.1308131436.git.laijs@cn.fujitsu.com>
 <4f75c511d209281967ff8eaa97a75d38d5346903.1308131436.git.laijs@cn.fujitsu.com>
 <1310090784.26417.217.camel@gandalf.stny.rr.com>
Reply-To: paulmck@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
	Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Steven Rostedt <rostedt@goodmis.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e8.ny.us.ibm.com ([32.97.182.138]:54369 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612Ab1GHQCs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 8 Jul 2011 12:02:48 -0400
Content-Disposition: inline
In-Reply-To: <1310090784.26417.217.camel@gandalf.stny.rr.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 07, 2011 at 10:06:24PM -0400, Steven Rostedt wrote:
> On Thu, 2011-06-16 at 09:47 +0800, Lai Jiangshan wrote:
> > TP_printk() is not inside the RCU critical section, so the return value
> > of jbd2_dev_to_name() may be invalid. This fix pass a devname argument to
> > store the result name to void this problem.
> > 
> > And ftrace_print_bdevname() is introduced to wrap
> > trace_seq_reserve() and jbd2_dev_to_name().
> > 
> > Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> 
> Acked-by: Steven Rostedt <rostedt@goodmis.org>
> 
> Ted,
> 
> Are you going to take these patches? Probably too late for 3.0, but
> maybe can get them into 3.1?

Me too.

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> -- Steve
> 
> > ---
> >  fs/jbd2/journal.c            |   27 ++++++++++++---------------
> >  include/linux/ftrace_event.h |   10 ++++++++++
> >  include/linux/jbd2.h         |    6 +++---
> >  include/trace/events/jbd2.h  |   15 ++++++++-------
> >  4 files changed, 33 insertions(+), 25 deletions(-)
> > 
> > diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> > index 1c45b6a..c37597a 100644
> > --- a/fs/jbd2/journal.c
> > +++ b/fs/jbd2/journal.c
> > @@ -2427,11 +2427,8 @@ static void __exit journal_exit(void)
> >   * jbd2_dev_to_name is a utility function used by the jbd2 and ext4 
> >   * tracing infrastructure to map a dev_t to a device name.
> >   *
> > - * The caller should use rcu_read_lock() in order to make sure the
> > - * device name stays valid until its done with it.  We use
> > - * rcu_read_lock() as well to make sure we're safe in case the caller
> > - * gets sloppy, and because rcu_read_lock() is cheap and can be safely
> > - * nested.
> > + * We use caches to cache the results and use rcu_read_lock()
> > + * to protect the caches.
> >   */
> >  struct devname_cache {
> >  	struct rcu_head	rcu;
> > @@ -2442,34 +2439,35 @@ struct devname_cache {
> >  static struct devname_cache __rcu *devcache[1 << CACHE_SIZE_BITS];
> >  static DEFINE_SPINLOCK(devname_cache_lock);
> >  
> > -const char *jbd2_dev_to_name(dev_t device)
> > +void jbd2_dev_to_name(dev_t device, char *devname)
> >  {
> >  	int	i = hash_32(device, CACHE_SIZE_BITS);
> > -	char	*ret;
> >  	struct block_device *bd;
> >  	static struct devname_cache *cache;
> >  
> >  	rcu_read_lock();
> >  	cache = rcu_dereference(devcache[i]);
> >  	if (cache && cache->device == device) {
> > -		ret = cache->devname;
> > +		memcpy(devname, cache->devname, BDEVNAME_SIZE);
> >  		rcu_read_unlock();
> > -		return ret;
> > +		return;
> >  	}
> >  	rcu_read_unlock();
> >  
> >  	cache = kmalloc(sizeof(struct devname_cache), GFP_KERNEL);
> > -	if (!cache)
> > -		return "NODEV-ALLOCFAILURE"; /* Something non-NULL */
> > +	if (!cache) {
> > +		__bdevname(device, devname);
> > +		return;
> > +	}
> >  	bd = bdget(device);
> >  	spin_lock(&devname_cache_lock);
> >  	if (devcache[i]) {
> >  		if (devcache[i]->device == device) {
> >  			kfree(cache);
> >  			bdput(bd);
> > -			ret = devcache[i]->devname;
> > +			memcpy(devname, devcache[i]->devname, BDEVNAME_SIZE);
> >  			spin_unlock(&devname_cache_lock);
> > -			return ret;
> > +			return;
> >  		}
> >  		kfree_rcu(devcache[i], rcu);
> >  	}
> > @@ -2480,9 +2478,8 @@ const char *jbd2_dev_to_name(dev_t device)
> >  	} else
> >  		__bdevname(device, cache->devname);
> >  	rcu_assign_pointer(devcache[i], cache);
> > -	ret = cache->devname;
> > +	memcpy(devname, cache->devname, BDEVNAME_SIZE);
> >  	spin_unlock(&devname_cache_lock);
> > -	return ret;
> >  }
> >  EXPORT_SYMBOL(jbd2_dev_to_name);
> >  
> > diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
> > index 59d3ef1..2959ead 100644
> > --- a/include/linux/ftrace_event.h
> > +++ b/include/linux/ftrace_event.h
> > @@ -6,6 +6,7 @@
> >  #include <linux/percpu.h>
> >  #include <linux/hardirq.h>
> >  #include <linux/perf_event.h>
> > +#include <linux/jbd2.h>
> >  
> >  struct trace_array;
> >  struct tracer;
> > @@ -28,6 +29,15 @@ const char *ftrace_print_flags_seq(struct trace_seq *p, const char *delim,
> >  const char *ftrace_print_symbols_seq(struct trace_seq *p, unsigned long val,
> >  				     const struct trace_print_flags *symbol_array);
> >  
> > +static inline const char *ftrace_print_bdevname(struct trace_seq *p, dev_t device)
> > +{
> > +	char *bdevname = trace_seq_reserve(p, BDEVNAME_SIZE);
> > +
> > +	jbd2_dev_to_name(device, bdevname);
> > +
> > +	return bdevname;
> > +}
> > +
> >  #if BITS_PER_LONG == 32
> >  const char *ftrace_print_symbols_seq_u64(struct trace_seq *p,
> >  					 unsigned long long val,
> > diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
> > index 4ecb7b1..964f375 100644
> > --- a/include/linux/jbd2.h
> > +++ b/include/linux/jbd2.h
> > @@ -1331,11 +1331,11 @@ extern int jbd_blocks_per_page(struct inode *inode);
> >  #define BUFFER_TRACE2(bh, bh2, info)	do {} while (0)
> >  #define JBUFFER_TRACE(jh, info)	do {} while (0)
> >  
> > -/* 
> > - * jbd2_dev_to_name is a utility function used by the jbd2 and ext4 
> > +/*
> > + * jbd2_dev_to_name is a utility function used by the jbd2 and ext4
> >   * tracing infrastructure to map a dev_t to a device name.
> >   */
> > -extern const char *jbd2_dev_to_name(dev_t device);
> > +extern void jbd2_dev_to_name(dev_t device, char *bdevname);
> >  
> >  #endif	/* __KERNEL__ */
> >  
> > diff --git a/include/trace/events/jbd2.h b/include/trace/events/jbd2.h
> > index bf16545..a9c8b44 100644
> > --- a/include/trace/events/jbd2.h
> > +++ b/include/trace/events/jbd2.h
> > @@ -27,7 +27,7 @@ TRACE_EVENT(jbd2_checkpoint,
> >  	),
> >  
> >  	TP_printk("dev %s result %d",
> > -		  jbd2_dev_to_name(__entry->dev), __entry->result)
> > +		  ftrace_print_bdevname(p, __entry->dev), __entry->result)
> >  );
> >  
> >  DECLARE_EVENT_CLASS(jbd2_commit,
> > @@ -49,7 +49,7 @@ DECLARE_EVENT_CLASS(jbd2_commit,
> >  	),
> >  
> >  	TP_printk("dev %s transaction %d sync %d",
> > -		  jbd2_dev_to_name(__entry->dev), __entry->transaction,
> > +		  ftrace_print_bdevname(p, __entry->dev), __entry->transaction,
> >  		  __entry->sync_commit)
> >  );
> >  
> > @@ -101,7 +101,7 @@ TRACE_EVENT(jbd2_end_commit,
> >  	),
> >  
> >  	TP_printk("dev %s transaction %d sync %d head %d",
> > -		  jbd2_dev_to_name(__entry->dev), __entry->transaction,
> > +		  ftrace_print_bdevname(p, __entry->dev), __entry->transaction,
> >  		  __entry->sync_commit, __entry->head)
> >  );
> >  
> > @@ -121,7 +121,8 @@ TRACE_EVENT(jbd2_submit_inode_data,
> >  	),
> >  
> >  	TP_printk("dev %s ino %lu",
> > -		  jbd2_dev_to_name(__entry->dev), (unsigned long) __entry->ino)
> > +		  ftrace_print_bdevname(p, __entry->dev),
> > +		  (unsigned long) __entry->ino)
> >  );
> >  
> >  TRACE_EVENT(jbd2_run_stats,
> > @@ -158,7 +159,7 @@ TRACE_EVENT(jbd2_run_stats,
> >  
> >  	TP_printk("dev %s tid %lu wait %u running %u locked %u flushing %u "
> >  		  "logging %u handle_count %u blocks %u blocks_logged %u",
> > -		  jbd2_dev_to_name(__entry->dev), __entry->tid,
> > +		  ftrace_print_bdevname(p, __entry->dev), __entry->tid,
> >  		  jiffies_to_msecs(__entry->wait),
> >  		  jiffies_to_msecs(__entry->running),
> >  		  jiffies_to_msecs(__entry->locked),
> > @@ -194,7 +195,7 @@ TRACE_EVENT(jbd2_checkpoint_stats,
> >  
> >  	TP_printk("dev %s tid %lu chp_time %u forced_to_close %u "
> >  		  "written %u dropped %u",
> > -		  jbd2_dev_to_name(__entry->dev), __entry->tid,
> > +		  ftrace_print_bdevname(p, __entry->dev), __entry->tid,
> >  		  jiffies_to_msecs(__entry->chp_time),
> >  		  __entry->forced_to_close, __entry->written, __entry->dropped)
> >  );
> > @@ -223,7 +224,7 @@ TRACE_EVENT(jbd2_cleanup_journal_tail,
> >  	),
> >  
> >  	TP_printk("dev %s from %u to %u offset %lu freed %lu",
> > -		  jbd2_dev_to_name(__entry->dev), __entry->tail_sequence,
> > +		  ftrace_print_bdevname(p, __entry->dev), __entry->tail_sequence,
> >  		  __entry->first_tid, __entry->block_nr, __entry->freed)
> >  );
> >  
> 
> 
