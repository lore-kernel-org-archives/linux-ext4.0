From: Ted Ts'o <tytso@mit.edu>
Subject: Re: ext4 corruption on 17TB file system during power cycle test
Date: Wed, 13 Jun 2012 11:44:43 -0400
Message-ID: <20120613154443.GB12595@thunk.org>
References: <2CE44BD3DBCF9541909CCB42F11CA392828AAC@SFO1EXC-MBXP06.nbttech.com>
 <4FD89F5C.4040600@redhat.com>
 <2CE44BD3DBCF9541909CCB42F11CA392828B20@SFO1EXC-MBXP06.nbttech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Ming Lei <Ming.Lei@riverbed.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:49610 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753206Ab2FMPos (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 Jun 2012 11:44:48 -0400
Content-Disposition: inline
In-Reply-To: <2CE44BD3DBCF9541909CCB42F11CA392828B20@SFO1EXC-MBXP06.nbttech.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 13, 2012 at 02:17:18PM +0000, Ming Lei wrote:
> We are using 1.42
> # fsck.ext4 -f -y /dev/md0
> e2fsck 1.42 (29-Nov-2011)

You really need to update to 1.42.4.  E2fsck on earlier versions had a
critical journal replay bug on >16TB file systems which would
certainly cause all sorts of file system corruptions after a power
cycle test.

Note that there have been all sorts of bug fixes to ext4 since 2.6.32,
so it's especially critical that your distribution vendor is keeping
up with the latest fixes.  It appears that Scientific Linux (which is
I assume what you mwant by 2.6.32SL6.1) is based on RHEL, but I don't
know how well the Scientific Linux folks have been keeping up with
backporting ext4 fixes to their kernel.

Even if your company is a cheapskate about using something like SL6.x
on your clients and compute servers, it might be a very good idea
indeed to get official Red Hat on your server and ask for their
support.  If you consider the cost of your RAID array, and the valu of
your data, trying to take the cheap way out for your storage server
may be quite foolhardy.

Alternatively, if you really want to go with free community support,
you really want to run with a bleeding edge 3.x kernel and make sure
you go with the latest version of e2fsprogs.  I think you will find
that very few people who are willing to give you free support on
ancient 2.6.32-based kernels, especially when we know how many ext4
bugs there were with the original 2.6.32 release, and how hard it is
to backport bug fixes to 2.6.32 kernels....

Regards,

						- Ted


> 
> -----Original Message-----
> From: Eric Sandeen [mailto:sandeen@redhat.com] 
> Sent: Wednesday, June 13, 2012 7:11 AM
> To: Ming Lei
> Cc: linux-ext4@vger.kernel.org
> Subject: Re: ext4 corruption on 17TB file system during power cycle test
> 
> On 6/13/12 8:49 AM, Ming Lei wrote:
> > I  have raid0 on 12 Seagate new 3TB sas drives and kernel version is
> > 2.6.32SL6.1 version. The ext4 is mounted with barrier on, delalloc 
> > on/off has almost the same result.
> > 
> > I ran fs_mark -F -t 10 -D 1000 -N 1000 -n 1000000 -s 40 -S 2 into 4 
> > iterations(reported count of 40000000) and then power cycled the box.
> > After the box came up, I ran fsck -f to check inconsistency. On ext4 
> > FS 7.5TB and 16TB, I got no fsck error; but on 17TB, 21TB and 33TB, I 
> > got big chunk of fsck errors.
> > 
> > My question is: is this known issue and any fix?
> 
> What version of e2fsprogs?  That'd be the critical first question.
> 
> There was at least one log recovery fix that went in post-1.42.3:
> 
> commit 3b693d0b03569795d04920a04a0a21e5f64ffedc
> Author: Theodore Ts'o <tytso@mit.edu>
> Date:   Mon May 21 21:30:45 2012 -0400
> 
>     e2fsck: fix 64-bit journal support
> 
>     64-bit journal support was broken; we weren't using the high bits from
>     the journal descriptor blocks!  We were also using "unsigned long" for
>     the journal block numbers, which would be a problem on 32-bit systems.
> 
>     Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> 
> 
> 1.42.4 was just released yesterday, you might retest that version.
> 
> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
