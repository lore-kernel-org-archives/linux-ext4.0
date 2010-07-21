From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [BUG] ext4 trace events cause NULL pointer dereferences
Date: Wed, 21 Jul 2010 16:21:16 +0200
Message-ID: <20100721142112.GB5764@nowhere>
References: <4C401CE3.7010004@cn.fujitsu.com> <20100721222508.8704.A69D9226@jp.fujitsu.com> <1279721766.4818.39.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	Li Zefan <lizf@cn.fujitsu.com>, Theodore Ts'o <tytso@mit.edu>,
	LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56630 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755624Ab0GUOVU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 21 Jul 2010 10:21:20 -0400
Content-Disposition: inline
In-Reply-To: <1279721766.4818.39.camel@gandalf.stny.rr.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 21, 2010 at 10:16:06AM -0400, Steven Rostedt wrote:
> On Wed, 2010-07-21 at 22:31 +0900, KOSAKI Motohiro wrote:
> > Hi Steven,
> 
> >         if (ac)
> > 	        trace_ext4_mb_release_group_pa(ac, pa);
> > 
> > But, I don't think this is proper fix because we don't want any overhead
> > if the tracepoint is disabled.
> > 
> > So, How do we check NULL in TP_fast_assign()?
> 
> You could do:
> 
> 	TP_fast_assign(
> 		if (ac) {
> 	                __entry->dev            = ac->ac_sb->s_dev;
>         	        __entry->ino            = ac->ac_inode->i_ino;
>         	        __entry->pa_pstart      = pa->pa_pstart;
>         	        __entry->pa_len         = pa->pa_len;
> 		}
>         ),
> 
> But this just makes the __entry null and wastes the ring buffer.
> 
> I may be able to add a __discard_entry that may help. Then we could do
> something like this:
> 
> 	if (ac) {
>                 __entry->dev            = ac->ac_sb->s_dev;
>                 __entry->ino            = ac->ac_inode->i_ino;
>                 __entry->pa_pstart      = pa->pa_pstart;
>                 __entry->pa_len         = pa->pa_len;
> 	} else
> 		__discard_entry;
> 
> Does this seem reasonable?
> 
> But for now, the wasting the entry seems to be the only choice we have,
> or to do as you suggested and have the "if (ac) trace_...", but I don't
> like that.
> 
> -- Steve


Is there no already existing branch in ext4 you could reuse in order to
send the trace only if (ac) ?

