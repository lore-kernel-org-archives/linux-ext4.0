From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 0/4] ext4: DAX fixes
Date: Fri, 13 May 2016 01:24:19 -0400
Message-ID: <20160513052419.GD5862@thunk.org>
References: <1462959551-28622-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-nvdimm@ml01.01.org,
	Vishal Verma <vishal.l.verma@intel.com>,
	Ross Zwisler <ross.zwisler@linux.intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	linux-fsdevel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1462959551-28622-1-git-send-email-jack@suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, May 11, 2016 at 11:39:07AM +0200, Jan Kara wrote:
> Hi!
> 
> These are ext4 patches that were originally part of my DAX locking patch
> series. They stand on their own so I'm submitting them independently and since
> they are non-trivial, I'd like them to be merged through ext4 tree.  The rest
> of the DAX locking series depends on these patches so whichever tree is going
> to merge them will have to pull the ext4 tree to get these patches.  They
> didn't change since the last posting of the DAX locking series (except for
> minor fixup due to patch reordering).
> 
> Ted, can you please queue these patches for the coming merge window? Thanks!

Queued and I'm running tests before I push them out.  The patches
passed the smoke tests[1], and the full tests should be running for the
next seven hours or so at:   http://104.197.222.91

I'm also doing a DAX run which should done in a half an hour or so.

    	       	     	       	      	      - Ted

[1] CMDLINE: smoke
FSTESTVER: e2fsprogs	v1.43-WIP-2015-05-18-64-g2334bd3 (Sat, 5 Sep 2015 22:21:35 -0400)
FSTESTVER: fio		fio-2.6-8-ge6989e1 (Thu, 4 Feb 2016 12:09:48 -0700)
FSTESTVER: quota		67fd9cc (Mon, 4 Apr 2016 00:32:39 -0400)
FSTESTVER: xfsprogs	v4.3.0 (Mon, 23 Nov 2015 15:24:24 +1100)
FSTESTVER: xfstests-bld	ccae8d1 (Tue, 26 Apr 2016 00:42:18 -0400)
FSTESTVER: xfstests	linux-v3.8-1010-g97dd2d8 (Wed, 27 Apr 2016 00:04:44 -0400)
FSTESTVER: kernel	4.6.0-rc4-ext4-00022-gaacd0c8 #282 SMP Fri May 13 00:52:07 EDT 2016 x86_64
FSTESTCFG: "4k"
FSTESTSET: "-g quick"
FSTESTEXC: ""
FSTESTOPT: "aex"
MNTOPTS: ""
CPUS: "2"
MEM: "7497.07"
MEM: 7680 MB (Max capacity)
BEGIN TEST 4k: Ext4 4k block Fri May 13 01:05:52 EDT 2016
Passed all 158 tests


