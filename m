From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: a suspected data race bug in Ext4 file system
Date: Thu, 6 Nov 2008 18:51:09 -0800
Message-ID: <20081106185109.ce8be9b8.akpm@linux-foundation.org>
References: <2014bcab0811061809vca13befn813440a32dda3914@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: adilger@sun.com, linux-ext4@vger.kernel.org
To: =?UTF-8?Q? "=ED=99=8D=EC=8B=A0_shin_hong" ?= <hongshin@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55870 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751388AbYKGCva (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Nov 2008 21:51:30 -0500
In-Reply-To: <2014bcab0811061809vca13befn813440a32dda3914@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 7 Nov 2008 11:09:49 +0900 "______ shin hong" <hongshin@gmail.com> wrote:

> Dear Ext4 maintainer,
> 
> I found a suspected data race bug at ext4_release_file() in ext4/file.c .
> 
> Is it necessary to re-check whether the if-statement's
> condition(atomic_read(&inode->i_writecount) == 1) is satisifed after
> semaphore down operation?
> 
> It seems to use "test and test and set" pattern(double-checking)
>  but the second "test" seems to be missed.
> 
> Please examine this function. Thank you.
> 
> p.s. I sent the same report to sct@redhat.com. But I did not received
> any reply.
>        I think my mail was discarded so I am sending the same again.
> 

An appropriate way to report this possible bug is to Cc: the ext4 mailing
list, which I have cc'ed here.

Thanks.
