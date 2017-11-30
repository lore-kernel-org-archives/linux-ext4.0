From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4 fix for interaction between i_size, fallocate, and delalloc
 after a crash
Date: Wed, 29 Nov 2017 19:24:08 -0500
Message-ID: <20171130002408.5w4axekvcdrbag53@thunk.org>
References: <CAFk8rvZYEN4kGP9dF_FQxhP+UGfAY55uKrdsGr4-6ztWSoUp6w@mail.gmail.com>
 <20171122180317.nvymp7eedhswga7l@thunk.org>
 <CAFk8rvZ=EAUcAzxgi4bk+Qh2Y3ACZEv8unaowi0jvPNRB97XMA@mail.gmail.com>
 <20171127161137.4ghjcxfklpurk2eo@thunk.org>
 <CAFk8rvbxaQ72rvOg6NXDQYG1rXtuZsdzJ5SrbR=C6ftAU0YyPA@mail.gmail.com>
 <20171128204525.ijpis74t75f4bbsc@thunk.org>
 <CAFk8rvZQopSupfc3nakAR+1ORbHSZF+ypzhZA12w=g=MNstHrA@mail.gmail.com>
 <20171129061307.f6hekryi3bppo26y@thunk.org>
 <CAOQ4uxiU3gu5+CRTSKig8r-Bpk=W0-J5N+MBL7s6XSrNUMrAKA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ashlie Martinez <ashmrtn@utexas.edu>,
        Vijay Chidambaram <vvijay03@gmail.com>,
        Ext4 <linux-ext4@vger.kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:44778 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753002AbdK3AYL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 29 Nov 2017 19:24:11 -0500
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiU3gu5+CRTSKig8r-Bpk=W0-J5N+MBL7s6XSrNUMrAKA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 29, 2017 at 10:07:39AM +0200, Amir Goldstein wrote:
> If you could work out how to fix the test to catch the bug in kvm-xfstests
> that would be nice.

One question, how did you actually test it using kvm-xfstests?  The
kvm-xfstests image that I had up on www.kernel.org did not have
generic/456.  It was dated from September 2017, so it didn't have that
test.  Since the publically available image didn't have generic/456,
did you create your own image some how?

I just updated the test appliance yesterday, so it does now.  The
version stamp on it is:

e2fsprogs	v1.43.6-85-g7595699d0 (Wed, 6 Sep 2017 22:04:14 -0400)
fio		fio-3.2 (Fri, 3 Nov 2017 15:23:49 -0600)
quota		4d81e8b (Mon, 16 Oct 2017 09:42:44 +0200)
stress-ng	977ae35 (Wed, 6 Sep 2017 23:45:03 -0400)
xfsprogs	v4.14.0-rc2-1-g19ca9b0b (Mon, 27 Nov 2017 10:56:21 -0600)
xfstests-bld	0b27af9 (Tue, 28 Nov 2017 16:28:51 -0500)
xfstests	linux-v3.8-1797-g4f1eaa02 (Tue, 28 Nov 2017 15:49:06 -0500)

Can you try the latest version of the kvm-xfststs test appliance image
that is on www.kernel.org, with the latest xfstests-bld git repo to
drive it?

I use the default configuration (so 2 cpu's, 2 gigs of memory).  The
only difference I have from the default config is that I have the
following in my ~/.config/kvm-xfstests:

VG=callcc

VDB=/dev/$VG/test-4k
VDC=/dev/$VG/scratch
VDD=/dev/$VG/test-1k
VDE=/dev/$VG/scratch2
VDF=/dev/$VG/scratch3
VDG=/dev/$VG/results

Where callcc is an LVM setup using an SSD.  (A Samsung 850 PRO, to be
precise).  VDB, VDC, VDD, and VDG are 5 gig logical volumes, VDE and
VDF are 20 gig logical volumes (although you won't need those for this
repro.)

With this setup, generic/456 reproduces *reliably* for me.  I tested
using a v4.15-rc1 kernel with commit 51e3ae81ec58e95 reverted. and the
command: "kvm-xfstests -c 4k generic/456"

      		  	      	     		     - Ted
