From: Ted Ts'o <tytso@mit.edu>
Subject: Re: fsck.ext4 taking a very long time because of "should not have
 EOFBLOCKS_FL set"
Date: Wed, 19 Oct 2011 14:53:44 -0400
Message-ID: <20111019185344.GA4284@thunk.org>
References: <CAFj9jjyLbPjehM1QbVAK9qRQ3F45sRpp055cKGa6EijWi1CBUw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Johannes Segitz <johannes.segitz@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:33937 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752329Ab1JSSxs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 Oct 2011 14:53:48 -0400
Content-Disposition: inline
In-Reply-To: <CAFj9jjyLbPjehM1QbVAK9qRQ3F45sRpp055cKGa6EijWi1CBUw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 19, 2011 at 06:02:12PM +0200, Johannes Segitz wrote:
> Hello,
> 
> yesterday i was forced to start a fsck of an ext4 filesystem (4 TB on
> a encrypted raid5 array). After a while a got a lot
> of those messages:
> Inode 23565579 should not have EOFBLOCKS_FL set (size 0, lblk -1)
> 
> After some googling i found this thread
> http://kerneltrap.org/mailarchive/linux-ext4/2010/8/19/6885408/thread#mid-6885408

What kernel version are you using, and can you upgrade to one that has
this bug fixed?  This is a problem which was fixed over a year ago...

> Since it's something that can be taken care of by using "-p" i started
> it yesterday and was kind of surprised
> to discover it running happily today with no sign of stopping. I piped
> the output to /dev/null since the printing
> of the messages alone caused quite a bit of load so i don't know at
> which inode fsck currently is.
> 
> Is there a way to speed things up? If i understand the thread
> correctly those errors should self correct over time
> and i don't want to wait anymore. Can i do any harm by killing fsck
> and start it again without the pipe to see
> at which inode it currently is?

What version of e2fsprogs are you using?  Given that you're using an
old version of the kernel there's a good chance you're using a old
version of e2fsprogs.  Are you willing to upgrade to a newer kernel
and e2fsprogs?  If so, the following procedure documented in the
following commit, which is included in e2fsprogs 1.41.13 or newer,
should help you out (see below).

						- Ted

commit 75990388365c5688dbade9c33a3394e40f757526
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Mon Dec 6 10:10:33 2010 -0500

    e2fsck: Add the ability to force a problem to not be fixed
    
    The boolean options "force_no" in the problems stanza of e2fsck.conf
    allows a particular problem code be treated as if the user will answer
    "no" to the question of whether a particular problem should be fixed
    --- even if e2fsck is run with the -y option.
    
    As an example use case, suppose a distribution had widely deployed a
    version of the kernel where under some circumstances, the EOFBLOCKS_FL
    flag would be left set even though it should not be left set, and a
    customer had a workload which exercised the fencepost error all the
    time, resulting in many large number of inodes that had EOFBLOCKS_FL
    set erroneously.  Enough, in fact, the e2fsck runs were taking too
    long.  (There was such a bug in the kernel, which was fixed by commit
    58590b06d in 2.6.36).
    
    Leaving EOFBLOCKS_FL set when it should not be isn't a huge deal, and
    is certainly than having high availability timeout alerts going off
    left and right.  So in this case, the best fix might be to put the
    following in /etc/e2fsck.conf:
    
    [problems]
    0x010060 = {                        # PR_1_EOFBLOCKS_FL_SET
         force_no = true
         no_ok = true
         no_nomsg = true
    }
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

