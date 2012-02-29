From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: getdents - ext4 vs btrfs performance
Date: Wed, 29 Feb 2012 15:00:12 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1202291453450.23368@dhcp-27-109.brq.redhat.com>
References: <CADDYkjRnRKPMW53F=oELhwkSt5EQB9v0JkC=inNvZQPKu94Xtw@mail.gmail.com> <20120229135158.GA5054@shiny>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jacek Luczak <difrost.kernel@gmail.com>,
	linux-ext4@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, linux-btrfs@vger.kernel.org,
	Al Viro <viro@zeniv.linux.org.uk>, "Ted Ts'o" <tytso@mit.edu>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120229135158.GA5054@shiny>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 29 Feb 2012, Chris Mason wrote:

> On Wed, Feb 29, 2012 at 02:31:03PM +0100, Jacek Luczak wrote:
> > Hi All,
> > 
> > Long story short: We've found that operations on a directory structure
> > holding many dirs takes ages on ext4.
> > 
> > The Question: Why there's that huge difference in ext4 and btrfs? See
> > below test results for real values.
> > 
> > Background: I had to backup a Jenkins directory holding workspace for
> > few projects which were co from svn (implies lot of extra .svn dirs).
> > The copy takes lot of time (at least more than I've expected) and
> > process was mostly in D (disk sleep). I've dig more and done some
> > extra test to see if this is not a regression on block/fs site. To
> > isolate the issue I've also performed same tests on btrfs.
> > 
> > Test environment configuration:
> > 1) HW: HP ProLiant BL460 G6, 48 GB of memory, 2x 6 core Intel X5670 HT
> > enabled, Smart Array P410i, RAID 1 on top of 2x 10K RPM SAS HDDs.
> > 2) Kernels: All tests were done on following kernels:
> >  - 2.6.39.4-3 -- the build ID (3) is used here for internal tacking of
> > config changes mostly. In -3 we've introduced ,,fix readahead pipeline
> > break caused by block plug'' patch. Otherwise it's pure 2.6.39.4.
> >  - 3.2.7 -- latest kernel at the time of testing (3.2.8 has been
> > release recently).
> > 3) A subject of tests, directory holding:
> >  - 54GB of data (measured on ext4)
> >  - 1978149 files
> >  - 844008 directories
> > 4) Mount options:
> >  - ext4 -- errors=remount-ro,noatime,data=writeback
> >  - btrfs -- noatime,nodatacow and for later investigation on
> > copression effect: noatime,nodatacow,compress=lzo
> 
> For btrfs, nodatacow and compression don't really mix.  The compression
> will just override it. (Just FYI, not really related to these results).
> 
> > 
> > In all tests I've been measuring time of execution. Following tests
> > were performed:
> > - find . -type d
> > - find . -type f
> > - cp -a
> > - rm -rf
> > 
> > Ext4 results:
> > | Type     | 2.6.39.4-3   | 3.2.7
> > | Dir cnt  | 17m 40sec  | 11m 20sec
> > | File cnt |  17m 36sec | 11m 22sec
> > | Copy    | 1h 28m        | 1h 27m
> > | Remove| 3m 43sec
> 
> Are the btrfs numbers missing? ;)
> 
> In order for btrfs to be faster for cp -a, the files probably didn't
> change much since creation.  Btrfs maintains extra directory indexes
> that help in sequential backup scans, but this usually means slower
> delete performance.

Exactly and IIRC ext4 have directory entries stored in hash order which
does not really help the sequential access.

> 
> But, how exactly did you benchmark it?  If you compare a fresh
> mkfs.btrfs where you just copied all the data over with an ext4 FS that
> has been on the disk for a long time, it isn't quite fair to ext4.

I have the same question, note that if the files on ext4 has been worked
with it may very well be that directory hash trees are not in very good
shape. You can attempt to optimize that by e2fsck (just run fsck.ext4 -f
<device>) but that may take quite some time and memory, but it is worth
trying.

Thanks!
-Lukas

> 
> -chris
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
