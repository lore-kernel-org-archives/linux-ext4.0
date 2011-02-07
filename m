From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH V3 RESEND 2] ext4: serialize unaligned asynchronous DIO
Date: Sun, 6 Feb 2011 21:33:36 -0500
Message-ID: <20110207023336.GI10402@thunk.org>
References: <4D2F7B52.1040209@redhat.com>
 <20110114041514.GI31800@thunk.org>
 <4D3087CE.2060200@redhat.com>
 <4D39CFEE.6070403@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:59532 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754344Ab1BGCdt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 6 Feb 2011 21:33:49 -0500
Content-Disposition: inline
In-Reply-To: <4D39CFEE.6070403@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 21, 2011 at 12:26:54PM -0600, Eric Sandeen wrote:
> ext4 has a data corruption case when doing non-block-aligned
> asynchronous direct IO into a sparse file, as demonstrated
> by xfstest 240.

Hey Eric,

One question about this patch.  You are currently using a hashed array
of size 37 for the waitqueue; what about using a similarly sized
hashed array for the aio_mutex?  We only take it for unaligned
mutexes, and I'm trying to work on reducing the size of ext4 inode,
since it gets rather large in the inode cache....

	     	 	   	   	    	- Ted
