From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] allocate struct ext4_allocation_context from a	kmem	cache
 to save stack space
Date: Thu, 07 Feb 2008 20:35:54 -0600
Message-ID: <47ABC00A.9080302@redhat.com>
References: <47A9E8CA.2070404@redhat.com>	 <1202429513.3840.12.camel@localhost.localdomain>	 <47ABAB29.2060300@redhat.com> <1202434636.3840.25.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:34823 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751571AbYBHChE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 7 Feb 2008 21:37:04 -0500
In-Reply-To: <1202434636.3840.25.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Mingming Cao wrote:
> On Thu, 2008-02-07 at 19:06 -0600, Eric Sandeen wrote:
>> Mingming Cao wrote:
>>
>>> Do you intend to remove the #ifdef CONFIG_PROC_FS, or it's a accident? I
>>> think we need keep that to allow ext4 build without procfs configured.
>>>
>>> Other than this, the patch looks fine to me.:)
>> oh, it kind of snuck in.  It actually should still build, as
>> remove_proc_entry is a no-op function w/o the config option.
> 
> Oh, I mean the proc_mkdir(EXT4_ROOT, proc_root_fs) will complain w/o
> CONFIG_PROC_FS configured.
> 
> Mingming
> 

it'll build:

static inline struct proc_dir_entry *proc_mkdir(const char *name,
        struct proc_dir_entry *parent) {return NULL;}

yes, it'll issue a printk though.  *shrug*

I like fewer #ifdefs better than more, but doesn't matter much to me.

-Eric
