From: Jeff Moyer <jmoyer@redhat.com>
Subject: dax pmd fault handler never returns to userspace
Date: Wed, 18 Nov 2015 10:53:06 -0500
Message-ID: <x49wptfnw2l.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: ross.zwisler@intel.com, "Matthew R. Wilcox" <willy@linux.intel.com>
To: linux-ext4@vger.kernel.org, linux-nvdimm@ml01.01.org,
	linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

When running the nvml library's test suite against an ext4 file system
mounted with -o dax, I ran into an issue where many of the tests would
simply timeout.  The problem appears to be that the pmd fault handler
never returns to userspace (the application is doing a memcpy of 512
bytes into pmem).  Here's the 'perf report -g' output:

-   88.30%     0.01%  blk_non_zero.st  libc-2.17.so                  [.] __memmove_ssse3_back
   - 88.30% __memmove_ssse3_back
      - 66.63% page_fault
         - 66.47% do_page_fault
            - 66.16% __do_page_fault
               - 63.38% handle_mm_fault
                  - 61.15% ext4_dax_pmd_fault
                     - 45.04% __dax_pmd_fault
                        - 37.05% vmf_insert_pfn_pmd
                           - track_pfn_insert
                              - 35.58% lookup_memtype
                                 - 33.80% pat_pagerange_is_ram
                                    - 33.40% walk_system_ram_range
                                       - 31.63% find_next_iomem_res
                                            21.78% strcmp

And here's 'perf top':

Samples: 2M of event 'cycles:pp', Event count (approx.): 56080150519
Overhead  Shared Object            Symbol
  22.55%  [kernel]                 [k] strcmp
  20.33%  [unknown]                [k] 0x00007f9f549ef3f3
  10.01%  [kernel]                 [k] native_irq_return_iret
   9.54%  [kernel]                 [k] find_next_iomem_res
   3.00%  [jbd2]                   [k] start_this_handle

This is easily reproduced by doing the following:

git clone https://github.com/pmem/nvml.git
cd nvml
make
make test
cd src/test/blk_non_zero
./blk_non_zero.static-nondebug 512 /path/to/ext4/dax/fs/testfile1 c 1073741824 w:0

I also ran the test suite against xfs, and the problem is not present
there.  However, I did not verify that the xfs tests were getting pmd
faults.

I'm happy to help diagnose the problem further, if necessary.

Cheers,
Jeff
