From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: Fix ext4_show_options to show the correct mount
 options.
Date: Wed, 24 Oct 2007 23:48:15 +0530
Message-ID: <471F8C67.2020907@linux.vnet.ibm.com>
References: <1193244441-10149-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1193244441-10149-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1193244441-10149-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1193244441-10149-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1193244441-10149-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1193244441-10149-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1193244441-10149-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1193244441-10149-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <471F8705.9090308@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:39717 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757514AbXJXSSn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Oct 2007 14:18:43 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp02.au.ibm.com (8.13.1/8.13.1) with ESMTP id l9OIIf5J032390
	for <linux-ext4@vger.kernel.org>; Thu, 25 Oct 2007 04:18:41 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9OIMGmt257360
	for <linux-ext4@vger.kernel.org>; Thu, 25 Oct 2007 04:22:16 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9OIIN6Z023855
	for <linux-ext4@vger.kernel.org>; Thu, 25 Oct 2007 04:18:23 +1000
In-Reply-To: <471F8705.9090308@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



Eric Sandeen wrote:
> Aneesh Kumar K.V wrote:
>> We need to look at the default value and make sure
>> the mount options are not set via default value
>> before showing them via ext4_show_options
> 
> Hm, does this jive with the comment about what's intended?
> 
> /*
>  * Show an option if
>  *  - it's set to a non-default value OR
>  *  - if the per-sb default is different from the global default
>  */
> 
> Aren't you now omitting the option if it's set in the per-sb default?
> 
> For example the "debug" option; it's off by default, globally.  The
> above comment suggests that if you have overridden that global default
> in the per-sb "default mount options" then it should be shown; this sort
> of makes sense to me because tune2fs calls these "default mount
> options," I'd expect them to behave exactly as if you had explicitly
> mounted with them.
> 
> With your patch, if you've set debug as default, it no longer shows up,
> right?


I was looking at commit 93d44cb275f3eba720617a8c5b00d51a8e0e9049

   Using mtab is problematic for various reasons, one of them is that
    unprivileged mounts won't turn up in there.  So we want to get rid of it, and
    use /proc/mounts instead.
    
    But most filesystems are lazy, and are not showing all mount options.  Which
    means, that without mtab, the user won't be able to see some or all of the
    options.
    
    It would be nice if the generic code could remember the mount options, and
    show them without the need to add extra code to filesystems.  But this is not
    easy, because different filesystems handle mount options given options, and
    not tough the rest.  This is not taken into account by mount(8) either, so
    /etc/mtab will be broken in this case.
   

So my understanding was that we are supposed to make /proc/mounts show the same output as
/etc/mtab did. In that case should we be showing the the default set in super block ?

-aneesh
