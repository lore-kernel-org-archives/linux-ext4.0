From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] allocate struct ext4_allocation_context from
	a	kmem	cache to save stack space
Date: Fri, 08 Feb 2008 08:39:53 -0800
Message-ID: <1202488793.3936.4.camel@localhost.localdomain>
References: <47A9E8CA.2070404@redhat.com>
	 <1202429513.3840.12.camel@localhost.localdomain>
	 <47ABAB29.2060300@redhat.com>
	 <1202434636.3840.25.camel@localhost.localdomain>
	 <47ABC00A.9080302@redhat.com>
	 <1202485537.6852.4.camel@norville.austin.ibm.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:59819 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934225AbYBHQj5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Feb 2008 11:39:57 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e32.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m18Fa7pR000918
	for <linux-ext4@vger.kernel.org>; Fri, 8 Feb 2008 10:36:07 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m18GdqHS158352
	for <linux-ext4@vger.kernel.org>; Fri, 8 Feb 2008 09:39:52 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m18GdqOd006407
	for <linux-ext4@vger.kernel.org>; Fri, 8 Feb 2008 09:39:52 -0700
In-Reply-To: <1202485537.6852.4.camel@norville.austin.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 2008-02-08 at 09:45 -0600, Dave Kleikamp wrote:
> On Thu, 2008-02-07 at 20:35 -0600, Eric Sandeen wrote:
> > Mingming Cao wrote:
> > > On Thu, 2008-02-07 at 19:06 -0600, Eric Sandeen wrote:
> > >> Mingming Cao wrote:
> > >>
> > >>> Do you intend to remove the #ifdef CONFIG_PROC_FS, or it's a accident? I
> > >>> think we need keep that to allow ext4 build without procfs configured.
> > >>>
> > >>> Other than this, the patch looks fine to me.:)
> > >> oh, it kind of snuck in.  It actually should still build, as
> > >> remove_proc_entry is a no-op function w/o the config option.
> > > 
> > > Oh, I mean the proc_mkdir(EXT4_ROOT, proc_root_fs) will complain w/o
> > > CONFIG_PROC_FS configured.
> > > 
> > > Mingming
> > > 
> > 
> > it'll build:
> > 
> > static inline struct proc_dir_entry *proc_mkdir(const char *name,
> >         struct proc_dir_entry *parent) {return NULL;}
> > 
> > yes, it'll issue a printk though.  *shrug*
> > 
printk could be removed...so as long as it builds fine. I had looked at
the history yesterday and find this fix
http://lists.openwall.net/linux-ext4/2007/10/10/2
so I was under impression that the ifdefs was added to fix compile
issue. I did not look more closely. Maybe that's not a issue any more.

> > I like fewer #ifdefs better than more, but doesn't matter much to me.
> 

Oh, I prefer fewer #ifdefs too.:-)

> It's strongly encouraged to avoid unnecessary ifdefs.  (Does Christoph
> read this list?)  In my opinion, the decision is whether or not to just
> remove the printk.
> 

Mingming
> Shaggy
