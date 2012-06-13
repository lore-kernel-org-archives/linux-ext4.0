From: Ming Lei <Ming.Lei@riverbed.com>
Subject: RE: ext4 corruption on 17TB file system during power cycle test
Date: Wed, 13 Jun 2012 14:17:18 +0000
Message-ID: <2CE44BD3DBCF9541909CCB42F11CA392828B20@SFO1EXC-MBXP06.nbttech.com>
References: <2CE44BD3DBCF9541909CCB42F11CA392828AAC@SFO1EXC-MBXP06.nbttech.com>
 <4FD89F5C.4040600@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.riverbed.com ([208.70.196.44]:56539 "EHLO
	smtp2.riverbed.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868Ab2FMORU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Jun 2012 10:17:20 -0400
In-Reply-To: <4FD89F5C.4040600@redhat.com>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We are using 1.42
# fsck.ext4 -f -y /dev/md0
e2fsck 1.42 (29-Nov-2011)

-----Original Message-----
From: Eric Sandeen [mailto:sandeen@redhat.com] 
Sent: Wednesday, June 13, 2012 7:11 AM
To: Ming Lei
Cc: linux-ext4@vger.kernel.org
Subject: Re: ext4 corruption on 17TB file system during power cycle test

On 6/13/12 8:49 AM, Ming Lei wrote:
> I  have raid0 on 12 Seagate new 3TB sas drives and kernel version is
> 2.6.32SL6.1 version. The ext4 is mounted with barrier on, delalloc 
> on/off has almost the same result.
> 
> I ran fs_mark -F -t 10 -D 1000 -N 1000 -n 1000000 -s 40 -S 2 into 4 
> iterations(reported count of 40000000) and then power cycled the box.
> After the box came up, I ran fsck -f to check inconsistency. On ext4 
> FS 7.5TB and 16TB, I got no fsck error; but on 17TB, 21TB and 33TB, I 
> got big chunk of fsck errors.
> 
> My question is: is this known issue and any fix?

What version of e2fsprogs?  That'd be the critical first question.

There was at least one log recovery fix that went in post-1.42.3:

commit 3b693d0b03569795d04920a04a0a21e5f64ffedc
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Mon May 21 21:30:45 2012 -0400

    e2fsck: fix 64-bit journal support

    64-bit journal support was broken; we weren't using the high bits from
    the journal descriptor blocks!  We were also using "unsigned long" for
    the journal block numbers, which would be a problem on 32-bit systems.

    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>


1.42.4 was just released yesterday, you might retest that version.

-Eric
