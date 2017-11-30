From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4 fix for interaction between i_size, fallocate, and delalloc
 after a crash
Date: Wed, 29 Nov 2017 19:48:16 -0500
Message-ID: <20171130004816.pdzfqjluchtvfq6u@thunk.org>
References: <CAFk8rvZYEN4kGP9dF_FQxhP+UGfAY55uKrdsGr4-6ztWSoUp6w@mail.gmail.com>
 <20171122180317.nvymp7eedhswga7l@thunk.org>
 <CAFk8rvZ=EAUcAzxgi4bk+Qh2Y3ACZEv8unaowi0jvPNRB97XMA@mail.gmail.com>
 <20171127161137.4ghjcxfklpurk2eo@thunk.org>
 <CAFk8rvbxaQ72rvOg6NXDQYG1rXtuZsdzJ5SrbR=C6ftAU0YyPA@mail.gmail.com>
 <20171128204525.ijpis74t75f4bbsc@thunk.org>
 <CAFk8rvZQopSupfc3nakAR+1ORbHSZF+ypzhZA12w=g=MNstHrA@mail.gmail.com>
 <20171129061307.f6hekryi3bppo26y@thunk.org>
 <CAOQ4uxiU3gu5+CRTSKig8r-Bpk=W0-J5N+MBL7s6XSrNUMrAKA@mail.gmail.com>
 <CAFk8rvY9_-GxghCA43G9JoVqw-8NTG7-oRxEcV_cudcgDcy=rQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Amir Goldstein <amir73il@gmail.com>,
        Vijay Chidambaram <vvijay03@gmail.com>,
        Ext4 <linux-ext4@vger.kernel.org>
To: Ashlie Martinez <ashmrtn@utexas.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:44894 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753686AbdK3AsS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 29 Nov 2017 19:48:18 -0500
Content-Disposition: inline
In-Reply-To: <CAFk8rvY9_-GxghCA43G9JoVqw-8NTG7-oRxEcV_cudcgDcy=rQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 29, 2017 at 01:58:53PM -0600, Ashlie Martinez wrote:
> Ted,
> 
> 1.      write 0x137dd 0xdc69 0x0
> 2.      fallocate 0xb531 0xb5ad 0x21446
> 3.      collapse_range 0x1c000 0x4000 0x21446
> 4.      write 0x3e5ec 0x1a14 0x21446
> 5.      zero_range 0x20fac 0x6d9c 0x40000 keep_size
> 
> I have made a CrashMonkey test that runs the same operations run by
> xfstests generic/456 as I wanted a bit more control over the test. My
> test runs operations 1-3 from the list above, and then runs sleep(30).
> After that, it runs operations 4 and 5 (I skipped operation 6 as it
> doesn't seem to be related to the underlying cause of the bug).
> CrashMonkey then waits a further 120 seconds for IO to trickle down to
> the block device.

So I'm not sure exactly what Crashmonkey is doing here.  Are you
forcing a crash, or not?

So here's my test which I think should replicate what you are doing.

1.  Start "kvm-xfstests shell"
2.  Create the fsxops file:

	cat > /tmp/fsxops
	write 0x137dd 0xdc69 0x0
	fallocate 0xb531 0xb5ad 0x21446
	collapse_range 0x1c000 0x4000 0x21446
	write 0x3e5ec 0x1a14 0x21446
	zero_range 0x20fac 0x6d9c 0x40000 keep_size
	<type control-d>

3.  Create a scratch file system and mount it:

	mke2fs -Fq -t ext4 /dev/vdc
	mount /vdc

4.  Run fsx:

	./xfstests/ltp/fsx -d --replay-ops /tmp/fsxops /vdc/testfile

5.  Since I'm too lazy to wait 120 seconds, just force everything to disk:

	sync

6a.  Unmount the file system and check it:

	umount /vdc
	e2fsck -fy /dev/vdc

6b.   Force a crash, and then restart kvm-xfstests shell, and then check the file system:

	<type control-A followed by 'x'>
	kvm-xfstests shell
	e2fsck -fy /dev/vdc

In both cases, e2fsck does not complain.  In the 6b variant, e2fsck
will replay the journal first, but other than that, no real differences.

So, tell me --- how is what I am doing any different from your Crashmonkey test?

    	    	       	      - Ted
