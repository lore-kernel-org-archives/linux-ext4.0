From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: RE: generic/064 test failures on ext4 (4.2-rc*)
Date: Mon, 03 Aug 2015 11:01:46 +0900
Message-ID: <04d101d0cd90$5ac2b980$10482c80$@samsung.com>
References: <20150727190957.GA1606@localhost.localdomain>
 <20150727215129.GH3902@dastard> <20150728030913.GC2851@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: 'Eric Whitney' <enwlinux@gmail.com>, a.sangwan@samsung.com,
	linux-ext4@vger.kernel.org, fstests@vger.kernel.org
To: 'Theodore Ts'o' <tytso@mit.edu>,
	'Dave Chinner' <david@fromorbit.com>
Return-path: <fstests-owner@vger.kernel.org>
In-reply-to: <20150728030913.GC2851@thunk.org>
Content-language: ko
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

Sorry for late response.
I am on vacation. I will check this issue as soon as getting back.

Thanks!

> Yes, that's what is going on.  If delayed allocation is disabled (as
> it is in some configuration scenarios), ext4's block allocator doesn't
> do as well, and in some cases it will pick a starting block number for
> the file that ends up splitting the initial file across block groups'
> meta data blocks.
> 
> > Really, the number of extents or holes at the intermediate stage
> > doesn't matter. What matters is that after collapsing the holes back
> > out of the file, then number of extents is identical to the original
> > file (i.e. that fcollapse() undoes finsert() exactly).
> 
> Yup.
> 
> > So changing this code to use _within_tolerance to say that 100 >=
> > num_extents >= 105 is ok would probably be better:
> >
> > 	_within_tolerance "Extent count" $nextents 100 0 5%
> >
> > This will output a standard pass/fail message rather than an exact
> > count.  This allows some wiggle room for filesystem configurations
> > that have unexpected non-contiguous baseline allocation behaviour to
> > pass the test.
> 
> Works for me.
> 
> Thanks,
> 
> 					- Ted
