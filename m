From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/4] ext4: DAX fixes
Date: Wed, 11 May 2016 11:39:07 +0200
Message-ID: <1462959551-28622-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, linux-nvdimm@lists.01.org,
	Vishal Verma <vishal.l.verma@intel.com>,
	Ross Zwisler <ross.zwisler@linux.intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi!

These are ext4 patches that were originally part of my DAX locking patch
series. They stand on their own so I'm submitting them independently and since
they are non-trivial, I'd like them to be merged through ext4 tree.  The rest
of the DAX locking series depends on these patches so whichever tree is going
to merge them will have to pull the ext4 tree to get these patches.  They
didn't change since the last posting of the DAX locking series (except for
minor fixup due to patch reordering).

Ted, can you please queue these patches for the coming merge window? Thanks!

								Honza
