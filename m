From: Theodore Tso <tytso@mit.edu>
Subject: Re: Online resize with flex bg
Date: Thu, 28 Aug 2008 13:11:56 -0400
Message-ID: <20080828171156.GK26987@mit.edu>
References: <1219934280.3591.121.camel@frecb007923.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: =?iso-8859-1?Q?Fr=E9d=E9ric_Boh=E9?= <frederic.bohe@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:51977 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752052AbYH1RL6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Aug 2008 13:11:58 -0400
Content-Disposition: inline
In-Reply-To: <1219934280.3591.121.camel@frecb007923.frec.bull.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 28, 2008 at 04:38:00PM +0200, Fr=E9d=E9ric Boh=E9 wrote:
> with flexbg :
> 	It works the same way but this time, meta-datas blocks for new group=
s
> are created inside the working filesystem (in a group containing
> meta-datas for the whole flex group). resize2fs scans from the end of
> the last flex_group meta-datas until it finds enough space to put the
> new meta-datas. This is not a problem when resizing offline, but when
> online, the blocks found for the meta-datas may be allocated by someo=
ne
> else before the GROUP_ADD ioctl occurs.

Yep, that's a problem.  Probably the quick fix is to allocate the
metadata outside of the working filesystem at least for now.  Because
we're extending the filesystem block group by block group, the
quick-and-dirty fix would be to just use the non-flex_bg allocation
algorithm and allocate the block bitmap, inode bitmap, and inode table
in the block group.

This we can do in the userspace code right now, since the kernel code
is enforcing that the block and inode bitmaps be in the new block
group at the moment anyway.  It is highly undesirable, since it would
break the advantage of flex_bg, but at least online resizing would
work.

To fix it right, I suspect we will need a new ioctl and do more of the
work inside the kernel, instead of in userspace.  That's the only way
we can do the block allocation inside the kernel efficiently.

       	      	    	       	      	  	 - Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
