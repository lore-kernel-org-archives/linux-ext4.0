From: Theodore Tso <tytso@mit.edu>
Subject: Re: possible (ext4 related?) memory leak in kernel 2.6.26
Date: Sun, 5 Oct 2008 08:27:52 -0400
Message-ID: <20081005122752.GB27335@mit.edu>
References: <20080930211854.GZ10831@mit.edu> <20080930222358.1FF30EAC415@quatramaran.ens.fr> <20081003003548.GA18138@mit.edu> <20081005091526.GA678@goelette.ens.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Quentin Godfroy <godfroy@clipper.ens.fr>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:41587 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753694AbYJEM16 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 5 Oct 2008 08:27:58 -0400
Content-Disposition: inline
In-Reply-To: <20081005091526.GA678@goelette.ens.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Oct 05, 2008 at 11:15:26AM +0200, Quentin Godfroy wrote:
> On Thu, Oct 02, 2008 at 08:35:48PM -0400, Theodore Tso wrote:
> > On Wed, Oct 01, 2008 at 12:23:58AM +0200, Quentin wrote:
> > > 
> > > Of course. However since I unmounted and remounted /home the 'buffer' line
> > > is now only 59megs, and they are still not dropped when a program tries to
> > > malloc all the memory. I'll tell next time the problem shows up (it
> > > can take ten days)
> > > 
> > 
> > Are you willing to patch and recompile your kernel?  If so, the
> > following patch would be very helpful in determining what is going on.
> > It allows us to see what buffer heads are in use for a particular
> > block device.  Attached please the kernel patch and the user program.
> 
> Now that the machine is again in the 100M+ in buffers (still unreleased when
> a program asks for all the memory), I launched the program on the devices
> which support / and /home.
> 
> I also attached /proc/meminfo and /proc/slabinfo
> 
> In both cases it freezes solid the machine for more than a minute or so, and
> it overflows the dmesg with messages. 

Can you check and see if you got more of the messages recorded in
/var/log/messages?  Once you do, can you take the block numbers, and
pull them out into a single command file to feed to debugfs.

So for example, given:

> [166632.382632] buffer dirty: block 35491 count 1
> [166632.386827] buffer dirty: block 35493 count 3
> [166632.391019] buffer dirty: block 35494 count 1
> [166632.395251] buffer dirty: block 35496 count 1
> [166632.399446] buffer dirty: block 35497 count 2
> [166632.403644] buffer dirty: block 35498 count 3
> [166632.407979] buffer dirty: block 35499 count 1
> [166632.412221] buffer dirty: block 35501 count 2

Take the column of block numbers, and tack on "icheck " at the
beginning, like so:

icheck 35491 35493 35494 35496 35497 35498 35499 35501 ...

You can put a thousand or so block numbers on each line; then it's
probably better to start a new line with "icheck " at the beginning.  
Then take that script and run it through debugfs:

     debugfs /dev/XXX < icheck.in > icheck.out

That will result in a file icheck.out that looks like this:

debugfs: icheck 33347
Block  Inode number
33347  8193
33348  8193
33350  8196
33351  8197
  ...

Now you'll need to take the inode numbers returned in icheck.out, and
create another file called ncheck.in that will take the inode numbers
and turn them into pathnames.  (I find that using emacs's
kill-rectangle command very handy for doing this sort of thing, but
other people will like to use awk, and I'm sure there's some way to do
this using vi but I don't know what it is.  :-) It's also a good idea
to take the inode numbers and run them through "sort -u" to get rid of
duplicates before putting them on a single line and adding ncheck to
them.  So what you want is to create a file ncheck.in that looks like this:

ncheck 8193 8196 8197 ....

... and then feed that to debugfs again:

debugfs /dev/XXX  < ncheck.in  > ncheck.out

That will produce a file that looks like this:

debugfs:  ncheck 8193
Inode	  Pathname
8193	  /ext4
   ...


The next thing I'd ask you to do is to look at the pathnames and
eyeball them; are they all directories?  Files?  Files that you have
modified earlier?  If you're not sure, you can look at a particular
inode either by giving its pathname:

debugfs: stat /ext4

or by its inode number, in angle brackets:

debugfs: stat <8193>

What I'm trying to do here is to get a pattern of what might be going
on.  I'm assuming that your filesystem is too big (and probably
contains private information) for you to send it to me.  (Although if
you're willing to send me a compressed raw e2image --- see the "RAW
IMAGE FILES" section of the e2image man page ---- and the portions of
the buffer information dummped in /var/log/messages, I can try to do
some of the analysis for you.)

						- Ted
