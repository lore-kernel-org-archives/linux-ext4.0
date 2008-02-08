From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: Re: [PATCH] allocate struct ext4_allocation_context from
	a	kmem	cache to save stack space
Date: Fri, 08 Feb 2008 09:45:37 -0600
Message-ID: <1202485537.6852.4.camel@norville.austin.ibm.com>
References: <47A9E8CA.2070404@redhat.com>
	 <1202429513.3840.12.camel@localhost.localdomain>
	 <47ABAB29.2060300@redhat.com>
	 <1202434636.3840.25.camel@localhost.localdomain>
	 <47ABC00A.9080302@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: cmm@us.ibm.com, ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:50973 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756471AbYBHPqv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 8 Feb 2008 10:46:51 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m18Fka5w007730
	for <linux-ext4@vger.kernel.org>; Fri, 8 Feb 2008 10:46:36 -0500
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m18FkaT9244866
	for <linux-ext4@vger.kernel.org>; Fri, 8 Feb 2008 10:46:36 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m18FkaK0025770
	for <linux-ext4@vger.kernel.org>; Fri, 8 Feb 2008 10:46:36 -0500
In-Reply-To: <47ABC00A.9080302@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Thu, 2008-02-07 at 20:35 -0600, Eric Sandeen wrote:
> Mingming Cao wrote:
> > On Thu, 2008-02-07 at 19:06 -0600, Eric Sandeen wrote:
> >> Mingming Cao wrote:
> >>
> >>> Do you intend to remove the #ifdef CONFIG_PROC_FS, or it's a accident? I
> >>> think we need keep that to allow ext4 build without procfs configured.
> >>>
> >>> Other than this, the patch looks fine to me.:)
> >> oh, it kind of snuck in.  It actually should still build, as
> >> remove_proc_entry is a no-op function w/o the config option.
> > 
> > Oh, I mean the proc_mkdir(EXT4_ROOT, proc_root_fs) will complain w/o
> > CONFIG_PROC_FS configured.
> > 
> > Mingming
> > 
> 
> it'll build:
> 
> static inline struct proc_dir_entry *proc_mkdir(const char *name,
>         struct proc_dir_entry *parent) {return NULL;}
> 
> yes, it'll issue a printk though.  *shrug*
> 
> I like fewer #ifdefs better than more, but doesn't matter much to me.

It's strongly encouraged to avoid unnecessary ifdefs.  (Does Christoph
read this list?)  In my opinion, the decision is whether or not to just
remove the printk.

Shaggy
-- 
David Kleikamp
IBM Linux Technology Center
