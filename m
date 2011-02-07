From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH V3 RESEND 2] ext4: serialize unaligned asynchronous DIO
Date: Mon, 07 Feb 2011 14:18:22 -0800
Message-ID: <1297117102.3207.311.camel@mingming-laptop>
References: <4D2F7B52.1040209@redhat.com> <20110114041514.GI31800@thunk.org>
	 <4D3087CE.2060200@redhat.com> <4D39CFEE.6070403@redhat.com>
	 <20110207023336.GI10402@thunk.org> <20110207155936.GA3457@thunk.org>
	 <4D5032BD.4030708@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: "Ted Ts'o" <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:60582 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242Ab1BGWSd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Feb 2011 17:18:33 -0500
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e34.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p17M7BTY016628
	for <linux-ext4@vger.kernel.org>; Mon, 7 Feb 2011 15:07:11 -0700
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id p17MISRl262338
	for <linux-ext4@vger.kernel.org>; Mon, 7 Feb 2011 15:18:28 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p17MISua016858
	for <linux-ext4@vger.kernel.org>; Mon, 7 Feb 2011 15:18:28 -0700
In-Reply-To: <4D5032BD.4030708@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 2011-02-07 at 11:58 -0600, Eric Sandeen wrote:
> On 02/07/2011 09:59 AM, Ted Ts'o wrote:
> > On Sun, Feb 06, 2011 at 09:33:36PM -0500, Ted Ts'o wrote:
> >>
> >> Hey Eric,
> >>
> >> One question about this patch.  You are currently using a hashed array
> >> of size 37 for the waitqueue; what about using a similarly sized
> >> hashed array for the aio_mutex?  We only take it for unaligned
> >> mutexes, and I'm trying to work on reducing the size of ext4 inode,
> >> since it gets rather large in the inode cache....
> >>
> >> 	     	 	   	   	    	- Ted
> > 
> > Like this....  I also changed to_ioend_wq() and ioend_wq[] to be
> > ext4_ioend_wq() and ext4__ioend_wq[], since they are now global
> > variables.
> > 
> 
> Looks fine to me, thanks, feel free to put an akpm-style comment
> in the commit about what you fixed up.
> 
> -Eric

Ted, Eric,

If it matters, you could add reviewed-by: Mingming Cao <cmm@us.ibm.com>
from me. The modified version looks fine with me.

Mingming
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


