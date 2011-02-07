From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH V3 RESEND 2] ext4: serialize unaligned asynchronous DIO
Date: Mon, 07 Feb 2011 11:58:21 -0600
Message-ID: <4D5032BD.4030708@redhat.com>
References: <4D2F7B52.1040209@redhat.com> <20110114041514.GI31800@thunk.org> <4D3087CE.2060200@redhat.com> <4D39CFEE.6070403@redhat.com> <20110207023336.GI10402@thunk.org> <20110207155936.GA3457@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56336 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752161Ab1BGR6X (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Feb 2011 12:58:23 -0500
In-Reply-To: <20110207155936.GA3457@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 02/07/2011 09:59 AM, Ted Ts'o wrote:
> On Sun, Feb 06, 2011 at 09:33:36PM -0500, Ted Ts'o wrote:
>>
>> Hey Eric,
>>
>> One question about this patch.  You are currently using a hashed array
>> of size 37 for the waitqueue; what about using a similarly sized
>> hashed array for the aio_mutex?  We only take it for unaligned
>> mutexes, and I'm trying to work on reducing the size of ext4 inode,
>> since it gets rather large in the inode cache....
>>
>> 	     	 	   	   	    	- Ted
> 
> Like this....  I also changed to_ioend_wq() and ioend_wq[] to be
> ext4_ioend_wq() and ext4__ioend_wq[], since they are now global
> variables.
> 

Looks fine to me, thanks, feel free to put an akpm-style comment
in the commit about what you fixed up.

-Eric
