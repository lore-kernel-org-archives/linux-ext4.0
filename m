From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 0/6] introduce DAX tracepoint support
Date: Wed, 23 Nov 2016 11:44:16 -0700
Message-ID: <1479926662-21718-1-git-send-email-ross.zwisler@linux.intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Chinner <david@fromorbit.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Matthew Wilcox <mawilcox@microsoft.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-nvdimm@lists.01.org
To: linux-kernel@vger.kernel.org
Return-path: <owner-linux-mm@kvack.org>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

Tracepoints are the standard way to capture debugging and tracing
information in many parts of the kernel, including the XFS and ext4
filesystems.  This series creates a tracepoint header for FS DAX and add
the first few DAX tracepoints to the PMD fault handler.  This allows the
tracing for DAX to be done in the same way as the filesystem tracing so
that developers can look at them together and get a coherent idea of what
the system is doing.                                                            
                                                                                
I do intend to add tracepoints to the normal 4k DAX fault path and to the       
DAX I/O path, but I wanted to get feedback on the PMD tracepoints before I      
went any further.                                                               
                                                                                
This series is based on Jan Kara's "dax: Clear dirty bits after flushing        
caches" series:                                                                 
                                                                                
https://lists.01.org/pipermail/linux-nvdimm/2016-November/007864.html           
                                                                                
I've pushed a git tree with this work here:                                     
                                                                                
https://git.kernel.org/cgit/linux/kernel/git/zwisler/linux.git/log/?h=dax_tracepoints

Ross Zwisler (6):
  dax: fix build breakage with ext4, dax and !iomap
  dax: remove leading space from labels
  dax: add tracepoint infrastructure, PMD tracing
  dax: update MAINTAINERS entries for FS DAX
  dax: add tracepoints to dax_pmd_load_hole()
  dax: add tracepoints to dax_pmd_insert_mapping()

 MAINTAINERS                   |   4 +-
 fs/Kconfig                    |   1 +
 fs/dax.c                      |  78 ++++++++++++++----------
 fs/ext2/Kconfig               |   1 -
 include/linux/mm.h            |  14 +++++
 include/linux/pfn_t.h         |   6 ++
 include/trace/events/fs_dax.h | 135 ++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 206 insertions(+), 33 deletions(-)
 create mode 100644 include/trace/events/fs_dax.h

-- 
2.7.4

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
