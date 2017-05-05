From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/4 v2] mm,dax: Fix data corruption due to mmap inconsistency
Date: Fri,  5 May 2017 09:24:56 +0200
Message-ID: <20170505072500.25692-1-jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dan Williams <dan.j.williams@intel.com>,
        <linux-fsdevel@vger.kernel.org>, <linux-ext4@vger.kernel.org>,
        linux-nvdimm@lists.01.org, Jan Kara <jack@suse.cz>
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello,

this series fixes data corruption that can happen for DAX mounts when
page faults race with write(2) and as a result page tables get out of sync
with block mappings in the filesystem and thus data seen through mmap is
different from data seen through read(2).

The series passes testing with t_mmap_stale test program from Ross and also
other mmap related tests on DAX filesystem. Ross, what you think?

								Honza
