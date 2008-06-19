From: Holger Kiehl <Holger.Kiehl@dwd.de>
Subject: Re: Performance of ext4
Date: Thu, 19 Jun 2008 15:04:39 +0000 (GMT)
Message-ID: <Pine.LNX.4.64.0806191440450.24740@diagnostix.dwd.de>
References: <Pine.LNX.4.64.0806121154090.27806@diagnostix.dwd.de>
 <20080612131928.GB18229@mit.edu> <Pine.LNX.4.64.0806121333480.27806@diagnostix.dwd.de>
 <20080612180605.GD22481@skywalker> <Pine.LNX.4.64.0806121940020.2974@diagnostix.dwd.de>
 <Pine.LNX.4.64.0806130753100.7097@diagnostix.dwd.de>
 <20080616175408.GF3279@atrey.karlin.mff.cuni.cz> <20080616181353.GA20686@skywalker>
 <Pine.LNX.4.64.0806171001200.6307@diagnostix.dwd.de>
 <Pine.LNX.4.64.0806180546370.20901@diagnostix.dwd.de> <20080619110947.GB11516@mit.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Jan Kara <jack@suse.cz>, Solofo.Ramangalahy@bull.net,
	Nick Dokos <nicholas.dokos@hp.com>, linux-ext4@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758723AbYFSPFI@vger.kernel.org>
In-Reply-To: <20080619110947.GB11516@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 19 Jun 2008, Theodore Tso wrote:

> On Wed, Jun 18, 2008 at 05:58:00AM +0000, Holger Kiehl wrote:
>> For afdbench: 5336.41 files per second 15.63 MiB/s
>>
>> So it seems that for afdbench the ext4-patch-queue is a slowdown.
>
> Can you remind me where afdbench can be downloaded?  And if I remember
> correctly, it creates and deletes large numbers of small files,
> correct?
>
Yes and yes.

You can download the benchmark but it is complicated to setup. You can
download it from ftp://ftp.dwd.de/pub/afd/afdbench-2.0.0.tar.bz2 and
you will also need ftp://ftp.dwd.de/pub/afd/development/afd-1.4.0pre1.tar.bz2

Here a short guide how you need to set this up (there is also a SETUP
file in afdbench-2.0.0.tar.bz2):

    - create a new user for example afdbench
    - untar afdbench-2.0.0.tar.bz2 where ever your test filesystem is mounted
      eg /home
    - ln -s /home/afdbench-2.0.0 /home/afdbench
    - ensure that in .bash_profile of user afdbench you have:
         PATH=$PATH:$HOME/bin
    - login as afdbench
    - Untar afd-1.4.0pre1.tar.bz2
    - cd afd-1.4.0pre1
    - ./configure --prefix=$HOME --enable-ftp_reuse_data_port --enable-passwd_in_msg --enable-expand_path_in_message --enable-compiler-optimizations --enable-with_afdbench_settings --enable-splice_support --enable-sendfile_support
    - make
    - make install-strip
    - In afdbench script change BENCH_PASSWD to whatever you have set the
      password of user afdbench.

If you have problems because you do not have openmotif or lesstif, just use
the configure switch --with-gui=none. Also make sure you have an FTP-server
running, I always used vsftpd. To run the test I just called tiny-bench,
in it you will find how you can start it. You can also run without FTP-server
but I do not know if the problems are reproduceable.

> It would be interesting to see which new feature introduced by the
> ext4 patch queue --- probably dellayed allocation or mballoc --- is
> responsible for the slowdown.  One or the other (or both) can be
> disabled by mounting the filesystem (using a kernel with the ext4
> patch queue) with the mount options -O nomballoc or -O nodelalloc.
>
> If it turns out that nomballoc restores the speed for afdbench, for
> example, then it will tell us where we need to look more closely.
> Ideally we would not want to have one mount option needed to optimize
> filesystem operations for large amoutns of modifications to small
> files, and another mode of operation when mostly writing to large
> files.  So if you could do a round of tests using the ext4 patch queue
> kernel, with -O nomballoc and -O nodelalloc (and if both seem to
> improve things, try "-O nomballoc,nodelalloc" and see if you get back
> to the pre-ext4 patch queue speed), it would be very much appreciated.
>
Yes, I will try and redo the test as suggested, it might just take a while
since I just made my testing system operational.

What worries me more is the truncation of files, it makes the filesystem
unusable since you loose data. I hope there will be a solution for this.

Holger
