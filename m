From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] e2fsck: Always fix last mount/write/check time with -p
Date: Sat, 17 Oct 2009 10:23:09 -0500
Message-ID: <4AD9E15D.2060400@redhat.com>
References: <E1MxMjT-0003XH-Mn@zelda.netsplit.com> <20091017010330.GA8081@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Scott James Remnant <scott@ubuntu.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:65426 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751945AbZJQPXL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 17 Oct 2009 11:23:11 -0400
In-Reply-To: <20091017010330.GA8081@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
...

> In any case, I accept that in some cases it's not possible for the
> distribution to do the right thing.  I do want to leave the
> possibility for a "strict mode", in the hopes that one day we can do a
> better job.  So here's what I ultimately checked into e2fsprogs.
> 
>        	     	       	      		 	 - Ted
> 
> From ba5131f6d48eded504e84c2a8ffc8131df8a512e Mon Sep 17 00:00:00 2001
> From: Theodore Ts'o <tytso@mit.edu>
> Date: Fri, 16 Oct 2009 20:46:45 -0400
> Subject: [PATCH] e2fsck: Accept superblock times to be fudged by up to 24 hours by default

could you please push this out to the kernel.org repo?

Thanks,
-Eric
