From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] Documentation/filesystems/ext3.txt
Date: Tue, 19 May 2009 11:16:13 -0500
Message-ID: <4A12DB4D.4080407@redhat.com>
References: <20090518212209.17c46cee@digital-domain.net>	<4A12C3A4.90202@redhat.com> <20090519170358.5d38a2bc@zeus.int.pccl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Andrew Clayton <andrew@digital-domain.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:56397 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753988AbZESQQP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 May 2009 12:16:15 -0400
In-Reply-To: <20090519170358.5d38a2bc@zeus.int.pccl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andrew Clayton wrote:
> On Tue, 19 May 2009 09:35:16 -0500, Eric Sandeen wrote:
> 
>> Andrew Clayton wrote:
>>> Update the ext3 document with the fact that data=writeback is now
>>> the default journaling mode.
>>>
>>>
>>> Signed-off-by: Andrew Clayton <andrew@digital-domain.net>
>>>
>>> --- linux-2.6/Documentation/filesystems/ext3.txt.orig
>>> 2009-05-18 20:48:27.084220753 +0100 +++
>>> linux-2.6/Documentation/filesystems/ext3.txt	2009-05-18
>>> 20:49:01.023225288 +0100 @@ -39,11 +39,11 @@
>>> data=journal		All data are committed into the journal
>>> prior to being written into the main file system. 
>>> -data=ordered	(*)	All data are forced directly out to
>>> the main file +data=ordered		All data are forced
>>> directly out to the main file system prior to its metadata being
>>> committed to the journal.
>>>  
>>> -data=writeback		Data ordering is not preserved, data
>>> may be written +data=writeback	(*)	Data ordering is
>>> not preserved, data may be written into the main file system after
>>> its metadata has been committed to the journal.
>> If we're updating this documentation, while we're at it we should add
>> that the default is actually controlled by a new kernel config option,
>> and also something along the lines of "this mode will produce file
>> corruption on a power loss or unclean shutdown, and may lead to
>> unintentional information disclosure."
> 
> Sure, the data problem is actually eluded to further down the document
> where I've expanded it slightly and chat about the default writeback vs
> ordered mode.
> 
> Hows the below?

sounds better, minor nitpicks below

>> -Eric
> 
> Update the ext3 document with the fact that data=writeback is now
>  the default journaling mode and mention that the default can be turned 
> back to ordered mode via CONFIG_EXT3_DEFAULTS_TO_ORDERED
> 
> Also slightly expand upon the problems with writeback mode and possible
> file corruption and information disclosures as noted by Eric Sandeen
> 
> Signed-off-by: Andrew Clayton <andrew@digital-domain.net>
> 
> --- ext3.txt.orig	2009-05-19 16:31:17.000000000 +0100
> +++ ext3.txt	2009-05-19 16:59:35.000000000 +0100
> @@ -39,11 +39,11 @@
>  data=journal		All data are committed into the journal prior to being
>  			written into the main file system.
>  
> -data=ordered	(*)	All data are forced directly out to the main file
> +data=ordered		All data are forced directly out to the main file
>  			system prior to its metadata being committed to the
>  			journal.
>  
> -data=writeback		Data ordering is not preserved, data may be written
> +data=writeback	(*)	Data ordering is not preserved, data may be written
>  			into the main file system after its metadata has been
>  			committed to the journal.

I guess I'd still rather see a "see below" or something here, because I
think this is a critical change.  Perhaps you can tell I have a slight
agenda ;)  I think writeback as default is a terrible choice, and at
least full disclosure of risks is in order....

> @@ -160,16 +160,19 @@
>  There are 3 different data modes:
>  
>  * writeback mode
> -In data=writeback mode, ext3 does not journal data at all.  This mode provides
> -a similar level of journaling as that of XFS, JFS, and ReiserFS in its default
> -mode - metadata journaling.  A crash+recovery can cause incorrect data to
> -appear in files which were written shortly before the crash.  This mode will
> -typically provide the best ext3 performance.
> +If no mode is explicitly set then this is the default mode.  In data=writeback 
> +mode, ext3 does not journal data at all.  This mode provides a similar level of
> +journaling as that of XFS, JFS, and ReiserFS in its default mode - metadata 
> +journaling.  A crash+recovery can cause file corruption and may lead to 
> +sensitve data to appear in files which were written shortly before the crash.  
> +This mode will typically provide the best ext3 performance.

I'd do something like:

---
If no mode is explicitly set then this is the default mode.  In
data=writeback mode, ext3 does not journal data at all.  This mode
provides a similar level of journaling as that of XFS, JFS, and ReiserFS
in its default mode - metadata journaling.  Unlike these other
filesystems, however, a crash+recovery of ext3 in writeback mode can
cause file data corruption by allowing stale or sensitive data to appear
in files which were written shortly before the crash.  This mode will
typically provide the best ext3 performance.
---

I propose this change because the implication that this mode is no worse
than what other journaling filesystems do is wrong, IMHO.  Other
filesystems consider this sort of stale data exposure to be a bug and a
security flaw.  :)

Thanks,
-Eric

>  * ordered mode
> -In data=ordered mode, ext3 only officially journals metadata, but it logically
> -groups metadata and data blocks into a single unit called a transaction.  When
> -it's time to write the new metadata out to disk, the associated data blocks
> +This mode can be made the default via the kernel config option
> +CONFIG_EXT3_DEFAULTS_TO_ORDERED.  In data=ordered mode, ext3 only officially 
> +journals metadata, but it logically groups metadata and data blocks into a 
> +single unit called a transaction.  
> +When it's time to write the new metadata out to disk, the associated data blocks
>  are written first.  In general, this mode performs slightly slower than
>  writeback but significantly faster than journal mode.
>  

