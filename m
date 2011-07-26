From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Filesystem benchmarks on reasonably fast hardware
Date: Tue, 26 Jul 2011 10:57:36 -0400
Message-ID: <20110726145736.GA7684@thunk.org>
References: <20110717160501.GA1437@logfs.org>
 <20110718120751.GH14869@thunk.org>
 <20110718124229.GG1437@logfs.org>
 <20110725151825.GI3469@thunk.org>
 <20110725182037.GE26160@logfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:37832 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753334Ab1GZO5r (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Jul 2011 10:57:47 -0400
Content-Disposition: inline
In-Reply-To: <20110725182037.GE26160@logfs.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 25, 2011 at 08:20:37PM +0200, J=F6rn Engel wrote:
> On Mon, 25 July 2011 11:18:25 -0400, Ted Ts'o wrote:
> >=20
> > Did you have a chance to do an ext4 lockstat run?

Hi J=F6rn,

Thanks for forwarding it to me.  It's the same problem as in XFS, the
excessive coverage of the i_mutex lock.  In ext4's case, it's in the
generic generic_file_aio_write() machinery where we need to do the
lock busting.  (XFS apparently doesn't use the generic routines, so
the fix that Dave did won't help ext3 and ext4.)

I don't have the time to look at it now, but I'll put it on my todo
list; or maybe someone with a bit more time can look into how we might
be able to use a similar approach in the generic file system code.

   	       	 	 	     	 	 - Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
