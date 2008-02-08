From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: Re: [PATCH] allocate struct ext4_allocation_context from
	a	kmem	cache to save stack space
Date: Fri, 08 Feb 2008 11:00:41 -0600
Message-ID: <1202490041.6852.11.camel@norville.austin.ibm.com>
References: <47A9E8CA.2070404@redhat.com>
	 <1202429513.3840.12.camel@localhost.localdomain>
	 <47ABAB29.2060300@redhat.com>
	 <1202434636.3840.25.camel@localhost.localdomain>
	 <47ABC00A.9080302@redhat.com>
	 <1202485537.6852.4.camel@norville.austin.ibm.com>
	 <1202488793.3936.4.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:60678 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934626AbYBHRAn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 8 Feb 2008 12:00:43 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m18H0gad002941
	for <linux-ext4@vger.kernel.org>; Fri, 8 Feb 2008 12:00:42 -0500
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m18H0gX4388964
	for <linux-ext4@vger.kernel.org>; Fri, 8 Feb 2008 12:00:42 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m18H0fSE005935
	for <linux-ext4@vger.kernel.org>; Fri, 8 Feb 2008 12:00:42 -0500
In-Reply-To: <1202488793.3936.4.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Fri, 2008-02-08 at 08:39 -0800, Mingming Cao wrote:
> On Fri, 2008-02-08 at 09:45 -0600, Dave Kleikamp wrote:
> > On Thu, 2008-02-07 at 20:35 -0600, Eric Sandeen wrote:

> > > it'll build:
> > > 
> > > static inline struct proc_dir_entry *proc_mkdir(const char *name,
> > >         struct proc_dir_entry *parent) {return NULL;}
> > > 
> > > yes, it'll issue a printk though.  *shrug*
> > > 
> printk could be removed...so as long as it builds fine. I had looked at
> the history yesterday and find this fix
> http://lists.openwall.net/linux-ext4/2007/10/10/2
> so I was under impression that the ifdefs was added to fix compile
> issue. I did not look more closely. Maybe that's not a issue any more.

It looks like the problem is that proc_root_fs is not defined when
CONFIG_PROC_FS is undefined.  Even though proc_mkdir() is defined as an
inline function, the compile still fails.

	proc_root_ext4 = proc_mkdir(EXT4_ROOT, proc_root_fs);

Maybe the best thing would be to put some dummy define in proc_fs.h
like:

#define proc_root_fs NULL

> > > I like fewer #ifdefs better than more, but doesn't matter much to me.
> > 
> 
> Oh, I prefer fewer #ifdefs too.:-)

-- 
David Kleikamp
IBM Linux Technology Center
