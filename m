From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [REPOST][PATCH][RFC] vfs: add message print mechanism for the
 mount/umount into the VFS layer
Date: Fri, 15 Jan 2010 13:43:42 -0500
Message-ID: <4B50B75E.1050802@redhat.com>
References: <20100114154837.734fff60.toshi.okajima@jp.fujitsu.com> <20100114081448.GI19799@ZenIV.linux.org.uk> <D69F3C0C-FC4A-4866-98BD-DE9558250A0B@sun.com> <20100115012421.GA28498@discord.disaster> <20100115180722.GD3482@shell>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Dave Chinner <david@fromorbit.com>,
	Andreas Dilger <adilger@sun.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>,
	tytso@mit.edu, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>
To: Valerie Aurora <vaurora@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22168 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751899Ab0AOSng (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 15 Jan 2010 13:43:36 -0500
In-Reply-To: <20100115180722.GD3482@shell>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 01/15/2010 01:07 PM, Valerie Aurora wrote:
> On Fri, Jan 15, 2010 at 12:24:21PM +1100, Dave Chinner wrote:
>    
>> FWIW, having a general event channel for reporting filesystem events like
>> mount, enospc, corruption, etc makes a lot of sense to me.
>> Especially from the point of view that they can be also be tied into
>> automated filesystem test harnesses easily....
>>      
> Mmm, yummy!  Is this perhaps a topic for the next file systems workshop?
>
> (When _is_ the next file systems workshop?)
>
> -VAL
>    

I think that the current plan is to have it next to the LinuxCon event 
in Boston in early August....

The VM people are looking to do a mini-summit there as well and we were 
talking about getting together with them during part of the time,

Ric

