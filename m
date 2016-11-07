From: kernel test robot <xiaolong.ye@intel.com>
Subject: [lkp] [ext4] adad5aa544: fio.write_bw_MBps
	+4074.4% improvement
Date: Mon, 7 Nov 2016 10:40:11 +0800
Message-ID: <20161107024011.GB21529@yexl-desktop>
References: <1478279296-6575-4-git-send-email-jack@suse.cz>
Reply-To: kernel test robot <xiaolong.ye@intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="3uo+9/B/ebqu+fSQ"
Content-Transfer-Encoding: 8bit
Cc: Jens Axboe <axboe@kernel.dk>, Evgeniy Dushistov <dushistov@mail.ru>,
	linux-ntfs-dev@lists.sourceforge.net,
	Christoph Hellwig <hch@infradead.org>,
	linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org, lkp@01.org, ocfs2-devel@oss.oracle.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ntfs-dev-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <1478279296-6575-4-git-send-email-jack@suse.cz>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-ntfs-dev>,
	<mailto:linux-ntfs-dev-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-ntfs-dev>
List-Post: <mailto:linux-ntfs-dev@lists.sourceforge.net>
List-Help: <mailto:linux-ntfs-dev-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-ntfs-dev>,
	<mailto:linux-ntfs-dev-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-ntfs-dev-bounces@lists.sourceforge.net
List-Id: linux-ext4.vger.kernel.org


--3uo+9/B/ebqu+fSQ
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit


Greeting,

FYI, we noticed a +4074.4% improvement of fio.write_bw_MBps due to commit:


commit adad5aa544e281d84f837b2786809611cb35a999 ("ext4: Use clean_bdev_aliases() instead of iteration")
https://github.com/0day-ci/linux Jan-Kara/fs-Provide-function-to-unmap-metadata-for-a-range-of-blocks/20161105-030924

in testcase: fio-basic
on test machine: 56 threads Intel(R) Xeon(R) CPU E5-2695 v3 @ 2.30GHz with 256G memory
with following parameters:

	disk: 2pmem
	fs: ext4
	runtime: 200s
	nr_task: 50%
	time_based: tb
	rw: randwrite
	bs: 4k
	ioengine: libaio
	test_size: 200G
	cpufreq_governor: performance

Fio is a tool that will spawn a number of threads or processes doing a particular type of I/O action as specified by the user.

In addition to that, the commit also has significant impact on the following tests:

+------------------+-----------------------------------------------------------------------+
| testcase: change | fio-basic:  fio.write_bw_MBps +3928.3% improvement			   |
| test machine     | 56 threads Intel(R) Xeon(R) CPU E5-2695 v3 @ 2.30GHz with 256G memory |
| test parameters  | bs=4k                                                                 |
|                  | cpufreq_governor=performance                                          |
|                  | disk=2pmem                                                            |
|                  | fs=ext4                                                               |
|                  | ioengine=sync                                                         |
|                  | nr_task=50%                                                           |
|                  | runtime=200s                                                          |
|                  | rw=randwrite                                                          |
|                  | test_size=200G                                                        |
|                  | time_based=tb                                                         |
+------------------+-----------------------------------------------------------------------+
| testcase: change | fio-basic: fio.write_bw_MBps +88.0% improvement	                   |
| test machine     | 16 threads Intel(R) Xeon(R) CPU D-1541 @ 2.10GHz with 8G memory       |
| test parameters  | bs=4k                                                                 |
|                  | cpufreq_governor=performance                                          |
|                  | disk=1SSD                                                             |
|                  | fs=ext4                                                               |
|                  | ioengine=sync                                                         |
|                  | nr_task=64                                                            |
|                  | runtime=300s                                                          |
|                  | rw=randwrite                                                          |
|                  | test_size=400g                                                        |
+------------------+-----------------------------------------------------------------------+
| testcase: change | trinity:                                                              |
| test machine     | qemu-system-x86_64 -enable-kvm -cpu IvyBridge -m 360M                 |
| test parameters  | runtime=300s                                                          |
+------------------+-----------------------------------------------------------------------+


Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.

Details are as below:
-------------------------------------------------------------------------------------------------->


To reproduce:

        git clone git://git.kernel.org/pub/scm/linux/kernel/git/wfg/lkp-tests.git
        cd lkp-tests
        bin/lkp install job.yaml  # job file is attached in this email
        bin/lkp run     job.yaml

=========================================================================================
bs/compiler/cpufreq_governor/disk/fs/ioengine/kconfig/nr_task/rootfs/runtime/rw/tbox_group/test_size/testcase/time_based:
  4k/gcc-6/performance/2pmem/ext4/libaio/x86_64-rhel-7.2/50%/debian-x86_64-2016-08-31.cgz/200s/randwrite/lkp-hsw-ep6/200G/fio-basic/tb

commit: 
  6f2b562c3a ("direct-io: Use clean_bdev_aliases() instead of handmade iteration")
  adad5aa544 ("ext4: Use clean_bdev_aliases() instead of iteration")

6f2b562c3a89f4a6 adad5aa544e281d84f837b2786 
---------------- -------------------------- 
       fail:runs  %reproduction    fail:runs
           |             |             |    
         %stddev     %change         %stddev
             \          |                \  
     64.45 ±  0%   +4074.4%       2690 ±  2%  fio.write_bw_MBps
      0.05 ± 52%    -100.0%       0.00 ± -1%  fio.latency_1000ms%
      0.01 ±  0%   +1075.0%       0.12 ± 58%  fio.latency_1000us%
      3.41 ±  0%     -97.3%       0.09 ±  8%  fio.latency_10ms%
      0.42 ±  4%     -70.1%       0.12 ±  6%  fio.latency_20ms%
     23.23 ±  1%    -100.0%       0.01 ±  0%  fio.latency_250ms%
     14.50 ±  3%     -82.6%       2.52 ± 24%  fio.latency_250us%
      0.06 ± 20%     +86.4%       0.10 ±  4%  fio.latency_2ms%
      0.01 ±  0%    +100.0%       0.02 ±  0%  fio.latency_4ms%
      1.95 ±  6%     -99.6%       0.01 ± 57%  fio.latency_500ms%
     53.08 ±  2%     +52.0%      80.68 ±  3%  fio.latency_500us%
      0.14 ± 13%   +1492.9%       2.23 ±  3%  fio.latency_50ms%
      1.05 ± 13%    -100.0%       0.00 ± -1%  fio.latency_750ms%
      2.12 ± 52%    +560.9%      14.03 ± 16%  fio.latency_750us%
  26414526 ±  0%   +4069.9%  1.101e+09 ±  2%  fio.time.file_system_outputs
    673.00 ±  3%    +915.8%       6836 ± 12%  fio.time.involuntary_context_switches
     35917 ±  2%    +103.7%      73176 ± 11%  fio.time.minor_page_faults
     21.25 ±  3%   +4110.6%     894.75 ±  1%  fio.time.percent_of_cpu_this_job_got
     29.64 ±  3%   +5107.6%       1543 ±  1%  fio.time.system_time
     13.86 ±  2%   +1755.6%     257.23 ±  1%  fio.time.user_time
     58627 ±  0%    +808.6%     532701 ±  0%  fio.time.voluntary_context_switches
    166912 ±  2%     -99.6%     586.00 ±  2%  fio.write_clat_90%_us
    207872 ±  0%     -99.7%     638.00 ±  2%  fio.write_clat_95%_us
    521216 ± 20%     -92.8%      37632 ±  1%  fio.write_clat_99%_us
     52577 ±  0%     -97.6%       1261 ±  2%  fio.write_clat_mean_us
    105001 ±  2%     -94.6%       5676 ±  1%  fio.write_clat_stddev
     16498 ±  0%   +4074.4%     688706 ±  2%  fio.write_iops
      1693 ±  0%     -97.7%      38.82 ±  2%  fio.write_slat_mean_us
     17054 ±  0%     -94.0%       1021 ±  1%  fio.write_slat_stddev
     53581 ±  7%    +272.4%     199560 ±  3%  softirqs.RCU
    158867 ±  1%     +69.5%     269287 ±  0%  softirqs.SCHED
    565968 ±  0%    +175.8%    1560998 ±  1%  softirqs.TIMER
   3629667 ±  9%    +237.9%   12265065 ±  6%  cpuidle.C1-HSW.time
     66590 ± 12%    +689.8%     525953 ±  2%  cpuidle.C1-HSW.usage
 4.193e+09 ± 11%     -29.6%  2.952e+09 ±  3%  cpuidle.C3-HSW.time
   4346531 ± 11%     -28.6%    3101279 ±  3%  cpuidle.C3-HSW.usage
      2467 ± 22%    +434.5%      13186 ±  2%  cpuidle.POLL.usage
   1321503 ± 47%   +4167.7%   56398032 ± 19%  numa-numastat.node0.local_node
    542888 ± 99%   +2637.3%   14860275 ± 50%  numa-numastat.node0.numa_foreign
   1321513 ± 47%   +4167.7%   56398044 ± 19%  numa-numastat.node0.numa_hit
    592541 ± 99%   +1833.8%   11458393 ± 54%  numa-numastat.node0.numa_miss
   1425379 ± 39%   +3705.7%   54245725 ± 29%  numa-numastat.node1.local_node
    590754 ± 99%   +1840.5%   11463742 ± 55%  numa-numastat.node1.numa_foreign
   1425389 ± 39%   +3705.7%   54245733 ± 29%  numa-numastat.node1.numa_hit
    541101 ± 99%   +2647.3%   14865705 ± 50%  numa-numastat.node1.numa_miss
     66807 ±  0%   +5149.0%    3506733 ±  1%  vmstat.io.bo
     19111 ±  1%    +906.8%     192416 ±  0%  vmstat.memory.buff
  12571099 ±  0%    +231.6%   41679612 ±  0%  vmstat.memory.cache
  32807369 ±  0%     -89.3%    3505038 ±  0%  vmstat.memory.free
     27.00 ±  0%     -33.3%      18.00 ±  0%  vmstat.procs.b
      2.00 ±  0%    +475.0%      11.50 ±  4%  vmstat.procs.r
      2235 ±  4%    +414.3%      11499 ±  3%  vmstat.system.cs
     57912 ±  0%      +1.1%      58522 ±  0%  vmstat.system.in
      7.67 ±  1%    +219.5%      24.51 ±  1%  turbostat.%Busy
    160.00 ±  1%    +132.2%     371.50 ±  1%  turbostat.Avg_MHz
      2084 ±  1%     -27.3%       1515 ±  0%  turbostat.Bzy_MHz
     30.71 ±  4%     +10.2%      33.84 ±  1%  turbostat.CPU%c1
     37.92 ± 15%     -32.6%      25.57 ±  9%  turbostat.CPU%c3
     68.50 ±  3%      -6.9%      63.75 ±  3%  turbostat.CoreTmp
      4.84 ± 11%     +69.0%       8.19 ± 21%  turbostat.PKG_%
     20.77 ± 19%     -90.5%       1.97 ± 47%  turbostat.Pkg%pc2
    103.88 ±  1%     +12.3%     116.62 ±  0%  turbostat.PkgWatt
     81.35 ±  0%     +45.5%     118.40 ±  0%  turbostat.RAMWatt
    162447 ±  0%    +131.8%     376599 ±  0%  meminfo.Active
     58081 ±  1%    +364.5%     269806 ±  1%  meminfo.Active(file)
     19012 ±  1%    +911.6%     192331 ±  0%  meminfo.Buffers
  11732139 ±  0%    +240.7%   39971418 ±  0%  meminfo.Cached
    202839 ±  0%     -78.8%      43021 ±  3%  meminfo.CmaFree
   8269379 ±  0%     -14.8%    7041826 ±  0%  meminfo.Dirty
  11689070 ±  0%    +236.3%   39313737 ±  0%  meminfo.Inactive
  11567135 ±  0%    +238.8%   39191794 ±  0%  meminfo.Inactive(file)
  32825801 ±  0%     -89.3%    3516995 ±  0%  meminfo.MemFree
    820135 ±  0%    +106.8%    1695987 ±  0%  meminfo.SReclaimable
    920315 ±  0%     +95.2%    1796868 ±  0%  meminfo.Slab
    659.25 ±100%  +86807.4%     572937 ±  0%  meminfo.Unevictable
   4075428 ±  5%     -14.0%    3506877 ±  8%  numa-meminfo.node0.Dirty
   5833539 ±  6%    +245.8%   20174456 ±  0%  numa-meminfo.node0.FilePages
   5797730 ±  6%    +242.3%   19845628 ±  0%  numa-meminfo.node0.Inactive
   5708833 ±  5%    +245.6%   19726898 ±  0%  numa-meminfo.node0.Inactive(file)
  16344904 ±  4%     -88.7%    1841535 ±  1%  numa-meminfo.node0.MemFree
   8261907 ±  8%    +175.5%   22765276 ±  0%  numa-meminfo.node0.MemUsed
    381.50 ±100%  +75068.0%     286766 ±  0%  numa-meminfo.node0.Unevictable
     76111 ± 29%    +267.1%     279386 ± 12%  numa-meminfo.node1.Active
     24102 ± 30%    +862.9%     232089 ±  5%  numa-meminfo.node1.Active(file)
   4193777 ±  5%     -15.8%    3532488 ±  8%  numa-meminfo.node1.Dirty
   5920446 ±  5%    +237.7%   19992694 ±  0%  numa-meminfo.node1.FilePages
   5894203 ±  5%    +230.3%   19470961 ±  0%  numa-meminfo.node1.Inactive
   5861163 ±  4%    +232.1%   19467743 ±  0%  numa-meminfo.node1.Inactive(file)
  16477881 ±  4%     -89.9%    1671879 ±  2%  numa-meminfo.node1.MemFree
   8272729 ±  8%    +179.0%   23078732 ±  0%  numa-meminfo.node1.MemUsed
    412948 ± 82%    +176.4%    1141200 ±  6%  numa-meminfo.node1.SReclaimable
    457998 ± 73%    +159.9%    1190119 ±  6%  numa-meminfo.node1.Slab
    277.50 ±100%    +1e+05%     286552 ±  0%  numa-meminfo.node1.Unevictable
    946.00 ±  9%     +31.9%       1248 ±  5%  slabinfo.Acpi-ParseExt.active_objs
      1003 ±  7%     +28.7%       1291 ±  4%  slabinfo.Acpi-ParseExt.num_objs
   2728626 ±  0%    +260.1%    9826661 ±  0%  slabinfo.buffer_head.active_objs
     69964 ±  0%    +260.4%     252129 ±  0%  slabinfo.buffer_head.active_slabs
   2728626 ±  0%    +260.4%    9833052 ±  0%  slabinfo.buffer_head.num_objs
     69964 ±  0%    +260.4%     252129 ±  0%  slabinfo.buffer_head.num_slabs
    149.00 ± 37%    +642.8%       1106 ±  3%  slabinfo.dquot.active_objs
    149.00 ± 37%    +642.8%       1106 ±  3%  slabinfo.dquot.num_objs
    915961 ±  1%    +163.7%    2415651 ±  0%  slabinfo.ext4_extent_status.active_objs
      8979 ±  1%    +358.0%      41130 ±  1%  slabinfo.ext4_extent_status.active_slabs
    915961 ±  1%    +358.0%    4195339 ±  1%  slabinfo.ext4_extent_status.num_objs
      8979 ±  1%    +358.0%      41130 ±  1%  slabinfo.ext4_extent_status.num_slabs
    126.00 ±  0%    +237.9%     425.75 ± 15%  slabinfo.ext4_io_end.active_objs
    126.00 ±  0%    +237.9%     425.75 ± 15%  slabinfo.ext4_io_end.num_objs
      3350 ± 11%     +32.3%       4432 ±  2%  slabinfo.jbd2_journal_handle.active_objs
      3350 ± 11%     +32.3%       4432 ±  2%  slabinfo.jbd2_journal_handle.num_objs
      1818 ±  0%   +1433.8%      27884 ±  2%  slabinfo.jbd2_journal_head.active_objs
     67.50 ±  1%   +1210.4%     884.50 ±  3%  slabinfo.jbd2_journal_head.active_slabs
      2315 ±  1%   +1199.4%      30090 ±  3%  slabinfo.jbd2_journal_head.num_objs
     67.50 ±  1%   +1210.4%     884.50 ±  3%  slabinfo.jbd2_journal_head.num_slabs
      1722 ±  3%     +11.7%       1923 ±  4%  slabinfo.mnt_cache.active_objs
      1722 ±  3%     +11.7%       1923 ±  4%  slabinfo.mnt_cache.num_objs
 8.187e+11 ±  5%     -21.5%  6.428e+11 ±  2%  perf-stat.branch-instructions
      0.06 ± 13%   +2272.9%       1.46 ±  1%  perf-stat.branch-miss-rate%
 5.033e+08 ± 15%   +1758.8%  9.356e+09 ±  3%  perf-stat.branch-misses
      3.46 ±  2%    +746.3%      29.25 ±  1%  perf-stat.cache-miss-rate%
 1.366e+08 ±  8%   +7828.0%  1.083e+10 ±  3%  perf-stat.cache-misses
 3.951e+09 ±  7%    +837.4%  3.704e+10 ±  2%  perf-stat.cache-references
    447606 ±  4%    +420.9%    2331472 ±  3%  perf-stat.context-switches
  1.91e+12 ±  3%    +131.8%  4.427e+12 ±  2%  perf-stat.cpu-cycles
      7857 ±  6%    +196.2%      23270 ±  9%  perf-stat.cpu-migrations
      0.03 ±  7%   +3471.0%       1.23 ±  6%  perf-stat.dTLB-load-miss-rate%
 4.077e+08 ±  5%   +2913.0%  1.228e+10 ±  7%  perf-stat.dTLB-load-misses
 1.195e+12 ± 12%     -17.4%  9.878e+11 ±  4%  perf-stat.dTLB-loads
      0.01 ±  8%   +1635.3%       0.13 ± 21%  perf-stat.dTLB-store-miss-rate%
  76890357 ±  3%    +976.0%  8.273e+08 ± 23%  perf-stat.dTLB-store-misses
 1.067e+12 ± 11%     -38.9%  6.521e+11 ±  5%  perf-stat.dTLB-stores
     57.00 ±  1%     -38.6%      35.00 ±  2%  perf-stat.iTLB-load-miss-rate%
  80424911 ±  1%     -15.4%   68057203 ±  2%  perf-stat.iTLB-load-misses
  60673587 ±  2%    +108.3%  1.264e+08 ±  2%  perf-stat.iTLB-loads
 4.486e+12 ±  5%     -20.6%  3.563e+12 ±  2%  perf-stat.instructions
     55749 ±  3%      -6.1%      52369 ±  1%  perf-stat.instructions-per-iTLB-miss
      2.35 ±  2%     -65.7%       0.81 ±  1%  perf-stat.ipc
    420593 ±  0%      +9.3%     459778 ±  1%  perf-stat.minor-faults
  48205740 ±  7%   +9150.7%  4.459e+09 ± 11%  perf-stat.node-load-misses
  47211353 ±  3%   +9255.4%  4.417e+09 ± 17%  perf-stat.node-loads
  16243571 ±  8%   +2951.8%  4.957e+08 ± 10%  perf-stat.node-store-misses
  19185688 ±  4%   +2840.8%  5.642e+08 ±  4%  perf-stat.node-stores
    420632 ±  0%      +9.3%     459778 ±  1%  perf-stat.page-faults
     14521 ±  1%    +364.6%      67463 ±  1%  proc-vmstat.nr_active_file
   3310726 ±  0%   +4073.0%  1.382e+08 ±  2%  proc-vmstat.nr_dirtied
   2067310 ±  0%     -14.9%    1760148 ±  0%  proc-vmstat.nr_dirty
   2938080 ±  0%    +241.8%   10041069 ±  0%  proc-vmstat.nr_file_pages
     50709 ±  0%     -78.9%      10677 ±  4%  proc-vmstat.nr_free_cma
   8206148 ±  0%     -89.3%     879094 ±  0%  proc-vmstat.nr_free_pages
   2892082 ±  0%    +238.8%    9798085 ±  0%  proc-vmstat.nr_inactive_file
    205049 ±  0%    +106.8%     423996 ±  0%  proc-vmstat.nr_slab_reclaimable
    164.75 ±100%  +86842.0%     143237 ±  0%  proc-vmstat.nr_unevictable
   1377940 ±  1%   +9813.4%  1.366e+08 ±  2%  proc-vmstat.nr_written
     14521 ±  1%    +364.6%      67463 ±  1%  proc-vmstat.nr_zone_active_file
   2892082 ±  0%    +238.8%    9798122 ±  0%  proc-vmstat.nr_zone_inactive_file
    164.75 ±100%  +86842.0%     143237 ±  0%  proc-vmstat.nr_zone_unevictable
   2067310 ±  0%     -14.9%    1760151 ±  0%  proc-vmstat.nr_zone_write_pending
   1133626 ±  6%   +2222.1%   26324018 ± 13%  proc-vmstat.numa_foreign
    795.25 ± 82%   +4364.9%      35507 ± 25%  proc-vmstat.numa_hint_faults
    493.75 ± 76%   +5956.4%      29903 ± 29%  proc-vmstat.numa_hint_faults_local
   2748483 ±  3%   +3925.7%  1.106e+08 ±  5%  proc-vmstat.numa_hit
   2748463 ±  3%   +3925.8%  1.106e+08 ±  5%  proc-vmstat.numa_local
   1133626 ±  6%   +2222.1%   26324092 ± 13%  proc-vmstat.numa_miss
    295.00 ± 93%    +578.1%       2000 ± 21%  proc-vmstat.numa_pages_migrated
      2372 ± 77%   +1632.1%      41094 ± 20%  proc-vmstat.numa_pte_updates
      2891 ±  7%     +43.7%       4155 ± 11%  proc-vmstat.pgactivate
      0.00 ±  0%      +Inf%    5413142 ±  5%  proc-vmstat.pgalloc_dma32
   4013920 ±  0%   +3180.9%  1.317e+08 ±  3%  proc-vmstat.pgalloc_normal
    444351 ±  0%  +28262.2%   1.26e+08 ±  3%  proc-vmstat.pgfree
    295.00 ± 93%    +580.8%       2008 ± 21%  proc-vmstat.pgmigrate_success
  13537222 ±  0%   +5160.6%  7.121e+08 ±  2%  proc-vmstat.pgpgout
    242.50 ±100%  +70361.6%     170869 ±  0%  proc-vmstat.unevictable_pgs_culled
   1396319 ±  5%   +1827.5%   26914501 ±  6%  numa-vmstat.node0.nr_dirtied
   1018825 ±  5%     -14.0%     876621 ±  8%  numa-vmstat.node0.nr_dirty
   1458483 ±  6%    +245.8%    5043691 ±  0%  numa-vmstat.node0.nr_file_pages
   4086118 ±  4%     -88.7%     460244 ±  1%  numa-vmstat.node0.nr_free_pages
   1427304 ±  5%    +245.5%    4931802 ±  0%  numa-vmstat.node0.nr_inactive_file
     95.25 ±100%  +75177.2%      71701 ±  0%  numa-vmstat.node0.nr_unevictable
    377494 ±  7%   +6797.6%   26037879 ±  6%  numa-vmstat.node0.nr_written
   1427304 ±  5%    +245.5%    4931851 ±  0%  numa-vmstat.node0.nr_zone_inactive_file
     95.25 ±100%  +75177.2%      71701 ±  0%  numa-vmstat.node0.nr_zone_unevictable
   1018825 ±  5%     -14.0%     876636 ±  8%  numa-vmstat.node0.nr_zone_write_pending
    613506 ± 82%    +938.4%    6370772 ± 55%  numa-vmstat.node0.numa_foreign
   1209554 ± 44%   +1743.8%   22301956 ± 17%  numa-vmstat.node0.numa_hit
   1209543 ± 44%   +1743.8%   22301941 ± 17%  numa-vmstat.node0.numa_local
    622639 ± 83%    +717.3%    5088961 ± 41%  numa-vmstat.node0.numa_miss
      6025 ± 30%    +863.1%      58033 ±  5%  numa-vmstat.node1.nr_active_file
   1399379 ±  4%   +1908.6%   28107434 ± 12%  numa-vmstat.node1.nr_dirtied
   1048423 ±  5%     -15.8%     882992 ±  8%  numa-vmstat.node1.nr_dirty
   1480223 ±  5%    +237.7%    4998217 ±  0%  numa-vmstat.node1.nr_file_pages
     50710 ±  0%     -78.7%      10798 ±  4%  numa-vmstat.node1.nr_free_cma
   4119342 ±  4%     -89.9%     417911 ±  2%  numa-vmstat.node1.nr_free_pages
   1465406 ±  4%    +232.1%    4866978 ±  0%  numa-vmstat.node1.nr_inactive_file
    103241 ± 82%    +176.3%     285301 ±  6%  numa-vmstat.node1.nr_slab_reclaimable
     69.00 ±100%    +1e+05%      71643 ±  0%  numa-vmstat.node1.nr_unevictable
    350955 ±  7%   +7657.2%   27224439 ± 12%  numa-vmstat.node1.nr_written
      6025 ± 30%    +863.1%      58033 ±  5%  numa-vmstat.node1.nr_zone_active_file
   1465406 ±  4%    +232.1%    4866977 ±  0%  numa-vmstat.node1.nr_zone_inactive_file
     69.00 ±100%    +1e+05%      71643 ±  0%  numa-vmstat.node1.nr_zone_unevictable
   1048423 ±  5%     -15.8%     882992 ±  8%  numa-vmstat.node1.nr_zone_write_pending
    537217 ± 96%    +837.7%    5037423 ± 42%  numa-vmstat.node1.numa_foreign
   1283021 ± 41%   +1606.3%   21892238 ± 32%  numa-vmstat.node1.numa_hit
   1283007 ± 41%   +1606.3%   21892229 ± 32%  numa-vmstat.node1.numa_local
    528083 ± 96%   +1096.6%    6319275 ± 55%  numa-vmstat.node1.numa_miss
      3799 ±  0%    +311.7%      15643 ±  1%  sched_debug.cfs_rq:/.exec_clock.avg
     88813 ±  0%     -31.8%      60546 ± 15%  sched_debug.cfs_rq:/.exec_clock.max
    135.94 ± 11%   +1748.1%       2512 ± 42%  sched_debug.cfs_rq:/.exec_clock.min
     16353 ±  0%     -33.8%      10824 ± 12%  sched_debug.cfs_rq:/.exec_clock.stddev
     45073 ± 10%    +356.5%     205780 ± 13%  sched_debug.cfs_rq:/.load.avg
    173873 ± 11%     +91.4%     332795 ±  3%  sched_debug.cfs_rq:/.load.stddev
     31.39 ±  1%    +525.1%     196.23 ±  9%  sched_debug.cfs_rq:/.load_avg.avg
    144.71 ±  0%     +58.6%     229.45 ± 12%  sched_debug.cfs_rq:/.load_avg.stddev
     20203 ±  7%     +47.9%      29889 ±  9%  sched_debug.cfs_rq:/.min_vruntime.avg
    110963 ±  2%     -31.0%      76608 ± 13%  sched_debug.cfs_rq:/.min_vruntime.max
     17352 ±  2%     -35.4%      11201 ± 11%  sched_debug.cfs_rq:/.min_vruntime.stddev
      0.09 ±  8%    +181.7%       0.26 ±  7%  sched_debug.cfs_rq:/.nr_running.avg
      0.28 ±  2%     +50.6%       0.43 ±  2%  sched_debug.cfs_rq:/.nr_running.stddev
     29.50 ±  1%    +246.8%     102.30 ± 24%  sched_debug.cfs_rq:/.runnable_load_avg.avg
    141.43 ±  0%     +44.7%     204.62 ±  9%  sched_debug.cfs_rq:/.runnable_load_avg.stddev
     17352 ±  2%     -35.4%      11202 ± 11%  sched_debug.cfs_rq:/.spread0.stddev
    188.45 ±  3%     +92.8%     363.35 ±  4%  sched_debug.cfs_rq:/.util_avg.avg
    158.51 ±  1%     +45.3%     230.30 ±  7%  sched_debug.cfs_rq:/.util_avg.stddev
     99800 ±  0%     -27.8%      72076 ± 19%  sched_debug.cpu.avg_idle.min
    182448 ±  3%     +13.6%     207291 ±  7%  sched_debug.cpu.avg_idle.stddev
      6.26 ±  8%    +158.0%      16.16 ±  3%  sched_debug.cpu.clock.stddev
      6.26 ±  8%    +158.0%      16.16 ±  3%  sched_debug.cpu.clock_task.stddev
     29.01 ±  1%    +240.9%      98.90 ± 22%  sched_debug.cpu.cpu_load[0].avg
    141.19 ±  0%     +44.3%     203.80 ± 12%  sched_debug.cpu.cpu_load[0].stddev
     29.56 ±  1%    +350.4%     133.15 ± 19%  sched_debug.cpu.cpu_load[1].avg
    142.04 ±  0%     +49.6%     212.45 ±  9%  sched_debug.cpu.cpu_load[1].stddev
     29.26 ±  1%    +342.0%     129.30 ± 19%  sched_debug.cpu.cpu_load[2].avg
    141.48 ±  0%     +44.3%     204.21 ±  9%  sched_debug.cpu.cpu_load[2].stddev
     28.93 ±  1%    +327.8%     123.79 ± 18%  sched_debug.cpu.cpu_load[3].avg
    141.35 ±  0%     +38.0%     195.12 ± 10%  sched_debug.cpu.cpu_load[3].stddev
     28.53 ±  1%    +312.9%     117.79 ± 19%  sched_debug.cpu.cpu_load[4].avg
    141.39 ±  0%     +30.9%     185.09 ± 10%  sched_debug.cpu.cpu_load[4].stddev
    182.95 ± 10%    +176.1%     505.11 ±  9%  sched_debug.cpu.curr->pid.avg
    709.20 ±  5%     +32.1%     937.00 ±  1%  sched_debug.cpu.curr->pid.stddev
     44133 ± 11%    +374.4%     209378 ± 14%  sched_debug.cpu.load.avg
    171770 ± 11%     +94.3%     333803 ±  4%  sched_debug.cpu.load.stddev
     33181 ±  0%     +19.9%      39776 ±  0%  sched_debug.cpu.nr_load_updates.avg
     98035 ±  0%     -23.4%      75114 ±  9%  sched_debug.cpu.nr_load_updates.max
     10011 ±  4%    +100.8%      20108 ± 14%  sched_debug.cpu.nr_load_updates.min
     12893 ±  1%     -32.8%       8664 ± 12%  sched_debug.cpu.nr_load_updates.stddev
      0.09 ± 11%    +184.3%       0.26 ±  9%  sched_debug.cpu.nr_running.avg
      0.28 ±  4%     +51.2%       0.43 ±  2%  sched_debug.cpu.nr_running.stddev
      5765 ±  2%    +317.3%      24062 ±  2%  sched_debug.cpu.nr_switches.avg
     26550 ± 39%    +581.1%     180832 ± 16%  sched_debug.cpu.nr_switches.max
      1909 ±  5%    +151.0%       4791 ± 16%  sched_debug.cpu.nr_switches.min
      4347 ± 23%    +554.5%      28453 ± 13%  sched_debug.cpu.nr_switches.stddev
      0.39 ±  0%     -35.7%       0.25 ± 12%  sched_debug.cpu.nr_uninterruptible.avg
     10.88 ± 26%    +160.9%      28.38 ± 22%  sched_debug.cpu.nr_uninterruptible.max
    -12.44 ±-15%    +120.1%     -27.38 ±-29%  sched_debug.cpu.nr_uninterruptible.min
      4.40 ± 22%    +192.3%      12.85 ± 26%  sched_debug.cpu.nr_uninterruptible.stddev
      3718 ±  3%    +490.5%      21955 ±  2%  sched_debug.cpu.sched_count.avg
     23269 ± 44%    +665.3%     178092 ± 16%  sched_debug.cpu.sched_count.max
    170.69 ± 30%   +1730.8%       3125 ± 25%  sched_debug.cpu.sched_count.min
      4022 ± 27%    +603.4%      28294 ± 13%  sched_debug.cpu.sched_count.stddev
      1764 ±  4%    +509.7%      10757 ±  2%  sched_debug.cpu.sched_goidle.avg
     11576 ± 44%    +666.5%      88735 ± 16%  sched_debug.cpu.sched_goidle.max
     51.69 ± 28%   +2705.3%       1450 ± 24%  sched_debug.cpu.sched_goidle.min
      2023 ± 26%    +598.8%      14140 ± 13%  sched_debug.cpu.sched_goidle.stddev
      1782 ±  4%    +512.4%      10915 ±  2%  sched_debug.cpu.ttwu_count.avg
     15347 ± 35%    +467.3%      87069 ± 18%  sched_debug.cpu.ttwu_count.max
     76.25 ± 47%   +1728.4%       1394 ± 26%  sched_debug.cpu.ttwu_count.min
      2407 ± 23%    +484.3%      14068 ± 17%  sched_debug.cpu.ttwu_count.stddev
      1010 ±  0%     +75.5%       1772 ±  1%  sched_debug.cpu.ttwu_local.avg
      6785 ± 20%     -35.4%       4380 ± 12%  sched_debug.cpu.ttwu_local.max
     36.69 ± 18%    +959.8%     388.81 ± 26%  sched_debug.cpu.ttwu_local.min
      1133 ± 15%     -32.6%     764.11 ± 10%  sched_debug.cpu.ttwu_local.stddev
      2.70 ±  3%    -100.0%       0.00 ± -1%  perf-profile.calltrace.cycles-pp.___might_sleep.__might_sleep.unmap_underlying_metadata.ext4_ext_map_blocks.ext4_map_blocks
      1.21 ±  9%    -100.0%       0.00 ± -1%  perf-profile.calltrace.cycles-pp.___might_sleep.unmap_underlying_metadata.ext4_ext_map_blocks.ext4_map_blocks.ext4_writepages
      0.00 ± -1%      +Inf%       1.38 ±  7%  perf-profile.calltrace.cycles-pp.__alloc_pages_nodemask.alloc_pages_current.__page_cache_alloc.pagecache_get_page.grab_cache_page_write_begin
      0.00 ± -1%      +Inf%       2.16 ±  4%  perf-profile.calltrace.cycles-pp.__block_commit_write.block_write_end.generic_write_end.ext4_da_write_end.generic_perform_write
      0.00 ± -1%      +Inf%      15.40 ±  3%  perf-profile.calltrace.cycles-pp.__block_write_begin.ext4_da_write_begin.generic_perform_write.__generic_file_write_iter.ext4_file_write_iter
      0.00 ± -1%      +Inf%      15.38 ±  3%  perf-profile.calltrace.cycles-pp.__block_write_begin_int.__block_write_begin.ext4_da_write_begin.generic_perform_write.__generic_file_write_iter
      0.00 ± -1%      +Inf%       4.40 ± 13%  perf-profile.calltrace.cycles-pp.__copy_user_nocache.pmem_do_bvec.pmem_make_request.generic_make_request.submit_bio
      0.00 ± -1%      +Inf%       2.36 ± 18%  perf-profile.calltrace.cycles-pp.__delete_from_page_cache.__remove_mapping.shrink_page_list.shrink_inactive_list.shrink_node_memcg
      0.00 ± -1%      +Inf%       2.35 ±  5%  perf-profile.calltrace.cycles-pp.__es_insert_extent.ext4_es_insert_extent.ext4_da_get_block_prep.__block_write_begin_int.__block_write_begin
      0.00 ± -1%      +Inf%       0.99 ± 12%  perf-profile.calltrace.cycles-pp.__es_shrink.ext4_es_scan.shrink_slab.shrink_node.kswapd
      0.00 ± -1%      +Inf%       0.94 ±  4%  perf-profile.calltrace.cycles-pp.__es_tree_search.ext4_es_insert_extent.ext4_da_get_block_prep.__block_write_begin_int.__block_write_begin
      0.00 ± -1%      +Inf%       1.62 ± 13%  perf-profile.calltrace.cycles-pp.__ext4_journal_start_sb.ext4_da_write_begin.generic_perform_write.__generic_file_write_iter.ext4_file_write_iter
      0.00 ± -1%      +Inf%       2.98 ±  2%  perf-profile.calltrace.cycles-pp.__find_get_block.__getblk_gfp.__read_extent_tree_block.ext4_find_extent.ext4_ext_map_blocks
      0.00 ± -1%      +Inf%       1.58 ±  2%  perf-profile.calltrace.cycles-pp.__find_get_block_slow.__find_get_block.__getblk_gfp.__read_extent_tree_block.ext4_find_extent
     32.81 ±  5%    -100.0%       0.00 ± -1%  perf-profile.calltrace.cycles-pp.__find_get_block_slow.unmap_underlying_metadata.ext4_ext_map_blocks.ext4_map_blocks.ext4_writepages
      0.00 ± -1%      +Inf%      29.40 ±  4%  perf-profile.calltrace.cycles-pp.__generic_file_write_iter.ext4_file_write_iter.aio_run_iocb.do_io_submit.sys_io_submit
      0.00 ± -1%      +Inf%       3.17 ±  2%  perf-profile.calltrace.cycles-pp.__getblk_gfp.__read_extent_tree_block.ext4_find_extent.ext4_ext_map_blocks.ext4_da_get_block_prep
      1.22 ±  7%    -100.0%       0.00 ± -1%  perf-profile.calltrace.cycles-pp.__might_sleep.ext4_ext_map_blocks.ext4_map_blocks.ext4_writepages.do_writepages
      4.57 ±  2%    -100.0%       0.00 ± -1%  perf-profile.calltrace.cycles-pp.__might_sleep.unmap_underlying_metadata.ext4_ext_map_blocks.ext4_map_blocks.ext4_writepages
      0.00 ± -1%      +Inf%       1.53 ±  8%  perf-profile.calltrace.cycles-pp.__page_cache_alloc.pagecache_get_page.grab_cache_page_write_begin.ext4_da_write_begin.generic_perform_write
      0.00 ± -1%      +Inf%       2.09 ± 19%  perf-profile.calltrace.cycles-pp.__radix_tree_lookup.__delete_from_page_cache.__remove_mapping.shrink_page_list.shrink_inactive_list
     14.60 ±  6%     -95.4%       0.67 ±  4%  perf-profile.calltrace.cycles-pp.__radix_tree_lookup.radix_tree_lookup_slot.find_get_entry.pagecache_get_page.__find_get_block_slow
      0.00 ± -1%      +Inf%       1.65 ±  8%  perf-profile.calltrace.cycles-pp.__radix_tree_lookup.radix_tree_lookup_slot.find_get_entry.pagecache_get_page.grab_cache_page_write_begin
      0.00 ± -1%      +Inf%       3.30 ±  2%  perf-profile.calltrace.cycles-pp.__read_extent_tree_block.ext4_find_extent.ext4_ext_map_blocks.ext4_da_get_block_prep.__block_write_begin_int
      0.00 ± -1%      +Inf%       2.99 ± 16%  perf-profile.calltrace.cycles-pp.__remove_mapping.shrink_page_list.shrink_inactive_list.shrink_node_memcg.shrink_node
      0.00 ± -1%      +Inf%       1.22 ±  7%  perf-profile.calltrace.cycles-pp.__set_page_dirty.mark_buffer_dirty.__block_commit_write.block_write_end.generic_write_end
      0.00 ± -1%      +Inf%       0.92 ± 14%  perf-profile.calltrace.cycles-pp.__test_set_page_writeback.ext4_bio_write_page.mpage_submit_page.mpage_process_page_bufs.mpage_prepare_extent_to_map
     48.30 ±  5%     -67.4%      15.72 ± 10%  perf-profile.calltrace.cycles-pp.__writeback_inodes_wb.wb_writeback.wb_workfn.process_one_work.worker_thread
     48.30 ±  5%     -67.5%      15.72 ± 10%  perf-profile.calltrace.cycles-pp.__writeback_single_inode.writeback_sb_inodes.__writeback_inodes_wb.wb_writeback.wb_workfn
      0.00 ± -1%      +Inf%       1.86 ±  8%  perf-profile.calltrace.cycles-pp.add_to_page_cache_lru.pagecache_get_page.grab_cache_page_write_begin.ext4_da_write_begin.generic_perform_write
      0.00 ± -1%      +Inf%      31.07 ±  4%  perf-profile.calltrace.cycles-pp.aio_run_iocb.do_io_submit.sys_io_submit.entry_SYSCALL_64_fastpath
      0.00 ± -1%      +Inf%       1.48 ±  7%  perf-profile.calltrace.cycles-pp.alloc_pages_current.__page_cache_alloc.pagecache_get_page.grab_cache_page_write_begin.ext4_da_write_begin
      2.38 ±  7%     -85.1%       0.35 ±100%  perf-profile.calltrace.cycles-pp.apic_timer_interrupt.cpuidle_enter.call_cpuidle.cpu_startup_entry.start_secondary
      0.00 ± -1%      +Inf%       2.39 ± 13%  perf-profile.calltrace.cycles-pp.bio_endio.pmem_make_request.generic_make_request.submit_bio.ext4_io_submit
      0.00 ± -1%      +Inf%       2.19 ±  4%  perf-profile.calltrace.cycles-pp.block_write_end.generic_write_end.ext4_da_write_end.generic_perform_write.__generic_file_write_iter
     49.54 ±  6%     -16.1%      41.58 ±  5%  perf-profile.calltrace.cycles-pp.call_cpuidle.cpu_startup_entry.start_secondary
      0.00 ± -1%      +Inf%       2.56 ±  4%  perf-profile.calltrace.cycles-pp.copy_user_enhanced_fast_string.generic_perform_write.__generic_file_write_iter.ext4_file_write_iter.aio_run_iocb
     50.10 ±  5%     -16.2%      41.98 ±  5%  perf-profile.calltrace.cycles-pp.cpu_startup_entry.start_secondary
     49.52 ±  6%     -16.0%      41.58 ±  5%  perf-profile.calltrace.cycles-pp.cpuidle_enter.call_cpuidle.cpu_startup_entry.start_secondary
     46.57 ±  6%     -12.2%      40.89 ±  6%  perf-profile.calltrace.cycles-pp.cpuidle_enter_state.cpuidle_enter.call_cpuidle.cpu_startup_entry.start_secondary
      0.00 ± -1%      +Inf%      32.31 ±  4%  perf-profile.calltrace.cycles-pp.do_io_submit.sys_io_submit.entry_SYSCALL_64_fastpath
     48.30 ±  5%     -67.5%      15.72 ± 10%  perf-profile.calltrace.cycles-pp.do_writepages.__writeback_single_inode.writeback_sb_inodes.__writeback_inodes_wb.wb_writeback
      0.00 ± -1%      +Inf%       1.05 ± 11%  perf-profile.calltrace.cycles-pp.end_page_writeback.ext4_finish_bio.ext4_end_bio.bio_endio.pmem_make_request
      0.32 ±100%  +10536.2%      33.77 ±  4%  perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_fastpath
      0.00 ± -1%      +Inf%       0.95 ± 13%  perf-profile.calltrace.cycles-pp.es_do_reclaim_extents.es_reclaim_extents.__es_shrink.ext4_es_scan.shrink_slab
      0.00 ± -1%      +Inf%       0.98 ± 12%  perf-profile.calltrace.cycles-pp.es_reclaim_extents.__es_shrink.ext4_es_scan.shrink_slab.shrink_node
      0.00 ± -1%      +Inf%       0.78 ± 25%  perf-profile.calltrace.cycles-pp.ext4_bio_write_page.mpage_submit_page.mpage_map_and_submit_buffers.ext4_writepages.do_writepages
      0.00 ± -1%      +Inf%       8.89 ± 12%  perf-profile.calltrace.cycles-pp.ext4_bio_write_page.mpage_submit_page.mpage_process_page_bufs.mpage_prepare_extent_to_map.ext4_writepages
      0.00 ± -1%      +Inf%      14.36 ±  3%  perf-profile.calltrace.cycles-pp.ext4_da_get_block_prep.__block_write_begin_int.__block_write_begin.ext4_da_write_begin.generic_perform_write
      0.00 ± -1%      +Inf%      22.64 ±  4%  perf-profile.calltrace.cycles-pp.ext4_da_write_begin.generic_perform_write.__generic_file_write_iter.ext4_file_write_iter.aio_run_iocb
      0.00 ± -1%      +Inf%       3.30 ±  5%  perf-profile.calltrace.cycles-pp.ext4_da_write_end.generic_perform_write.__generic_file_write_iter.ext4_file_write_iter.aio_run_iocb
      0.00 ± -1%      +Inf%       1.65 ±  6%  perf-profile.calltrace.cycles-pp.ext4_end_bio.bio_endio.pmem_make_request.generic_make_request.submit_bio
      0.00 ± -1%      +Inf%       3.66 ±  3%  perf-profile.calltrace.cycles-pp.ext4_es_insert_extent.ext4_da_get_block_prep.__block_write_begin_int.__block_write_begin.ext4_da_write_begin
      0.00 ± -1%      +Inf%       4.21 ±  5%  perf-profile.calltrace.cycles-pp.ext4_es_lookup_extent.ext4_da_get_block_prep.__block_write_begin_int.__block_write_begin.ext4_da_write_begin
      0.00 ± -1%      +Inf%       0.99 ± 12%  perf-profile.calltrace.cycles-pp.ext4_es_scan.shrink_slab.shrink_node.kswapd.kthread
      0.00 ± -1%      +Inf%       5.80 ±  3%  perf-profile.calltrace.cycles-pp.ext4_ext_map_blocks.ext4_da_get_block_prep.__block_write_begin_int.__block_write_begin.ext4_da_write_begin
     46.91 ±  5%     -97.7%       1.07 ± 24%  perf-profile.calltrace.cycles-pp.ext4_ext_map_blocks.ext4_map_blocks.ext4_writepages.do_writepages.__writeback_single_inode
      0.00 ± -1%      +Inf%      29.67 ±  4%  perf-profile.calltrace.cycles-pp.ext4_file_write_iter.aio_run_iocb.do_io_submit.sys_io_submit.entry_SYSCALL_64_fastpath
      0.00 ± -1%      +Inf%       5.40 ±  3%  perf-profile.calltrace.cycles-pp.ext4_find_extent.ext4_ext_map_blocks.ext4_da_get_block_prep.__block_write_begin_int.__block_write_begin
      0.00 ± -1%      +Inf%       1.31 ± 11%  perf-profile.calltrace.cycles-pp.ext4_finish_bio.ext4_end_bio.bio_endio.pmem_make_request.generic_make_request
      0.00 ± -1%      +Inf%       6.92 ± 11%  perf-profile.calltrace.cycles-pp.ext4_io_submit.ext4_bio_write_page.mpage_submit_page.mpage_process_page_bufs.mpage_prepare_extent_to_map
      0.00 ± -1%      +Inf%       0.86 ± 24%  perf-profile.calltrace.cycles-pp.ext4_io_submit.ext4_writepages.do_writepages.__writeback_single_inode.writeback_sb_inodes
     47.67 ±  5%     -96.2%       1.81 ± 23%  perf-profile.calltrace.cycles-pp.ext4_map_blocks.ext4_writepages.do_writepages.__writeback_single_inode.writeback_sb_inodes
      0.00 ± -1%      +Inf%       1.10 ± 16%  perf-profile.calltrace.cycles-pp.ext4_releasepage.try_to_release_page.shrink_page_list.shrink_inactive_list.shrink_node_memcg
     48.29 ±  5%     -67.6%      15.63 ± 10%  perf-profile.calltrace.cycles-pp.ext4_writepages.do_writepages.__writeback_single_inode.writeback_sb_inodes.__writeback_inodes_wb
      1.20 ± 10%    -100.0%       0.00 ± -1%  perf-profile.calltrace.cycles-pp.find_get_entry.__find_get_block_slow.unmap_underlying_metadata.ext4_ext_map_blocks.ext4_map_blocks
      0.00 ± -1%      +Inf%       1.21 ±  2%  perf-profile.calltrace.cycles-pp.find_get_entry.pagecache_get_page.__find_get_block_slow.__find_get_block.__getblk_gfp
     20.02 ±  6%    -100.0%       0.00 ± -1%  perf-profile.calltrace.cycles-pp.find_get_entry.pagecache_get_page.__find_get_block_slow.unmap_underlying_metadata.ext4_ext_map_blocks
      0.00 ± -1%      +Inf%       1.70 ±  9%  perf-profile.calltrace.cycles-pp.find_get_entry.pagecache_get_page.grab_cache_page_write_begin.ext4_da_write_begin.generic_perform_write
      0.00 ± -1%      +Inf%       0.90 ± 12%  perf-profile.calltrace.cycles-pp.find_get_pages_tag.pagevec_lookup_tag.mpage_prepare_extent_to_map.ext4_writepages.do_writepages
      0.00 ± -1%      +Inf%       7.36 ±  8%  perf-profile.calltrace.cycles-pp.generic_make_request.submit_bio.ext4_io_submit.ext4_bio_write_page.mpage_submit_page
      0.00 ± -1%      +Inf%       0.86 ± 24%  perf-profile.calltrace.cycles-pp.generic_make_request.submit_bio.ext4_io_submit.ext4_writepages.do_writepages
      0.00 ± -1%      +Inf%      29.06 ±  4%  perf-profile.calltrace.cycles-pp.generic_perform_write.__generic_file_write_iter.ext4_file_write_iter.aio_run_iocb.do_io_submit
      0.00 ± -1%      +Inf%       2.48 ±  5%  perf-profile.calltrace.cycles-pp.generic_write_end.ext4_da_write_end.generic_perform_write.__generic_file_write_iter.ext4_file_write_iter
      0.00 ± -1%      +Inf%       1.15 ±  9%  perf-profile.calltrace.cycles-pp.get_page_from_freelist.__alloc_pages_nodemask.alloc_pages_current.__page_cache_alloc.pagecache_get_page
      0.00 ± -1%      +Inf%       5.26 ±  8%  perf-profile.calltrace.cycles-pp.grab_cache_page_write_begin.ext4_da_write_begin.generic_perform_write.__generic_file_write_iter.ext4_file_write_iter
      0.96 ±  6%    -100.0%       0.00 ± -1%  perf-profile.calltrace.cycles-pp.irq_exit.smp_apic_timer_interrupt.apic_timer_interrupt.cpuidle_enter.call_cpuidle
      0.00 ± -1%      +Inf%       1.34 ± 12%  perf-profile.calltrace.cycles-pp.jbd2__journal_start.__ext4_journal_start_sb.ext4_da_write_begin.generic_perform_write.__generic_file_write_iter
      0.00 ± -1%      +Inf%       1.04 ± 17%  perf-profile.calltrace.cycles-pp.jbd2_journal_try_to_free_buffers.ext4_releasepage.try_to_release_page.shrink_page_list.shrink_inactive_list
      0.00 ± -1%      +Inf%       6.95 ± 14%  perf-profile.calltrace.cycles-pp.kswapd.kthread.ret_from_fork
     48.40 ±  5%     -52.7%      22.88 ±  2%  perf-profile.calltrace.cycles-pp.kthread.ret_from_fork
      0.91 ±  9%    -100.0%       0.00 ± -1%  perf-profile.calltrace.cycles-pp.local_apic_timer_interrupt.smp_apic_timer_interrupt.apic_timer_interrupt.cpuidle_enter.call_cpuidle
      0.00 ± -1%      +Inf%       1.57 ±  6%  perf-profile.calltrace.cycles-pp.mark_buffer_dirty.__block_commit_write.block_write_end.generic_write_end.ext4_da_write_end
      0.00 ± -1%      +Inf%       1.34 ± 25%  perf-profile.calltrace.cycles-pp.mpage_map_and_submit_buffers.ext4_writepages.do_writepages.__writeback_single_inode.writeback_sb_inodes
      0.00 ± -1%      +Inf%      11.30 ± 12%  perf-profile.calltrace.cycles-pp.mpage_prepare_extent_to_map.ext4_writepages.do_writepages.__writeback_single_inode.writeback_sb_inodes
      0.00 ± -1%      +Inf%      10.02 ± 11%  perf-profile.calltrace.cycles-pp.mpage_process_page_bufs.mpage_prepare_extent_to_map.ext4_writepages.do_writepages.__writeback_single_inode
      0.00 ± -1%      +Inf%       0.84 ± 25%  perf-profile.calltrace.cycles-pp.mpage_submit_page.mpage_map_and_submit_buffers.ext4_writepages.do_writepages.__writeback_single_inode
      0.00 ± -1%      +Inf%       9.40 ± 12%  perf-profile.calltrace.cycles-pp.mpage_submit_page.mpage_process_page_bufs.mpage_prepare_extent_to_map.ext4_writepages.do_writepages
      0.00 ± -1%      +Inf%       1.28 ±  2%  perf-profile.calltrace.cycles-pp.pagecache_get_page.__find_get_block_slow.__find_get_block.__getblk_gfp.__read_extent_tree_block
     26.12 ±  6%    -100.0%       0.00 ± -1%  perf-profile.calltrace.cycles-pp.pagecache_get_page.__find_get_block_slow.unmap_underlying_metadata.ext4_ext_map_blocks.ext4_map_blocks
      0.00 ± -1%      +Inf%       5.19 ±  8%  perf-profile.calltrace.cycles-pp.pagecache_get_page.grab_cache_page_write_begin.ext4_da_write_begin.generic_perform_write.__generic_file_write_iter
      0.00 ± -1%      +Inf%       0.91 ± 12%  perf-profile.calltrace.cycles-pp.pagevec_lookup_tag.mpage_prepare_extent_to_map.ext4_writepages.do_writepages.__writeback_single_inode
      0.00 ± -1%      +Inf%       4.59 ±  8%  perf-profile.calltrace.cycles-pp.pmem_do_bvec.pmem_make_request.generic_make_request.submit_bio.ext4_io_submit
      0.00 ± -1%      +Inf%       6.95 ±  8%  perf-profile.calltrace.cycles-pp.pmem_make_request.generic_make_request.submit_bio.ext4_io_submit.ext4_bio_write_page
      0.00 ± -1%      +Inf%       0.84 ± 23%  perf-profile.calltrace.cycles-pp.pmem_make_request.generic_make_request.submit_bio.ext4_io_submit.ext4_writepages
     12.15 ± 46%     -77.5%       2.74 ± 50%  perf-profile.calltrace.cycles-pp.poll_idle.cpuidle_enter_state.cpuidle_enter.call_cpuidle.cpu_startup_entry
     48.36 ±  5%     -67.4%      15.75 ± 10%  perf-profile.calltrace.cycles-pp.process_one_work.worker_thread.kthread.ret_from_fork
     16.45 ±  6%    -100.0%       0.00 ± -1%  perf-profile.calltrace.cycles-pp.radix_tree_lookup_slot.find_get_entry.pagecache_get_page.__find_get_block_slow.unmap_underlying_metadata
      0.00 ± -1%      +Inf%       1.66 ±  8%  perf-profile.calltrace.cycles-pp.radix_tree_lookup_slot.find_get_entry.pagecache_get_page.grab_cache_page_write_begin.ext4_da_write_begin
     48.40 ±  5%     -52.7%      22.88 ±  2%  perf-profile.calltrace.cycles-pp.ret_from_fork
      0.00 ± -1%      +Inf%       5.92 ± 15%  perf-profile.calltrace.cycles-pp.shrink_inactive_list.shrink_node_memcg.shrink_node.kswapd.kthread
      0.00 ± -1%      +Inf%       6.94 ± 14%  perf-profile.calltrace.cycles-pp.shrink_node.kswapd.kthread.ret_from_fork
      0.00 ± -1%      +Inf%       5.94 ± 15%  perf-profile.calltrace.cycles-pp.shrink_node_memcg.shrink_node.kswapd.kthread.ret_from_fork
      0.00 ± -1%      +Inf%       5.37 ± 15%  perf-profile.calltrace.cycles-pp.shrink_page_list.shrink_inactive_list.shrink_node_memcg.shrink_node.kswapd
      0.00 ± -1%      +Inf%       1.00 ± 13%  perf-profile.calltrace.cycles-pp.shrink_slab.shrink_node.kswapd.kthread.ret_from_fork
      2.32 ±  8%     -85.1%       0.34 ±100%  perf-profile.calltrace.cycles-pp.smp_apic_timer_interrupt.apic_timer_interrupt.cpuidle_enter.call_cpuidle.cpu_startup_entry
     50.21 ±  5%     -16.3%      42.00 ±  5%  perf-profile.calltrace.cycles-pp.start_secondary
      0.00 ± -1%      +Inf%       6.91 ± 11%  perf-profile.calltrace.cycles-pp.submit_bio.ext4_io_submit.ext4_bio_write_page.mpage_submit_page.mpage_process_page_bufs
      0.00 ± -1%      +Inf%       0.86 ± 24%  perf-profile.calltrace.cycles-pp.submit_bio.ext4_io_submit.ext4_writepages.do_writepages.__writeback_single_inode
      0.00 ± -1%      +Inf%      32.48 ±  4%  perf-profile.calltrace.cycles-pp.sys_io_submit.entry_SYSCALL_64_fastpath
      0.00 ± -1%      +Inf%       0.87 ± 10%  perf-profile.calltrace.cycles-pp.test_clear_page_writeback.end_page_writeback.ext4_finish_bio.ext4_end_bio.bio_endio
      0.00 ± -1%      +Inf%       1.12 ± 17%  perf-profile.calltrace.cycles-pp.try_to_release_page.shrink_page_list.shrink_inactive_list.shrink_node_memcg.shrink_node
     42.84 ±  5%    -100.0%       0.00 ± -1%  perf-profile.calltrace.cycles-pp.unmap_underlying_metadata.ext4_ext_map_blocks.ext4_map_blocks.ext4_writepages.do_writepages
     48.30 ±  5%     -67.4%      15.72 ± 10%  perf-profile.calltrace.cycles-pp.wb_workfn.process_one_work.worker_thread.kthread.ret_from_fork
     48.30 ±  5%     -67.4%      15.72 ± 10%  perf-profile.calltrace.cycles-pp.wb_writeback.wb_workfn.process_one_work.worker_thread.kthread
     48.36 ±  5%     -67.4%      15.76 ± 10%  perf-profile.calltrace.cycles-pp.worker_thread.kthread.ret_from_fork
     48.30 ±  5%     -67.5%      15.72 ± 10%  perf-profile.calltrace.cycles-pp.writeback_sb_inodes.__writeback_inodes_wb.wb_writeback.wb_workfn.process_one_work
      3.93 ±  2%     -84.2%       0.62 ±  2%  perf-profile.children.cycles-pp.___might_sleep
      0.02 ±173%   +7942.9%       1.41 ±  7%  perf-profile.children.cycles-pp.__alloc_pages_nodemask
      0.01 ±173%  +17180.0%       2.16 ±  4%  perf-profile.children.cycles-pp.__block_commit_write
      0.05 ± 62%  +32336.8%      15.41 ±  3%  perf-profile.children.cycles-pp.__block_write_begin
      0.05 ± 62%  +32300.0%      15.39 ±  3%  perf-profile.children.cycles-pp.__block_write_begin_int
      0.18 ± 13%   +2764.4%       5.23 ±  9%  perf-profile.children.cycles-pp.__copy_user_nocache
      0.00 ± -1%      +Inf%       2.36 ± 18%  perf-profile.children.cycles-pp.__delete_from_page_cache
      0.06 ± 64%   +4572.7%       2.57 ±  4%  perf-profile.children.cycles-pp.__es_insert_extent
      0.00 ± -1%      +Inf%       0.99 ± 12%  perf-profile.children.cycles-pp.__es_shrink
      0.00 ± -1%      +Inf%       1.16 ±  2%  perf-profile.children.cycles-pp.__es_tree_search
      0.01 ±173%  +14200.0%       1.79 ± 12%  perf-profile.children.cycles-pp.__ext4_journal_start_sb
      0.00 ± -1%      +Inf%       3.10 ±  2%  perf-profile.children.cycles-pp.__find_get_block
     33.44 ±  5%     -95.1%       1.65 ±  1%  perf-profile.children.cycles-pp.__find_get_block_slow
      0.30 ± 10%   +9542.6%      29.41 ±  4%  perf-profile.children.cycles-pp.__generic_file_write_iter
      0.00 ± -1%      +Inf%       3.31 ±  2%  perf-profile.children.cycles-pp.__getblk_gfp
      5.83 ±  3%     -85.3%       0.86 ±  5%  perf-profile.children.cycles-pp.__might_sleep
      0.01 ±173%  +10133.3%       1.53 ±  8%  perf-profile.children.cycles-pp.__page_cache_alloc
     15.24 ±  6%     -70.8%       4.45 ±  7%  perf-profile.children.cycles-pp.__radix_tree_lookup
      0.00 ± -1%      +Inf%       3.41 ±  2%  perf-profile.children.cycles-pp.__read_extent_tree_block
      0.00 ± -1%      +Inf%       2.99 ± 16%  perf-profile.children.cycles-pp.__remove_mapping
      0.00 ± -1%      +Inf%       1.23 ±  7%  perf-profile.children.cycles-pp.__set_page_dirty
      0.00 ± -1%      +Inf%       1.04 ± 13%  perf-profile.children.cycles-pp.__test_set_page_writeback
     48.30 ±  5%     -67.4%      15.72 ± 10%  perf-profile.children.cycles-pp.__writeback_inodes_wb
     48.30 ±  5%     -67.5%      15.72 ± 10%  perf-profile.children.cycles-pp.__writeback_single_inode
      0.09 ± 17%   +1352.9%       1.23 ±  8%  perf-profile.children.cycles-pp._raw_spin_lock_irqsave
      0.00 ± -1%      +Inf%       1.87 ±  8%  perf-profile.children.cycles-pp.add_to_page_cache_lru
      0.32 ± 12%   +9536.4%      31.08 ±  4%  perf-profile.children.cycles-pp.aio_run_iocb
      0.02 ±173%   +8442.9%       1.50 ±  7%  perf-profile.children.cycles-pp.alloc_pages_current
      2.58 ±  7%     -65.8%       0.88 ± 28%  perf-profile.children.cycles-pp.apic_timer_interrupt
      0.07 ± 66%   +3833.3%       2.95 ±  9%  perf-profile.children.cycles-pp.bio_endio
      0.03 ±100%   +7881.8%       2.20 ±  4%  perf-profile.children.cycles-pp.block_write_end
     50.15 ±  5%     -15.4%      42.45 ±  4%  perf-profile.children.cycles-pp.call_cpuidle
      0.05 ±  9%   +4868.2%       2.73 ±  4%  perf-profile.children.cycles-pp.copy_user_enhanced_fast_string
     50.70 ±  5%     -15.5%      42.85 ±  4%  perf-profile.children.cycles-pp.cpu_startup_entry
     50.11 ±  5%     -15.3%      42.45 ±  4%  perf-profile.children.cycles-pp.cpuidle_enter
     46.86 ±  6%     -11.1%      41.67 ±  5%  perf-profile.children.cycles-pp.cpuidle_enter_state
      0.34 ± 14%   +9334.3%      32.31 ±  4%  perf-profile.children.cycles-pp.do_io_submit
     48.30 ±  5%     -67.5%      15.72 ± 10%  perf-profile.children.cycles-pp.do_writepages
      0.01 ±173%  +10480.0%       1.32 ±  9%  perf-profile.children.cycles-pp.end_page_writeback
      0.64 ± 10%   +5173.9%      33.88 ±  4%  perf-profile.children.cycles-pp.entry_SYSCALL_64_fastpath
      0.00 ± -1%      +Inf%       0.95 ± 13%  perf-profile.children.cycles-pp.es_do_reclaim_extents
      0.00 ± -1%      +Inf%       0.98 ± 12%  perf-profile.children.cycles-pp.es_reclaim_extents
      0.05 ± 61%  +19285.0%       9.69 ± 10%  perf-profile.children.cycles-pp.ext4_bio_write_page
      0.01 ±173%  +1.1e+05%      14.36 ±  3%  perf-profile.children.cycles-pp.ext4_da_get_block_prep
      0.17 ± 10%  +13621.2%      22.64 ±  4%  perf-profile.children.cycles-pp.ext4_da_write_begin
      0.04 ± 59%   +7238.9%       3.30 ±  5%  perf-profile.children.cycles-pp.ext4_da_write_end
      0.04 ±100%   +5253.3%       2.01 ±  6%  perf-profile.children.cycles-pp.ext4_end_bio
      0.09 ± 26%   +4362.2%       4.13 ±  3%  perf-profile.children.cycles-pp.ext4_es_insert_extent
      0.04 ± 60%  +10347.1%       4.44 ±  5%  perf-profile.children.cycles-pp.ext4_es_lookup_extent
      0.00 ± -1%      +Inf%       0.99 ± 12%  perf-profile.children.cycles-pp.ext4_es_scan
     46.91 ±  5%     -85.3%       6.88 ±  6%  perf-profile.children.cycles-pp.ext4_ext_map_blocks
      0.30 ± 11%   +9709.1%      29.67 ±  4%  perf-profile.children.cycles-pp.ext4_file_write_iter
      0.04 ±102%  +15914.3%       5.60 ±  4%  perf-profile.children.cycles-pp.ext4_find_extent
      0.03 ±100%   +5800.0%       1.62 ±  9%  perf-profile.children.cycles-pp.ext4_finish_bio
      0.23 ± 16%   +3540.2%       8.37 ±  9%  perf-profile.children.cycles-pp.ext4_io_submit
     47.67 ±  5%     -96.2%       1.82 ± 23%  perf-profile.children.cycles-pp.ext4_map_blocks
      0.00 ± -1%      +Inf%       0.84 ± 31%  perf-profile.children.cycles-pp.ext4_put_io_end_defer
      0.00 ± -1%      +Inf%       1.10 ± 16%  perf-profile.children.cycles-pp.ext4_releasepage
     48.29 ±  5%     -67.6%      15.63 ± 10%  perf-profile.children.cycles-pp.ext4_writepages
     21.26 ±  6%     -85.9%       2.99 ±  6%  perf-profile.children.cycles-pp.find_get_entry
      0.10 ±  9%    +852.6%       0.91 ± 12%  perf-profile.children.cycles-pp.find_get_pages_tag
      0.30 ± 17%   +2817.5%       8.75 ±  9%  perf-profile.children.cycles-pp.generic_make_request
      0.29 ± 10%   +9924.1%      29.07 ±  4%  perf-profile.children.cycles-pp.generic_perform_write
      0.04 ± 58%   +6118.7%       2.49 ±  5%  perf-profile.children.cycles-pp.generic_write_end
      0.01 ±173%   +9420.0%       1.19 ±  9%  perf-profile.children.cycles-pp.get_page_from_freelist
      0.10 ±  5%   +5450.0%       5.27 ±  8%  perf-profile.children.cycles-pp.grab_cache_page_write_begin
      1.01 ± 10%     -56.3%       0.44 ± 26%  perf-profile.children.cycles-pp.hrtimer_interrupt
      1.55 ±  9%     -69.5%       0.47 ± 26%  perf-profile.children.cycles-pp.irq_exit
      0.00 ± -1%      +Inf%       1.49 ± 11%  perf-profile.children.cycles-pp.jbd2__journal_start
      0.00 ± -1%      +Inf%       1.05 ± 17%  perf-profile.children.cycles-pp.jbd2_journal_try_to_free_buffers
      0.01 ±173%   +8660.0%       1.09 ±  6%  perf-profile.children.cycles-pp.kmem_cache_alloc
      0.00 ± -1%      +Inf%       6.95 ± 14%  perf-profile.children.cycles-pp.kswapd
     48.40 ±  5%     -52.7%      22.88 ±  2%  perf-profile.children.cycles-pp.kthread
      1.04 ± 10%     -56.4%       0.45 ± 27%  perf-profile.children.cycles-pp.local_apic_timer_interrupt
      0.00 ± -1%      +Inf%       1.57 ±  5%  perf-profile.children.cycles-pp.mark_buffer_dirty
      0.21 ±  9%    +524.4%       1.34 ± 25%  perf-profile.children.cycles-pp.mpage_map_and_submit_buffers
      0.12 ± 15%   +9124.5%      11.30 ± 12%  perf-profile.children.cycles-pp.mpage_prepare_extent_to_map
      0.00 ± -1%      +Inf%      10.03 ± 11%  perf-profile.children.cycles-pp.mpage_process_page_bufs
      0.07 ± 58%  +15100.0%      10.26 ± 10%  perf-profile.children.cycles-pp.mpage_submit_page
     26.82 ±  6%     -75.6%       6.53 ±  6%  perf-profile.children.cycles-pp.pagecache_get_page
      0.10 ±  9%    +860.5%       0.91 ± 13%  perf-profile.children.cycles-pp.pagevec_lookup_tag
      0.18 ± 13%   +2830.1%       5.35 ±  9%  perf-profile.children.cycles-pp.pmem_do_bvec
      0.28 ± 17%   +2935.1%       8.42 ±  9%  perf-profile.children.cycles-pp.pmem_make_request
     12.15 ± 46%     -77.3%       2.76 ± 50%  perf-profile.children.cycles-pp.poll_idle
     48.36 ±  5%     -67.4%      15.75 ± 10%  perf-profile.children.cycles-pp.process_one_work
     17.14 ±  6%     -86.0%       2.39 ±  6%  perf-profile.children.cycles-pp.radix_tree_lookup_slot
     48.40 ±  5%     -52.7%      22.88 ±  2%  perf-profile.children.cycles-pp.ret_from_fork
      0.00 ± -1%      +Inf%       5.92 ± 15%  perf-profile.children.cycles-pp.shrink_inactive_list
      0.00 ± -1%      +Inf%       6.94 ± 14%  perf-profile.children.cycles-pp.shrink_node
      0.00 ± -1%      +Inf%       5.94 ± 15%  perf-profile.children.cycles-pp.shrink_node_memcg
      0.00 ± -1%      +Inf%       5.37 ± 15%  perf-profile.children.cycles-pp.shrink_page_list
      0.00 ± -1%      +Inf%       1.00 ± 13%  perf-profile.children.cycles-pp.shrink_slab
      2.51 ±  8%     -65.7%       0.86 ± 28%  perf-profile.children.cycles-pp.smp_apic_timer_interrupt
     50.21 ±  5%     -16.3%      42.00 ±  5%  perf-profile.children.cycles-pp.start_secondary
      0.30 ± 17%   +2828.3%       8.79 ±  9%  perf-profile.children.cycles-pp.submit_bio
      0.35 ± 15%   +9326.8%      32.52 ±  4%  perf-profile.children.cycles-pp.sys_io_submit
      0.00 ± -1%      +Inf%       1.09 ±  9%  perf-profile.children.cycles-pp.test_clear_page_writeback
      0.00 ± -1%      +Inf%       1.13 ± 17%  perf-profile.children.cycles-pp.try_to_release_page
     43.48 ±  5%     -99.9%       0.03 ±100%  perf-profile.children.cycles-pp.unmap_underlying_metadata
     48.30 ±  5%     -67.4%      15.72 ± 10%  perf-profile.children.cycles-pp.wb_workfn
     48.30 ±  5%     -67.4%      15.72 ± 10%  perf-profile.children.cycles-pp.wb_writeback
     48.36 ±  5%     -67.4%      15.76 ± 10%  perf-profile.children.cycles-pp.worker_thread
     48.30 ±  5%     -67.5%      15.72 ± 10%  perf-profile.children.cycles-pp.writeback_sb_inodes
      3.93 ±  2%     -84.2%       0.62 ±  2%  perf-profile.self.cycles-pp.___might_sleep
      0.18 ± 13%   +2764.4%       5.23 ±  9%  perf-profile.self.cycles-pp.__copy_user_nocache
      0.01 ±173%   +9700.0%       1.23 ±  2%  perf-profile.self.cycles-pp.__es_insert_extent
      0.00 ± -1%      +Inf%       1.07 ±  2%  perf-profile.self.cycles-pp.__es_tree_search
      6.10 ±  4%     -95.7%       0.27 ±  5%  perf-profile.self.cycles-pp.__find_get_block_slow
      3.10 ±  6%     -87.1%       0.40 ±  8%  perf-profile.self.cycles-pp.__might_sleep
     15.24 ±  6%     -70.8%       4.45 ±  7%  perf-profile.self.cycles-pp.__radix_tree_lookup
      0.05 ±  9%   +4868.2%       2.73 ±  4%  perf-profile.self.cycles-pp.copy_user_enhanced_fast_string
      0.04 ± 60%   +9776.5%       4.20 ±  5%  perf-profile.self.cycles-pp.ext4_es_lookup_extent
      1.22 ±  7%     -87.1%       0.16 ± 13%  perf-profile.self.cycles-pp.ext4_ext_map_blocks
      0.00 ± -1%      +Inf%       1.86 ±  9%  perf-profile.self.cycles-pp.ext4_find_extent
      0.00 ± -1%      +Inf%       0.84 ± 31%  perf-profile.self.cycles-pp.ext4_put_io_end_defer
      4.18 ±  5%     -85.6%       0.60 ±  4%  perf-profile.self.cycles-pp.find_get_entry
      6.03 ±  6%     -98.1%       0.11 ± 17%  perf-profile.self.cycles-pp.pagecache_get_page
     12.15 ± 46%     -77.3%       2.76 ± 50%  perf-profile.self.cycles-pp.poll_idle
      2.47 ±  4%    -100.0%       0.00 ± -1%  perf-profile.self.cycles-pp.radix_tree_lookup_slot
      4.26 ±  8%    -100.0%       0.00 ± -1%  perf-profile.self.cycles-pp.unmap_underlying_metadata



                                 fio.write_bw_MBps

  3500 ++-------------------------------------------------------------------+
       |       O                                                            |
  3000 ++   O                                                               |
       O  O           O  O    O    O  O O       O         O         O  O    O
  2500 ++        O  O      O     O         O O    O  O  O    O O  O      O  |
       |                                                                    |
  2000 ++                                                                   |
       |                                                                    |
  1500 ++                                                                   |
       |                                                                    |
  1000 ++                                                                   |
       |                                                                    |
   500 ++                                                                   |
       |                                                                    |
     0 *+-*-*--*-*--*-*--*-*--*--*-*--*-*--*-*--*-*--*--*-*--*-*--*-*--*-*--*


                                   fio.write_iops

  900000 ++-----------------------------------------------------------------+
         |                                                                  |
  800000 ++   O O                                                           |
  700000 O+O            O O    O       O O       O         O         O O    O
         |         O O       O    O O       O O    O  O O    O  O O       O |
  600000 ++                                                                 |
  500000 ++                                                                 |
         |                                                                  |
  400000 ++                                                                 |
  300000 ++                                                                 |
         |                                                                  |
  200000 ++                                                                 |
  100000 ++                                                                 |
         |                                                                  |
       0 *+*--*-*--*-*--*-*--*-*--*-*--*-*--*-*--*-*--*-*--*-*--*-*--*-*--*-*


                               fio.write_clat_mean_us

  60000 ++------------------------------------------------------------------+
        |                .*.       .*.                                      |
  50000 *+.*.*..*.*..*.*.   *..*.*.   *..*.*..*.*..*.*..*.*..*.*..*.*..*.*..*
        |                                                                   |
        |                                                                   |
  40000 ++                                                                  |
        |                                                                   |
  30000 ++                                                                  |
        |                                                                   |
  20000 ++                                                                  |
        |                                                                   |
        |                                                                   |
  10000 ++                                                                  |
        |                                                                   |
      0 O+-O-O--O-O--O-O--O-O--O-O--O-O--O-O--O-O--O-O--O-O--O-O--O-O--O-O--O


                                fio.write_clat_stddev

  120000 ++-----------------------------------------------------------------+
         |          .*.. .*..*.  .*.*..                                  .*.|
  100000 *+*..*.*..*    *      *.      *.*..*.*..*.*..*.*..*.*..*.*..*.*.   *
         |                                                                  |
         |                                                                  |
   80000 ++                                                                 |
         |                                                                  |
   60000 ++                                                                 |
         |                                                                  |
   40000 ++                                                                 |
         |                                                                  |
         |                                                                  |
   20000 ++                                                                 |
         O O  O O  O O  O O  O O  O O  O O  O O  O O  O O  O O  O O  O O  O O
       0 ++-----------------------------------------------------------------+


                                fio.write_clat_90__us

  200000 ++-----------------------------------------------------------------+
  180000 ++          *..                                                    |
         |   .*.*.. +    .*..*.*..*.*..    .*.*..      .*..*.  .*.    .*..*.*
  160000 *+*.      *    *              *.*.      *.*..*      *.   *..*      |
  140000 ++                                                                 |
         |                                                                  |
  120000 ++                                                                 |
  100000 ++                                                                 |
   80000 ++                                                                 |
         |                                                                  |
   60000 ++                                                                 |
   40000 ++                                                                 |
         |                                                                  |
   20000 ++                                                                 |
       0 O+O--O-O--O-O--O-O--O-O--O-O--O-O--O-O--O-O--O-O--O-O--O-O--O-O--O-O


                                fio.write_clat_95__us

  250000 ++-----------------------------------------------------------------+
         |                                                                  |
         *.*..*.*..*.*..*.*..*.*..*.*..*.*..*.*..*.*..*.*..*.*..*.*..*.*..*.*
  200000 ++                                                                 |
         |                                                                  |
         |                                                                  |
  150000 ++                                                                 |
         |                                                                  |
  100000 ++                                                                 |
         |                                                                  |
         |                                                                  |
   50000 ++                                                                 |
         |                                                                  |
         |                                                                  |
       0 O+O--O-O--O-O--O-O--O-O--O-O--O-O--O-O--O-O--O-O--O-O--O-O--O-O--O-O


                                fio.write_clat_99__us

  700000 ++-----------------------------------------------------------------+
         |    *.*    *    *..*    *.*       *.*         *..*    *.*       *.*
  600000 ++  :   :   ::   :  :   :   :     :   :        :  :   :   :     :  |
         |   :   :  : :  :    :  :   :     :   :       :    :  :   :     :  |
  500000 ++ :     : :  : :    : :     :   :     :      :    : :     :   :   |
         |  :     ::   ::      ::     :   :     :     :      ::     :   :   |
  400000 *+*       *    *      *       *.*       *.*..*      *       *.*    |
         |                                                                  |
  300000 ++                                                                 |
         |                                                                  |
  200000 ++                                                                 |
         |                                                                  |
  100000 ++                                                                 |
         O O  O O  O O  O O  O O  O O  O O  O O  O O  O O  O O  O O  O O  O O
       0 ++-----------------------------------------------------------------+


                              fio.write_slat_mean_us

  1800 ++----------------*---------*----------------------------------------+
       *..*.*..*.*..*.*.   *..*..*    *.*..*.*..*.*..*..*.*..*.*..*.*..*.*..*
  1600 ++                                                                   |
  1400 ++                                                                   |
       |                                                                    |
  1200 ++                                                                   |
  1000 ++                                                                   |
       |                                                                    |
   800 ++                                                                   |
   600 ++                                                                   |
       |                                                                    |
   400 ++                                                                   |
   200 ++                                                                   |
       |                                                                    |
     0 O+-O-O--O-O--O-O--O-O--O--O-O--O-O--O-O--O-O--O--O-O--O-O--O-O--O-O--O


                                fio.write_slat_stddev

  18000 ++----------------*-*----*--*---------------------------------------+
        *..*.*..*.*..*.*.      *      *..*.*..*.*..*.*..*.*..*.*..*.*..*.*..*
  16000 ++                                                                  |
  14000 ++                                                                  |
        |                                                                   |
  12000 ++                                                                  |
  10000 ++                                                                  |
        |                                                                   |
   8000 ++                                                                  |
   6000 ++                                                                  |
        |                                                                   |
   4000 ++                                                                  |
   2000 ++                                                                  |
        O  O O  O O  O O  O O  O O  O O  O O  O O  O O  O O  O O  O O  O O  O
      0 ++------------------------------------------------------------------+


	[*] bisect-good sample
	[O] bisect-bad  sample

***************************************************************************************************
lkp-hsw-ep6: 56 threads Intel(R) Xeon(R) CPU E5-2695 v3 @ 2.30GHz with 256G memory
=========================================================================================
bs/compiler/cpufreq_governor/disk/fs/ioengine/kconfig/nr_task/rootfs/runtime/rw/tbox_group/test_size/testcase/time_based:
  4k/gcc-6/performance/2pmem/ext4/sync/x86_64-rhel-7.2/50%/debian-x86_64-2016-08-31.cgz/200s/randwrite/lkp-hsw-ep6/200G/fio-basic/tb

commit: 
  6f2b562c3a ("direct-io: Use clean_bdev_aliases() instead of handmade iteration")
  adad5aa544 ("ext4: Use clean_bdev_aliases() instead of iteration")

6f2b562c3a89f4a6 adad5aa544e281d84f837b2786 
---------------- -------------------------- 
       fail:runs  %reproduction    fail:runs
           |             |             |    
         %stddev     %change         %stddev
             \          |                \  
     64.51 ±  0%   +3928.3%       2598 ±  1%  fio.write_bw_MBps
     16514 ±  0%   +3928.3%     665261 ±  1%  fio.write_iops
      0.01 ± 34%    +860.0%       0.12 ± 15%  fio.latency_100us%
      0.13 ±  0%     -92.3%       0.01 ±  0%  fio.latency_10ms%
     73.95 ±  3%     -44.9%      40.77 ±  9%  fio.latency_10us%
     22.26 ± 11%    +152.0%      56.10 ±  6%  fio.latency_20us%
      0.99 ±  1%     -99.0%       0.01 ±  0%  fio.latency_250ms%
      1.14 ± 38%     -79.4%       0.23 ± 21%  fio.latency_4us%
      1.50 ± 14%     +78.5%       2.68 ± 15%  fio.latency_50us%
  26441098 ±  0%   +3924.1%  1.064e+09 ±  1%  fio.time.file_system_outputs
    697.50 ± 10%    +751.8%       5941 ± 13%  fio.time.involuntary_context_switches
     35000 ±  2%     +85.3%      64861 ±  9%  fio.time.minor_page_faults
     19.75 ±  2%   +3984.8%     806.75 ±  2%  fio.time.percent_of_cpu_this_job_got
     27.40 ±  2%   +5046.0%       1410 ±  2%  fio.time.system_time
     13.58 ±  4%   +1448.1%     210.31 ±  2%  fio.time.user_time
     58660 ±  1%    +880.4%     575084 ±  1%  fio.time.voluntary_context_switches
     12.00 ±  5%     +25.0%      15.00 ±  4%  fio.write_clat_90%_us
     35088 ±126%     -99.9%      31.50 ±  4%  fio.write_clat_99%_us
      1692 ±  0%     -97.6%      40.74 ±  1%  fio.write_clat_mean_us
     17029 ±  1%     -93.8%       1058 ±  0%  fio.write_clat_stddev
     53709 ±  8%    +262.8%     194831 ±  5%  softirqs.RCU
    131442 ± 21%    +103.9%     267986 ±  1%  softirqs.SCHED
    564652 ±  0%    +160.4%    1470111 ±  1%  softirqs.TIMER
      7.64 ±  1%    +202.8%      23.14 ±  1%  turbostat.%Busy
    160.00 ±  1%    +119.7%     351.50 ±  1%  turbostat.Avg_MHz
      2093 ±  0%     -27.5%       1518 ±  0%  turbostat.Bzy_MHz
     33.02 ±  8%     -21.7%      25.84 ± 15%  turbostat.CPU%c3
     27.55 ±  3%     -36.9%      17.38 ± 24%  turbostat.CPU%c6
    104.45 ±  1%     +10.0%     114.90 ±  1%  turbostat.PkgWatt
     81.34 ±  0%     +44.8%     117.79 ±  0%  turbostat.RAMWatt
    898622 ± 71%   +5898.0%   53899245 ± 30%  numa-numastat.node0.local_node
    266526 ±170%   +6795.0%   18377074 ± 77%  numa-numastat.node0.numa_foreign
    898629 ± 71%   +5897.9%   53899261 ± 30%  numa-numastat.node0.numa_hit
    952875 ± 57%    +971.7%   10212364 ± 77%  numa-numastat.node0.numa_miss
   1759729 ± 31%   +2688.3%   49067006 ± 48%  numa-numastat.node1.local_node
    956501 ± 57%    +966.7%   10203280 ± 77%  numa-numastat.node1.numa_foreign
   1759741 ± 31%   +2688.3%   49067011 ± 48%  numa-numastat.node1.numa_hit
    270153 ±168%   +6699.2%   18368109 ± 77%  numa-numastat.node1.numa_miss
     67997 ±  1%   +4935.1%    3423742 ±  1%  vmstat.io.bo
     19171 ±  0%    +902.5%     192190 ±  0%  vmstat.memory.buff
  12561916 ±  0%    +231.4%   41626714 ±  0%  vmstat.memory.cache
  32814140 ±  0%     -89.1%    3561112 ±  1%  vmstat.memory.free
     27.00 ±  0%     -30.6%      18.75 ±  2%  vmstat.procs.b
      2.00 ±  0%    +425.0%      10.50 ±  4%  vmstat.procs.r
      2267 ±  7%    +425.8%      11922 ±  2%  vmstat.system.cs
     57499 ±  0%      +2.0%      58675 ±  0%  vmstat.system.in
   3757119 ± 10%    +258.1%   13452676 ± 12%  cpuidle.C1-HSW.time
     70143 ± 23%    +684.6%     550376 ±  8%  cpuidle.C1-HSW.usage
 1.719e+08 ± 45%     -73.5%   45531804 ± 32%  cpuidle.C1E-HSW.time
    214536 ± 37%     -51.0%     105146 ± 14%  cpuidle.C1E-HSW.usage
 4.173e+09 ±  6%     -24.9%  3.133e+09 ±  6%  cpuidle.C3-HSW.time
   4335690 ±  6%     -24.1%    3290671 ±  6%  cpuidle.C3-HSW.usage
  6.14e+09 ±  3%      -9.9%  5.529e+09 ±  2%  cpuidle.C6-HSW.time
   6354558 ±  3%      -9.8%    5734069 ±  2%  cpuidle.C6-HSW.usage
      2300 ± 14%    +510.3%      14041 ±  5%  cpuidle.POLL.usage
    164216 ±  1%    +128.1%     374592 ±  1%  meminfo.Active
     59099 ±  2%    +350.9%     266480 ±  1%  meminfo.Active(file)
     19136 ±  0%    +904.0%     192130 ±  0%  meminfo.Buffers
  11734813 ±  0%    +240.2%   39922439 ±  0%  meminfo.Cached
    202840 ±  0%     -76.6%      47427 ±  7%  meminfo.CmaFree
   8241883 ±  0%     -14.8%    7022847 ±  0%  meminfo.Dirty
  11690671 ±  0%    +235.9%   39269224 ±  0%  meminfo.Inactive
  11568749 ±  0%    +238.4%   39147090 ±  0%  meminfo.Inactive(file)
  32820647 ±  0%     -89.1%    3569553 ±  1%  meminfo.MemFree
    820377 ±  0%    +106.7%    1695619 ±  0%  meminfo.SReclaimable
    919835 ±  0%     +95.1%    1794614 ±  0%  meminfo.Slab
    989.25 ± 57%  +57562.5%     570426 ±  0%  meminfo.Unevictable
     71280 ± 25%    +220.1%     228145 ± 33%  numa-meminfo.node0.Active
     29498 ± 24%    +440.1%     159331 ± 41%  numa-meminfo.node0.Active(file)
   5690258 ±  5%    +248.7%   19839495 ±  0%  numa-meminfo.node0.FilePages
   5658227 ±  5%    +242.7%   19392224 ±  0%  numa-meminfo.node0.Inactive
   5571535 ±  5%    +246.5%   19303184 ±  0%  numa-meminfo.node0.Inactive(file)
  16701744 ±  3%     -89.1%    1827775 ±  2%  numa-meminfo.node0.MemFree
   7905066 ±  7%    +188.2%   22779035 ±  0%  numa-meminfo.node0.MemUsed
    235449 ±123%    +278.8%     891948 ± 12%  numa-meminfo.node0.SReclaimable
    288330 ±100%    +228.3%     946566 ± 12%  numa-meminfo.node0.Slab
    467.50 ± 60%  +60926.3%     285297 ±  0%  numa-meminfo.node0.Unevictable
     29610 ± 27%    +260.3%     106675 ± 59%  numa-meminfo.node1.Active(file)
   6066070 ±  5%    +234.0%   20260420 ±  0%  numa-meminfo.node1.FilePages
   6034806 ±  5%    +229.1%   19862918 ±  0%  numa-meminfo.node1.Inactive
   5999586 ±  5%    +230.5%   19829825 ±  0%  numa-meminfo.node1.Inactive(file)
  16116396 ±  4%     -89.1%    1756070 ±  0%  numa-meminfo.node1.MemFree
   8634214 ±  7%    +166.3%   22994540 ±  0%  numa-meminfo.node1.MemUsed
    521.25 ± 60%  +54624.3%     285250 ±  0%  numa-meminfo.node1.Unevictable
   2728768 ±  0%    +259.7%    9814399 ±  0%  slabinfo.buffer_head.active_objs
     69967 ±  0%    +260.0%     251912 ±  0%  slabinfo.buffer_head.active_slabs
   2728768 ±  0%    +260.0%    9824608 ±  0%  slabinfo.buffer_head.num_objs
     69967 ±  0%    +260.0%     251912 ±  0%  slabinfo.buffer_head.num_slabs
    115.25 ± 24%    +785.9%       1021 ±  9%  slabinfo.dquot.active_objs
    115.25 ± 24%    +785.9%       1021 ±  9%  slabinfo.dquot.num_objs
    925018 ±  1%    +162.9%    2432034 ±  0%  slabinfo.ext4_extent_status.active_objs
      9068 ±  1%    +357.6%      41494 ±  1%  slabinfo.ext4_extent_status.active_slabs
    925018 ±  1%    +357.6%    4232438 ±  1%  slabinfo.ext4_extent_status.num_objs
      9068 ±  1%    +357.6%      41494 ±  1%  slabinfo.ext4_extent_status.num_slabs
    149.50 ± 27%    +239.1%     507.00 ± 65%  slabinfo.ext4_io_end.active_objs
    149.50 ± 27%    +239.1%     507.00 ± 65%  slabinfo.ext4_io_end.num_objs
      3009 ± 10%     +53.9%       4631 ±  0%  slabinfo.jbd2_journal_handle.active_objs
      3009 ± 10%     +53.9%       4631 ±  0%  slabinfo.jbd2_journal_handle.num_objs
      1808 ±  9%   +1387.2%      26889 ±  1%  slabinfo.jbd2_journal_head.active_objs
     67.50 ±  4%   +1158.9%     849.75 ±  1%  slabinfo.jbd2_journal_head.active_slabs
      2310 ±  4%   +1151.5%      28909 ±  1%  slabinfo.jbd2_journal_head.num_objs
     67.50 ±  4%   +1158.9%     849.75 ±  1%  slabinfo.jbd2_journal_head.num_slabs
    145655 ±  2%     -77.5%      32809 ±  0%  latency_stats.avg.balance_dirty_pages.balance_dirty_pages_ratelimited.generic_perform_write.__generic_file_write_iter.ext4_file_write_iter.__vfs_write.vfs_write.SyS_write.entry_SYSCALL_64_fastpath
      0.00 ± -1%      +Inf%      40251 ±  5%  latency_stats.avg.jbd2_log_wait_commit.jbd2_log_do_checkpoint.__jbd2_log_wait_for_space.add_transaction_credits.start_this_handle.jbd2__journal_start.__ext4_journal_start_sb.ext4_da_write_begin.generic_perform_write.__generic_file_write_iter.ext4_file_write_iter.__vfs_write
      0.00 ± -1%      +Inf%      40772 ±  4%  latency_stats.avg.jbd2_log_wait_commit.jbd2_log_do_checkpoint.__jbd2_log_wait_for_space.add_transaction_credits.start_this_handle.jbd2__journal_start.__ext4_journal_start_sb.ext4_dirty_inode.__mark_inode_dirty.generic_update_time.file_update_time.__generic_file_write_iter
    245.00 ± 62%  +15014.2%      37029 ± 12%  latency_stats.avg.wait_transaction_locked.add_transaction_credits.start_this_handle.jbd2__journal_start.__ext4_journal_start_sb.ext4_da_write_begin.generic_perform_write.__generic_file_write_iter.ext4_file_write_iter.__vfs_write.vfs_write.SyS_write
    381.50 ± 92%  +17588.2%      67480 ±  8%  latency_stats.avg.wait_transaction_locked.add_transaction_credits.start_this_handle.jbd2__journal_start.__ext4_journal_start_sb.ext4_dirty_inode.__mark_inode_dirty.generic_update_time.file_update_time.__generic_file_write_iter.ext4_file_write_iter.__vfs_write
     37333 ±  2%    +212.4%     116638 ±  1%  latency_stats.hits.balance_dirty_pages.balance_dirty_pages_ratelimited.generic_perform_write.__generic_file_write_iter.ext4_file_write_iter.__vfs_write.vfs_write.SyS_write.entry_SYSCALL_64_fastpath
      0.00 ± -1%      +Inf%     428352 ±  1%  latency_stats.hits.call_rwsem_down_read_failed.ext4_da_get_block_prep.__block_write_begin_int.__block_write_begin.ext4_da_write_begin.generic_perform_write.__generic_file_write_iter.ext4_file_write_iter.__vfs_write.vfs_write.SyS_write.entry_SYSCALL_64_fastpath
     52674 ± 19%    +713.2%     428352 ±  1%  latency_stats.hits.max
     25.25 ±173%  +28336.6%       7180 ± 58%  latency_stats.hits.wait_on_page_bit.__migration_entry_wait.migration_entry_wait.do_swap_page.handle_mm_fault.__do_page_fault.do_page_fault.page_fault
      0.00 ± -1%      +Inf%      52028 ±  3%  latency_stats.max.jbd2_log_wait_commit.jbd2_log_do_checkpoint.__jbd2_log_wait_for_space.add_transaction_credits.start_this_handle.jbd2__journal_start.__ext4_journal_start_sb.ext4_da_write_begin.generic_perform_write.__generic_file_write_iter.ext4_file_write_iter.__vfs_write
      0.00 ± -1%      +Inf%      42916 ± 11%  latency_stats.max.jbd2_log_wait_commit.jbd2_log_do_checkpoint.__jbd2_log_wait_for_space.add_transaction_credits.start_this_handle.jbd2__journal_start.__ext4_journal_start_sb.ext4_dirty_inode.__mark_inode_dirty.generic_update_time.file_update_time.__generic_file_write_iter
    415.25 ± 61%  +50138.4%     208614 ±  6%  latency_stats.max.wait_transaction_locked.add_transaction_credits.start_this_handle.jbd2__journal_start.__ext4_journal_start_sb.ext4_da_write_begin.generic_perform_write.__generic_file_write_iter.ext4_file_write_iter.__vfs_write.vfs_write.SyS_write
    406.25 ± 94%  +49880.9%     203047 ±  8%  latency_stats.max.wait_transaction_locked.add_transaction_credits.start_this_handle.jbd2__journal_start.__ext4_journal_start_sb.ext4_dirty_inode.__mark_inode_dirty.generic_update_time.file_update_time.__generic_file_write_iter.ext4_file_write_iter.__vfs_write
      0.00 ± -1%      +Inf%    1808461 ± 11%  latency_stats.sum.call_rwsem_down_read_failed.ext4_da_get_block_prep.__block_write_begin_int.__block_write_begin.ext4_da_write_begin.generic_perform_write.__generic_file_write_iter.ext4_file_write_iter.__vfs_write.vfs_write.SyS_write.entry_SYSCALL_64_fastpath
      0.00 ± -1%      +Inf%     824147 ± 12%  latency_stats.sum.jbd2_log_wait_commit.jbd2_log_do_checkpoint.__jbd2_log_wait_for_space.add_transaction_credits.start_this_handle.jbd2__journal_start.__ext4_journal_start_sb.ext4_da_write_begin.generic_perform_write.__generic_file_write_iter.ext4_file_write_iter.__vfs_write
      0.00 ± -1%      +Inf%      82526 ± 39%  latency_stats.sum.jbd2_log_wait_commit.jbd2_log_do_checkpoint.__jbd2_log_wait_for_space.add_transaction_credits.start_this_handle.jbd2__journal_start.__ext4_journal_start_sb.ext4_dirty_inode.__mark_inode_dirty.generic_update_time.file_update_time.__generic_file_write_iter
    369.00 ±173%  +74142.4%     273954 ± 68%  latency_stats.sum.wait_on_page_bit.__migration_entry_wait.migration_entry_wait.do_swap_page.handle_mm_fault.__do_page_fault.do_page_fault.page_fault
      1932 ±109%  +6.4e+05%   12442046 ± 18%  latency_stats.sum.wait_transaction_locked.add_transaction_credits.start_this_handle.jbd2__journal_start.__ext4_journal_start_sb.ext4_da_write_begin.generic_perform_write.__generic_file_write_iter.ext4_file_write_iter.__vfs_write.vfs_write.SyS_write
      1112 ± 97%  +1.8e+06%   20573361 ±  7%  latency_stats.sum.wait_transaction_locked.add_transaction_credits.start_this_handle.jbd2__journal_start.__ext4_journal_start_sb.ext4_dirty_inode.__mark_inode_dirty.generic_update_time.file_update_time.__generic_file_write_iter.ext4_file_write_iter.__vfs_write
 8.134e+11 ±  7%     -29.2%   5.76e+11 ±  1%  perf-stat.branch-instructions
      0.07 ±  1%   +2199.3%       1.54 ±  1%  perf-stat.branch-miss-rate%
 5.443e+08 ±  6%   +1528.4%  8.863e+09 ±  1%  perf-stat.branch-misses
      3.32 ±  6%   +1005.8%      36.72 ±  2%  perf-stat.cache-miss-rate%
 1.301e+08 ± 12%   +7830.6%  1.032e+10 ±  1%  perf-stat.cache-misses
 3.903e+09 ±  6%    +620.2%  2.811e+10 ±  1%  perf-stat.cache-references
    446946 ±  5%    +439.6%    2411928 ±  2%  perf-stat.context-switches
  1.89e+12 ±  5%    +118.5%   4.13e+12 ±  1%  perf-stat.cpu-cycles
      8650 ±  7%    +161.0%      22573 ±  8%  perf-stat.cpu-migrations
      0.05 ± 33%   +2689.6%       1.38 ±  7%  perf-stat.dTLB-load-miss-rate%
 3.894e+08 ±  5%   +3138.7%  1.261e+10 ±  6%  perf-stat.dTLB-load-misses
      0.01 ± 59%   +1236.0%       0.14 ± 14%  perf-stat.dTLB-store-miss-rate%
  71487525 ±  3%   +1048.6%  8.211e+08 ± 10%  perf-stat.dTLB-store-misses
     58.98 ±  1%     -45.2%      32.33 ±  1%  perf-stat.iTLB-load-miss-rate%
  81063987 ±  1%     -11.6%   71683301 ±  2%  perf-stat.iTLB-load-misses
  56389233 ±  2%    +166.2%  1.501e+08 ±  3%  perf-stat.iTLB-loads
 4.453e+12 ±  7%     -28.5%  3.184e+12 ±  1%  perf-stat.instructions
     54933 ±  7%     -19.1%      44447 ±  3%  perf-stat.instructions-per-iTLB-miss
      2.35 ±  1%     -67.2%       0.77 ±  2%  perf-stat.ipc
    417970 ±  0%      +7.8%     450558 ±  1%  perf-stat.minor-faults
  47679867 ± 13%  +10402.2%  5.007e+09 ± 15%  perf-stat.node-load-misses
  44725841 ±  6%   +8141.8%  3.686e+09 ± 19%  perf-stat.node-loads
     42.89 ± 15%     +26.5%      54.27 ±  5%  perf-stat.node-store-miss-rate%
  12288499 ± 27%   +4184.3%  5.265e+08 ±  5%  perf-stat.node-store-misses
  15883566 ±  5%   +2695.6%   4.44e+08 ±  7%  perf-stat.node-stores
    417971 ±  0%      +7.8%     450593 ±  1%  perf-stat.page-faults
      7366 ± 24%    +440.8%      39839 ± 41%  numa-vmstat.node0.nr_active_file
   1317901 ±  5%   +1806.1%   25120768 ± 13%  numa-vmstat.node0.nr_dirtied
   1421455 ±  5%    +248.9%    4959834 ±  0%  numa-vmstat.node0.nr_file_pages
   4176580 ±  3%     -89.1%     456964 ±  2%  numa-vmstat.node0.nr_free_pages
   1391778 ±  5%    +246.7%    4825746 ±  0%  numa-vmstat.node0.nr_inactive_file
     58818 ±123%    +279.1%     222990 ± 12%  numa-vmstat.node0.nr_slab_reclaimable
    116.00 ± 60%  +61385.8%      71323 ±  0%  numa-vmstat.node0.nr_unevictable
    328581 ±  4%   +7288.0%   24275709 ± 13%  numa-vmstat.node0.nr_written
      7366 ± 24%    +440.8%      39840 ± 41%  numa-vmstat.node0.nr_zone_active_file
   1391778 ±  5%    +246.7%    4825787 ±  0%  numa-vmstat.node0.nr_zone_inactive_file
    116.00 ± 60%  +61386.0%      71323 ±  0%  numa-vmstat.node0.nr_zone_unevictable
    320855 ±126%   +2018.4%    6796862 ± 81%  numa-vmstat.node0.numa_foreign
    811358 ± 69%   +2361.3%   19970097 ± 36%  numa-vmstat.node0.numa_hit
    811349 ± 69%   +2361.3%   19970080 ± 36%  numa-vmstat.node0.numa_local
    902242 ± 54%    +496.3%    5379824 ± 70%  numa-vmstat.node0.numa_miss
      7395 ± 27%    +260.7%      26675 ± 59%  numa-vmstat.node1.nr_active_file
   1475724 ±  5%   +1764.2%   27510187 ± 12%  numa-vmstat.node1.nr_dirtied
   1515054 ±  5%    +234.3%    5065379 ±  0%  numa-vmstat.node1.nr_file_pages
     50710 ±  0%     -76.1%      12111 ±  8%  numa-vmstat.node1.nr_free_cma
   4030612 ±  4%     -89.1%     438738 ±  0%  numa-vmstat.node1.nr_free_pages
   1498440 ±  5%    +230.9%    4957711 ±  0%  numa-vmstat.node1.nr_inactive_file
    129.75 ± 60%  +54860.9%      71311 ±  0%  numa-vmstat.node1.nr_unevictable
    403988 ±  4%   +6484.2%   26599507 ± 12%  numa-vmstat.node1.nr_written
      7395 ± 27%    +260.7%      26675 ± 59%  numa-vmstat.node1.nr_zone_active_file
   1498440 ±  5%    +230.9%    4957710 ±  0%  numa-vmstat.node1.nr_zone_inactive_file
    129.75 ± 60%  +54860.9%      71311 ±  0%  numa-vmstat.node1.nr_zone_unevictable
    872187 ± 53%    +506.1%    5286095 ± 71%  numa-vmstat.node1.numa_foreign
   1639879 ± 30%   +1191.0%   21171288 ± 43%  numa-vmstat.node1.numa_hit
   1639864 ± 30%   +1191.0%   21171282 ± 43%  numa-vmstat.node1.numa_local
    290798 ±150%   +2205.1%    6703187 ± 82%  numa-vmstat.node1.numa_miss
     14775 ±  2%    +351.0%      66631 ±  1%  proc-vmstat.nr_active_file
   3314070 ±  0%   +3927.8%  1.335e+08 ±  1%  proc-vmstat.nr_dirtied
   2060410 ±  0%     -14.8%    1755444 ±  0%  proc-vmstat.nr_dirty
   2938721 ±  0%    +241.3%   10029056 ±  0%  proc-vmstat.nr_file_pages
     50710 ±  0%     -76.5%      11910 ±  8%  proc-vmstat.nr_free_cma
   8204888 ±  0%     -89.1%     891960 ±  1%  proc-vmstat.nr_free_pages
   2892431 ±  0%    +238.4%    9787283 ±  0%  proc-vmstat.nr_inactive_file
    205104 ±  0%    +106.7%     423919 ±  0%  proc-vmstat.nr_slab_reclaimable
    247.25 ± 57%  +57596.0%     142653 ±  0%  proc-vmstat.nr_unevictable
   1398737 ±  1%   +9324.0%  1.318e+08 ±  1%  proc-vmstat.nr_written
     14775 ±  2%    +351.0%      66633 ±  1%  proc-vmstat.nr_zone_active_file
   2892431 ±  0%    +238.4%    9787320 ±  0%  proc-vmstat.nr_zone_inactive_file
    247.25 ± 57%  +57596.1%     142653 ±  0%  proc-vmstat.nr_zone_unevictable
   2060409 ±  0%     -14.8%    1755458 ±  0%  proc-vmstat.nr_zone_write_pending
   1223028 ±  9%   +2245.9%   28690632 ± 30%  proc-vmstat.numa_foreign
    282.75 ±109%   +8696.6%      24872 ± 11%  proc-vmstat.numa_hint_faults
     82.00 ± 56%  +23385.1%      19257 ± 13%  proc-vmstat.numa_hint_faults_local
   2660314 ±  3%   +3794.0%  1.036e+08 ± 10%  proc-vmstat.numa_hit
   2660293 ±  3%   +3794.0%  1.036e+08 ± 10%  proc-vmstat.numa_local
   1223028 ±  9%   +2245.9%   28690610 ± 30%  proc-vmstat.numa_miss
    195.75 ±143%    +693.5%       1553 ± 22%  proc-vmstat.numa_pages_migrated
      1185 ±115%   +2435.2%      30048 ± 10%  proc-vmstat.numa_pte_updates
      2845 ±  6%     +57.4%       4479 ± 13%  proc-vmstat.pgactivate
      0.00 ±  0%      +Inf%    5194751 ± 13%  proc-vmstat.pgalloc_dma32
   4015781 ±  0%   +3068.0%  1.272e+08 ±  1%  proc-vmstat.pgalloc_normal
    443537 ±  0%  +27265.1%  1.214e+08 ±  1%  proc-vmstat.pgfree
      0.75 ±173%  +16200.0%     122.25 ± 42%  proc-vmstat.pgmigrate_fail
    195.75 ±143%    +693.5%       1553 ± 22%  proc-vmstat.pgmigrate_success
  13772223 ±  1%   +4931.5%   6.93e+08 ±  1%  proc-vmstat.pgpgout
    364.25 ± 57%  +46700.3%     170470 ±  0%  proc-vmstat.unevictable_pgs_culled
      3771 ±  0%    +283.2%      14453 ±  1%  sched_debug.cfs_rq:/.exec_clock.avg
    123.31 ± 22%    +863.5%       1188 ± 30%  sched_debug.cfs_rq:/.exec_clock.min
     15977 ±  4%     -28.2%      11469 ± 17%  sched_debug.cfs_rq:/.exec_clock.stddev
     41685 ±  1%    +345.4%     185655 ±  7%  sched_debug.cfs_rq:/.load.avg
    161304 ±  1%     +95.9%     315971 ±  4%  sched_debug.cfs_rq:/.load.stddev
     32.87 ±  4%    +435.3%     175.97 ±  6%  sched_debug.cfs_rq:/.load_avg.avg
    157.72 ±  7%     +28.4%     202.48 ±  3%  sched_debug.cfs_rq:/.load_avg.stddev
     18584 ± 14%     +47.5%      27418 ±  5%  sched_debug.cfs_rq:/.min_vruntime.avg
     16749 ±  3%     -28.6%      11963 ± 16%  sched_debug.cfs_rq:/.min_vruntime.stddev
      0.10 ± 17%    +136.0%       0.23 ±  6%  sched_debug.cfs_rq:/.nr_running.avg
      0.29 ±  6%     +43.8%       0.41 ±  3%  sched_debug.cfs_rq:/.nr_running.stddev
     29.02 ±  1%    +220.3%      92.95 ±  9%  sched_debug.cfs_rq:/.runnable_load_avg.avg
    141.32 ±  0%     +35.8%     191.91 ±  4%  sched_debug.cfs_rq:/.runnable_load_avg.stddev
     83254 ±  2%     -38.9%      50853 ± 35%  sched_debug.cfs_rq:/.spread0.max
    -12291 ±-14%     +72.7%     -21225 ±-23%  sched_debug.cfs_rq:/.spread0.min
     16749 ±  3%     -28.6%      11966 ± 16%  sched_debug.cfs_rq:/.spread0.stddev
    185.76 ±  4%     +85.4%     344.36 ±  2%  sched_debug.cfs_rq:/.util_avg.avg
    158.08 ±  1%     +37.9%     217.92 ±  3%  sched_debug.cfs_rq:/.util_avg.stddev
    182455 ±  4%     +24.2%     226649 ± 10%  sched_debug.cpu.avg_idle.stddev
      5.84 ±  8%    +163.5%      15.38 ±  7%  sched_debug.cpu.clock.stddev
      5.84 ±  8%    +163.5%      15.38 ±  7%  sched_debug.cpu.clock_task.stddev
     28.76 ±  1%    +216.9%      91.13 ± 11%  sched_debug.cpu.cpu_load[0].avg
    141.31 ±  0%     +35.0%     190.72 ±  5%  sched_debug.cpu.cpu_load[0].stddev
     29.02 ±  1%    +352.8%     131.42 ± 15%  sched_debug.cpu.cpu_load[1].avg
    141.76 ±  0%     +41.5%     200.56 ±  5%  sched_debug.cpu.cpu_load[1].stddev
     28.81 ±  1%    +343.7%     127.84 ± 15%  sched_debug.cpu.cpu_load[2].avg
    141.36 ±  0%     +39.6%     197.31 ±  5%  sched_debug.cpu.cpu_load[2].stddev
     28.54 ±  1%    +324.6%     121.20 ± 15%  sched_debug.cpu.cpu_load[3].avg
    141.27 ±  0%     +35.5%     191.48 ±  5%  sched_debug.cpu.cpu_load[3].stddev
     28.22 ±  0%    +299.2%     112.65 ± 16%  sched_debug.cpu.cpu_load[4].avg
    141.27 ±  0%     +29.2%     182.54 ±  6%  sched_debug.cpu.cpu_load[4].stddev
    191.26 ± 18%    +141.2%     461.32 ±  7%  sched_debug.cpu.curr->pid.avg
    676.82 ± 11%     +35.3%     915.48 ±  5%  sched_debug.cpu.curr->pid.stddev
     43084 ±  5%    +336.3%     187993 ±  7%  sched_debug.cpu.load.avg
    164119 ±  2%     +93.1%     316944 ±  5%  sched_debug.cpu.load.stddev
      0.00 ±  9%     +52.3%       0.00 ±  2%  sched_debug.cpu.next_balance.stddev
     22918 ± 44%     +69.8%      38923 ±  1%  sched_debug.cpu.nr_load_updates.avg
      8553 ± 24%    +140.5%      20569 ± 24%  sched_debug.cpu.nr_load_updates.min
     14186 ± 11%     -36.9%       8947 ± 13%  sched_debug.cpu.nr_load_updates.stddev
      0.11 ± 20%    +112.0%       0.24 ±  7%  sched_debug.cpu.nr_running.avg
      0.32 ± 11%     +28.4%       0.41 ±  4%  sched_debug.cpu.nr_running.stddev
      5869 ±  5%    +320.3%      24672 ±  2%  sched_debug.cpu.nr_switches.avg
     29766 ± 33%    +538.3%     190010 ± 25%  sched_debug.cpu.nr_switches.max
      1914 ±  4%    +110.7%       4034 ± 27%  sched_debug.cpu.nr_switches.min
      4636 ± 27%    +560.1%      30603 ± 23%  sched_debug.cpu.nr_switches.stddev
      0.39 ±  1%     -33.8%       0.26 ±  5%  sched_debug.cpu.nr_uninterruptible.avg
     13.12 ± 18%    +116.2%      28.38 ± 24%  sched_debug.cpu.nr_uninterruptible.max
    -15.00 ±-30%    +110.8%     -31.62 ±-22%  sched_debug.cpu.nr_uninterruptible.min
      4.87 ± 14%    +163.9%      12.86 ± 27%  sched_debug.cpu.nr_uninterruptible.stddev
      3796 ±  9%    +494.6%      22569 ±  2%  sched_debug.cpu.sched_count.avg
     26488 ± 37%    +606.2%     187066 ± 26%  sched_debug.cpu.sched_count.max
    190.62 ± 24%   +1031.8%       2157 ± 55%  sched_debug.cpu.sched_count.min
      4339 ± 30%    +601.8%      30453 ± 23%  sched_debug.cpu.sched_count.stddev
      1804 ±  9%    +514.1%      11080 ±  2%  sched_debug.cpu.sched_goidle.avg
     13206 ± 37%    +606.5%      93305 ± 26%  sched_debug.cpu.sched_goidle.max
     45.06 ± 16%   +2154.2%       1015 ± 59%  sched_debug.cpu.sched_goidle.min
      2184 ± 30%    +595.6%      15196 ± 23%  sched_debug.cpu.sched_goidle.stddev
      1822 ±  9%    +515.7%      11222 ±  2%  sched_debug.cpu.ttwu_count.avg
     15326 ± 33%    +524.9%      95775 ± 19%  sched_debug.cpu.ttwu_count.max
     66.31 ± 22%   +1399.6%     994.44 ± 71%  sched_debug.cpu.ttwu_count.min
      2476 ± 28%    +538.9%      15824 ± 16%  sched_debug.cpu.ttwu_count.stddev
      1013 ±  0%     +78.4%       1807 ±  0%  sched_debug.cpu.ttwu_local.avg
      7952 ± 25%     -43.3%       4512 ± 29%  sched_debug.cpu.ttwu_local.max
     35.31 ± 23%    +506.5%     214.19 ± 50%  sched_debug.cpu.ttwu_local.min
      1311 ± 16%     -32.0%     891.49 ± 15%  sched_debug.cpu.ttwu_local.stddev
      2.58 ±  9%    -100.0%       0.00 ± -1%  perf-profile.calltrace.cycles-pp.___might_sleep.__might_sleep.unmap_underlying_metadata.ext4_ext_map_blocks.ext4_map_blocks
      1.32 ± 10%    -100.0%       0.00 ± -1%  perf-profile.calltrace.cycles-pp.___might_sleep.unmap_underlying_metadata.ext4_ext_map_blocks.ext4_map_blocks.ext4_writepages
      0.00 ± -1%      +Inf%       0.93 ±  4%  perf-profile.calltrace.cycles-pp.__add_to_page_cache_locked.add_to_page_cache_lru.pagecache_get_page.grab_cache_page_write_begin.ext4_da_write_begin
      0.00 ± -1%      +Inf%       1.43 ± 11%  perf-profile.calltrace.cycles-pp.__alloc_pages_nodemask.alloc_pages_current.__page_cache_alloc.pagecache_get_page.grab_cache_page_write_begin
      0.00 ± -1%      +Inf%       2.30 ±  1%  perf-profile.calltrace.cycles-pp.__block_commit_write.block_write_end.generic_write_end.ext4_da_write_end.generic_perform_write
      0.00 ± -1%      +Inf%      16.00 ±  3%  perf-profile.calltrace.cycles-pp.__block_write_begin.ext4_da_write_begin.generic_perform_write.__generic_file_write_iter.ext4_file_write_iter
      0.00 ± -1%      +Inf%      15.98 ±  3%  perf-profile.calltrace.cycles-pp.__block_write_begin_int.__block_write_begin.ext4_da_write_begin.generic_perform_write.__generic_file_write_iter
      0.00 ± -1%      +Inf%       4.97 ±  3%  perf-profile.calltrace.cycles-pp.__copy_user_nocache.pmem_do_bvec.pmem_make_request.generic_make_request.submit_bio
      0.00 ± -1%      +Inf%       2.29 ±  3%  perf-profile.calltrace.cycles-pp.__delete_from_page_cache.__remove_mapping.shrink_page_list.shrink_inactive_list.shrink_node_memcg
      0.00 ± -1%      +Inf%       2.38 ±  6%  perf-profile.calltrace.cycles-pp.__es_insert_extent.ext4_es_insert_extent.ext4_da_get_block_prep.__block_write_begin_int.__block_write_begin
      0.00 ± -1%      +Inf%       1.03 ±  5%  perf-profile.calltrace.cycles-pp.__es_tree_search.ext4_es_insert_extent.ext4_da_get_block_prep.__block_write_begin_int.__block_write_begin
      0.00 ± -1%      +Inf%       1.76 ±  6%  perf-profile.calltrace.cycles-pp.__ext4_journal_start_sb.ext4_da_write_begin.generic_perform_write.__generic_file_write_iter.ext4_file_write_iter
      0.00 ± -1%      +Inf%       3.23 ±  3%  perf-profile.calltrace.cycles-pp.__find_get_block.__getblk_gfp.__read_extent_tree_block.ext4_find_extent.ext4_ext_map_blocks
      0.00 ± -1%      +Inf%       1.70 ±  3%  perf-profile.calltrace.cycles-pp.__find_get_block_slow.__find_get_block.__getblk_gfp.__read_extent_tree_block.ext4_find_extent
     35.05 ±  7%    -100.0%       0.00 ± -1%  perf-profile.calltrace.cycles-pp.__find_get_block_slow.unmap_underlying_metadata.ext4_ext_map_blocks.ext4_map_blocks.ext4_writepages
      0.00 ± -1%      +Inf%      30.01 ±  3%  perf-profile.calltrace.cycles-pp.__generic_file_write_iter.ext4_file_write_iter.__vfs_write.vfs_write.sys_write
      0.00 ± -1%      +Inf%       3.42 ±  3%  perf-profile.calltrace.cycles-pp.__getblk_gfp.__read_extent_tree_block.ext4_find_extent.ext4_ext_map_blocks.ext4_da_get_block_prep
      1.32 ±  5%    -100.0%       0.00 ± -1%  perf-profile.calltrace.cycles-pp.__might_sleep.ext4_ext_map_blocks.ext4_map_blocks.ext4_writepages.do_writepages
      4.51 ±  9%    -100.0%       0.00 ± -1%  perf-profile.calltrace.cycles-pp.__might_sleep.unmap_underlying_metadata.ext4_ext_map_blocks.ext4_map_blocks.ext4_writepages
      0.00 ± -1%      +Inf%       1.56 ± 11%  perf-profile.calltrace.cycles-pp.__page_cache_alloc.pagecache_get_page.grab_cache_page_write_begin.ext4_da_write_begin.generic_perform_write
      0.00 ± -1%      +Inf%       2.00 ±  4%  perf-profile.calltrace.cycles-pp.__radix_tree_lookup.__delete_from_page_cache.__remove_mapping.shrink_page_list.shrink_inactive_list
     15.27 ±  6%     -95.3%       0.73 ±  5%  perf-profile.calltrace.cycles-pp.__radix_tree_lookup.radix_tree_lookup_slot.find_get_entry.pagecache_get_page.__find_get_block_slow
      0.00 ± -1%      +Inf%       1.62 ±  4%  perf-profile.calltrace.cycles-pp.__radix_tree_lookup.radix_tree_lookup_slot.find_get_entry.pagecache_get_page.grab_cache_page_write_begin
      0.00 ± -1%      +Inf%       3.56 ±  3%  perf-profile.calltrace.cycles-pp.__read_extent_tree_block.ext4_find_extent.ext4_ext_map_blocks.ext4_da_get_block_prep.__block_write_begin_int
      0.00 ± -1%      +Inf%       2.90 ±  3%  perf-profile.calltrace.cycles-pp.__remove_mapping.shrink_page_list.shrink_inactive_list.shrink_node_memcg.shrink_node
      0.00 ± -1%      +Inf%       1.27 ±  2%  perf-profile.calltrace.cycles-pp.__set_page_dirty.mark_buffer_dirty.__block_commit_write.block_write_end.generic_write_end
      0.00 ± -1%      +Inf%       0.96 ±  9%  perf-profile.calltrace.cycles-pp.__test_set_page_writeback.ext4_bio_write_page.mpage_submit_page.mpage_process_page_bufs.mpage_prepare_extent_to_map
      0.82 ± 14%    -100.0%       0.00 ± -1%  perf-profile.calltrace.cycles-pp.__tick_nohz_idle_enter.tick_nohz_irq_exit.irq_exit.smp_apic_timer_interrupt.apic_timer_interrupt
      0.00 ± -1%      +Inf%      30.45 ±  3%  perf-profile.calltrace.cycles-pp.__vfs_write.vfs_write.sys_write.entry_SYSCALL_64_fastpath
     51.11 ±  7%     -65.2%      17.80 ±  2%  perf-profile.calltrace.cycles-pp.__writeback_inodes_wb.wb_writeback.wb_workfn.process_one_work.worker_thread
     51.11 ±  7%     -65.2%      17.80 ±  2%  perf-profile.calltrace.cycles-pp.__writeback_single_inode.writeback_sb_inodes.__writeback_inodes_wb.wb_writeback.wb_workfn
      0.00 ± -1%      +Inf%       1.77 ±  5%  perf-profile.calltrace.cycles-pp.add_to_page_cache_lru.pagecache_get_page.grab_cache_page_write_begin.ext4_da_write_begin.generic_perform_write
      0.00 ± -1%      +Inf%       1.53 ± 10%  perf-profile.calltrace.cycles-pp.alloc_pages_current.__page_cache_alloc.pagecache_get_page.grab_cache_page_write_begin.ext4_da_write_begin
      2.79 ± 16%     -83.8%       0.45 ± 62%  perf-profile.calltrace.cycles-pp.apic_timer_interrupt.cpuidle_enter.call_cpuidle.cpu_startup_entry.start_secondary
      0.00 ± -1%      +Inf%       2.42 ±  3%  perf-profile.calltrace.cycles-pp.bio_endio.pmem_make_request.generic_make_request.submit_bio.ext4_io_submit
      0.00 ± -1%      +Inf%       2.35 ±  1%  perf-profile.calltrace.cycles-pp.block_write_end.generic_write_end.ext4_da_write_end.generic_perform_write.__generic_file_write_iter
      0.00 ± -1%      +Inf%       2.19 ±  2%  perf-profile.calltrace.cycles-pp.copy_user_enhanced_fast_string.generic_perform_write.__generic_file_write_iter.ext4_file_write_iter.__vfs_write
     51.11 ±  7%     -65.2%      17.80 ±  2%  perf-profile.calltrace.cycles-pp.do_writepages.__writeback_single_inode.writeback_sb_inodes.__writeback_inodes_wb.wb_writeback
      0.00 ± -1%      +Inf%       1.04 ±  4%  perf-profile.calltrace.cycles-pp.end_page_writeback.ext4_finish_bio.ext4_end_bio.bio_endio.pmem_make_request
      0.48 ± 58%   +6534.9%      31.85 ±  3%  perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_fastpath
      0.00 ± -1%      +Inf%       1.03 ±  2%  perf-profile.calltrace.cycles-pp.ext4_bio_write_page.mpage_submit_page.mpage_map_and_submit_buffers.ext4_writepages.do_writepages
      0.00 ± -1%      +Inf%       9.22 ±  3%  perf-profile.calltrace.cycles-pp.ext4_bio_write_page.mpage_submit_page.mpage_process_page_bufs.mpage_prepare_extent_to_map.ext4_writepages
      0.00 ± -1%      +Inf%      14.90 ±  3%  perf-profile.calltrace.cycles-pp.ext4_da_get_block_prep.__block_write_begin_int.__block_write_begin.ext4_da_write_begin.generic_perform_write
      0.00 ± -1%      +Inf%      23.29 ±  4%  perf-profile.calltrace.cycles-pp.ext4_da_write_begin.generic_perform_write.__generic_file_write_iter.ext4_file_write_iter.__vfs_write
      0.00 ± -1%      +Inf%       3.61 ±  1%  perf-profile.calltrace.cycles-pp.ext4_da_write_end.generic_perform_write.__generic_file_write_iter.ext4_file_write_iter.__vfs_write
      0.00 ± -1%      +Inf%       1.53 ±  3%  perf-profile.calltrace.cycles-pp.ext4_end_bio.bio_endio.pmem_make_request.generic_make_request.submit_bio
      0.00 ± -1%      +Inf%       3.80 ±  5%  perf-profile.calltrace.cycles-pp.ext4_es_insert_extent.ext4_da_get_block_prep.__block_write_begin_int.__block_write_begin.ext4_da_write_begin
      0.00 ± -1%      +Inf%       4.19 ±  4%  perf-profile.calltrace.cycles-pp.ext4_es_lookup_extent.ext4_da_get_block_prep.__block_write_begin_int.__block_write_begin.ext4_da_write_begin
      0.00 ± -1%      +Inf%       6.14 ±  3%  perf-profile.calltrace.cycles-pp.ext4_ext_map_blocks.ext4_da_get_block_prep.__block_write_begin_int.__block_write_begin.ext4_da_write_begin
     49.67 ±  7%     -97.1%       1.42 ±  2%  perf-profile.calltrace.cycles-pp.ext4_ext_map_blocks.ext4_map_blocks.ext4_writepages.do_writepages.__writeback_single_inode
      0.00 ± -1%      +Inf%      30.29 ±  3%  perf-profile.calltrace.cycles-pp.ext4_file_write_iter.__vfs_write.vfs_write.sys_write.entry_SYSCALL_64_fastpath
      0.00 ± -1%      +Inf%       5.73 ±  3%  perf-profile.calltrace.cycles-pp.ext4_find_extent.ext4_ext_map_blocks.ext4_da_get_block_prep.__block_write_begin_int.__block_write_begin
      0.00 ± -1%      +Inf%       1.33 ±  4%  perf-profile.calltrace.cycles-pp.ext4_finish_bio.ext4_end_bio.bio_endio.pmem_make_request.generic_make_request
      0.00 ± -1%      +Inf%       7.16 ±  2%  perf-profile.calltrace.cycles-pp.ext4_io_submit.ext4_bio_write_page.mpage_submit_page.mpage_process_page_bufs.mpage_prepare_extent_to_map
      0.00 ± -1%      +Inf%       1.17 ±  1%  perf-profile.calltrace.cycles-pp.ext4_io_submit.ext4_writepages.do_writepages.__writeback_single_inode.writeback_sb_inodes
     50.46 ±  7%     -95.1%       2.46 ±  2%  perf-profile.calltrace.cycles-pp.ext4_map_blocks.ext4_writepages.do_writepages.__writeback_single_inode.writeback_sb_inodes
      0.00 ± -1%      +Inf%       0.88 ± 13%  perf-profile.calltrace.cycles-pp.ext4_put_io_end_defer.bio_endio.pmem_make_request.generic_make_request.submit_bio
      0.00 ± -1%      +Inf%       1.18 ±  2%  perf-profile.calltrace.cycles-pp.ext4_releasepage.try_to_release_page.shrink_page_list.shrink_inactive_list.shrink_node_memcg
     51.11 ±  7%     -65.3%      17.72 ±  2%  perf-profile.calltrace.cycles-pp.ext4_writepages.do_writepages.__writeback_single_inode.writeback_sb_inodes.__writeback_inodes_wb
      1.32 ±  6%    -100.0%       0.00 ± -1%  perf-profile.calltrace.cycles-pp.find_get_entry.__find_get_block_slow.unmap_underlying_metadata.ext4_ext_map_blocks.ext4_map_blocks
      0.00 ± -1%      +Inf%       1.32 ±  2%  perf-profile.calltrace.cycles-pp.find_get_entry.pagecache_get_page.__find_get_block_slow.__find_get_block.__getblk_gfp
     21.16 ±  6%    -100.0%       0.00 ± -1%  perf-profile.calltrace.cycles-pp.find_get_entry.pagecache_get_page.__find_get_block_slow.unmap_underlying_metadata.ext4_ext_map_blocks
      0.00 ± -1%      +Inf%       1.66 ±  5%  perf-profile.calltrace.cycles-pp.find_get_entry.pagecache_get_page.grab_cache_page_write_begin.ext4_da_write_begin.generic_perform_write
      0.00 ± -1%      +Inf%       0.98 ±  2%  perf-profile.calltrace.cycles-pp.find_get_pages_tag.pagevec_lookup_tag.mpage_prepare_extent_to_map.ext4_writepages.do_writepages
      0.00 ± -1%      +Inf%       7.88 ±  2%  perf-profile.calltrace.cycles-pp.generic_make_request.submit_bio.ext4_io_submit.ext4_bio_write_page.mpage_submit_page
      0.00 ± -1%      +Inf%       1.16 ±  1%  perf-profile.calltrace.cycles-pp.generic_make_request.submit_bio.ext4_io_submit.ext4_writepages.do_writepages
      0.00 ± -1%      +Inf%      29.66 ±  3%  perf-profile.calltrace.cycles-pp.generic_perform_write.__generic_file_write_iter.ext4_file_write_iter.__vfs_write.vfs_write
      0.00 ± -1%      +Inf%       2.72 ±  2%  perf-profile.calltrace.cycles-pp.generic_write_end.ext4_da_write_end.generic_perform_write.__generic_file_write_iter.ext4_file_write_iter
      0.00 ± -1%      +Inf%       1.16 ± 10%  perf-profile.calltrace.cycles-pp.get_page_from_freelist.__alloc_pages_nodemask.alloc_pages_current.__page_cache_alloc.pagecache_get_page
      0.00 ± -1%      +Inf%       5.13 ±  7%  perf-profile.calltrace.cycles-pp.grab_cache_page_write_begin.ext4_da_write_begin.generic_perform_write.__generic_file_write_iter.ext4_file_write_iter
      1.02 ± 20%    -100.0%       0.00 ± -1%  perf-profile.calltrace.cycles-pp.hrtimer_interrupt.local_apic_timer_interrupt.smp_apic_timer_interrupt.apic_timer_interrupt.cpuidle_enter
      1.04 ± 11%    -100.0%       0.00 ± -1%  perf-profile.calltrace.cycles-pp.irq_exit.smp_apic_timer_interrupt.apic_timer_interrupt.cpuidle_enter.call_cpuidle
      0.00 ± -1%      +Inf%       1.44 ±  5%  perf-profile.calltrace.cycles-pp.jbd2__journal_start.__ext4_journal_start_sb.ext4_da_write_begin.generic_perform_write.__generic_file_write_iter
      0.00 ± -1%      +Inf%       1.11 ±  2%  perf-profile.calltrace.cycles-pp.jbd2_journal_try_to_free_buffers.ext4_releasepage.try_to_release_page.shrink_page_list.shrink_inactive_list
      0.00 ± -1%      +Inf%       6.87 ±  1%  perf-profile.calltrace.cycles-pp.kswapd.kthread.ret_from_fork
     51.25 ±  7%     -51.4%      24.89 ±  1%  perf-profile.calltrace.cycles-pp.kthread.ret_from_fork
      1.08 ± 19%    -100.0%       0.00 ± -1%  perf-profile.calltrace.cycles-pp.local_apic_timer_interrupt.smp_apic_timer_interrupt.apic_timer_interrupt.cpuidle_enter.call_cpuidle
      0.00 ± -1%      +Inf%       1.65 ±  2%  perf-profile.calltrace.cycles-pp.mark_buffer_dirty.__block_commit_write.block_write_end.generic_write_end.ext4_da_write_end
      0.00 ± -1%      +Inf%       1.80 ±  1%  perf-profile.calltrace.cycles-pp.mpage_map_and_submit_buffers.ext4_writepages.do_writepages.__writeback_single_inode.writeback_sb_inodes
      0.00 ± -1%      +Inf%      11.87 ±  2%  perf-profile.calltrace.cycles-pp.mpage_prepare_extent_to_map.ext4_writepages.do_writepages.__writeback_single_inode.writeback_sb_inodes
      0.00 ± -1%      +Inf%      10.50 ±  3%  perf-profile.calltrace.cycles-pp.mpage_process_page_bufs.mpage_prepare_extent_to_map.ext4_writepages.do_writepages.__writeback_single_inode
      0.00 ± -1%      +Inf%       1.11 ±  1%  perf-profile.calltrace.cycles-pp.mpage_submit_page.mpage_map_and_submit_buffers.ext4_writepages.do_writepages.__writeback_single_inode
      0.00 ± -1%      +Inf%       9.77 ±  3%  perf-profile.calltrace.cycles-pp.mpage_submit_page.mpage_process_page_bufs.mpage_prepare_extent_to_map.ext4_writepages.do_writepages
      0.00 ± -1%      +Inf%       1.39 ±  2%  perf-profile.calltrace.cycles-pp.pagecache_get_page.__find_get_block_slow.__find_get_block.__getblk_gfp.__read_extent_tree_block
     27.73 ±  7%    -100.0%       0.00 ± -1%  perf-profile.calltrace.cycles-pp.pagecache_get_page.__find_get_block_slow.unmap_underlying_metadata.ext4_ext_map_blocks.ext4_map_blocks
      0.00 ± -1%      +Inf%       5.07 ±  6%  perf-profile.calltrace.cycles-pp.pagecache_get_page.grab_cache_page_write_begin.ext4_da_write_begin.generic_perform_write.__generic_file_write_iter
      0.00 ± -1%      +Inf%       0.98 ±  3%  perf-profile.calltrace.cycles-pp.pagevec_lookup_tag.mpage_prepare_extent_to_map.ext4_writepages.do_writepages.__writeback_single_inode
      0.00 ± -1%      +Inf%       5.05 ±  3%  perf-profile.calltrace.cycles-pp.pmem_do_bvec.pmem_make_request.generic_make_request.submit_bio.ext4_io_submit
      0.00 ± -1%      +Inf%       7.58 ±  2%  perf-profile.calltrace.cycles-pp.pmem_make_request.generic_make_request.submit_bio.ext4_io_submit.ext4_bio_write_page
      0.00 ± -1%      +Inf%       1.13 ±  1%  perf-profile.calltrace.cycles-pp.pmem_make_request.generic_make_request.submit_bio.ext4_io_submit.ext4_writepages
     51.22 ±  7%     -65.1%      17.86 ±  2%  perf-profile.calltrace.cycles-pp.process_one_work.worker_thread.kthread.ret_from_fork
     17.22 ±  6%    -100.0%       0.00 ± -1%  perf-profile.calltrace.cycles-pp.radix_tree_lookup_slot.find_get_entry.pagecache_get_page.__find_get_block_slow.unmap_underlying_metadata
      0.00 ± -1%      +Inf%       1.64 ±  4%  perf-profile.calltrace.cycles-pp.radix_tree_lookup_slot.find_get_entry.pagecache_get_page.grab_cache_page_write_begin.ext4_da_write_begin
     51.25 ±  7%     -51.4%      24.89 ±  1%  perf-profile.calltrace.cycles-pp.ret_from_fork
      0.00 ± -1%      +Inf%       5.95 ±  1%  perf-profile.calltrace.cycles-pp.shrink_inactive_list.shrink_node_memcg.shrink_node.kswapd.kthread
      0.00 ± -1%      +Inf%       6.86 ±  1%  perf-profile.calltrace.cycles-pp.shrink_node.kswapd.kthread.ret_from_fork
      0.00 ± -1%      +Inf%       5.98 ±  1%  perf-profile.calltrace.cycles-pp.shrink_node_memcg.shrink_node.kswapd.kthread.ret_from_fork
      0.00 ± -1%      +Inf%       5.36 ±  1%  perf-profile.calltrace.cycles-pp.shrink_page_list.shrink_inactive_list.shrink_node_memcg.shrink_node.kswapd
      2.73 ± 16%     -88.4%       0.32 ±103%  perf-profile.calltrace.cycles-pp.smp_apic_timer_interrupt.apic_timer_interrupt.cpuidle_enter.call_cpuidle.cpu_startup_entry
      0.00 ± -1%      +Inf%       7.14 ±  2%  perf-profile.calltrace.cycles-pp.submit_bio.ext4_io_submit.ext4_bio_write_page.mpage_submit_page.mpage_process_page_bufs
      0.00 ± -1%      +Inf%       1.17 ±  1%  perf-profile.calltrace.cycles-pp.submit_bio.ext4_io_submit.ext4_writepages.do_writepages.__writeback_single_inode
      0.00 ± -1%      +Inf%      31.25 ±  3%  perf-profile.calltrace.cycles-pp.sys_write.entry_SYSCALL_64_fastpath
      0.83 ± 14%    -100.0%       0.00 ± -1%  perf-profile.calltrace.cycles-pp.tick_nohz_irq_exit.irq_exit.smp_apic_timer_interrupt.apic_timer_interrupt.cpuidle_enter
      0.00 ± -1%      +Inf%       1.20 ±  1%  perf-profile.calltrace.cycles-pp.try_to_release_page.shrink_page_list.shrink_inactive_list.shrink_node_memcg.shrink_node
     45.39 ±  7%    -100.0%       0.00 ± -1%  perf-profile.calltrace.cycles-pp.unmap_underlying_metadata.ext4_ext_map_blocks.ext4_map_blocks.ext4_writepages.do_writepages
      0.00 ± -1%      +Inf%      31.09 ±  3%  perf-profile.calltrace.cycles-pp.vfs_write.sys_write.entry_SYSCALL_64_fastpath
     51.11 ±  7%     -65.2%      17.80 ±  2%  perf-profile.calltrace.cycles-pp.wb_workfn.process_one_work.worker_thread.kthread.ret_from_fork
     51.11 ±  7%     -65.2%      17.80 ±  2%  perf-profile.calltrace.cycles-pp.wb_writeback.wb_workfn.process_one_work.worker_thread.kthread
     51.23 ±  7%     -65.1%      17.86 ±  2%  perf-profile.calltrace.cycles-pp.worker_thread.kthread.ret_from_fork
     51.11 ±  7%     -65.2%      17.80 ±  2%  perf-profile.calltrace.cycles-pp.writeback_sb_inodes.__writeback_inodes_wb.wb_writeback.wb_workfn.process_one_work
      3.93 ±  9%     -88.6%       0.45 ±  6%  perf-profile.children.cycles-pp.___might_sleep
      0.00 ± -1%      +Inf%       0.93 ±  5%  perf-profile.children.cycles-pp.__add_to_page_cache_locked
      0.00 ± -1%      +Inf%       1.46 ± 10%  perf-profile.children.cycles-pp.__alloc_pages_nodemask
      0.04 ± 58%   +5668.8%       2.31 ±  1%  perf-profile.children.cycles-pp.__block_commit_write
      0.07 ± 23%  +24519.2%      16.00 ±  3%  perf-profile.children.cycles-pp.__block_write_begin
      0.07 ± 23%  +24488.5%      15.98 ±  3%  perf-profile.children.cycles-pp.__block_write_begin_int
      0.21 ±  5%   +2617.6%       5.78 ±  2%  perf-profile.children.cycles-pp.__copy_user_nocache
      0.00 ± -1%      +Inf%       2.29 ±  3%  perf-profile.children.cycles-pp.__delete_from_page_cache
      0.05 ± 58%   +5573.7%       2.69 ±  6%  perf-profile.children.cycles-pp.__es_insert_extent
      0.01 ±173%  +10280.0%       1.30 ±  5%  perf-profile.children.cycles-pp.__es_tree_search
      0.04 ±102%   +5485.7%       1.96 ±  6%  perf-profile.children.cycles-pp.__ext4_journal_start_sb
      0.00 ± -1%      +Inf%       3.36 ±  2%  perf-profile.children.cycles-pp.__find_get_block
     35.73 ±  7%     -95.0%       1.80 ±  3%  perf-profile.children.cycles-pp.__find_get_block_slow
      0.33 ± 11%   +8997.0%      30.02 ±  3%  perf-profile.children.cycles-pp.__generic_file_write_iter
      0.00 ± -1%      +Inf%       3.58 ±  3%  perf-profile.children.cycles-pp.__getblk_gfp
      5.86 ±  8%     -89.9%       0.59 ±  4%  perf-profile.children.cycles-pp.__might_sleep
      0.00 ± -1%      +Inf%       1.57 ± 10%  perf-profile.children.cycles-pp.__page_cache_alloc
     15.94 ±  6%     -72.4%       4.41 ±  1%  perf-profile.children.cycles-pp.__radix_tree_lookup
      0.00 ± -1%      +Inf%       3.70 ±  3%  perf-profile.children.cycles-pp.__read_extent_tree_block
      0.00 ± -1%      +Inf%       2.91 ±  3%  perf-profile.children.cycles-pp.__remove_mapping
      0.00 ± -1%      +Inf%       1.28 ±  2%  perf-profile.children.cycles-pp.__set_page_dirty
      0.00 ± -1%      +Inf%       1.11 ±  9%  perf-profile.children.cycles-pp.__test_set_page_writeback
      0.87 ± 13%     -75.4%       0.21 ±  7%  perf-profile.children.cycles-pp.__tick_nohz_idle_enter
      0.42 ±  7%   +7123.1%      30.52 ±  3%  perf-profile.children.cycles-pp.__vfs_write
     51.11 ±  7%     -65.2%      17.80 ±  2%  perf-profile.children.cycles-pp.__writeback_inodes_wb
     51.11 ±  7%     -65.2%      17.80 ±  2%  perf-profile.children.cycles-pp.__writeback_single_inode
      0.09 ± 20%   +1173.0%       1.18 ±  9%  perf-profile.children.cycles-pp._raw_spin_lock_irqsave
      0.00 ± -1%      +Inf%       1.77 ±  5%  perf-profile.children.cycles-pp.add_to_page_cache_lru
      0.00 ± -1%      +Inf%       1.55 ± 10%  perf-profile.children.cycles-pp.alloc_pages_current
      2.98 ± 15%     -69.8%       0.90 ± 10%  perf-profile.children.cycles-pp.apic_timer_interrupt
      0.10 ±  8%   +2990.2%       3.17 ±  2%  perf-profile.children.cycles-pp.bio_endio
      0.03 ±102%   +7750.0%       2.36 ±  1%  perf-profile.children.cycles-pp.block_write_end
     47.10 ±  8%     -10.3%      42.25 ±  3%  perf-profile.children.cycles-pp.call_cpuidle
      0.04 ± 58%   +5393.7%       2.20 ±  2%  perf-profile.children.cycles-pp.copy_user_enhanced_fast_string
     47.72 ±  7%     -10.5%      42.72 ±  3%  perf-profile.children.cycles-pp.cpu_startup_entry
     47.06 ±  8%     -10.2%      42.25 ±  3%  perf-profile.children.cycles-pp.cpuidle_enter
     51.11 ±  7%     -65.2%      17.80 ±  2%  perf-profile.children.cycles-pp.do_writepages
      0.01 ±173%  +10920.0%       1.38 ±  4%  perf-profile.children.cycles-pp.end_page_writeback
      0.73 ±  4%   +4272.0%      32.02 ±  3%  perf-profile.children.cycles-pp.entry_SYSCALL_64_fastpath
      0.06 ± 13%  +16332.0%      10.27 ±  2%  perf-profile.children.cycles-pp.ext4_bio_write_page
      0.03 ±100%  +54100.0%      14.90 ±  3%  perf-profile.children.cycles-pp.ext4_da_get_block_prep
      0.18 ±  8%  +12661.6%      23.29 ±  4%  perf-profile.children.cycles-pp.ext4_da_write_begin
      0.07 ± 19%   +5259.3%       3.62 ±  1%  perf-profile.children.cycles-pp.ext4_da_write_end
      0.06 ± 14%   +3352.2%       1.98 ±  4%  perf-profile.children.cycles-pp.ext4_end_bio
      0.09 ± 18%   +4988.6%       4.45 ±  5%  perf-profile.children.cycles-pp.ext4_es_insert_extent
      0.03 ±100%  +16281.8%       4.50 ±  4%  perf-profile.children.cycles-pp.ext4_es_lookup_extent
     49.67 ±  7%     -84.8%       7.57 ±  3%  perf-profile.children.cycles-pp.ext4_ext_map_blocks
      0.32 ± 11%   +9440.9%      30.29 ±  3%  perf-profile.children.cycles-pp.ext4_file_write_iter
      0.07 ± 12%   +8807.4%       6.01 ±  3%  perf-profile.children.cycles-pp.ext4_find_extent
      0.01 ±173%  +13720.0%       1.73 ±  4%  perf-profile.children.cycles-pp.ext4_finish_bio
      0.27 ±  6%   +3330.2%       9.09 ±  2%  perf-profile.children.cycles-pp.ext4_io_submit
     50.46 ±  7%     -95.1%       2.48 ±  2%  perf-profile.children.cycles-pp.ext4_map_blocks
      0.01 ±173%   +7016.7%       1.07 ± 12%  perf-profile.children.cycles-pp.ext4_put_io_end_defer
      0.00 ± -1%      +Inf%       1.18 ±  2%  perf-profile.children.cycles-pp.ext4_releasepage
     51.11 ±  7%     -65.3%      17.72 ±  2%  perf-profile.children.cycles-pp.ext4_writepages
     22.53 ±  6%     -86.4%       3.07 ±  3%  perf-profile.children.cycles-pp.find_get_entry
      0.08 ±  5%   +1047.1%       0.98 ±  2%  perf-profile.children.cycles-pp.find_get_pages_tag
      0.34 ±  1%   +2691.2%       9.56 ±  2%  perf-profile.children.cycles-pp.generic_make_request
      0.32 ±  8%   +9243.3%      29.67 ±  3%  perf-profile.children.cycles-pp.generic_perform_write
      0.05 ± 62%   +5657.9%       2.73 ±  2%  perf-profile.children.cycles-pp.generic_write_end
      0.00 ± -1%      +Inf%       1.22 ± 10%  perf-profile.children.cycles-pp.get_page_from_freelist
      0.09 ± 16%   +5774.3%       5.14 ±  7%  perf-profile.children.cycles-pp.grab_cache_page_write_begin
      1.17 ± 16%     -61.8%       0.45 ±  8%  perf-profile.children.cycles-pp.hrtimer_interrupt
      1.33 ± 16%     -69.0%       0.41 ± 17%  perf-profile.children.cycles-pp.irq_exit
      0.01 ±173%  +10616.7%       1.61 ±  5%  perf-profile.children.cycles-pp.jbd2__journal_start
      0.00 ± -1%      +Inf%       1.12 ±  2%  perf-profile.children.cycles-pp.jbd2_journal_try_to_free_buffers
      0.00 ± -1%      +Inf%       0.94 ± 15%  perf-profile.children.cycles-pp.kmem_cache_alloc
      0.00 ± -1%      +Inf%       6.87 ±  1%  perf-profile.children.cycles-pp.kswapd
     51.25 ±  7%     -51.4%      24.89 ±  1%  perf-profile.children.cycles-pp.kthread
      1.22 ± 16%     -62.0%       0.46 ±  8%  perf-profile.children.cycles-pp.local_apic_timer_interrupt
      0.00 ± -1%      +Inf%       1.66 ±  2%  perf-profile.children.cycles-pp.mark_buffer_dirty
      0.20 ± 12%    +787.7%       1.80 ±  1%  perf-profile.children.cycles-pp.mpage_map_and_submit_buffers
      0.12 ±  4%   +9394.0%      11.87 ±  2%  perf-profile.children.cycles-pp.mpage_prepare_extent_to_map
      0.00 ± -1%      +Inf%      10.51 ±  3%  perf-profile.children.cycles-pp.mpage_process_page_bufs
      0.07 ± 14%  +14430.0%      10.90 ±  2%  perf-profile.children.cycles-pp.mpage_submit_page
     28.44 ±  7%     -77.0%       6.55 ±  5%  perf-profile.children.cycles-pp.pagecache_get_page
      0.09 ±  9%   +1020.0%       0.98 ±  3%  perf-profile.children.cycles-pp.pagevec_lookup_tag
      0.21 ±  6%   +2634.9%       5.88 ±  2%  perf-profile.children.cycles-pp.pmem_do_bvec
      0.32 ±  2%   +2774.2%       9.20 ±  2%  perf-profile.children.cycles-pp.pmem_make_request
     51.22 ±  7%     -65.1%      17.86 ±  2%  perf-profile.children.cycles-pp.process_one_work
     17.93 ±  6%     -86.3%       2.45 ±  3%  perf-profile.children.cycles-pp.radix_tree_lookup_slot
     51.25 ±  7%     -51.4%      24.89 ±  1%  perf-profile.children.cycles-pp.ret_from_fork
      0.00 ± -1%      +Inf%       5.96 ±  1%  perf-profile.children.cycles-pp.shrink_inactive_list
      0.00 ± -1%      +Inf%       6.86 ±  1%  perf-profile.children.cycles-pp.shrink_node
      0.00 ± -1%      +Inf%       5.98 ±  1%  perf-profile.children.cycles-pp.shrink_node_memcg
      0.00 ± -1%      +Inf%       5.36 ±  1%  perf-profile.children.cycles-pp.shrink_page_list
      2.92 ± 15%     -70.2%       0.87 ± 10%  perf-profile.children.cycles-pp.smp_apic_timer_interrupt
      0.34 ±  1%   +2701.5%       9.59 ±  2%  perf-profile.children.cycles-pp.submit_bio
      0.45 ±  8%   +6782.4%      31.31 ±  3%  perf-profile.children.cycles-pp.sys_write
      0.00 ± -1%      +Inf%       1.15 ±  4%  perf-profile.children.cycles-pp.test_clear_page_writeback
      0.87 ± 13%     -80.8%       0.17 ± 11%  perf-profile.children.cycles-pp.tick_nohz_irq_exit
      0.00 ± -1%      +Inf%       1.21 ±  1%  perf-profile.children.cycles-pp.try_to_release_page
     46.07 ±  7%     -99.9%       0.06 ± 11%  perf-profile.children.cycles-pp.unmap_underlying_metadata
      0.45 ±  8%   +6824.4%      31.16 ±  3%  perf-profile.children.cycles-pp.vfs_write
     51.11 ±  7%     -65.2%      17.80 ±  2%  perf-profile.children.cycles-pp.wb_workfn
     51.11 ±  7%     -65.2%      17.80 ±  2%  perf-profile.children.cycles-pp.wb_writeback
     51.23 ±  7%     -65.1%      17.86 ±  2%  perf-profile.children.cycles-pp.worker_thread
     51.11 ±  7%     -65.2%      17.80 ±  2%  perf-profile.children.cycles-pp.writeback_sb_inodes
      3.93 ±  9%     -88.6%       0.45 ±  6%  perf-profile.self.cycles-pp.___might_sleep
      0.21 ±  5%   +2617.6%       5.78 ±  2%  perf-profile.self.cycles-pp.__copy_user_nocache
      0.00 ± -1%      +Inf%       1.31 ±  5%  perf-profile.self.cycles-pp.__es_insert_extent
      0.01 ±173%   +9320.0%       1.18 ±  5%  perf-profile.self.cycles-pp.__es_tree_search
      6.65 ±  7%     -95.7%       0.29 ±  9%  perf-profile.self.cycles-pp.__find_get_block_slow
      3.26 ±  7%     -91.9%       0.26 ±  8%  perf-profile.self.cycles-pp.__might_sleep
     15.94 ±  6%     -72.4%       4.41 ±  1%  perf-profile.self.cycles-pp.__radix_tree_lookup
      0.04 ± 58%   +5393.7%       2.20 ±  2%  perf-profile.self.cycles-pp.copy_user_enhanced_fast_string
      0.03 ±100%  +15418.2%       4.27 ±  4%  perf-profile.self.cycles-pp.ext4_es_lookup_extent
      1.24 ± 14%     -87.1%       0.16 ±  7%  perf-profile.self.cycles-pp.ext4_ext_map_blocks
      0.00 ± -1%      +Inf%       1.99 ±  4%  perf-profile.self.cycles-pp.ext4_find_extent
      0.01 ±173%   +7016.7%       1.07 ± 12%  perf-profile.self.cycles-pp.ext4_put_io_end_defer
      4.63 ±  7%     -86.5%       0.62 ±  7%  perf-profile.self.cycles-pp.find_get_entry
      6.50 ±  9%     -98.3%       0.11 ±  7%  perf-profile.self.cycles-pp.pagecache_get_page
      2.59 ±  8%    -100.0%       0.00 ± -1%  perf-profile.self.cycles-pp.radix_tree_lookup_slot
      4.53 ±  7%    -100.0%       0.00 ± -1%  perf-profile.self.cycles-pp.unmap_underlying_metadata



***************************************************************************************************
lkp-bdw-de1: 16 threads Intel(R) Xeon(R) CPU D-1541 @ 2.10GHz with 8G memory
=========================================================================================
bs/compiler/cpufreq_governor/disk/fs/ioengine/kconfig/nr_task/rootfs/runtime/rw/tbox_group/test_size/testcase:
  4k/gcc-6/performance/1SSD/ext4/sync/x86_64-rhel-7.2/64/debian-x86_64-2016-08-31.cgz/300s/randwrite/lkp-bdw-de1/400g/fio-basic

commit: 
  6f2b562c3a ("direct-io: Use clean_bdev_aliases() instead of handmade iteration")
  adad5aa544 ("ext4: Use clean_bdev_aliases() instead of iteration")

6f2b562c3a89f4a6 adad5aa544e281d84f837b2786 
---------------- -------------------------- 
         %stddev     %change         %stddev
             \          |                \  
     21.99 ±  3%     +88.0%      41.34 ±  0%  fio.write_bw_MBps
      5630 ±  3%     +88.0%      10584 ±  0%  fio.write_iops
      0.01 ±  0%   +2550.0%       0.27 ± 10%  fio.latency_100ms%
      1.82 ± 21%     +31.9%       2.40 ±  2%  fio.latency_20us%
      5.41 ±  3%     -44.0%       3.03 ±  1%  fio.latency_250ms%
      0.09 ± 24%     -50.0%       0.04 ± 38%  fio.latency_2us%
      0.01 ±  0%    +800.0%       0.09 ± 39%  fio.latency_50ms%
      0.10 ±  5%     +36.8%       0.13 ± 12%  fio.latency_50us%
      0.01 ±  0%    +100.0%       0.02 ±  0%  fio.latency_750us%
      0.01 ±  0%    -100.0%       0.00 ± -1%  fio.latency_>=2000ms%
  13520302 ±  3%     +87.9%   25407598 ±  0%  fio.time.file_system_outputs
    572.00 ± 11%    +106.8%       1182 ±  9%  fio.time.involuntary_context_switches
      4.00 ±  0%     +75.0%       7.00 ±  0%  fio.time.percent_of_cpu_this_job_got
     10.81 ±  3%     +64.4%      17.77 ±  1%  fio.time.system_time
    124822 ±  0%     +14.3%     142634 ±  0%  fio.time.voluntary_context_switches
    207872 ±  0%    -100.0%      10.50 ±  4%  fio.write_clat_95%_us
     11370 ±  3%     -46.9%       6043 ±  0%  fio.write_clat_mean_us
     48714 ±  1%     -31.2%      33513 ±  0%  fio.write_clat_stddev
    779996 ±  4%    +116.4%    1688045 ±  0%  softirqs.BLOCK
    236088 ±  1%     -40.2%     141136 ±  2%  softirqs.TIMER
 1.273e+08 ± 32%    +125.7%  2.873e+08 ±  7%  cpuidle.C1-BDW.time
   1259421 ±  8%    +150.7%    3157306 ±  1%  cpuidle.C1-BDW.usage
  35610319 ±  8%     +48.0%   52707031 ±  7%  cpuidle.POLL.time
     25450 ±  4%    +159.0%      65928 ±  0%  cpuidle.POLL.usage
      6.06 ±  1%     -43.9%       3.39 ±  0%  iostat.sda.avgqu-sz
      5181 ±  4%    +116.2%      11205 ±  0%  iostat.sda.w/s
     48263 ±  2%     +82.4%      88033 ±  0%  iostat.sda.wkB/s
    281.65 ±  9%    +129.5%     646.34 ±  0%  iostat.sda.wrqm/s
      7.05 ±  2%     -41.8%       4.10 ±  2%  turbostat.%Busy
    175.25 ±  2%     -43.7%      98.75 ±  2%  turbostat.Avg_MHz
      0.83 ± 58%    +102.7%       1.68 ± 22%  turbostat.CPU%c3
     24.78 ±  0%      -6.2%      23.24 ±  0%  turbostat.PkgWatt
     20259 ±  4%    +105.3%      41593 ±  0%  vmstat.io.bo
     40089 ±  3%    +146.8%      98930 ±  0%  vmstat.memory.buff
   4840450 ±  1%     +44.3%    6985650 ±  0%  vmstat.memory.cache
   2944417 ±  3%     -75.0%     735714 ±  0%  vmstat.memory.free
      9190 ±  5%    +131.5%      21271 ±  0%  vmstat.system.cs
     21597 ±  0%     +27.5%      27530 ±  0%  vmstat.system.in
    206807 ±  0%     +28.8%     266435 ±  0%  meminfo.Active
     91674 ±  1%     +63.7%     150046 ±  0%  meminfo.Active(file)
     39950 ±  3%    +147.0%      98691 ±  0%  meminfo.Buffers
   4301589 ±  1%     +42.2%    6117099 ±  0%  meminfo.Cached
    147136 ±  4%     -51.8%      70930 ±  3%  meminfo.CmaFree
   1231530 ±  0%      -9.8%    1110281 ±  0%  meminfo.Dirty
   4165928 ±  1%     +33.2%    5546973 ±  0%  meminfo.Inactive
   4035603 ±  1%     +34.2%    5416550 ±  0%  meminfo.Inactive(file)
   2954425 ±  3%     -75.0%     738296 ±  0%  meminfo.MemFree
    528634 ±  2%     +63.7%     865637 ±  0%  meminfo.SReclaimable
    572788 ±  1%     +58.8%     909788 ±  0%  meminfo.Slab
     82578 ± 22%    +527.1%     517878 ±  0%  meminfo.Unevictable
 3.364e+11 ±  6%     -83.3%  5.634e+10 ±  3%  perf-stat.branch-instructions
      0.08 ±  7%   +1007.3%       0.91 ±  2%  perf-stat.branch-miss-rate%
 2.762e+08 ±  5%     +86.2%  5.142e+08 ±  4%  perf-stat.branch-misses
 1.991e+09 ±  7%     +56.6%  3.118e+09 ±  5%  perf-stat.cache-misses
 1.991e+09 ±  7%     +56.6%  3.118e+09 ±  5%  perf-stat.cache-references
   2785024 ±  5%    +131.2%    6439786 ±  0%  perf-stat.context-switches
 7.542e+11 ±  4%     -46.1%  4.062e+11 ±  3%  perf-stat.cpu-cycles
     12762 ±  8%     +64.5%      20989 ± 10%  perf-stat.cpu-migrations
      0.01 ±  4%    +972.7%       0.07 ±  4%  perf-stat.dTLB-load-miss-rate%
  29564776 ± 14%     +86.4%   55104164 ± 10%  perf-stat.dTLB-load-misses
 4.544e+11 ± 10%     -82.6%  7.909e+10 ±  8%  perf-stat.dTLB-loads
      0.00 ± 11%   +1059.4%       0.01 ±  2%  perf-stat.dTLB-store-miss-rate%
   2671103 ±  5%     +34.6%    3595369 ±  3%  perf-stat.dTLB-store-misses
 3.157e+11 ±  6%     -88.5%  3.635e+10 ±  0%  perf-stat.dTLB-stores
      9.80 ±  0%     -23.4%       7.51 ±  4%  perf-stat.iTLB-load-miss-rate%
   7536032 ±  5%     +15.5%    8705667 ±  4%  perf-stat.iTLB-load-misses
  69358427 ±  4%     +54.6%  1.072e+08 ±  2%  perf-stat.iTLB-loads
 1.841e+12 ±  6%     -84.9%  2.778e+11 ±  3%  perf-stat.instructions
    245649 ± 10%     -87.0%      32014 ±  7%  perf-stat.instructions-per-iTLB-miss
      2.44 ±  2%     -72.0%       0.68 ±  1%  perf-stat.ipc
     13430 ±  3%      -8.6%      12278 ±  4%  slabinfo.anon_vma.active_objs
     13430 ±  3%      -8.6%      12278 ±  4%  slabinfo.anon_vma.num_objs
    829.00 ±  3%     +25.5%       1040 ±  1%  slabinfo.blkdev_requests.active_objs
    829.00 ±  3%     +31.4%       1089 ±  1%  slabinfo.blkdev_requests.num_objs
    868726 ±  2%     +54.0%    1338136 ±  0%  slabinfo.buffer_head.active_objs
     22278 ±  2%     +54.1%      34328 ±  0%  slabinfo.buffer_head.active_slabs
    868881 ±  2%     +54.1%    1338829 ±  0%  slabinfo.buffer_head.num_objs
     22278 ±  2%     +54.1%      34328 ±  0%  slabinfo.buffer_head.num_slabs
    240.50 ±  9%     +72.8%     415.50 ±  7%  slabinfo.ext4_allocation_context.active_objs
    240.50 ±  9%     +72.8%     415.50 ±  7%  slabinfo.ext4_allocation_context.num_objs
   1008816 ±  3%    +102.0%    2037569 ±  0%  slabinfo.ext4_extent_status.active_objs
     10145 ±  3%     +99.7%      20257 ±  0%  slabinfo.ext4_extent_status.active_slabs
   1034848 ±  3%     +99.7%    2066293 ±  0%  slabinfo.ext4_extent_status.num_objs
     10145 ±  3%     +99.7%      20257 ±  0%  slabinfo.ext4_extent_status.num_slabs
    598.50 ±  7%    +204.2%       1820 ± 16%  slabinfo.ext4_io_end.active_objs
    598.50 ±  7%    +204.2%       1820 ± 16%  slabinfo.ext4_io_end.num_objs
      7552 ±  3%    +139.9%      18119 ±  1%  slabinfo.jbd2_journal_head.active_objs
    225.50 ±  3%    +145.5%     553.50 ±  1%  slabinfo.jbd2_journal_head.active_slabs
      7688 ±  3%    +145.0%      18836 ±  1%  slabinfo.jbd2_journal_head.num_objs
    225.50 ±  3%    +145.5%     553.50 ±  1%  slabinfo.jbd2_journal_head.num_slabs
      1705 ±  2%     +10.9%       1892 ±  1%  slabinfo.kmalloc-128.active_objs
      1705 ±  2%     +10.9%       1892 ±  1%  slabinfo.kmalloc-128.num_objs
    635923 ±  1%     +68.0%    1068344 ±  0%  slabinfo.radix_tree_node.active_objs
     22711 ±  1%     +68.1%      38179 ±  0%  slabinfo.radix_tree_node.active_slabs
    635924 ±  1%     +68.1%    1069036 ±  0%  slabinfo.radix_tree_node.num_objs
     22711 ±  1%     +68.1%      38179 ±  0%  slabinfo.radix_tree_node.num_slabs
     43.25 ± 30%    +659.5%     328.50 ±  5%  proc-vmstat.kswapd_high_wmark_hit_quickly
     22911 ±  1%     +63.7%      37511 ±  0%  proc-vmstat.nr_active_file
   1719405 ±  3%     +88.3%    3238051 ±  0%  proc-vmstat.nr_dirtied
    307915 ±  0%      -9.9%     277568 ±  0%  proc-vmstat.nr_dirty
    173320 ±  0%     -11.2%     153959 ±  0%  proc-vmstat.nr_dirty_background_threshold
    347064 ±  0%     -11.2%     308295 ±  0%  proc-vmstat.nr_dirty_threshold
   1084951 ±  1%     +43.2%    1553939 ±  0%  proc-vmstat.nr_file_pages
     36802 ±  4%     -51.8%      17727 ±  3%  proc-vmstat.nr_free_cma
    739051 ±  3%     -75.0%     184500 ±  0%  proc-vmstat.nr_free_pages
   1008614 ±  1%     +34.3%    1354148 ±  0%  proc-vmstat.nr_inactive_file
    132095 ±  2%     +63.8%     216411 ±  0%  proc-vmstat.nr_slab_reclaimable
     20520 ± 22%    +530.9%     129469 ±  0%  proc-vmstat.nr_unevictable
   1455387 ±  4%    +104.6%    2977054 ±  0%  proc-vmstat.nr_written
     22911 ±  1%     +63.7%      37512 ±  0%  proc-vmstat.nr_zone_active_file
   1008623 ±  1%     +34.3%    1354156 ±  0%  proc-vmstat.nr_zone_inactive_file
     20520 ± 22%    +530.9%     129469 ±  0%  proc-vmstat.nr_zone_unevictable
    307921 ±  0%      -9.9%     277574 ±  0%  proc-vmstat.nr_zone_write_pending
   2276380 ±  2%     +82.3%    4149633 ±  0%  proc-vmstat.numa_hit
   2276380 ±  2%     +82.3%    4149633 ±  0%  proc-vmstat.numa_local
      2290 ±  8%     -19.0%       1854 ±  3%  proc-vmstat.pgactivate
    586459 ±  0%     +95.4%    1146061 ±  0%  proc-vmstat.pgalloc_dma32
   1813324 ±  3%     +75.7%    3185203 ±  0%  proc-vmstat.pgalloc_normal
    686981 ± 11%    +280.1%    2611518 ±  0%  proc-vmstat.pgfree
   6092313 ±  4%    +106.2%   12563054 ±  0%  proc-vmstat.pgpgout
     11203 ± 36%    +170.9%      30354 ±  8%  proc-vmstat.pgrotated
    449606 ± 16%    +339.3%    1974929 ±  0%  proc-vmstat.pgscan_kswapd
    233963 ± 24%    +654.4%    1764934 ±  0%  proc-vmstat.pgsteal_kswapd
   1198400 ± 16%    +425.5%    6298080 ±  0%  proc-vmstat.slabs_scanned
      0.00 ±  0%      +Inf%      71874 ±  1%  proc-vmstat.workingset_nodereclaim
      8388 ±  1%     -71.6%       2385 ±  0%  sched_debug.cfs_rq:/.exec_clock.avg
    121674 ±  1%     -83.1%      20594 ±  1%  sched_debug.cfs_rq:/.exec_clock.max
    488.99 ±  7%     +83.9%     899.07 ±  2%  sched_debug.cfs_rq:/.exec_clock.min
     29252 ±  1%     -83.9%       4705 ±  2%  sched_debug.cfs_rq:/.exec_clock.stddev
     14195 ±  1%     -45.0%       7807 ±  8%  sched_debug.cfs_rq:/.min_vruntime.avg
    129717 ±  1%     -79.5%      26584 ±  3%  sched_debug.cfs_rq:/.min_vruntime.max
     29978 ±  1%     -82.1%       5358 ±  4%  sched_debug.cfs_rq:/.min_vruntime.stddev
     42.38 ± 13%     -64.7%      14.96 ± 32%  sched_debug.cfs_rq:/.runnable_load_avg.avg
    587.46 ± 10%     -73.2%     157.17 ± 58%  sched_debug.cfs_rq:/.runnable_load_avg.max
    142.60 ± 10%     -72.0%      39.89 ± 54%  sched_debug.cfs_rq:/.runnable_load_avg.stddev
   -115054 ± -1%     -84.2%     -18209 ± -2%  sched_debug.cfs_rq:/.spread0.avg
   -124959 ± -1%     -82.4%     -21931 ± -2%  sched_debug.cfs_rq:/.spread0.min
     29980 ±  1%     -82.1%       5359 ±  4%  sched_debug.cfs_rq:/.spread0.stddev
    183.46 ±  4%     -12.6%     160.38 ±  3%  sched_debug.cfs_rq:/.util_avg.avg
    758.46 ±  6%     -54.2%     347.67 ± 21%  sched_debug.cfs_rq:/.util_avg.max
    159.02 ±  6%     -59.6%      64.19 ± 27%  sched_debug.cfs_rq:/.util_avg.stddev
      4.62 ± 14%     +25.0%       5.78 ±  8%  sched_debug.cpu.clock.stddev
      4.62 ± 14%     +25.0%       5.78 ±  8%  sched_debug.cpu.clock_task.stddev
     32.76 ± 20%     -71.9%       9.22 ± 28%  sched_debug.cpu.cpu_load[0].avg
    476.58 ± 20%     -82.2%      85.00 ± 41%  sched_debug.cpu.cpu_load[0].max
    115.51 ± 20%     -80.9%      22.05 ± 38%  sched_debug.cpu.cpu_load[0].stddev
     50.30 ± 18%     -35.9%      32.26 ± 22%  sched_debug.cpu.cpu_load[1].avg
    689.00 ± 14%     -47.2%     363.67 ± 40%  sched_debug.cpu.cpu_load[1].max
    167.01 ± 14%     -45.9%      90.39 ± 37%  sched_debug.cpu.cpu_load[1].stddev
     49.20 ± 17%     -36.6%      31.17 ± 12%  sched_debug.cpu.cpu_load[2].avg
    685.33 ± 12%     -48.1%     355.79 ± 25%  sched_debug.cpu.cpu_load[2].max
    165.88 ± 13%     -47.3%      87.49 ± 22%  sched_debug.cpu.cpu_load[2].stddev
     48.09 ± 14%     -39.4%      29.16 ± 13%  sched_debug.cpu.cpu_load[3].avg
    680.83 ± 10%     -50.2%     339.04 ± 21%  sched_debug.cpu.cpu_load[3].max
    164.53 ± 10%     -49.7%      82.78 ± 20%  sched_debug.cpu.cpu_load[3].stddev
     48.58 ± 10%     -41.4%      28.46 ± 14%  sched_debug.cpu.cpu_load[4].avg
    688.96 ±  7%     -51.1%     336.62 ± 20%  sched_debug.cpu.cpu_load[4].max
    166.58 ±  7%     -50.9%      81.78 ± 19%  sched_debug.cpu.cpu_load[4].stddev
     98158 ±  2%     -17.7%      80832 ±  9%  sched_debug.cpu.load.avg
     11358 ±  5%     +18.9%      13505 ±  1%  sched_debug.cpu.nr_load_updates.min
      0.49 ± 22%     -20.4%       0.39 ±  4%  sched_debug.cpu.nr_running.stddev
     68686 ±  5%    +225.6%     223616 ±  0%  sched_debug.cpu.nr_switches.avg
    716941 ±  6%    +334.4%    3114465 ±  0%  sched_debug.cpu.nr_switches.max
     15378 ±  9%     +49.4%      22975 ±  1%  sched_debug.cpu.nr_switches.min
    167664 ±  7%    +345.2%     746520 ±  0%  sched_debug.cpu.nr_switches.stddev
     27.08 ± 11%     +91.2%      51.79 ± 28%  sched_debug.cpu.nr_uninterruptible.max
    -70.88 ±-30%    +137.4%    -168.25 ±-28%  sched_debug.cpu.nr_uninterruptible.min
     21.97 ± 21%    +155.2%      56.05 ± 33%  sched_debug.cpu.nr_uninterruptible.stddev
     67027 ±  5%    +230.8%     221705 ±  0%  sched_debug.cpu.sched_count.avg
    709329 ±  6%    +338.0%    3106542 ±  0%  sched_debug.cpu.sched_count.max
     14191 ± 10%     +52.9%      21695 ±  2%  sched_debug.cpu.sched_count.min
    166147 ±  7%    +348.3%     744893 ±  0%  sched_debug.cpu.sched_count.stddev
     31385 ±  5%    +227.5%     102792 ±  0%  sched_debug.cpu.sched_goidle.avg
    332305 ±  6%    +333.7%    1441132 ±  0%  sched_debug.cpu.sched_goidle.max
      6750 ± 11%     +54.1%      10404 ±  1%  sched_debug.cpu.sched_goidle.min
     77791 ±  7%    +344.2%     345568 ±  0%  sched_debug.cpu.sched_goidle.stddev
     34470 ±  5%    +242.0%     117883 ±  0%  sched_debug.cpu.ttwu_count.avg
    382534 ±  6%    +338.8%    1678433 ±  0%  sched_debug.cpu.ttwu_count.max
      6678 ± 11%     +48.9%       9940 ±  3%  sched_debug.cpu.ttwu_count.min
     89977 ±  7%    +347.8%     402944 ±  0%  sched_debug.cpu.ttwu_count.stddev
     29594 ±  5%    +275.3%     111065 ±  0%  sched_debug.cpu.ttwu_local.avg
    375624 ±  7%    +342.3%    1661530 ±  0%  sched_debug.cpu.ttwu_local.max
      4098 ±  7%     +46.2%       5994 ±  2%  sched_debug.cpu.ttwu_local.min
     89363 ±  7%    +348.0%     400331 ±  0%  sched_debug.cpu.ttwu_local.stddev
      1.71 ± 25%     +28.4%       2.20 ±  7%  sched_debug.rt_rq:/.rt_time.max
      0.44 ± 18%     +21.7%       0.53 ±  7%  sched_debug.rt_rq:/.rt_time.stddev
      2.14 ± 21%    -100.0%       0.00 ± -1%  perf-profile.calltrace.cycles-pp.___might_sleep.__might_sleep.unmap_underlying_metadata.ext4_ext_map_blocks.ext4_map_blocks
      1.02 ± 29%    -100.0%       0.00 ± -1%  perf-profile.calltrace.cycles-pp.___might_sleep.unmap_underlying_metadata.ext4_ext_map_blocks.ext4_map_blocks.ext4_writepages
      0.00 ± -1%      +Inf%       1.14 ± 10%  perf-profile.calltrace.cycles-pp.__blk_run_queue.blk_delay_work.process_one_work.worker_thread.kthread
      0.13 ±173%    +649.0%       0.96 ± 25%  perf-profile.calltrace.cycles-pp.__blk_run_queue.blk_run_queue.scsi_run_queue.scsi_end_request.scsi_io_completion
      0.45 ±100%    +266.9%       1.66 ± 11%  perf-profile.calltrace.cycles-pp.__block_write_begin.ext4_da_write_begin.generic_perform_write.__generic_file_write_iter.ext4_file_write_iter
      0.45 ±100%    +265.2%       1.65 ± 11%  perf-profile.calltrace.cycles-pp.__block_write_begin_int.__block_write_begin.ext4_da_write_begin.generic_perform_write.__generic_file_write_iter
     29.24 ± 29%    -100.0%       0.00 ± -1%  perf-profile.calltrace.cycles-pp.__find_get_block_slow.unmap_underlying_metadata.ext4_ext_map_blocks.ext4_map_blocks.ext4_writepages
      1.71 ± 56%    +164.8%       4.52 ±  4%  perf-profile.calltrace.cycles-pp.__generic_file_write_iter.ext4_file_write_iter.__vfs_write.vfs_write.sys_write
      0.35 ±104%    +384.5%       1.72 ± 28%  perf-profile.calltrace.cycles-pp.__handle_irq_event_percpu.handle_irq_event_percpu.handle_irq_event.handle_fasteoi_irq.handle_irq
      0.00 ± -1%      +Inf%       0.87 ± 21%  perf-profile.calltrace.cycles-pp.__hrtimer_run_queues.hrtimer_interrupt.local_apic_timer_interrupt.smp_apic_timer_interrupt.apic_timer_interrupt
      1.15 ± 21%    -100.0%       0.00 ± -1%  perf-profile.calltrace.cycles-pp.__might_sleep.ext4_ext_map_blocks.ext4_map_blocks.ext4_writepages.do_writepages
      3.90 ± 22%    -100.0%       0.00 ± -1%  perf-profile.calltrace.cycles-pp.__might_sleep.unmap_underlying_metadata.ext4_ext_map_blocks.ext4_map_blocks.ext4_writepages
     12.80 ± 29%    -100.0%       0.00 ± -1%  perf-profile.calltrace.cycles-pp.__radix_tree_lookup.radix_tree_lookup_slot.find_get_entry.pagecache_get_page.__find_get_block_slow
      0.66 ± 59%    +211.3%       2.06 ± 27%  perf-profile.calltrace.cycles-pp.__softirqentry_text_start.irq_exit.do_IRQ.ret_from_intr.cpuidle_enter
      0.42 ± 58%    +185.0%       1.19 ±  8%  perf-profile.calltrace.cycles-pp.__tick_nohz_idle_enter.tick_nohz_irq_exit.irq_exit.smp_apic_timer_interrupt.apic_timer_interrupt
      1.73 ± 55%    +161.6%       4.53 ±  4%  perf-profile.calltrace.cycles-pp.__vfs_write.vfs_write.sys_write.entry_SYSCALL_64_fastpath
     46.87 ± 22%     -78.5%      10.06 ± 23%  perf-profile.calltrace.cycles-pp.__writeback_inodes_wb.wb_writeback.wb_workfn.process_one_work.worker_thread
     46.87 ± 22%     -78.5%      10.06 ± 23%  perf-profile.calltrace.cycles-pp.__writeback_single_inode.writeback_sb_inodes.__writeback_inodes_wb.wb_writeback.wb_workfn
      1.14 ± 30%     +80.0%       2.05 ±  6%  perf-profile.calltrace.cycles-pp._raw_spin_lock.tick_do_update_jiffies64.tick_irq_enter.irq_enter.smp_apic_timer_interrupt
      0.13 ±173%    +841.2%       1.20 ± 29%  perf-profile.calltrace.cycles-pp.ahci_handle_port_intr.ahci_single_level_irq_intr.__handle_irq_event_percpu.handle_irq_event_percpu.handle_irq_event
      0.34 ±104%    +398.5%       1.71 ± 27%  perf-profile.calltrace.cycles-pp.ahci_single_level_irq_intr.__handle_irq_event_percpu.handle_irq_event_percpu.handle_irq_event.handle_fasteoi_irq
      3.24 ± 20%    +104.9%       6.64 ±  8%  perf-profile.calltrace.cycles-pp.apic_timer_interrupt.cpuidle_enter.call_cpuidle.cpu_startup_entry.start_secondary
      0.00 ± -1%      +Inf%       1.16 ± 10%  perf-profile.calltrace.cycles-pp.blk_delay_work.process_one_work.worker_thread.kthread.ret_from_fork
      0.66 ± 59%    +202.6%       2.00 ± 26%  perf-profile.calltrace.cycles-pp.blk_done_softirq.__softirqentry_text_start.irq_exit.do_IRQ.ret_from_intr
      0.13 ±173%    +645.3%       0.99 ± 25%  perf-profile.calltrace.cycles-pp.blk_run_queue.scsi_run_queue.scsi_end_request.scsi_io_completion.scsi_finish_command
      0.36 ±105%    +372.6%       1.73 ± 38%  perf-profile.calltrace.cycles-pp.call_console_drivers.console_unlock.vprintk_emit.vprintk_default.printk
      2.92 ± 40%    +296.0%      11.55 ± 19%  perf-profile.calltrace.cycles-pp.call_cpuidle.cpu_startup_entry.rest_init.start_kernel.x86_64_start_reservations
     44.69 ± 17%     +40.6%      62.85 ±  8%  perf-profile.calltrace.cycles-pp.call_cpuidle.cpu_startup_entry.start_secondary
      0.36 ±105%    +374.7%       1.73 ± 39%  perf-profile.calltrace.cycles-pp.console_unlock.vprintk_emit.vprintk_default.printk.perf_duration_warn
      3.41 ± 39%    +287.3%      13.21 ± 20%  perf-profile.calltrace.cycles-pp.cpu_startup_entry.rest_init.start_kernel.x86_64_start_reservations.x86_64_start_kernel
     45.17 ± 17%     +41.1%      63.73 ±  8%  perf-profile.calltrace.cycles-pp.cpu_startup_entry.start_secondary
      2.92 ± 40%    +295.3%      11.52 ± 19%  perf-profile.calltrace.cycles-pp.cpuidle_enter.call_cpuidle.cpu_startup_entry.rest_init.start_kernel
     44.67 ± 17%     +40.7%      62.83 ±  8%  perf-profile.calltrace.cycles-pp.cpuidle_enter.call_cpuidle.cpu_startup_entry.start_secondary
      1.42 ± 40%    +380.2%       6.81 ± 17%  perf-profile.calltrace.cycles-pp.cpuidle_enter_state.cpuidle_enter.call_cpuidle.cpu_startup_entry.rest_init
     40.70 ± 17%     +33.2%      54.22 ±  9%  perf-profile.calltrace.cycles-pp.cpuidle_enter_state.cpuidle_enter.call_cpuidle.cpu_startup_entry.start_secondary
      1.39 ± 41%    +205.1%       4.22 ± 24%  perf-profile.calltrace.cycles-pp.do_IRQ.ret_from_intr.cpuidle_enter.call_cpuidle.cpu_startup_entry
      0.77 ± 24%     +73.7%       1.34 ± 25%  perf-profile.calltrace.cycles-pp.do_wait.sys_wait4.entry_SYSCALL_64_fastpath
     46.87 ± 22%     -78.5%      10.06 ± 23%  perf-profile.calltrace.cycles-pp.do_writepages.__writeback_single_inode.writeback_sb_inodes.__writeback_inodes_wb.wb_writeback
      2.72 ± 41%    +141.6%       6.57 ±  6%  perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_fastpath
      0.15 ±173%    +418.6%       0.76 ± 30%  perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_fastpath.read
      0.33 ±100%    +304.6%       1.32 ± 10%  perf-profile.calltrace.cycles-pp.ext4_da_get_block_prep.__block_write_begin_int.__block_write_begin.ext4_da_write_begin.generic_perform_write
      1.01 ± 74%    +210.2%       3.12 ±  3%  perf-profile.calltrace.cycles-pp.ext4_da_write_begin.generic_perform_write.__generic_file_write_iter.ext4_file_write_iter.__vfs_write
      0.30 ±100%    +269.2%       1.11 ± 11%  perf-profile.calltrace.cycles-pp.ext4_es_lookup_extent.ext4_da_get_block_prep.__block_write_begin_int.__block_write_begin.ext4_da_write_begin
     42.95 ± 26%     -91.3%       3.74 ± 18%  perf-profile.calltrace.cycles-pp.ext4_ext_map_blocks.ext4_map_blocks.ext4_writepages.do_writepages.__writeback_single_inode
      1.72 ± 55%    +163.6%       4.53 ±  4%  perf-profile.calltrace.cycles-pp.ext4_file_write_iter.__vfs_write.vfs_write.sys_write.entry_SYSCALL_64_fastpath
     43.95 ± 25%     -89.4%       4.66 ± 17%  perf-profile.calltrace.cycles-pp.ext4_map_blocks.ext4_writepages.do_writepages.__writeback_single_inode.writeback_sb_inodes
      0.92 ± 61%    +103.5%       1.87 ± 18%  perf-profile.calltrace.cycles-pp.ext4_split_extent.ext4_ext_map_blocks.ext4_map_blocks.ext4_writepages.do_writepages
      0.82 ± 62%     +89.6%       1.55 ± 22%  perf-profile.calltrace.cycles-pp.ext4_split_extent_at.ext4_split_extent.ext4_ext_map_blocks.ext4_map_blocks.ext4_writepages
     46.85 ± 22%     -78.5%      10.06 ± 23%  perf-profile.calltrace.cycles-pp.ext4_writepages.do_writepages.__writeback_single_inode.writeback_sb_inodes.__writeback_inodes_wb
      1.08 ± 23%    -100.0%       0.00 ± -1%  perf-profile.calltrace.cycles-pp.find_get_entry.__find_get_block_slow.unmap_underlying_metadata.ext4_ext_map_blocks.ext4_map_blocks
     17.78 ± 29%    -100.0%       0.00 ± -1%  perf-profile.calltrace.cycles-pp.find_get_entry.pagecache_get_page.__find_get_block_slow.unmap_underlying_metadata.ext4_ext_map_blocks
      1.65 ± 58%    +165.7%       4.37 ±  3%  perf-profile.calltrace.cycles-pp.generic_perform_write.__generic_file_write_iter.ext4_file_write_iter.__vfs_write.vfs_write
      0.15 ±173%    +672.9%       1.14 ±  9%  perf-profile.calltrace.cycles-pp.grab_cache_page_write_begin.ext4_da_write_begin.generic_perform_write.__generic_file_write_iter.ext4_file_write_iter
      0.39 ±103%    +393.6%       1.93 ± 24%  perf-profile.calltrace.cycles-pp.handle_fasteoi_irq.handle_irq.do_IRQ.ret_from_intr.cpuidle_enter
      0.40 ±103%    +392.5%       1.96 ± 23%  perf-profile.calltrace.cycles-pp.handle_irq.do_IRQ.ret_from_intr.cpuidle_enter.call_cpuidle
      0.35 ±104%    +393.7%       1.75 ± 27%  perf-profile.calltrace.cycles-pp.handle_irq_event.handle_fasteoi_irq.handle_irq.do_IRQ.ret_from_intr
      0.35 ±104%    +393.7%       1.75 ± 27%  perf-profile.calltrace.cycles-pp.handle_irq_event_percpu.handle_irq_event.handle_fasteoi_irq.handle_irq.do_IRQ
      0.66 ± 19%    +134.0%       1.53 ± 25%  perf-profile.calltrace.cycles-pp.hrtimer_interrupt.local_apic_timer_interrupt.smp_apic_timer_interrupt.apic_timer_interrupt.cpuidle_enter
      0.00 ± -1%      +Inf%       0.92 ± 39%  perf-profile.calltrace.cycles-pp.io_serial_in.wait_for_xmitr.serial8250_console_putchar.uart_console_write.serial8250_console_write
      1.64 ± 26%     +81.1%       2.98 ± 11%  perf-profile.calltrace.cycles-pp.irq_enter.smp_apic_timer_interrupt.apic_timer_interrupt.cpuidle_enter.call_cpuidle
      0.70 ± 60%    +208.2%       2.17 ± 25%  perf-profile.calltrace.cycles-pp.irq_exit.do_IRQ.ret_from_intr.cpuidle_enter.call_cpuidle
      0.79 ±  9%    +123.0%       1.77 ± 10%  perf-profile.calltrace.cycles-pp.irq_exit.smp_apic_timer_interrupt.apic_timer_interrupt.cpuidle_enter.call_cpuidle
      0.36 ±105%    +374.7%       1.73 ± 39%  perf-profile.calltrace.cycles-pp.irq_work_interrupt.cpuidle_enter.call_cpuidle.cpu_startup_entry.start_secondary
      0.36 ±105%    +374.7%       1.73 ± 39%  perf-profile.calltrace.cycles-pp.irq_work_run.smp_irq_work_interrupt.irq_work_interrupt.cpuidle_enter.call_cpuidle
      0.36 ±105%    +374.7%       1.73 ± 39%  perf-profile.calltrace.cycles-pp.irq_work_run_list.irq_work_run.smp_irq_work_interrupt.irq_work_interrupt.cpuidle_enter
      0.00 ± -1%      +Inf%       1.24 ± 22%  perf-profile.calltrace.cycles-pp.kswapd.kthread.ret_from_fork
     47.58 ± 21%     -70.6%      14.00 ± 19%  perf-profile.calltrace.cycles-pp.kthread.ret_from_fork
      0.69 ± 20%    +140.4%       1.67 ± 23%  perf-profile.calltrace.cycles-pp.local_apic_timer_interrupt.smp_apic_timer_interrupt.apic_timer_interrupt.cpuidle_enter.call_cpuidle
      1.14 ± 30%     +80.0%       2.05 ±  6%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock.tick_do_update_jiffies64.tick_irq_enter.irq_enter
     23.25 ± 30%    -100.0%       0.00 ± -1%  perf-profile.calltrace.cycles-pp.pagecache_get_page.__find_get_block_slow.unmap_underlying_metadata.ext4_ext_map_blocks.ext4_map_blocks
      0.15 ±173%    +669.5%       1.14 ±  9%  perf-profile.calltrace.cycles-pp.pagecache_get_page.grab_cache_page_write_begin.ext4_da_write_begin.generic_perform_write.__generic_file_write_iter
      0.36 ±105%    +374.7%       1.73 ± 39%  perf-profile.calltrace.cycles-pp.perf_duration_warn.irq_work_run_list.irq_work_run.smp_irq_work_interrupt.irq_work_interrupt
      5.62 ± 25%    +212.8%      17.59 ± 22%  perf-profile.calltrace.cycles-pp.poll_idle.cpuidle_enter_state.cpuidle_enter.call_cpuidle.cpu_startup_entry
      0.36 ±105%    +374.7%       1.73 ± 39%  perf-profile.calltrace.cycles-pp.printk.perf_duration_warn.irq_work_run_list.irq_work_run.smp_irq_work_interrupt
     47.34 ± 21%     -74.7%      11.96 ± 20%  perf-profile.calltrace.cycles-pp.process_one_work.worker_thread.kthread.ret_from_fork
     14.58 ± 29%    -100.0%       0.00 ± -1%  perf-profile.calltrace.cycles-pp.radix_tree_lookup_slot.find_get_entry.pagecache_get_page.__find_get_block_slow.unmap_underlying_metadata
      0.15 ±173%    +427.1%       0.78 ± 28%  perf-profile.calltrace.cycles-pp.read
      3.42 ± 38%    +287.3%      13.25 ± 20%  perf-profile.calltrace.cycles-pp.rest_init.start_kernel.x86_64_start_reservations.x86_64_start_kernel
     47.58 ± 21%     -70.6%      14.00 ± 19%  perf-profile.calltrace.cycles-pp.ret_from_fork
      1.39 ± 41%    +205.4%       4.23 ± 24%  perf-profile.calltrace.cycles-pp.ret_from_intr.cpuidle_enter.call_cpuidle.cpu_startup_entry.rest_init
      0.59 ± 60%    +204.2%       1.81 ± 25%  perf-profile.calltrace.cycles-pp.scsi_end_request.scsi_io_completion.scsi_finish_command.scsi_softirq_done.blk_done_softirq
      0.62 ± 59%    +203.6%       1.88 ± 26%  perf-profile.calltrace.cycles-pp.scsi_finish_command.scsi_softirq_done.blk_done_softirq.__softirqentry_text_start.irq_exit
      0.60 ± 60%    +207.1%       1.84 ± 27%  perf-profile.calltrace.cycles-pp.scsi_io_completion.scsi_finish_command.scsi_softirq_done.blk_done_softirq.__softirqentry_text_start
      0.00 ± -1%      +Inf%       1.12 ± 10%  perf-profile.calltrace.cycles-pp.scsi_request_fn.__blk_run_queue.blk_delay_work.process_one_work.worker_thread
      0.13 ±173%    +641.2%       0.95 ± 24%  perf-profile.calltrace.cycles-pp.scsi_request_fn.__blk_run_queue.blk_run_queue.scsi_run_queue.scsi_end_request
      0.13 ±173%    +645.3%       0.99 ± 25%  perf-profile.calltrace.cycles-pp.scsi_run_queue.scsi_end_request.scsi_io_completion.scsi_finish_command.scsi_softirq_done
      0.63 ± 59%    +203.2%       1.92 ± 25%  perf-profile.calltrace.cycles-pp.scsi_softirq_done.blk_done_softirq.__softirqentry_text_start.irq_exit.do_IRQ
      0.20 ±173%    +687.2%       1.54 ± 38%  perf-profile.calltrace.cycles-pp.serial8250_console_putchar.uart_console_write.serial8250_console_write.univ8250_console_write.call_console_drivers
      0.33 ±105%    +385.6%       1.60 ± 38%  perf-profile.calltrace.cycles-pp.serial8250_console_write.univ8250_console_write.call_console_drivers.console_unlock.vprintk_emit
      0.00 ± -1%      +Inf%       0.84 ± 27%  perf-profile.calltrace.cycles-pp.shrink_inactive_list.shrink_node_memcg.shrink_node.kswapd.kthread
      0.00 ± -1%      +Inf%       1.23 ± 22%  perf-profile.calltrace.cycles-pp.shrink_node.kswapd.kthread.ret_from_fork
      0.00 ± -1%      +Inf%       0.84 ± 27%  perf-profile.calltrace.cycles-pp.shrink_node_memcg.shrink_node.kswapd.kthread.ret_from_fork
      0.00 ± -1%      +Inf%       0.80 ± 24%  perf-profile.calltrace.cycles-pp.shrink_page_list.shrink_inactive_list.shrink_node_memcg.shrink_node.kswapd
      3.22 ± 20%    +104.0%       6.56 ±  7%  perf-profile.calltrace.cycles-pp.smp_apic_timer_interrupt.apic_timer_interrupt.cpuidle_enter.call_cpuidle.cpu_startup_entry
      0.36 ±105%    +374.7%       1.73 ± 39%  perf-profile.calltrace.cycles-pp.smp_irq_work_interrupt.irq_work_interrupt.cpuidle_enter.call_cpuidle.cpu_startup_entry
      3.42 ± 38%    +287.3%      13.25 ± 20%  perf-profile.calltrace.cycles-pp.start_kernel.x86_64_start_reservations.x86_64_start_kernel
     45.20 ± 17%     +41.2%      63.81 ±  8%  perf-profile.calltrace.cycles-pp.start_secondary
      0.79 ± 22%     +78.9%       1.42 ± 23%  perf-profile.calltrace.cycles-pp.sys_wait4.entry_SYSCALL_64_fastpath
      1.78 ± 55%    +166.8%       4.74 ±  5%  perf-profile.calltrace.cycles-pp.sys_write.entry_SYSCALL_64_fastpath
      1.25 ± 29%     +77.5%       2.21 ±  9%  perf-profile.calltrace.cycles-pp.tick_do_update_jiffies64.tick_irq_enter.irq_enter.smp_apic_timer_interrupt.apic_timer_interrupt
      1.55 ± 26%     +79.1%       2.78 ± 10%  perf-profile.calltrace.cycles-pp.tick_irq_enter.irq_enter.smp_apic_timer_interrupt.apic_timer_interrupt.cpuidle_enter
      0.55 ±  8%    +124.1%       1.23 ±  9%  perf-profile.calltrace.cycles-pp.tick_nohz_irq_exit.irq_exit.smp_apic_timer_interrupt.apic_timer_interrupt.cpuidle_enter
      0.14 ±173%    +621.4%       1.01 ± 10%  perf-profile.calltrace.cycles-pp.tick_nohz_stop_sched_tick.__tick_nohz_idle_enter.tick_nohz_irq_exit.irq_exit.smp_apic_timer_interrupt
      0.20 ±173%    +687.2%       1.54 ± 38%  perf-profile.calltrace.cycles-pp.uart_console_write.serial8250_console_write.univ8250_console_write.call_console_drivers.console_unlock
      0.33 ±105%    +385.6%       1.60 ± 38%  perf-profile.calltrace.cycles-pp.univ8250_console_write.call_console_drivers.console_unlock.vprintk_emit.vprintk_default
     38.19 ± 28%    -100.0%       0.00 ± -1%  perf-profile.calltrace.cycles-pp.unmap_underlying_metadata.ext4_ext_map_blocks.ext4_map_blocks.ext4_writepages.do_writepages
      1.76 ± 55%    +166.3%       4.70 ±  4%  perf-profile.calltrace.cycles-pp.vfs_write.sys_write.entry_SYSCALL_64_fastpath
      0.36 ±105%    +374.7%       1.73 ± 39%  perf-profile.calltrace.cycles-pp.vprintk_default.printk.perf_duration_warn.irq_work_run_list.irq_work_run
      0.36 ±105%    +374.7%       1.73 ± 39%  perf-profile.calltrace.cycles-pp.vprintk_emit.vprintk_default.printk.perf_duration_warn.irq_work_run_list
      0.62 ± 22%     +75.2%       1.09 ± 22%  perf-profile.calltrace.cycles-pp.wait_consider_task.do_wait.sys_wait4.entry_SYSCALL_64_fastpath
      0.19 ±173%    +702.7%       1.50 ± 38%  perf-profile.calltrace.cycles-pp.wait_for_xmitr.serial8250_console_putchar.uart_console_write.serial8250_console_write.univ8250_console_write
     46.87 ± 22%     -78.5%      10.06 ± 23%  perf-profile.calltrace.cycles-pp.wb_workfn.process_one_work.worker_thread.kthread.ret_from_fork
     46.87 ± 22%     -78.5%      10.06 ± 23%  perf-profile.calltrace.cycles-pp.wb_writeback.wb_workfn.process_one_work.worker_thread.kthread
     47.44 ± 21%     -74.1%      12.27 ± 19%  perf-profile.calltrace.cycles-pp.worker_thread.kthread.ret_from_fork
     46.87 ± 22%     -78.5%      10.06 ± 23%  perf-profile.calltrace.cycles-pp.writeback_sb_inodes.__writeback_inodes_wb.wb_writeback.wb_workfn.process_one_work
      3.42 ± 38%    +287.3%      13.25 ± 20%  perf-profile.calltrace.cycles-pp.x86_64_start_kernel
      3.42 ± 38%    +287.3%      13.25 ± 20%  perf-profile.calltrace.cycles-pp.x86_64_start_reservations.x86_64_start_kernel
      3.26 ± 22%     -92.8%       0.24 ± 23%  perf-profile.children.cycles-pp.___might_sleep
      0.92 ± 35%    +151.2%       2.31 ± 20%  perf-profile.children.cycles-pp.__blk_run_queue
      0.56 ± 63%    +199.1%       1.66 ± 11%  perf-profile.children.cycles-pp.__block_write_begin
      0.56 ± 63%    +196.4%       1.65 ± 11%  perf-profile.children.cycles-pp.__block_write_begin_int
     29.84 ± 29%     -99.5%       0.14 ± 26%  perf-profile.children.cycles-pp.__find_get_block_slow
      1.71 ± 55%    +164.4%       4.52 ±  4%  perf-profile.children.cycles-pp.__generic_file_write_iter
      0.96 ± 37%     +90.1%       1.81 ± 25%  perf-profile.children.cycles-pp.__handle_irq_event_percpu
      0.42 ± 21%    +137.1%       0.99 ± 21%  perf-profile.children.cycles-pp.__hrtimer_run_queues
      5.19 ± 20%     -93.8%       0.32 ± 21%  perf-profile.children.cycles-pp.__might_sleep
     13.51 ± 28%     -93.0%       0.95 ±  9%  perf-profile.children.cycles-pp.__radix_tree_lookup
      0.32 ± 30%    +230.7%       1.05 ±  8%  perf-profile.children.cycles-pp.__schedule
      1.36 ± 27%    +113.4%       2.91 ± 20%  perf-profile.children.cycles-pp.__softirqentry_text_start
      0.67 ± 17%    +151.3%       1.69 ± 10%  perf-profile.children.cycles-pp.__tick_nohz_idle_enter
      0.35 ± 32%    +111.6%       0.73 ± 38%  perf-profile.children.cycles-pp.__vfs_read
      1.98 ± 50%    +160.2%       5.15 ±  6%  perf-profile.children.cycles-pp.__vfs_write
     46.87 ± 22%     -78.5%      10.06 ± 23%  perf-profile.children.cycles-pp.__writeback_inodes_wb
     46.87 ± 22%     -78.5%      10.06 ± 23%  perf-profile.children.cycles-pp.__writeback_single_inode
      1.61 ± 27%     +98.1%       3.19 ±  9%  perf-profile.children.cycles-pp._raw_spin_lock
      0.33 ± 43%    +132.8%       0.76 ± 25%  perf-profile.children.cycles-pp.ahci_handle_port_interrupt
      0.62 ± 36%    +105.3%       1.27 ± 27%  perf-profile.children.cycles-pp.ahci_handle_port_intr
      0.93 ± 37%     +92.8%       1.80 ± 25%  perf-profile.children.cycles-pp.ahci_single_level_irq_intr
      3.48 ± 19%    +108.3%       7.25 ±  8%  perf-profile.children.cycles-pp.apic_timer_interrupt
      0.22 ± 31%    +218.2%       0.70 ± 34%  perf-profile.children.cycles-pp.ast_imageblit
      0.21 ± 45%    +457.8%       1.16 ± 10%  perf-profile.children.cycles-pp.blk_delay_work
      1.03 ± 36%    +119.9%       2.27 ± 24%  perf-profile.children.cycles-pp.blk_done_softirq
      0.49 ± 40%    +137.9%       1.18 ± 28%  perf-profile.children.cycles-pp.blk_run_queue
      0.55 ± 42%    +213.6%       1.73 ± 38%  perf-profile.children.cycles-pp.call_console_drivers
     47.62 ± 18%     +56.3%      74.41 ±  4%  perf-profile.children.cycles-pp.call_cpuidle
      0.55 ± 42%    +215.0%       1.73 ± 39%  perf-profile.children.cycles-pp.console_unlock
     48.58 ± 18%     +58.4%      76.95 ±  3%  perf-profile.children.cycles-pp.cpu_startup_entry
     47.58 ± 18%     +56.3%      74.35 ±  4%  perf-profile.children.cycles-pp.cpuidle_enter
     42.12 ± 17%     +44.9%      61.02 ±  6%  perf-profile.children.cycles-pp.cpuidle_enter_state
      0.55 ± 47%     +78.5%       0.98 ± 24%  perf-profile.children.cycles-pp.crypto_shash_update
      2.17 ± 37%    +110.4%       4.56 ± 23%  perf-profile.children.cycles-pp.do_IRQ
      0.77 ± 24%     +74.8%       1.35 ± 26%  perf-profile.children.cycles-pp.do_wait
     46.87 ± 22%     -78.5%      10.06 ± 23%  perf-profile.children.cycles-pp.do_writepages
      3.43 ± 35%    +139.4%       8.22 ±  6%  perf-profile.children.cycles-pp.entry_SYSCALL_64_fastpath
      0.41 ± 58%    +220.7%       1.32 ± 10%  perf-profile.children.cycles-pp.ext4_da_get_block_prep
      1.10 ± 58%    +184.7%       3.12 ±  3%  perf-profile.children.cycles-pp.ext4_da_write_begin
      0.46 ± 46%    +181.9%       1.28 ±  5%  perf-profile.children.cycles-pp.ext4_es_lookup_extent
     42.95 ± 26%     -91.1%       3.84 ± 18%  perf-profile.children.cycles-pp.ext4_ext_map_blocks
      1.72 ± 55%    +163.6%       4.53 ±  4%  perf-profile.children.cycles-pp.ext4_file_write_iter
      0.31 ± 35%    +211.3%       0.97 ± 22%  perf-profile.children.cycles-pp.ext4_find_extent
     43.95 ± 25%     -89.3%       4.69 ± 17%  perf-profile.children.cycles-pp.ext4_map_blocks
      1.00 ± 44%     +87.2%       1.87 ± 18%  perf-profile.children.cycles-pp.ext4_split_extent
      0.88 ± 47%     +77.3%       1.56 ± 22%  perf-profile.children.cycles-pp.ext4_split_extent_at
     46.85 ± 22%     -78.5%      10.06 ± 23%  perf-profile.children.cycles-pp.ext4_writepages
     19.06 ± 28%     -96.9%       0.60 ±  6%  perf-profile.children.cycles-pp.find_get_entry
      1.19 ± 38%    +124.8%       2.67 ± 32%  perf-profile.children.cycles-pp.find_get_pages
      1.65 ± 58%    +165.7%       4.37 ±  3%  perf-profile.children.cycles-pp.generic_perform_write
      0.36 ± 52%    +215.9%       1.15 ± 10%  perf-profile.children.cycles-pp.grab_cache_page_write_begin
      1.04 ± 38%     +96.4%       2.04 ± 21%  perf-profile.children.cycles-pp.handle_fasteoi_irq
      1.05 ± 38%     +97.6%       2.07 ± 21%  perf-profile.children.cycles-pp.handle_irq
      0.98 ± 38%     +90.3%       1.86 ± 25%  perf-profile.children.cycles-pp.handle_irq_event
      0.97 ± 38%     +91.8%       1.87 ± 25%  perf-profile.children.cycles-pp.handle_irq_event_percpu
      0.76 ± 16%    +122.6%       1.70 ± 22%  perf-profile.children.cycles-pp.hrtimer_interrupt
      0.29 ± 37%    +227.1%       0.97 ± 39%  perf-profile.children.cycles-pp.io_serial_in
      1.71 ± 25%     +91.8%       3.28 ± 11%  perf-profile.children.cycles-pp.irq_enter
      2.03 ± 22%    +118.6%       4.44 ± 14%  perf-profile.children.cycles-pp.irq_exit
      0.55 ± 42%    +215.0%       1.73 ± 39%  perf-profile.children.cycles-pp.irq_work_interrupt
      0.55 ± 42%    +215.0%       1.73 ± 39%  perf-profile.children.cycles-pp.irq_work_run
      0.55 ± 42%    +215.0%       1.73 ± 39%  perf-profile.children.cycles-pp.irq_work_run_list
      0.00 ± -1%      +Inf%       1.24 ± 22%  perf-profile.children.cycles-pp.kswapd
     47.58 ± 21%     -70.6%      14.00 ± 19%  perf-profile.children.cycles-pp.kthread
      0.80 ± 17%    +128.7%       1.83 ± 21%  perf-profile.children.cycles-pp.local_apic_timer_interrupt
      1.20 ± 28%     +87.0%       2.23 ±  7%  perf-profile.children.cycles-pp.native_queued_spin_lock_slowpath
     24.30 ± 28%     -94.8%       1.27 ±  9%  perf-profile.children.cycles-pp.pagecache_get_page
      1.23 ± 39%    +118.4%       2.70 ± 31%  perf-profile.children.cycles-pp.pagevec_lookup
      0.55 ± 42%    +215.0%       1.73 ± 39%  perf-profile.children.cycles-pp.perf_duration_warn
      5.69 ± 22%    +209.2%      17.59 ± 22%  perf-profile.children.cycles-pp.poll_idle
      0.55 ± 42%    +215.0%       1.73 ± 39%  perf-profile.children.cycles-pp.printk
     47.34 ± 21%     -74.7%      11.96 ± 20%  perf-profile.children.cycles-pp.process_one_work
     15.33 ± 28%     -96.2%       0.58 ±  7%  perf-profile.children.cycles-pp.radix_tree_lookup_slot
      0.38 ± 33%    +107.3%       0.78 ± 28%  perf-profile.children.cycles-pp.read
      3.42 ± 38%    +287.3%      13.25 ± 20%  perf-profile.children.cycles-pp.rest_init
     47.58 ± 21%     -70.6%      14.01 ± 19%  perf-profile.children.cycles-pp.ret_from_fork
      2.18 ± 37%    +109.5%       4.57 ± 23%  perf-profile.children.cycles-pp.ret_from_intr
      0.34 ± 30%    +215.3%       1.08 ±  6%  perf-profile.children.cycles-pp.schedule
      0.93 ± 37%    +120.9%       2.06 ± 23%  perf-profile.children.cycles-pp.scsi_end_request
      0.97 ± 36%    +120.7%       2.13 ± 23%  perf-profile.children.cycles-pp.scsi_finish_command
      0.94 ± 37%    +121.8%       2.08 ± 24%  perf-profile.children.cycles-pp.scsi_io_completion
      0.87 ± 36%    +161.2%       2.27 ± 19%  perf-profile.children.cycles-pp.scsi_request_fn
      0.51 ± 41%    +134.6%       1.20 ± 29%  perf-profile.children.cycles-pp.scsi_run_queue
      0.99 ± 36%    +120.8%       2.17 ± 23%  perf-profile.children.cycles-pp.scsi_softirq_done
      0.48 ± 41%    +219.8%       1.54 ± 38%  perf-profile.children.cycles-pp.serial8250_console_putchar
      0.50 ± 41%    +218.9%       1.60 ± 38%  perf-profile.children.cycles-pp.serial8250_console_write
      0.00 ± -1%      +Inf%       0.84 ± 27%  perf-profile.children.cycles-pp.shrink_inactive_list
      0.00 ± -1%      +Inf%       1.23 ± 22%  perf-profile.children.cycles-pp.shrink_node
      0.00 ± -1%      +Inf%       0.84 ± 27%  perf-profile.children.cycles-pp.shrink_node_memcg
      0.00 ± -1%      +Inf%       0.80 ± 24%  perf-profile.children.cycles-pp.shrink_page_list
      3.46 ± 19%    +107.3%       7.16 ±  7%  perf-profile.children.cycles-pp.smp_apic_timer_interrupt
      0.55 ± 42%    +215.0%       1.73 ± 39%  perf-profile.children.cycles-pp.smp_irq_work_interrupt
      3.42 ± 38%    +287.3%      13.25 ± 20%  perf-profile.children.cycles-pp.start_kernel
     45.20 ± 17%     +41.2%      63.81 ±  8%  perf-profile.children.cycles-pp.start_secondary
      0.40 ± 26%    +113.1%       0.85 ± 32%  perf-profile.children.cycles-pp.sys_read
      0.80 ± 22%     +79.9%       1.43 ± 23%  perf-profile.children.cycles-pp.sys_wait4
      2.07 ± 47%    +162.2%       5.43 ±  6%  perf-profile.children.cycles-pp.sys_write
      1.31 ± 29%     +88.4%       2.47 ± 11%  perf-profile.children.cycles-pp.tick_do_update_jiffies64
      1.61 ± 26%     +90.2%       3.07 ± 10%  perf-profile.children.cycles-pp.tick_irq_enter
      0.59 ± 12%    +137.3%       1.40 ±  4%  perf-profile.children.cycles-pp.tick_nohz_irq_exit
      0.59 ± 16%    +141.3%       1.42 ±  8%  perf-profile.children.cycles-pp.tick_nohz_stop_sched_tick
      0.37 ± 42%    +173.2%       1.02 ± 11%  perf-profile.children.cycles-pp.try_to_wake_up
      0.33 ± 42%    +169.9%       0.90 ± 11%  perf-profile.children.cycles-pp.ttwu_do_activate
      0.48 ± 41%    +219.8%       1.54 ± 38%  perf-profile.children.cycles-pp.uart_console_write
      0.50 ± 41%    +218.9%       1.60 ± 38%  perf-profile.children.cycles-pp.univ8250_console_write
     38.78 ± 28%     -99.7%       0.12 ± 42%  perf-profile.children.cycles-pp.unmap_underlying_metadata
      0.39 ± 23%    +116.9%       0.84 ± 34%  perf-profile.children.cycles-pp.vfs_read
      2.04 ± 48%    +162.8%       5.38 ±  6%  perf-profile.children.cycles-pp.vfs_write
      0.55 ± 42%    +215.0%       1.73 ± 39%  perf-profile.children.cycles-pp.vprintk_default
      0.55 ± 42%    +215.0%       1.73 ± 39%  perf-profile.children.cycles-pp.vprintk_emit
      0.63 ± 22%     +78.2%       1.12 ± 21%  perf-profile.children.cycles-pp.wait_consider_task
      0.49 ± 39%    +219.9%       1.57 ± 38%  perf-profile.children.cycles-pp.wait_for_xmitr
     46.87 ± 22%     -78.5%      10.06 ± 23%  perf-profile.children.cycles-pp.wb_workfn
     46.87 ± 22%     -78.5%      10.06 ± 23%  perf-profile.children.cycles-pp.wb_writeback
     47.44 ± 21%     -74.1%      12.27 ± 19%  perf-profile.children.cycles-pp.worker_thread
     46.87 ± 22%     -78.5%      10.06 ± 23%  perf-profile.children.cycles-pp.writeback_sb_inodes
      3.42 ± 38%    +287.3%      13.25 ± 20%  perf-profile.children.cycles-pp.x86_64_start_kernel
      3.42 ± 38%    +287.3%      13.25 ± 20%  perf-profile.children.cycles-pp.x86_64_start_reservations
      3.26 ± 22%     -92.8%       0.24 ± 23%  perf-profile.self.cycles-pp.___might_sleep
      5.38 ± 30%    -100.0%       0.00 ± -1%  perf-profile.self.cycles-pp.__find_get_block_slow
      2.93 ± 23%     -95.0%       0.15 ± 33%  perf-profile.self.cycles-pp.__might_sleep
     13.51 ± 28%     -93.0%       0.95 ±  9%  perf-profile.self.cycles-pp.__radix_tree_lookup
      0.45 ± 21%    +125.6%       1.01 ± 13%  perf-profile.self.cycles-pp._raw_spin_lock
      0.36 ± 22%    +148.3%       0.89 ± 20%  perf-profile.self.cycles-pp.cpuidle_enter_state
      0.46 ± 46%    +181.9%       1.28 ±  5%  perf-profile.self.cycles-pp.ext4_es_lookup_extent
      1.06 ± 24%     -93.0%       0.07 ± 66%  perf-profile.self.cycles-pp.ext4_ext_map_blocks
      3.75 ± 30%    -100.0%       0.00 ± -1%  perf-profile.self.cycles-pp.find_get_entry
      0.46 ± 43%    +174.9%       1.26 ± 35%  perf-profile.self.cycles-pp.find_get_pages
      0.29 ± 37%    +227.1%       0.97 ± 39%  perf-profile.self.cycles-pp.io_serial_in
      1.20 ± 28%     +87.0%       2.23 ±  7%  perf-profile.self.cycles-pp.native_queued_spin_lock_slowpath
      5.50 ± 29%    -100.0%       0.00 ± -1%  perf-profile.self.cycles-pp.pagecache_get_page
      5.69 ± 22%    +209.2%      17.59 ± 22%  perf-profile.self.cycles-pp.poll_idle
      2.18 ± 33%    -100.0%       0.00 ± -1%  perf-profile.self.cycles-pp.radix_tree_lookup_slot
      3.85 ± 26%    -100.0%       0.00 ± -1%  perf-profile.self.cycles-pp.unmap_underlying_metadata
      0.60 ± 21%     +78.3%       1.07 ± 21%  perf-profile.self.cycles-pp.wait_consider_task


Thanks,
Xiaolong

--3uo+9/B/ebqu+fSQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-4.9.0-rc3-00264-gadad5aa"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 4.9.0-rc3 Kernel Configuration
#
CONFIG_64BIT=y
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_MMU=y
CONFIG_ARCH_MMAP_RND_BITS_MIN=28
CONFIG_ARCH_MMAP_RND_BITS_MAX=32
CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MIN=8
CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MAX=16
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
CONFIG_ZONE_DMA32=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_HAVE_INTEL_TXT=y
CONFIG_X86_64_SMP=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_DEBUG_RODATA=y
CONFIG_PGTABLE_LEVELS=4
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y
CONFIG_THREAD_INFO_IN_TASK=y

#
# General setup
#
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
# CONFIG_COMPILE_TEST is not set
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_HAVE_KERNEL_LZ4=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_FHANDLE=y
CONFIG_USELIB=y
CONFIG_AUDIT=y
CONFIG_HAVE_ARCH_AUDITSYSCALL=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_WATCH=y
CONFIG_AUDIT_TREE=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_DOMAIN_HIERARCHY=y
CONFIG_GENERIC_MSI_IRQ=y
CONFIG_GENERIC_MSI_IRQ_DOMAIN=y
# CONFIG_IRQ_DOMAIN_DEBUG is not set
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
CONFIG_CLOCKSOURCE_VALIDATE_LAST_CYCLE=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
# CONFIG_NO_HZ_IDLE is not set
CONFIG_NO_HZ_FULL=y
# CONFIG_NO_HZ_FULL_ALL is not set
# CONFIG_NO_HZ_FULL_SYSIDLE is not set
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
CONFIG_VIRT_CPU_ACCOUNTING=y
CONFIG_VIRT_CPU_ACCOUNTING_GEN=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_RCU_EXPERT is not set
CONFIG_SRCU=y
CONFIG_TASKS_RCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_CONTEXT_TRACKING=y
# CONFIG_CONTEXT_TRACKING_FORCE is not set
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_RCU_NOCB_CPU=y
# CONFIG_RCU_NOCB_CPU_NONE is not set
# CONFIG_RCU_NOCB_CPU_ZERO is not set
CONFIG_RCU_NOCB_CPU_ALL=y
# CONFIG_RCU_EXPEDITE_BOOT is not set
CONFIG_BUILD_BIN2C=y
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=19
CONFIG_LOG_CPU_MAX_BUF_SHIFT=12
CONFIG_NMI_LOG_BUF_SHIFT=13
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH=y
CONFIG_ARCH_SUPPORTS_INT128=y
CONFIG_NUMA_BALANCING=y
CONFIG_NUMA_BALANCING_DEFAULT_ENABLED=y
CONFIG_CGROUPS=y
CONFIG_PAGE_COUNTER=y
CONFIG_MEMCG=y
CONFIG_MEMCG_SWAP=y
CONFIG_MEMCG_SWAP_ENABLED=y
CONFIG_BLK_CGROUP=y
# CONFIG_DEBUG_BLK_CGROUP is not set
CONFIG_CGROUP_WRITEBACK=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
CONFIG_RT_GROUP_SCHED=y
# CONFIG_CGROUP_PIDS is not set
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_HUGETLB=y
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
CONFIG_CGROUP_DEVICE=y
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_CGROUP_PERF=y
# CONFIG_CGROUP_DEBUG is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
CONFIG_RD_LZ4=y
CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_BPF=y
# CONFIG_EXPERT is not set
CONFIG_UID16=y
CONFIG_MULTIUSER=y
CONFIG_SGETMASK_SYSCALL=y
CONFIG_SYSFS_SYSCALL=y
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_KALLSYMS_ABSOLUTE_PERCPU=y
CONFIG_KALLSYMS_BASE_RELATIVE=y
CONFIG_PRINTK=y
CONFIG_PRINTK_NMI=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
# CONFIG_BPF_SYSCALL is not set
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_ADVISE_SYSCALLS=y
# CONFIG_USERFAULTFD is not set
CONFIG_PCI_QUIRKS=y
CONFIG_MEMBARRIER=y
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLAB_FREELIST_RANDOM is not set
CONFIG_SLUB_CPU_PARTIAL=y
# CONFIG_SYSTEM_DATA_VERIFICATION is not set
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_KEXEC_CORE=y
CONFIG_OPROFILE=m
CONFIG_OPROFILE_EVENT_MULTIPLEX=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_KPROBES=y
CONFIG_JUMP_LABEL=y
# CONFIG_STATIC_KEYS_SELFTEST is not set
CONFIG_OPTPROBES=y
CONFIG_KPROBES_ON_FTRACE=y
CONFIG_UPROBES=y
# CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_KRETPROBES=y
CONFIG_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_KPROBES_ON_FTRACE=y
CONFIG_HAVE_NMI=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_CONTIGUOUS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_ARCH_WANTS_DYNAMIC_TASK_STRUCT=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_CLK=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_PERF_REGS=y
CONFIG_HAVE_PERF_USER_STACK_DUMP=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y
CONFIG_HAVE_GCC_PLUGINS=y
# CONFIG_GCC_PLUGINS is not set
CONFIG_HAVE_CC_STACKPROTECTOR=y
# CONFIG_CC_STACKPROTECTOR is not set
CONFIG_CC_STACKPROTECTOR_NONE=y
# CONFIG_CC_STACKPROTECTOR_REGULAR is not set
# CONFIG_CC_STACKPROTECTOR_STRONG is not set
CONFIG_HAVE_ARCH_WITHIN_STACK_FRAMES=y
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_HUGE_VMAP=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_HAVE_IRQ_EXIT_ON_IRQ_STACK=y
CONFIG_ARCH_HAS_ELF_RANDOMIZE=y
CONFIG_HAVE_ARCH_MMAP_RND_BITS=y
CONFIG_HAVE_EXIT_THREAD=y
CONFIG_ARCH_MMAP_RND_BITS=28
CONFIG_HAVE_ARCH_MMAP_RND_COMPAT_BITS=y
CONFIG_ARCH_MMAP_RND_COMPAT_BITS=8
CONFIG_HAVE_COPY_THREAD_TLS=y
CONFIG_HAVE_STACK_VALIDATION=y
# CONFIG_HAVE_ARCH_HASH is not set
# CONFIG_ISA_BUS_API is not set
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_COMPAT_OLD_SIGACTION=y
# CONFIG_CPU_NO_EFFICIENT_FFS is not set
CONFIG_HAVE_ARCH_VMAP_STACK=y
CONFIG_VMAP_STACK=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_ARCH_HAS_GCOV_PROFILE_ALL=y
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
# CONFIG_MODULE_SIG is not set
# CONFIG_MODULE_COMPRESS is not set
# CONFIG_TRIM_UNUSED_KSYMS is not set
CONFIG_MODULES_TREE_LOOKUP=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLK_DEV_THROTTLING=y
# CONFIG_BLK_CMDLINE_PARSER is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_AIX_PARTITION is not set
CONFIG_OSF_PARTITION=y
CONFIG_AMIGA_PARTITION=y
# CONFIG_ATARI_PARTITION is not set
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
# CONFIG_LDM_PARTITION is not set
CONFIG_SGI_PARTITION=y
# CONFIG_ULTRIX_PARTITION is not set
CONFIG_SUN_PARTITION=y
CONFIG_KARMA_PARTITION=y
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
# CONFIG_CMDLINE_PARTITION is not set
CONFIG_BLOCK_COMPAT=y
CONFIG_BLK_MQ_PCI=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
CONFIG_CFQ_GROUP_IOSCHED=y
CONFIG_DEFAULT_DEADLINE=y
# CONFIG_DEFAULT_CFQ is not set
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="deadline"
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_PADATA=y
CONFIG_ASN1=y
CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
CONFIG_INLINE_READ_UNLOCK=y
CONFIG_INLINE_READ_UNLOCK_IRQ=y
CONFIG_INLINE_WRITE_UNLOCK=y
CONFIG_INLINE_WRITE_UNLOCK_IRQ=y
CONFIG_ARCH_SUPPORTS_ATOMIC_RMW=y
CONFIG_MUTEX_SPIN_ON_OWNER=y
CONFIG_RWSEM_SPIN_ON_OWNER=y
CONFIG_LOCK_SPIN_ON_OWNER=y
CONFIG_ARCH_USE_QUEUED_SPINLOCKS=y
CONFIG_QUEUED_SPINLOCKS=y
CONFIG_ARCH_USE_QUEUED_RWLOCKS=y
CONFIG_QUEUED_RWLOCKS=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
CONFIG_X86_FEATURE_NAMES=y
CONFIG_X86_FAST_FEATURE_TESTS=y
CONFIG_X86_X2APIC=y
CONFIG_X86_MPPARSE=y
# CONFIG_GOLDFISH is not set
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_NUMACHIP is not set
# CONFIG_X86_VSMP is not set
CONFIG_X86_UV=y
# CONFIG_X86_GOLDFISH is not set
# CONFIG_X86_INTEL_MID is not set
# CONFIG_MLX_PLATFORM is not set
CONFIG_X86_INTEL_LPSS=y
# CONFIG_X86_AMD_PLATFORM_DEVICE is not set
CONFIG_IOSF_MBI=y
# CONFIG_IOSF_MBI_DEBUG is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_PARAVIRT_SPINLOCKS=y
# CONFIG_QUEUED_LOCK_STAT is not set
CONFIG_XEN=y
CONFIG_XEN_DOM0=y
CONFIG_XEN_PVHVM=y
CONFIG_XEN_512GB=y
CONFIG_XEN_SAVE_RESTORE=y
# CONFIG_XEN_DEBUG_FS is not set
# CONFIG_XEN_PVH is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
CONFIG_PARAVIRT_TIME_ACCOUNTING=y
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_MAXSMP=y
CONFIG_NR_CPUS=8192
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=m
CONFIG_X86_THERMAL_VECTOR=y

#
# Performance monitoring
#
CONFIG_PERF_EVENTS_INTEL_UNCORE=y
CONFIG_PERF_EVENTS_INTEL_RAPL=y
CONFIG_PERF_EVENTS_INTEL_CSTATE=y
# CONFIG_PERF_EVENTS_AMD_POWER is not set
# CONFIG_VM86 is not set
CONFIG_X86_16BIT=y
CONFIG_X86_ESPFIX64=y
CONFIG_X86_VSYSCALL_EMULATION=y
CONFIG_I8K=m
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_X86_DIRECT_GBPAGES=y
CONFIG_NUMA=y
CONFIG_AMD_NUMA=y
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NODES_SPAN_OTHER_NODES=y
# CONFIG_NUMA_EMU is not set
CONFIG_NODES_SHIFT=10
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_MEMORY_PROBE=y
CONFIG_ARCH_PROC_KCORE_TEXT=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_NEED_MULTIPLE_NODES=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MEMORY_ISOLATION=y
CONFIG_MOVABLE_NODE=y
CONFIG_HAVE_BOOTMEM_INFO_NODE=y
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
# CONFIG_MEMORY_HOTPLUG_DEFAULT_ONLINE is not set
CONFIG_MEMORY_HOTREMOVE=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
CONFIG_MEMORY_BALLOON=y
CONFIG_BALLOON_COMPACTION=y
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
CONFIG_HWPOISON_INJECT=m
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
CONFIG_TRANSPARENT_HUGE_PAGECACHE=y
CONFIG_CLEANCACHE=y
CONFIG_FRONTSWAP=y
CONFIG_CMA=y
# CONFIG_CMA_DEBUG is not set
# CONFIG_CMA_DEBUGFS is not set
CONFIG_CMA_AREAS=7
CONFIG_ZSWAP=y
CONFIG_ZPOOL=y
CONFIG_ZBUD=y
# CONFIG_Z3FOLD is not set
CONFIG_ZSMALLOC=y
# CONFIG_PGTABLE_MAPPING is not set
# CONFIG_ZSMALLOC_STAT is not set
CONFIG_GENERIC_EARLY_IOREMAP=y
CONFIG_ARCH_SUPPORTS_DEFERRED_STRUCT_PAGE_INIT=y
# CONFIG_DEFERRED_STRUCT_PAGE_INIT is not set
# CONFIG_IDLE_PAGE_TRACKING is not set
CONFIG_ZONE_DEVICE=y
CONFIG_FRAME_VECTOR=y
CONFIG_ARCH_USES_HIGH_VMA_FLAGS=y
CONFIG_ARCH_HAS_PKEYS=y
CONFIG_X86_PMEM_LEGACY_DEVICE=y
CONFIG_X86_PMEM_LEGACY=m
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
# CONFIG_X86_INTEL_MPX is not set
CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS=y
CONFIG_EFI=y
CONFIG_EFI_STUB=y
# CONFIG_EFI_MIXED is not set
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
# CONFIG_KEXEC_FILE is not set
CONFIG_CRASH_DUMP=y
CONFIG_KEXEC_JUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
# CONFIG_RANDOMIZE_BASE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
# CONFIG_BOOTPARAM_HOTPLUG_CPU0 is not set
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
# CONFIG_COMPAT_VDSO is not set
# CONFIG_LEGACY_VSYSCALL_NATIVE is not set
CONFIG_LEGACY_VSYSCALL_EMULATE=y
# CONFIG_LEGACY_VSYSCALL_NONE is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_MODIFY_LDT_SYSCALL=y
CONFIG_HAVE_LIVEPATCH=y
# CONFIG_LIVEPATCH is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
CONFIG_USE_PERCPU_NUMA_NODE_ID=y

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
# CONFIG_PM_AUTOSLEEP is not set
# CONFIG_PM_WAKELOCKS is not set
CONFIG_PM=y
CONFIG_PM_DEBUG=y
CONFIG_PM_ADVANCED_DEBUG=y
CONFIG_PM_TEST_SUSPEND=y
CONFIG_PM_SLEEP_DEBUG=y
# CONFIG_PM_TRACE_RTC is not set
CONFIG_PM_CLK=y
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ACPI=y
CONFIG_ACPI_LEGACY_TABLES_LOOKUP=y
CONFIG_ARCH_MIGHT_HAVE_ACPI_PDC=y
CONFIG_ACPI_SYSTEM_POWER_STATES_SUPPORT=y
# CONFIG_ACPI_DEBUGGER is not set
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS_POWER is not set
CONFIG_ACPI_REV_OVERRIDE_POSSIBLE=y
CONFIG_ACPI_EC_DEBUGFS=m
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=m
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_CPU_FREQ_PSS=y
CONFIG_ACPI_PROCESSOR_CSTATE=y
CONFIG_ACPI_PROCESSOR_IDLE=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_IPMI=m
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_PROCESSOR_AGGREGATOR=m
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_NUMA=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ARCH_HAS_ACPI_TABLE_UPGRADE=y
CONFIG_ACPI_TABLE_UPGRADE=y
CONFIG_ACPI_DEBUG=y
CONFIG_ACPI_PCI_SLOT=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_HOTPLUG_MEMORY=y
CONFIG_ACPI_HOTPLUG_IOAPIC=y
CONFIG_ACPI_SBS=m
CONFIG_ACPI_HED=y
CONFIG_ACPI_CUSTOM_METHOD=m
CONFIG_ACPI_BGRT=y
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
CONFIG_ACPI_NFIT=m
# CONFIG_ACPI_NFIT_DEBUG is not set
CONFIG_HAVE_ACPI_APEI=y
CONFIG_HAVE_ACPI_APEI_NMI=y
CONFIG_ACPI_APEI=y
CONFIG_ACPI_APEI_GHES=y
CONFIG_ACPI_APEI_PCIEAER=y
CONFIG_ACPI_APEI_MEMORY_FAILURE=y
CONFIG_ACPI_APEI_EINJ=m
# CONFIG_ACPI_APEI_ERST_DEBUG is not set
# CONFIG_DPTF_POWER is not set
# CONFIG_ACPI_EXTLOG is not set
# CONFIG_PMIC_OPREGION is not set
# CONFIG_ACPI_CONFIGFS is not set
CONFIG_SFI=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_GOV_ATTR_SET=y
CONFIG_CPU_FREQ_GOV_COMMON=y
# CONFIG_CPU_FREQ_STAT is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_SCHEDUTIL is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y
# CONFIG_CPU_FREQ_GOV_SCHEDUTIL is not set

#
# CPU frequency scaling drivers
#
CONFIG_X86_INTEL_PSTATE=y
CONFIG_X86_PCC_CPUFREQ=m
CONFIG_X86_ACPI_CPUFREQ=m
CONFIG_X86_ACPI_CPUFREQ_CPB=y
CONFIG_X86_POWERNOW_K8=m
CONFIG_X86_AMD_FREQ_SENSITIVITY=m
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
CONFIG_X86_P4_CLOCKMOD=m

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=m

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_GOV_LADDER is not set
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
CONFIG_INTEL_IDLE=y

#
# Memory power savings
#
CONFIG_I7300_IDLE_IOAT_CHANNEL=y
CONFIG_I7300_IDLE=m

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_XEN=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=y
CONFIG_PCIEAER=y
CONFIG_PCIE_ECRC=y
CONFIG_PCIEAER_INJECT=m
CONFIG_PCIEASPM=y
# CONFIG_PCIEASPM_DEBUG is not set
CONFIG_PCIEASPM_DEFAULT=y
# CONFIG_PCIEASPM_POWERSAVE is not set
# CONFIG_PCIEASPM_PERFORMANCE is not set
CONFIG_PCIE_PME=y
# CONFIG_PCIE_DPC is not set
# CONFIG_PCIE_PTM is not set
CONFIG_PCI_BUS_ADDR_T_64BIT=y
CONFIG_PCI_MSI=y
CONFIG_PCI_MSI_IRQ_DOMAIN=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
CONFIG_PCI_STUB=y
# CONFIG_XEN_PCIDEV_FRONTEND is not set
CONFIG_HT_IRQ=y
CONFIG_PCI_ATS=y
CONFIG_PCI_IOV=y
CONFIG_PCI_PRI=y
CONFIG_PCI_PASID=y
CONFIG_PCI_LABEL=y
# CONFIG_PCI_HYPERV is not set
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_ACPI=y
CONFIG_HOTPLUG_PCI_ACPI_IBM=m
# CONFIG_HOTPLUG_PCI_CPCI is not set
CONFIG_HOTPLUG_PCI_SHPC=m

#
# PCI host controller drivers
#
# CONFIG_PCIE_DW_PLAT is not set
# CONFIG_VMD is not set
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
# CONFIG_PCMCIA is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=m
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
CONFIG_YENTA_TI=y
CONFIG_YENTA_ENE_TUNE=y
CONFIG_YENTA_TOSHIBA=y
# CONFIG_RAPIDIO is not set
# CONFIG_X86_SYSFB is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ELFCORE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_BINFMT_SCRIPT=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=m
CONFIG_COREDUMP=y
CONFIG_IA32_EMULATION=y
# CONFIG_IA32_AOUT is not set
# CONFIG_X86_X32 is not set
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_KEYS_COMPAT=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_PMC_ATOM=y
CONFIG_NET=y
CONFIG_COMPAT_NETLINK_MESSAGES=y
CONFIG_NET_INGRESS=y
CONFIG_NET_EGRESS=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_DIAG=m
CONFIG_UNIX=y
CONFIG_UNIX_DIAG=m
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_USER=y
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
CONFIG_XFRM_STATISTICS=y
CONFIG_XFRM_IPCOMP=m
CONFIG_NET_KEY=m
CONFIG_NET_KEY_MIGRATE=y
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_IP_FIB_TRIE_STATS=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_ROUTE_CLASSID=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
# CONFIG_IP_PNP_BOOTP is not set
# CONFIG_IP_PNP_RARP is not set
CONFIG_NET_IPIP=m
CONFIG_NET_IPGRE_DEMUX=m
CONFIG_NET_IP_TUNNEL=m
CONFIG_NET_IPGRE=m
CONFIG_NET_IPGRE_BROADCAST=y
CONFIG_IP_MROUTE=y
CONFIG_IP_MROUTE_MULTIPLE_TABLES=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
CONFIG_SYN_COOKIES=y
CONFIG_NET_IPVTI=m
CONFIG_NET_UDP_TUNNEL=m
# CONFIG_NET_FOU is not set
# CONFIG_NET_FOU_IP_TUNNELS is not set
CONFIG_INET_AH=m
CONFIG_INET_ESP=m
CONFIG_INET_IPCOMP=m
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=m
CONFIG_INET_XFRM_MODE_TRANSPORT=m
CONFIG_INET_XFRM_MODE_TUNNEL=m
CONFIG_INET_XFRM_MODE_BEET=m
CONFIG_INET_DIAG=m
CONFIG_INET_TCP_DIAG=m
CONFIG_INET_UDP_DIAG=m
# CONFIG_INET_DIAG_DESTROY is not set
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=m
CONFIG_TCP_CONG_CUBIC=y
CONFIG_TCP_CONG_WESTWOOD=m
CONFIG_TCP_CONG_HTCP=m
CONFIG_TCP_CONG_HSTCP=m
CONFIG_TCP_CONG_HYBLA=m
CONFIG_TCP_CONG_VEGAS=m
# CONFIG_TCP_CONG_NV is not set
CONFIG_TCP_CONG_SCALABLE=m
CONFIG_TCP_CONG_LP=m
CONFIG_TCP_CONG_VENO=m
CONFIG_TCP_CONG_YEAH=m
CONFIG_TCP_CONG_ILLINOIS=m
# CONFIG_TCP_CONG_DCTCP is not set
# CONFIG_TCP_CONG_CDG is not set
# CONFIG_TCP_CONG_BBR is not set
CONFIG_DEFAULT_CUBIC=y
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=y
CONFIG_IPV6_ROUTER_PREF=y
CONFIG_IPV6_ROUTE_INFO=y
CONFIG_IPV6_OPTIMISTIC_DAD=y
CONFIG_INET6_AH=m
CONFIG_INET6_ESP=m
CONFIG_INET6_IPCOMP=m
CONFIG_IPV6_MIP6=m
# CONFIG_IPV6_ILA is not set
CONFIG_INET6_XFRM_TUNNEL=m
CONFIG_INET6_TUNNEL=m
CONFIG_INET6_XFRM_MODE_TRANSPORT=m
CONFIG_INET6_XFRM_MODE_TUNNEL=m
CONFIG_INET6_XFRM_MODE_BEET=m
CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=m
# CONFIG_IPV6_VTI is not set
CONFIG_IPV6_SIT=m
CONFIG_IPV6_SIT_6RD=y
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=m
# CONFIG_IPV6_GRE is not set
# CONFIG_IPV6_FOU is not set
# CONFIG_IPV6_FOU_TUNNEL is not set
CONFIG_IPV6_MULTIPLE_TABLES=y
# CONFIG_IPV6_SUBTREES is not set
CONFIG_IPV6_MROUTE=y
CONFIG_IPV6_MROUTE_MULTIPLE_TABLES=y
CONFIG_IPV6_PIMSM_V2=y
CONFIG_NETLABEL=y
CONFIG_NETWORK_SECMARK=y
CONFIG_NET_PTP_CLASSIFY=y
CONFIG_NETWORK_PHY_TIMESTAMPING=y
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=m

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_INGRESS=y
CONFIG_NETFILTER_NETLINK=m
CONFIG_NETFILTER_NETLINK_ACCT=m
CONFIG_NETFILTER_NETLINK_QUEUE=m
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NF_CONNTRACK=m
CONFIG_NF_LOG_COMMON=m
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_SECMARK=y
CONFIG_NF_CONNTRACK_ZONES=y
CONFIG_NF_CONNTRACK_PROCFS=y
CONFIG_NF_CONNTRACK_EVENTS=y
# CONFIG_NF_CONNTRACK_TIMEOUT is not set
CONFIG_NF_CONNTRACK_TIMESTAMP=y
CONFIG_NF_CONNTRACK_LABELS=y
CONFIG_NF_CT_PROTO_DCCP=m
CONFIG_NF_CT_PROTO_GRE=m
CONFIG_NF_CT_PROTO_SCTP=m
CONFIG_NF_CT_PROTO_UDPLITE=m
CONFIG_NF_CONNTRACK_AMANDA=m
CONFIG_NF_CONNTRACK_FTP=m
CONFIG_NF_CONNTRACK_H323=m
CONFIG_NF_CONNTRACK_IRC=m
CONFIG_NF_CONNTRACK_BROADCAST=m
CONFIG_NF_CONNTRACK_NETBIOS_NS=m
CONFIG_NF_CONNTRACK_SNMP=m
CONFIG_NF_CONNTRACK_PPTP=m
CONFIG_NF_CONNTRACK_SANE=m
CONFIG_NF_CONNTRACK_SIP=m
CONFIG_NF_CONNTRACK_TFTP=m
CONFIG_NF_CT_NETLINK=m
# CONFIG_NF_CT_NETLINK_TIMEOUT is not set
# CONFIG_NETFILTER_NETLINK_GLUE_CT is not set
CONFIG_NF_NAT=m
CONFIG_NF_NAT_NEEDED=y
CONFIG_NF_NAT_PROTO_DCCP=m
CONFIG_NF_NAT_PROTO_UDPLITE=m
CONFIG_NF_NAT_PROTO_SCTP=m
CONFIG_NF_NAT_AMANDA=m
CONFIG_NF_NAT_FTP=m
CONFIG_NF_NAT_IRC=m
CONFIG_NF_NAT_SIP=m
CONFIG_NF_NAT_TFTP=m
CONFIG_NF_NAT_REDIRECT=m
CONFIG_NETFILTER_SYNPROXY=m
CONFIG_NF_TABLES=m
# CONFIG_NF_TABLES_INET is not set
# CONFIG_NF_TABLES_NETDEV is not set
CONFIG_NFT_EXTHDR=m
CONFIG_NFT_META=m
# CONFIG_NFT_NUMGEN is not set
CONFIG_NFT_CT=m
# CONFIG_NFT_SET_RBTREE is not set
# CONFIG_NFT_SET_HASH is not set
CONFIG_NFT_COUNTER=m
CONFIG_NFT_LOG=m
CONFIG_NFT_LIMIT=m
# CONFIG_NFT_MASQ is not set
# CONFIG_NFT_REDIR is not set
CONFIG_NFT_NAT=m
# CONFIG_NFT_QUEUE is not set
# CONFIG_NFT_QUOTA is not set
# CONFIG_NFT_REJECT is not set
CONFIG_NFT_COMPAT=m
CONFIG_NFT_HASH=m
CONFIG_NETFILTER_XTABLES=y

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=m
CONFIG_NETFILTER_XT_CONNMARK=m
CONFIG_NETFILTER_XT_SET=m

#
# Xtables targets
#
CONFIG_NETFILTER_XT_TARGET_AUDIT=m
CONFIG_NETFILTER_XT_TARGET_CHECKSUM=m
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=m
CONFIG_NETFILTER_XT_TARGET_CT=m
CONFIG_NETFILTER_XT_TARGET_DSCP=m
CONFIG_NETFILTER_XT_TARGET_HL=m
CONFIG_NETFILTER_XT_TARGET_HMARK=m
CONFIG_NETFILTER_XT_TARGET_IDLETIMER=m
CONFIG_NETFILTER_XT_TARGET_LED=m
CONFIG_NETFILTER_XT_TARGET_LOG=m
CONFIG_NETFILTER_XT_TARGET_MARK=m
CONFIG_NETFILTER_XT_NAT=m
CONFIG_NETFILTER_XT_TARGET_NETMAP=m
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
CONFIG_NETFILTER_XT_TARGET_NOTRACK=m
CONFIG_NETFILTER_XT_TARGET_RATEEST=m
CONFIG_NETFILTER_XT_TARGET_REDIRECT=m
CONFIG_NETFILTER_XT_TARGET_TEE=m
CONFIG_NETFILTER_XT_TARGET_TPROXY=m
CONFIG_NETFILTER_XT_TARGET_TRACE=m
CONFIG_NETFILTER_XT_TARGET_SECMARK=m
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=m

#
# Xtables matches
#
CONFIG_NETFILTER_XT_MATCH_ADDRTYPE=m
CONFIG_NETFILTER_XT_MATCH_BPF=m
# CONFIG_NETFILTER_XT_MATCH_CGROUP is not set
CONFIG_NETFILTER_XT_MATCH_CLUSTER=m
CONFIG_NETFILTER_XT_MATCH_COMMENT=m
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=m
CONFIG_NETFILTER_XT_MATCH_CONNLABEL=m
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=m
CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
CONFIG_NETFILTER_XT_MATCH_CPU=m
CONFIG_NETFILTER_XT_MATCH_DCCP=m
CONFIG_NETFILTER_XT_MATCH_DEVGROUP=m
CONFIG_NETFILTER_XT_MATCH_DSCP=m
CONFIG_NETFILTER_XT_MATCH_ECN=m
CONFIG_NETFILTER_XT_MATCH_ESP=m
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m
CONFIG_NETFILTER_XT_MATCH_HELPER=m
CONFIG_NETFILTER_XT_MATCH_HL=m
# CONFIG_NETFILTER_XT_MATCH_IPCOMP is not set
CONFIG_NETFILTER_XT_MATCH_IPRANGE=m
CONFIG_NETFILTER_XT_MATCH_IPVS=m
CONFIG_NETFILTER_XT_MATCH_L2TP=m
CONFIG_NETFILTER_XT_MATCH_LENGTH=m
CONFIG_NETFILTER_XT_MATCH_LIMIT=m
CONFIG_NETFILTER_XT_MATCH_MAC=m
CONFIG_NETFILTER_XT_MATCH_MARK=m
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
CONFIG_NETFILTER_XT_MATCH_NFACCT=m
CONFIG_NETFILTER_XT_MATCH_OSF=m
CONFIG_NETFILTER_XT_MATCH_OWNER=m
CONFIG_NETFILTER_XT_MATCH_POLICY=m
CONFIG_NETFILTER_XT_MATCH_PHYSDEV=m
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
CONFIG_NETFILTER_XT_MATCH_QUOTA=m
CONFIG_NETFILTER_XT_MATCH_RATEEST=m
CONFIG_NETFILTER_XT_MATCH_REALM=m
CONFIG_NETFILTER_XT_MATCH_RECENT=m
CONFIG_NETFILTER_XT_MATCH_SCTP=m
CONFIG_NETFILTER_XT_MATCH_SOCKET=m
CONFIG_NETFILTER_XT_MATCH_STATE=m
CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
CONFIG_NETFILTER_XT_MATCH_STRING=m
CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
CONFIG_NETFILTER_XT_MATCH_TIME=m
CONFIG_NETFILTER_XT_MATCH_U32=m
CONFIG_IP_SET=m
CONFIG_IP_SET_MAX=256
CONFIG_IP_SET_BITMAP_IP=m
CONFIG_IP_SET_BITMAP_IPMAC=m
CONFIG_IP_SET_BITMAP_PORT=m
CONFIG_IP_SET_HASH_IP=m
# CONFIG_IP_SET_HASH_IPMARK is not set
CONFIG_IP_SET_HASH_IPPORT=m
CONFIG_IP_SET_HASH_IPPORTIP=m
CONFIG_IP_SET_HASH_IPPORTNET=m
# CONFIG_IP_SET_HASH_MAC is not set
# CONFIG_IP_SET_HASH_NETPORTNET is not set
CONFIG_IP_SET_HASH_NET=m
# CONFIG_IP_SET_HASH_NETNET is not set
CONFIG_IP_SET_HASH_NETPORT=m
CONFIG_IP_SET_HASH_NETIFACE=m
CONFIG_IP_SET_LIST_SET=m
CONFIG_IP_VS=m
CONFIG_IP_VS_IPV6=y
# CONFIG_IP_VS_DEBUG is not set
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
CONFIG_IP_VS_PROTO_TCP=y
CONFIG_IP_VS_PROTO_UDP=y
CONFIG_IP_VS_PROTO_AH_ESP=y
CONFIG_IP_VS_PROTO_ESP=y
CONFIG_IP_VS_PROTO_AH=y
CONFIG_IP_VS_PROTO_SCTP=y

#
# IPVS scheduler
#
CONFIG_IP_VS_RR=m
CONFIG_IP_VS_WRR=m
CONFIG_IP_VS_LC=m
CONFIG_IP_VS_WLC=m
# CONFIG_IP_VS_FO is not set
# CONFIG_IP_VS_OVF is not set
CONFIG_IP_VS_LBLC=m
CONFIG_IP_VS_LBLCR=m
CONFIG_IP_VS_DH=m
CONFIG_IP_VS_SH=m
CONFIG_IP_VS_SED=m
CONFIG_IP_VS_NQ=m

#
# IPVS SH scheduler
#
CONFIG_IP_VS_SH_TAB_BITS=8

#
# IPVS application helper
#
CONFIG_IP_VS_FTP=m
CONFIG_IP_VS_NFCT=y
CONFIG_IP_VS_PE_SIP=m

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=m
CONFIG_NF_CONNTRACK_IPV4=m
CONFIG_NF_TABLES_IPV4=m
CONFIG_NFT_CHAIN_ROUTE_IPV4=m
# CONFIG_NFT_REJECT_IPV4 is not set
# CONFIG_NFT_DUP_IPV4 is not set
# CONFIG_NF_TABLES_ARP is not set
CONFIG_NF_DUP_IPV4=m
# CONFIG_NF_LOG_ARP is not set
CONFIG_NF_LOG_IPV4=m
CONFIG_NF_REJECT_IPV4=m
CONFIG_NF_NAT_IPV4=m
CONFIG_NFT_CHAIN_NAT_IPV4=m
CONFIG_NF_NAT_MASQUERADE_IPV4=m
CONFIG_NF_NAT_SNMP_BASIC=m
CONFIG_NF_NAT_PROTO_GRE=m
CONFIG_NF_NAT_PPTP=m
CONFIG_NF_NAT_H323=m
CONFIG_IP_NF_IPTABLES=m
CONFIG_IP_NF_MATCH_AH=m
CONFIG_IP_NF_MATCH_ECN=m
CONFIG_IP_NF_MATCH_RPFILTER=m
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_FILTER=m
CONFIG_IP_NF_TARGET_REJECT=m
CONFIG_IP_NF_TARGET_SYNPROXY=m
CONFIG_IP_NF_NAT=m
CONFIG_IP_NF_TARGET_MASQUERADE=m
CONFIG_IP_NF_TARGET_NETMAP=m
CONFIG_IP_NF_TARGET_REDIRECT=m
CONFIG_IP_NF_MANGLE=m
CONFIG_IP_NF_TARGET_CLUSTERIP=m
CONFIG_IP_NF_TARGET_ECN=m
CONFIG_IP_NF_TARGET_TTL=m
CONFIG_IP_NF_RAW=m
CONFIG_IP_NF_SECURITY=m
CONFIG_IP_NF_ARPTABLES=m
CONFIG_IP_NF_ARPFILTER=m
CONFIG_IP_NF_ARP_MANGLE=m

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV6=m
CONFIG_NF_CONNTRACK_IPV6=m
CONFIG_NF_TABLES_IPV6=m
CONFIG_NFT_CHAIN_ROUTE_IPV6=m
# CONFIG_NFT_REJECT_IPV6 is not set
# CONFIG_NFT_DUP_IPV6 is not set
CONFIG_NF_DUP_IPV6=m
CONFIG_NF_REJECT_IPV6=m
CONFIG_NF_LOG_IPV6=m
CONFIG_NF_NAT_IPV6=m
CONFIG_NFT_CHAIN_NAT_IPV6=m
# CONFIG_NF_NAT_MASQUERADE_IPV6 is not set
CONFIG_IP6_NF_IPTABLES=m
CONFIG_IP6_NF_MATCH_AH=m
CONFIG_IP6_NF_MATCH_EUI64=m
CONFIG_IP6_NF_MATCH_FRAG=m
CONFIG_IP6_NF_MATCH_OPTS=m
CONFIG_IP6_NF_MATCH_HL=m
CONFIG_IP6_NF_MATCH_IPV6HEADER=m
CONFIG_IP6_NF_MATCH_MH=m
CONFIG_IP6_NF_MATCH_RPFILTER=m
CONFIG_IP6_NF_MATCH_RT=m
CONFIG_IP6_NF_TARGET_HL=m
CONFIG_IP6_NF_FILTER=m
CONFIG_IP6_NF_TARGET_REJECT=m
CONFIG_IP6_NF_TARGET_SYNPROXY=m
CONFIG_IP6_NF_MANGLE=m
CONFIG_IP6_NF_RAW=m
CONFIG_IP6_NF_SECURITY=m
# CONFIG_IP6_NF_NAT is not set
CONFIG_NF_TABLES_BRIDGE=m
# CONFIG_NFT_BRIDGE_META is not set
# CONFIG_NF_LOG_BRIDGE is not set
CONFIG_BRIDGE_NF_EBTABLES=m
CONFIG_BRIDGE_EBT_BROUTE=m
CONFIG_BRIDGE_EBT_T_FILTER=m
CONFIG_BRIDGE_EBT_T_NAT=m
CONFIG_BRIDGE_EBT_802_3=m
CONFIG_BRIDGE_EBT_AMONG=m
CONFIG_BRIDGE_EBT_ARP=m
CONFIG_BRIDGE_EBT_IP=m
CONFIG_BRIDGE_EBT_IP6=m
CONFIG_BRIDGE_EBT_LIMIT=m
CONFIG_BRIDGE_EBT_MARK=m
CONFIG_BRIDGE_EBT_PKTTYPE=m
CONFIG_BRIDGE_EBT_STP=m
CONFIG_BRIDGE_EBT_VLAN=m
CONFIG_BRIDGE_EBT_ARPREPLY=m
CONFIG_BRIDGE_EBT_DNAT=m
CONFIG_BRIDGE_EBT_MARK_T=m
CONFIG_BRIDGE_EBT_REDIRECT=m
CONFIG_BRIDGE_EBT_SNAT=m
CONFIG_BRIDGE_EBT_LOG=m
CONFIG_BRIDGE_EBT_NFLOG=m
CONFIG_IP_DCCP=m
CONFIG_INET_DCCP_DIAG=m

#
# DCCP CCIDs Configuration
#
# CONFIG_IP_DCCP_CCID2_DEBUG is not set
CONFIG_IP_DCCP_CCID3=y
# CONFIG_IP_DCCP_CCID3_DEBUG is not set
CONFIG_IP_DCCP_TFRC_LIB=y

#
# DCCP Kernel Hacking
#
# CONFIG_IP_DCCP_DEBUG is not set
# CONFIG_NET_DCCPPROBE is not set
CONFIG_IP_SCTP=m
CONFIG_NET_SCTPPROBE=m
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5 is not set
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE is not set
CONFIG_SCTP_COOKIE_HMAC_MD5=y
CONFIG_SCTP_COOKIE_HMAC_SHA1=y
CONFIG_INET_SCTP_DIAG=m
# CONFIG_RDS is not set
CONFIG_TIPC=m
CONFIG_TIPC_MEDIA_UDP=y
CONFIG_ATM=m
CONFIG_ATM_CLIP=m
# CONFIG_ATM_CLIP_NO_ICMP is not set
CONFIG_ATM_LANE=m
# CONFIG_ATM_MPOA is not set
CONFIG_ATM_BR2684=m
# CONFIG_ATM_BR2684_IPFILTER is not set
CONFIG_L2TP=m
CONFIG_L2TP_DEBUGFS=m
CONFIG_L2TP_V3=y
CONFIG_L2TP_IP=m
CONFIG_L2TP_ETH=m
CONFIG_STP=m
CONFIG_GARP=m
CONFIG_MRP=m
CONFIG_BRIDGE=m
CONFIG_BRIDGE_IGMP_SNOOPING=y
CONFIG_BRIDGE_VLAN_FILTERING=y
CONFIG_HAVE_NET_DSA=y
CONFIG_VLAN_8021Q=m
CONFIG_VLAN_8021Q_GVRP=y
CONFIG_VLAN_8021Q_MVRP=y
# CONFIG_DECNET is not set
CONFIG_LLC=m
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_PHONET is not set
# CONFIG_6LOWPAN is not set
CONFIG_IEEE802154=m
# CONFIG_IEEE802154_NL802154_EXPERIMENTAL is not set
CONFIG_IEEE802154_SOCKET=m
CONFIG_MAC802154=m
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=m
CONFIG_NET_SCH_HTB=m
CONFIG_NET_SCH_HFSC=m
CONFIG_NET_SCH_ATM=m
CONFIG_NET_SCH_PRIO=m
CONFIG_NET_SCH_MULTIQ=m
CONFIG_NET_SCH_RED=m
CONFIG_NET_SCH_SFB=m
CONFIG_NET_SCH_SFQ=m
CONFIG_NET_SCH_TEQL=m
CONFIG_NET_SCH_TBF=m
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_DSMARK=m
CONFIG_NET_SCH_NETEM=m
CONFIG_NET_SCH_DRR=m
CONFIG_NET_SCH_MQPRIO=m
CONFIG_NET_SCH_CHOKE=m
CONFIG_NET_SCH_QFQ=m
CONFIG_NET_SCH_CODEL=m
CONFIG_NET_SCH_FQ_CODEL=m
# CONFIG_NET_SCH_FQ is not set
# CONFIG_NET_SCH_HHF is not set
# CONFIG_NET_SCH_PIE is not set
CONFIG_NET_SCH_INGRESS=m
CONFIG_NET_SCH_PLUG=m

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=m
CONFIG_NET_CLS_TCINDEX=m
CONFIG_NET_CLS_ROUTE4=m
CONFIG_NET_CLS_FW=m
CONFIG_NET_CLS_U32=m
CONFIG_CLS_U32_PERF=y
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=m
CONFIG_NET_CLS_RSVP6=m
CONFIG_NET_CLS_FLOW=m
CONFIG_NET_CLS_CGROUP=y
# CONFIG_NET_CLS_BPF is not set
# CONFIG_NET_CLS_FLOWER is not set
# CONFIG_NET_CLS_MATCHALL is not set
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=m
CONFIG_NET_EMATCH_NBYTE=m
CONFIG_NET_EMATCH_U32=m
CONFIG_NET_EMATCH_META=m
CONFIG_NET_EMATCH_TEXT=m
CONFIG_NET_EMATCH_IPSET=m
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=m
CONFIG_NET_ACT_GACT=m
CONFIG_GACT_PROB=y
CONFIG_NET_ACT_MIRRED=m
CONFIG_NET_ACT_IPT=m
CONFIG_NET_ACT_NAT=m
CONFIG_NET_ACT_PEDIT=m
CONFIG_NET_ACT_SIMP=m
CONFIG_NET_ACT_SKBEDIT=m
CONFIG_NET_ACT_CSUM=m
# CONFIG_NET_ACT_VLAN is not set
# CONFIG_NET_ACT_BPF is not set
# CONFIG_NET_ACT_CONNMARK is not set
# CONFIG_NET_ACT_SKBMOD is not set
# CONFIG_NET_ACT_IFE is not set
# CONFIG_NET_ACT_TUNNEL_KEY is not set
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=m
# CONFIG_BATMAN_ADV is not set
CONFIG_OPENVSWITCH=m
CONFIG_OPENVSWITCH_GRE=m
CONFIG_OPENVSWITCH_VXLAN=m
CONFIG_VSOCKETS=m
CONFIG_VMWARE_VMCI_VSOCKETS=m
# CONFIG_VIRTIO_VSOCKETS is not set
CONFIG_NETLINK_DIAG=m
CONFIG_MPLS=y
CONFIG_NET_MPLS_GSO=m
# CONFIG_MPLS_ROUTING is not set
# CONFIG_HSR is not set
# CONFIG_NET_SWITCHDEV is not set
# CONFIG_NET_L3_MASTER_DEV is not set
# CONFIG_NET_NCSI is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
CONFIG_SOCK_CGROUP_DATA=y
# CONFIG_CGROUP_NET_PRIO is not set
CONFIG_CGROUP_NET_CLASSID=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_BPF_JIT=y
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
CONFIG_NET_PKTGEN=m
# CONFIG_NET_TCPPROBE is not set
CONFIG_NET_DROP_MONITOR=y
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set
# CONFIG_AF_KCM is not set
# CONFIG_STREAM_PARSER is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_WIRELESS_EXT=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_WEXT_PRIV=y
CONFIG_CFG80211=m
# CONFIG_NL80211_TESTMODE is not set
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
CONFIG_CFG80211_DEFAULT_PS=y
# CONFIG_CFG80211_DEBUGFS is not set
# CONFIG_CFG80211_INTERNAL_REGDB is not set
CONFIG_CFG80211_CRDA_SUPPORT=y
CONFIG_CFG80211_WEXT=y
CONFIG_LIB80211=m
# CONFIG_LIB80211_DEBUG is not set
CONFIG_MAC80211=m
CONFIG_MAC80211_HAS_RC=y
CONFIG_MAC80211_RC_MINSTREL=y
CONFIG_MAC80211_RC_MINSTREL_HT=y
# CONFIG_MAC80211_RC_MINSTREL_VHT is not set
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel_ht"
CONFIG_MAC80211_MESH=y
CONFIG_MAC80211_LEDS=y
# CONFIG_MAC80211_DEBUGFS is not set
# CONFIG_MAC80211_MESSAGE_TRACING is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
CONFIG_MAC80211_STA_HASH_MAX_SIZE=0
# CONFIG_WIMAX is not set
CONFIG_RFKILL=m
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
# CONFIG_RFKILL_GPIO is not set
CONFIG_NET_9P=y
CONFIG_NET_9P_VIRTIO=y
# CONFIG_NET_9P_DEBUG is not set
# CONFIG_CAIF is not set
# CONFIG_CEPH_LIB is not set
# CONFIG_NFC is not set
# CONFIG_LWTUNNEL is not set
CONFIG_DST_CACHE=y
# CONFIG_NET_DEVLINK is not set
CONFIG_MAY_USE_DEVLINK=y
CONFIG_HAVE_EBPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER=y
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_FW_LOADER_USER_HELPER_FALLBACK is not set
CONFIG_ALLOW_DEV_COREDUMP=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_DEBUG_TEST_DRIVER_REMOVE is not set
CONFIG_SYS_HYPERVISOR=y
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_SPI=y
CONFIG_DMA_SHARED_BUFFER=y
# CONFIG_FENCE_TRACE is not set
CONFIG_DMA_CMA=y

#
# Default contiguous memory area size:
#
CONFIG_CMA_SIZE_MBYTES=200
CONFIG_CMA_SIZE_SEL_MBYTES=y
# CONFIG_CMA_SIZE_SEL_PERCENTAGE is not set
# CONFIG_CMA_SIZE_SEL_MIN is not set
# CONFIG_CMA_SIZE_SEL_MAX is not set
CONFIG_CMA_ALIGNMENT=8

#
# Bus devices
#
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
CONFIG_MTD=m
# CONFIG_MTD_TESTS is not set
# CONFIG_MTD_REDBOOT_PARTS is not set
# CONFIG_MTD_CMDLINE_PARTS is not set
# CONFIG_MTD_AR7_PARTS is not set

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=m
CONFIG_MTD_BLOCK=m
# CONFIG_MTD_BLOCK_RO is not set
# CONFIG_FTL is not set
# CONFIG_NFTL is not set
# CONFIG_INFTL is not set
# CONFIG_RFD_FTL is not set
# CONFIG_SSFDC is not set
# CONFIG_SM_FTL is not set
# CONFIG_MTD_OOPS is not set
# CONFIG_MTD_SWAP is not set
# CONFIG_MTD_PARTITIONED_MASTER is not set

#
# RAM/ROM/Flash chip drivers
#
# CONFIG_MTD_CFI is not set
# CONFIG_MTD_JEDECPROBE is not set
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
CONFIG_MTD_CFI_I1=y
CONFIG_MTD_CFI_I2=y
# CONFIG_MTD_CFI_I4 is not set
# CONFIG_MTD_CFI_I8 is not set
# CONFIG_MTD_RAM is not set
# CONFIG_MTD_ROM is not set
# CONFIG_MTD_ABSENT is not set

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
# CONFIG_MTD_INTEL_VR_NOR is not set
# CONFIG_MTD_PLATRAM is not set

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
# CONFIG_MTD_DATAFLASH is not set
# CONFIG_MTD_SST25L is not set
# CONFIG_MTD_SLRAM is not set
# CONFIG_MTD_PHRAM is not set
# CONFIG_MTD_MTDRAM is not set
# CONFIG_MTD_BLOCK2MTD is not set

#
# Disk-On-Chip Device Drivers
#
# CONFIG_MTD_DOCG3 is not set
# CONFIG_MTD_NAND is not set
# CONFIG_MTD_ONENAND is not set

#
# LPDDR & LPDDR2 PCM memory drivers
#
# CONFIG_MTD_LPDDR is not set
# CONFIG_MTD_SPI_NOR is not set
CONFIG_MTD_UBI=m
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
# CONFIG_MTD_UBI_FASTMAP is not set
# CONFIG_MTD_UBI_GLUEBI is not set
# CONFIG_MTD_UBI_BLOCK is not set
# CONFIG_OF is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PARPORT=m
CONFIG_PARPORT_PC=m
CONFIG_PARPORT_SERIAL=m
# CONFIG_PARPORT_PC_FIFO is not set
# CONFIG_PARPORT_PC_SUPERIO is not set
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_NULL_BLK=m
CONFIG_BLK_DEV_FD=m
# CONFIG_PARIDE is not set
CONFIG_BLK_DEV_PCIESSD_MTIP32XX=m
# CONFIG_ZRAM is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_LOOP_MIN_COUNT=0
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_DRBD is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SKD is not set
CONFIG_BLK_DEV_OSD=m
CONFIG_BLK_DEV_SX8=m
CONFIG_BLK_DEV_RAM=m
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=16384
# CONFIG_BLK_DEV_RAM_DAX is not set
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
CONFIG_ATA_OVER_ETH=m
CONFIG_XEN_BLKDEV_FRONTEND=m
# CONFIG_XEN_BLKDEV_BACKEND is not set
CONFIG_VIRTIO_BLK=y
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RBD is not set
CONFIG_BLK_DEV_RSXX=m
CONFIG_NVME_CORE=m
CONFIG_BLK_DEV_NVME=m
# CONFIG_BLK_DEV_NVME_SCSI is not set
# CONFIG_NVME_TARGET is not set

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=m
# CONFIG_AD525X_DPOT is not set
# CONFIG_DUMMY_IRQ is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
CONFIG_SGI_IOC4=m
CONFIG_TIFM_CORE=m
CONFIG_TIFM_7XX1=m
# CONFIG_ICS932S401 is not set
CONFIG_ENCLOSURE_SERVICES=m
CONFIG_SGI_XP=m
CONFIG_HP_ILO=m
CONFIG_SGI_GRU=m
# CONFIG_SGI_GRU_DEBUG is not set
CONFIG_APDS9802ALS=m
CONFIG_ISL29003=m
CONFIG_ISL29020=m
CONFIG_SENSORS_TSL2550=m
CONFIG_SENSORS_BH1770=m
CONFIG_SENSORS_APDS990X=m
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
# CONFIG_TI_DAC7512 is not set
CONFIG_VMWARE_BALLOON=m
# CONFIG_USB_SWITCH_FSA9480 is not set
# CONFIG_LATTICE_ECP3_CONFIG is not set
# CONFIG_SRAM is not set
# CONFIG_PANEL is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=m
# CONFIG_EEPROM_AT25 is not set
CONFIG_EEPROM_LEGACY=m
CONFIG_EEPROM_MAX6875=m
CONFIG_EEPROM_93CX6=m
# CONFIG_EEPROM_93XX46 is not set
CONFIG_CB710_CORE=m
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
CONFIG_SENSORS_LIS3_I2C=m

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=m
CONFIG_INTEL_MEI=y
CONFIG_INTEL_MEI_ME=y
# CONFIG_INTEL_MEI_TXE is not set
CONFIG_VMWARE_VMCI=m

#
# Intel MIC Bus Driver
#
# CONFIG_INTEL_MIC_BUS is not set

#
# SCIF Bus Driver
#
# CONFIG_SCIF_BUS is not set

#
# VOP Bus Driver
#
# CONFIG_VOP_BUS is not set

#
# Intel MIC Host Driver
#

#
# Intel MIC Card Driver
#

#
# SCIF Driver
#

#
# Intel MIC Coprocessor State Management (COSM) Drivers
#

#
# VOP Driver
#
# CONFIG_GENWQE is not set
# CONFIG_ECHO is not set
# CONFIG_CXL_BASE is not set
# CONFIG_CXL_AFU_DRIVER_OPS is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_NETLINK=y
# CONFIG_SCSI_MQ_DEFAULT is not set
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
CONFIG_CHR_DEV_ST=m
CONFIG_CHR_DEV_OSST=m
CONFIG_BLK_DEV_SR=m
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=m
CONFIG_CHR_DEV_SCH=m
CONFIG_SCSI_ENCLOSURE=m
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
CONFIG_SCSI_FC_ATTRS=m
CONFIG_SCSI_ISCSI_ATTRS=m
CONFIG_SCSI_SAS_ATTRS=m
CONFIG_SCSI_SAS_LIBSAS=m
CONFIG_SCSI_SAS_ATA=y
CONFIG_SCSI_SAS_HOST_SMP=y
CONFIG_SCSI_SRP_ATTRS=m
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_TCP=m
CONFIG_ISCSI_BOOT_SYSFS=m
CONFIG_SCSI_CXGB3_ISCSI=m
CONFIG_SCSI_CXGB4_ISCSI=m
CONFIG_SCSI_BNX2_ISCSI=m
CONFIG_SCSI_BNX2X_FCOE=m
CONFIG_BE2ISCSI=m
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
CONFIG_SCSI_HPSA=m
CONFIG_SCSI_3W_9XXX=m
CONFIG_SCSI_3W_SAS=m
# CONFIG_SCSI_ACARD is not set
CONFIG_SCSI_AACRAID=m
# CONFIG_SCSI_AIC7XXX is not set
CONFIG_SCSI_AIC79XX=m
CONFIG_AIC79XX_CMDS_PER_DEVICE=4
CONFIG_AIC79XX_RESET_DELAY_MS=15000
# CONFIG_AIC79XX_DEBUG_ENABLE is not set
CONFIG_AIC79XX_DEBUG_MASK=0
# CONFIG_AIC79XX_REG_PRETTY_PRINT is not set
# CONFIG_SCSI_AIC94XX is not set
CONFIG_SCSI_MVSAS=m
# CONFIG_SCSI_MVSAS_DEBUG is not set
CONFIG_SCSI_MVSAS_TASKLET=y
CONFIG_SCSI_MVUMI=m
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
CONFIG_SCSI_ARCMSR=m
# CONFIG_SCSI_ESAS2R is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
CONFIG_MEGARAID_SAS=m
CONFIG_SCSI_MPT3SAS=m
CONFIG_SCSI_MPT2SAS_MAX_SGE=128
CONFIG_SCSI_MPT3SAS_MAX_SGE=128
CONFIG_SCSI_MPT2SAS=m
# CONFIG_SCSI_SMARTPQI is not set
CONFIG_SCSI_UFSHCD=m
CONFIG_SCSI_UFSHCD_PCI=m
# CONFIG_SCSI_UFS_DWC_TC_PCI is not set
# CONFIG_SCSI_UFSHCD_PLATFORM is not set
CONFIG_SCSI_HPTIOP=m
# CONFIG_SCSI_BUSLOGIC is not set
CONFIG_VMWARE_PVSCSI=m
# CONFIG_XEN_SCSI_FRONTEND is not set
CONFIG_HYPERV_STORAGE=m
CONFIG_LIBFC=m
CONFIG_LIBFCOE=m
CONFIG_FCOE=m
CONFIG_FCOE_FNIC=m
# CONFIG_SCSI_SNIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
CONFIG_SCSI_ISCI=m
# CONFIG_SCSI_IPS is not set
CONFIG_SCSI_INITIO=m
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_PPA is not set
# CONFIG_SCSI_IMM is not set
CONFIG_SCSI_STEX=m
# CONFIG_SCSI_SYM53C8XX_2 is not set
CONFIG_SCSI_IPR=m
CONFIG_SCSI_IPR_TRACE=y
CONFIG_SCSI_IPR_DUMP=y
# CONFIG_SCSI_QLOGIC_1280 is not set
CONFIG_SCSI_QLA_FC=m
# CONFIG_TCM_QLA2XXX is not set
CONFIG_SCSI_QLA_ISCSI=m
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_AM53C974 is not set
# CONFIG_SCSI_WD719X is not set
CONFIG_SCSI_DEBUG=m
CONFIG_SCSI_PMCRAID=m
CONFIG_SCSI_PM8001=m
# CONFIG_SCSI_BFA_FC is not set
CONFIG_SCSI_VIRTIO=m
CONFIG_SCSI_CHELSIO_FCOE=m
CONFIG_SCSI_DH=y
CONFIG_SCSI_DH_RDAC=y
CONFIG_SCSI_DH_HP_SW=y
CONFIG_SCSI_DH_EMC=y
CONFIG_SCSI_DH_ALUA=y
CONFIG_SCSI_OSD_INITIATOR=m
CONFIG_SCSI_OSD_ULD=m
CONFIG_SCSI_OSD_DPRINT_SENSE=1
# CONFIG_SCSI_OSD_DEBUG is not set
CONFIG_ATA=m
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
# CONFIG_SATA_ZPODD is not set
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=m
CONFIG_SATA_AHCI_PLATFORM=m
# CONFIG_SATA_INIC162X is not set
CONFIG_SATA_ACARD_AHCI=m
CONFIG_SATA_SIL24=m
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
CONFIG_PDC_ADMA=m
CONFIG_SATA_QSTOR=m
CONFIG_SATA_SX4=m
CONFIG_ATA_BMDMA=y

#
# SATA SFF controllers with BMDMA
#
CONFIG_ATA_PIIX=m
# CONFIG_SATA_DWC is not set
CONFIG_SATA_MV=m
CONFIG_SATA_NV=m
CONFIG_SATA_PROMISE=m
CONFIG_SATA_SIL=m
CONFIG_SATA_SIS=m
CONFIG_SATA_SVW=m
CONFIG_SATA_ULI=m
CONFIG_SATA_VIA=m
CONFIG_SATA_VITESSE=m

#
# PATA SFF controllers with BMDMA
#
CONFIG_PATA_ALI=m
CONFIG_PATA_AMD=m
CONFIG_PATA_ARTOP=m
CONFIG_PATA_ATIIXP=m
CONFIG_PATA_ATP867X=m
CONFIG_PATA_CMD64X=m
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
CONFIG_PATA_HPT366=m
CONFIG_PATA_HPT37X=m
CONFIG_PATA_HPT3X2N=m
CONFIG_PATA_HPT3X3=m
# CONFIG_PATA_HPT3X3_DMA is not set
CONFIG_PATA_IT8213=m
CONFIG_PATA_IT821X=m
CONFIG_PATA_JMICRON=m
CONFIG_PATA_MARVELL=m
CONFIG_PATA_NETCELL=m
CONFIG_PATA_NINJA32=m
# CONFIG_PATA_NS87415 is not set
CONFIG_PATA_OLDPIIX=m
# CONFIG_PATA_OPTIDMA is not set
CONFIG_PATA_PDC2027X=m
CONFIG_PATA_PDC_OLD=m
# CONFIG_PATA_RADISYS is not set
CONFIG_PATA_RDC=m
CONFIG_PATA_SCH=m
CONFIG_PATA_SERVERWORKS=m
CONFIG_PATA_SIL680=m
CONFIG_PATA_SIS=m
CONFIG_PATA_TOSHIBA=m
# CONFIG_PATA_TRIFLEX is not set
CONFIG_PATA_VIA=m
# CONFIG_PATA_WINBOND is not set

#
# PIO-only SFF controllers
#
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_RZ1000 is not set

#
# Generic fallback / legacy drivers
#
CONFIG_PATA_ACPI=m
CONFIG_ATA_GENERIC=m
# CONFIG_PATA_LEGACY is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
CONFIG_MD_LINEAR=m
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=m
CONFIG_MD_RAID10=m
CONFIG_MD_RAID456=m
CONFIG_MD_MULTIPATH=m
CONFIG_MD_FAULTY=m
# CONFIG_MD_CLUSTER is not set
# CONFIG_BCACHE is not set
CONFIG_BLK_DEV_DM_BUILTIN=y
CONFIG_BLK_DEV_DM=m
# CONFIG_DM_MQ_DEFAULT is not set
CONFIG_DM_DEBUG=y
CONFIG_DM_BUFIO=m
# CONFIG_DM_DEBUG_BLOCK_STACK_TRACING is not set
CONFIG_DM_BIO_PRISON=m
CONFIG_DM_PERSISTENT_DATA=m
CONFIG_DM_CRYPT=m
CONFIG_DM_SNAPSHOT=m
CONFIG_DM_THIN_PROVISIONING=m
CONFIG_DM_CACHE=m
CONFIG_DM_CACHE_SMQ=m
CONFIG_DM_CACHE_CLEANER=m
# CONFIG_DM_ERA is not set
CONFIG_DM_MIRROR=m
CONFIG_DM_LOG_USERSPACE=m
CONFIG_DM_RAID=m
CONFIG_DM_ZERO=m
CONFIG_DM_MULTIPATH=m
CONFIG_DM_MULTIPATH_QL=m
CONFIG_DM_MULTIPATH_ST=m
CONFIG_DM_DELAY=m
CONFIG_DM_UEVENT=y
CONFIG_DM_FLAKEY=m
CONFIG_DM_VERITY=m
# CONFIG_DM_VERITY_FEC is not set
CONFIG_DM_SWITCH=m
# CONFIG_DM_LOG_WRITES is not set
CONFIG_TARGET_CORE=m
CONFIG_TCM_IBLOCK=m
CONFIG_TCM_FILEIO=m
CONFIG_TCM_PSCSI=m
# CONFIG_TCM_USER2 is not set
CONFIG_LOOPBACK_TARGET=m
CONFIG_TCM_FC=m
CONFIG_ISCSI_TARGET=m
# CONFIG_ISCSI_TARGET_CXGB4 is not set
# CONFIG_SBP_TARGET is not set
CONFIG_FUSION=y
CONFIG_FUSION_SPI=m
# CONFIG_FUSION_FC is not set
CONFIG_FUSION_SAS=m
CONFIG_FUSION_MAX_SGE=128
CONFIG_FUSION_CTL=m
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=m
CONFIG_FIREWIRE_OHCI=m
CONFIG_FIREWIRE_SBP2=m
CONFIG_FIREWIRE_NET=m
# CONFIG_FIREWIRE_NOSY is not set
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=y
CONFIG_NETDEVICES=y
CONFIG_MII=y
CONFIG_NET_CORE=y
CONFIG_BONDING=m
CONFIG_DUMMY=m
# CONFIG_EQUALIZER is not set
CONFIG_NET_FC=y
CONFIG_IFB=m
CONFIG_NET_TEAM=m
CONFIG_NET_TEAM_MODE_BROADCAST=m
CONFIG_NET_TEAM_MODE_ROUNDROBIN=m
CONFIG_NET_TEAM_MODE_RANDOM=m
CONFIG_NET_TEAM_MODE_ACTIVEBACKUP=m
CONFIG_NET_TEAM_MODE_LOADBALANCE=m
CONFIG_MACVLAN=m
CONFIG_MACVTAP=m
CONFIG_VXLAN=m
# CONFIG_GENEVE is not set
# CONFIG_GTP is not set
# CONFIG_MACSEC is not set
CONFIG_NETCONSOLE=m
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_TUN=m
# CONFIG_TUN_VNET_CROSS_LE is not set
CONFIG_VETH=m
CONFIG_VIRTIO_NET=y
CONFIG_NLMON=m
# CONFIG_ARCNET is not set
# CONFIG_ATM_DRIVERS is not set

#
# CAIF transport drivers
#

#
# Distributed Switch Architecture drivers
#
CONFIG_ETHERNET=y
CONFIG_MDIO=y
# CONFIG_NET_VENDOR_3COM is not set
# CONFIG_NET_VENDOR_ADAPTEC is not set
CONFIG_NET_VENDOR_AGERE=y
# CONFIG_ET131X is not set
# CONFIG_NET_VENDOR_ALTEON is not set
# CONFIG_ALTERA_TSE is not set
CONFIG_NET_VENDOR_AMAZON=y
# CONFIG_ENA_ETHERNET is not set
# CONFIG_NET_VENDOR_AMD is not set
CONFIG_NET_VENDOR_ARC=y
CONFIG_NET_VENDOR_ATHEROS=y
CONFIG_ATL2=m
CONFIG_ATL1=m
CONFIG_ATL1E=m
CONFIG_ATL1C=m
CONFIG_ALX=m
# CONFIG_NET_VENDOR_AURORA is not set
CONFIG_NET_CADENCE=y
# CONFIG_MACB is not set
CONFIG_NET_VENDOR_BROADCOM=y
CONFIG_B44=m
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
# CONFIG_BCMGENET is not set
CONFIG_BNX2=m
CONFIG_CNIC=m
CONFIG_TIGON3=y
# CONFIG_BNX2X is not set
# CONFIG_BNXT is not set
CONFIG_NET_VENDOR_BROCADE=y
CONFIG_BNA=m
CONFIG_NET_VENDOR_CAVIUM=y
# CONFIG_THUNDER_NIC_PF is not set
# CONFIG_THUNDER_NIC_VF is not set
# CONFIG_THUNDER_NIC_BGX is not set
# CONFIG_THUNDER_NIC_RGX is not set
# CONFIG_LIQUIDIO is not set
CONFIG_NET_VENDOR_CHELSIO=y
# CONFIG_CHELSIO_T1 is not set
CONFIG_CHELSIO_T3=m
CONFIG_CHELSIO_T4=m
# CONFIG_CHELSIO_T4_DCB is not set
CONFIG_CHELSIO_T4VF=m
CONFIG_CHELSIO_LIB=m
CONFIG_NET_VENDOR_CISCO=y
CONFIG_ENIC=m
# CONFIG_CX_ECAT is not set
CONFIG_DNET=m
CONFIG_NET_VENDOR_DEC=y
CONFIG_NET_TULIP=y
CONFIG_DE2104X=m
CONFIG_DE2104X_DSL=0
CONFIG_TULIP=y
# CONFIG_TULIP_MWI is not set
CONFIG_TULIP_MMIO=y
# CONFIG_TULIP_NAPI is not set
CONFIG_DE4X5=m
CONFIG_WINBOND_840=m
CONFIG_DM9102=m
CONFIG_ULI526X=m
CONFIG_PCMCIA_XIRCOM=m
# CONFIG_NET_VENDOR_DLINK is not set
CONFIG_NET_VENDOR_EMULEX=y
CONFIG_BE2NET=m
CONFIG_BE2NET_HWMON=y
CONFIG_NET_VENDOR_EZCHIP=y
# CONFIG_NET_VENDOR_EXAR is not set
# CONFIG_NET_VENDOR_HP is not set
CONFIG_NET_VENDOR_INTEL=y
# CONFIG_E100 is not set
CONFIG_E1000=y
CONFIG_E1000E=y
CONFIG_E1000E_HWTS=y
CONFIG_IGB=y
CONFIG_IGB_HWMON=y
CONFIG_IGBVF=m
CONFIG_IXGB=m
CONFIG_IXGBE=y
CONFIG_IXGBE_HWMON=y
CONFIG_IXGBE_DCB=y
CONFIG_IXGBEVF=m
CONFIG_I40E=m
# CONFIG_I40E_DCB is not set
# CONFIG_I40E_FCOE is not set
# CONFIG_I40EVF is not set
# CONFIG_FM10K is not set
# CONFIG_NET_VENDOR_I825XX is not set
CONFIG_JME=m
CONFIG_NET_VENDOR_MARVELL=y
CONFIG_MVMDIO=m
# CONFIG_MVNETA_BM is not set
CONFIG_SKGE=m
CONFIG_SKGE_DEBUG=y
CONFIG_SKGE_GENESIS=y
CONFIG_SKY2=m
CONFIG_SKY2_DEBUG=y
CONFIG_NET_VENDOR_MELLANOX=y
CONFIG_MLX4_EN=m
CONFIG_MLX4_EN_DCB=y
CONFIG_MLX4_CORE=m
CONFIG_MLX4_DEBUG=y
# CONFIG_MLX5_CORE is not set
# CONFIG_MLXSW_CORE is not set
# CONFIG_NET_VENDOR_MICREL is not set
CONFIG_NET_VENDOR_MICROCHIP=y
# CONFIG_ENC28J60 is not set
# CONFIG_ENCX24J600 is not set
CONFIG_NET_VENDOR_MYRI=y
CONFIG_MYRI10GE=m
# CONFIG_FEALNX is not set
# CONFIG_NET_VENDOR_NATSEMI is not set
CONFIG_NET_VENDOR_NETRONOME=y
# CONFIG_NFP_NETVF is not set
# CONFIG_NET_VENDOR_NVIDIA is not set
CONFIG_NET_VENDOR_OKI=y
CONFIG_ETHOC=m
CONFIG_NET_PACKET_ENGINE=y
# CONFIG_HAMACHI is not set
CONFIG_YELLOWFIN=m
CONFIG_NET_VENDOR_QLOGIC=y
CONFIG_QLA3XXX=m
CONFIG_QLCNIC=m
CONFIG_QLCNIC_SRIOV=y
CONFIG_QLCNIC_DCB=y
CONFIG_QLCNIC_HWMON=y
CONFIG_QLGE=m
CONFIG_NETXEN_NIC=m
# CONFIG_QED is not set
CONFIG_NET_VENDOR_QUALCOMM=y
# CONFIG_QCOM_EMAC is not set
CONFIG_NET_VENDOR_REALTEK=y
# CONFIG_ATP is not set
CONFIG_8139CP=y
CONFIG_8139TOO=y
CONFIG_8139TOO_PIO=y
# CONFIG_8139TOO_TUNE_TWISTER is not set
CONFIG_8139TOO_8129=y
# CONFIG_8139_OLD_RX_RESET is not set
CONFIG_R8169=y
CONFIG_NET_VENDOR_RENESAS=y
# CONFIG_NET_VENDOR_RDC is not set
CONFIG_NET_VENDOR_ROCKER=y
CONFIG_NET_VENDOR_SAMSUNG=y
# CONFIG_SXGBE_ETH is not set
# CONFIG_NET_VENDOR_SEEQ is not set
# CONFIG_NET_VENDOR_SILAN is not set
# CONFIG_NET_VENDOR_SIS is not set
CONFIG_SFC=m
CONFIG_SFC_MTD=y
CONFIG_SFC_MCDI_MON=y
CONFIG_SFC_SRIOV=y
CONFIG_SFC_MCDI_LOGGING=y
CONFIG_NET_VENDOR_SMSC=y
CONFIG_EPIC100=m
# CONFIG_SMSC911X is not set
CONFIG_SMSC9420=m
# CONFIG_NET_VENDOR_STMICRO is not set
# CONFIG_NET_VENDOR_SUN is not set
CONFIG_NET_VENDOR_SYNOPSYS=y
# CONFIG_NET_VENDOR_TEHUTI is not set
# CONFIG_NET_VENDOR_TI is not set
# CONFIG_NET_VENDOR_VIA is not set
# CONFIG_NET_VENDOR_WIZNET is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y
CONFIG_SWPHY=y

#
# MDIO bus device drivers
#
# CONFIG_MDIO_BCM_UNIMAC is not set
CONFIG_MDIO_BITBANG=m
# CONFIG_MDIO_GPIO is not set
# CONFIG_MDIO_OCTEON is not set
# CONFIG_MDIO_THUNDER is not set

#
# MII PHY device drivers
#
CONFIG_AMD_PHY=m
# CONFIG_AQUANTIA_PHY is not set
CONFIG_AT803X_PHY=m
# CONFIG_BCM7XXX_PHY is not set
CONFIG_BCM87XX_PHY=m
CONFIG_BCM_NET_PHYLIB=m
CONFIG_BROADCOM_PHY=m
CONFIG_CICADA_PHY=m
CONFIG_DAVICOM_PHY=m
# CONFIG_DP83848_PHY is not set
# CONFIG_DP83867_PHY is not set
CONFIG_FIXED_PHY=y
CONFIG_ICPLUS_PHY=m
# CONFIG_INTEL_XWAY_PHY is not set
CONFIG_LSI_ET1011C_PHY=m
CONFIG_LXT_PHY=m
CONFIG_MARVELL_PHY=m
CONFIG_MICREL_PHY=m
# CONFIG_MICROCHIP_PHY is not set
# CONFIG_MICROSEMI_PHY is not set
CONFIG_NATIONAL_PHY=m
CONFIG_QSEMI_PHY=m
CONFIG_REALTEK_PHY=m
CONFIG_SMSC_PHY=m
CONFIG_STE10XP=m
# CONFIG_TERANETICS_PHY is not set
CONFIG_VITESSE_PHY=m
# CONFIG_XILINX_GMII2RGMII is not set
# CONFIG_MICREL_KS8995MA is not set
# CONFIG_PLIP is not set
CONFIG_PPP=m
CONFIG_PPP_BSDCOMP=m
CONFIG_PPP_DEFLATE=m
CONFIG_PPP_FILTER=y
CONFIG_PPP_MPPE=m
CONFIG_PPP_MULTILINK=y
CONFIG_PPPOATM=m
CONFIG_PPPOE=m
CONFIG_PPTP=m
CONFIG_PPPOL2TP=m
CONFIG_PPP_ASYNC=m
CONFIG_PPP_SYNC_TTY=m
CONFIG_SLIP=m
CONFIG_SLHC=m
CONFIG_SLIP_COMPRESSED=y
CONFIG_SLIP_SMART=y
# CONFIG_SLIP_MODE_SLIP6 is not set
CONFIG_USB_NET_DRIVERS=y
CONFIG_USB_CATC=y
CONFIG_USB_KAWETH=y
CONFIG_USB_PEGASUS=y
CONFIG_USB_RTL8150=y
CONFIG_USB_RTL8152=m
# CONFIG_USB_LAN78XX is not set
CONFIG_USB_USBNET=y
CONFIG_USB_NET_AX8817X=y
CONFIG_USB_NET_AX88179_178A=m
CONFIG_USB_NET_CDCETHER=y
CONFIG_USB_NET_CDC_EEM=y
CONFIG_USB_NET_CDC_NCM=m
# CONFIG_USB_NET_HUAWEI_CDC_NCM is not set
CONFIG_USB_NET_CDC_MBIM=m
CONFIG_USB_NET_DM9601=y
# CONFIG_USB_NET_SR9700 is not set
# CONFIG_USB_NET_SR9800 is not set
CONFIG_USB_NET_SMSC75XX=y
CONFIG_USB_NET_SMSC95XX=y
CONFIG_USB_NET_GL620A=y
CONFIG_USB_NET_NET1080=y
CONFIG_USB_NET_PLUSB=y
CONFIG_USB_NET_MCS7830=y
CONFIG_USB_NET_RNDIS_HOST=y
CONFIG_USB_NET_CDC_SUBSET_ENABLE=y
CONFIG_USB_NET_CDC_SUBSET=y
CONFIG_USB_ALI_M5632=y
CONFIG_USB_AN2720=y
CONFIG_USB_BELKIN=y
CONFIG_USB_ARMLINUX=y
CONFIG_USB_EPSON2888=y
CONFIG_USB_KC2190=y
CONFIG_USB_NET_ZAURUS=y
CONFIG_USB_NET_CX82310_ETH=m
CONFIG_USB_NET_KALMIA=m
CONFIG_USB_NET_QMI_WWAN=m
CONFIG_USB_HSO=m
CONFIG_USB_NET_INT51X1=y
CONFIG_USB_IPHETH=y
CONFIG_USB_SIERRA_NET=y
CONFIG_USB_VL600=m
# CONFIG_USB_NET_CH9200 is not set
CONFIG_WLAN=y
CONFIG_WLAN_VENDOR_ADMTEK=y
# CONFIG_ADM8211 is not set
CONFIG_WLAN_VENDOR_ATH=y
# CONFIG_ATH_DEBUG is not set
# CONFIG_ATH5K is not set
# CONFIG_ATH5K_PCI is not set
# CONFIG_ATH9K is not set
# CONFIG_ATH9K_HTC is not set
# CONFIG_CARL9170 is not set
# CONFIG_ATH6KL is not set
# CONFIG_AR5523 is not set
# CONFIG_WIL6210 is not set
# CONFIG_ATH10K is not set
# CONFIG_WCN36XX is not set
CONFIG_WLAN_VENDOR_ATMEL=y
# CONFIG_ATMEL is not set
# CONFIG_AT76C50X_USB is not set
CONFIG_WLAN_VENDOR_BROADCOM=y
# CONFIG_B43 is not set
# CONFIG_B43LEGACY is not set
# CONFIG_BRCMSMAC is not set
# CONFIG_BRCMFMAC is not set
CONFIG_WLAN_VENDOR_CISCO=y
# CONFIG_AIRO is not set
CONFIG_WLAN_VENDOR_INTEL=y
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
# CONFIG_IWL4965 is not set
# CONFIG_IWL3945 is not set
# CONFIG_IWLWIFI is not set
CONFIG_WLAN_VENDOR_INTERSIL=y
# CONFIG_HOSTAP is not set
# CONFIG_HERMES is not set
# CONFIG_P54_COMMON is not set
# CONFIG_PRISM54 is not set
CONFIG_WLAN_VENDOR_MARVELL=y
# CONFIG_LIBERTAS is not set
# CONFIG_LIBERTAS_THINFIRM is not set
# CONFIG_MWIFIEX is not set
# CONFIG_MWL8K is not set
CONFIG_WLAN_VENDOR_MEDIATEK=y
# CONFIG_MT7601U is not set
CONFIG_WLAN_VENDOR_RALINK=y
# CONFIG_RT2X00 is not set
CONFIG_WLAN_VENDOR_REALTEK=y
# CONFIG_RTL8180 is not set
# CONFIG_RTL8187 is not set
CONFIG_RTL_CARDS=m
# CONFIG_RTL8192CE is not set
# CONFIG_RTL8192SE is not set
# CONFIG_RTL8192DE is not set
# CONFIG_RTL8723AE is not set
# CONFIG_RTL8723BE is not set
# CONFIG_RTL8188EE is not set
# CONFIG_RTL8192EE is not set
# CONFIG_RTL8821AE is not set
# CONFIG_RTL8192CU is not set
# CONFIG_RTL8XXXU is not set
CONFIG_WLAN_VENDOR_RSI=y
# CONFIG_RSI_91X is not set
CONFIG_WLAN_VENDOR_ST=y
# CONFIG_CW1200 is not set
CONFIG_WLAN_VENDOR_TI=y
# CONFIG_WL1251 is not set
# CONFIG_WL12XX is not set
# CONFIG_WL18XX is not set
# CONFIG_WLCORE is not set
CONFIG_WLAN_VENDOR_ZYDAS=y
# CONFIG_USB_ZD1201 is not set
# CONFIG_ZD1211RW is not set
CONFIG_MAC80211_HWSIM=m
# CONFIG_USB_NET_RNDIS_WLAN is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
CONFIG_WAN=y
# CONFIG_LANMEDIA is not set
CONFIG_HDLC=m
CONFIG_HDLC_RAW=m
# CONFIG_HDLC_RAW_ETH is not set
CONFIG_HDLC_CISCO=m
CONFIG_HDLC_FR=m
CONFIG_HDLC_PPP=m

#
# X.25/LAPB support is disabled
#
# CONFIG_PCI200SYN is not set
# CONFIG_WANXL is not set
# CONFIG_PC300TOO is not set
# CONFIG_FARSYNC is not set
# CONFIG_DSCC4 is not set
CONFIG_DLCI=m
CONFIG_DLCI_MAX=8
# CONFIG_SBNI is not set
CONFIG_IEEE802154_DRIVERS=m
CONFIG_IEEE802154_FAKELB=m
# CONFIG_IEEE802154_AT86RF230 is not set
# CONFIG_IEEE802154_MRF24J40 is not set
# CONFIG_IEEE802154_CC2520 is not set
# CONFIG_IEEE802154_ATUSB is not set
# CONFIG_IEEE802154_ADF7242 is not set
CONFIG_XEN_NETDEV_FRONTEND=m
# CONFIG_XEN_NETDEV_BACKEND is not set
CONFIG_VMXNET3=m
# CONFIG_FUJITSU_ES is not set
CONFIG_HYPERV_NET=m
CONFIG_ISDN=y
CONFIG_ISDN_I4L=m
CONFIG_ISDN_PPP=y
CONFIG_ISDN_PPP_VJ=y
CONFIG_ISDN_MPP=y
CONFIG_IPPP_FILTER=y
# CONFIG_ISDN_PPP_BSDCOMP is not set
CONFIG_ISDN_AUDIO=y
CONFIG_ISDN_TTY_FAX=y

#
# ISDN feature submodules
#
CONFIG_ISDN_DIVERSION=m

#
# ISDN4Linux hardware drivers
#

#
# Passive cards
#
# CONFIG_ISDN_DRV_HISAX is not set
CONFIG_ISDN_CAPI=m
# CONFIG_CAPI_TRACE is not set
CONFIG_ISDN_CAPI_CAPI20=m
CONFIG_ISDN_CAPI_MIDDLEWARE=y
CONFIG_ISDN_CAPI_CAPIDRV=m
# CONFIG_ISDN_CAPI_CAPIDRV_VERBOSE is not set

#
# CAPI hardware drivers
#
CONFIG_CAPI_AVM=y
CONFIG_ISDN_DRV_AVMB1_B1PCI=m
CONFIG_ISDN_DRV_AVMB1_B1PCIV4=y
CONFIG_ISDN_DRV_AVMB1_T1PCI=m
CONFIG_ISDN_DRV_AVMB1_C4=m
# CONFIG_CAPI_EICON is not set
CONFIG_ISDN_DRV_GIGASET=m
CONFIG_GIGASET_CAPI=y
# CONFIG_GIGASET_I4L is not set
# CONFIG_GIGASET_DUMMYLL is not set
CONFIG_GIGASET_BASE=m
CONFIG_GIGASET_M105=m
CONFIG_GIGASET_M101=m
# CONFIG_GIGASET_DEBUG is not set
CONFIG_HYSDN=m
CONFIG_HYSDN_CAPI=y
CONFIG_MISDN=m
CONFIG_MISDN_DSP=m
CONFIG_MISDN_L1OIP=m

#
# mISDN hardware drivers
#
CONFIG_MISDN_HFCPCI=m
CONFIG_MISDN_HFCMULTI=m
CONFIG_MISDN_HFCUSB=m
CONFIG_MISDN_AVMFRITZ=m
CONFIG_MISDN_SPEEDFAX=m
CONFIG_MISDN_INFINEON=m
CONFIG_MISDN_W6692=m
CONFIG_MISDN_NETJET=m
CONFIG_MISDN_IPAC=m
CONFIG_MISDN_ISAR=m
CONFIG_ISDN_HDLC=m
# CONFIG_NVM is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_LEDS=y
CONFIG_INPUT_FF_MEMLESS=m
CONFIG_INPUT_POLLDEV=m
CONFIG_INPUT_SPARSEKMAP=m
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_SAMSUNG is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_BYD=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_CYPRESS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_MOUSE_PS2_ELANTECH=y
CONFIG_MOUSE_PS2_SENTELIC=y
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
CONFIG_MOUSE_PS2_FOCALTECH=y
# CONFIG_MOUSE_PS2_VMMOUSE is not set
CONFIG_MOUSE_SERIAL=m
CONFIG_MOUSE_APPLETOUCH=m
CONFIG_MOUSE_BCM5974=m
CONFIG_MOUSE_CYAPA=m
# CONFIG_MOUSE_ELAN_I2C is not set
CONFIG_MOUSE_VSXXXAA=m
# CONFIG_MOUSE_GPIO is not set
CONFIG_MOUSE_SYNAPTICS_I2C=m
CONFIG_MOUSE_SYNAPTICS_USB=m
# CONFIG_INPUT_JOYSTICK is not set
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_USB_ACECAD=m
CONFIG_TABLET_USB_AIPTEK=m
CONFIG_TABLET_USB_GTCO=m
# CONFIG_TABLET_USB_HANWANG is not set
CONFIG_TABLET_USB_KBTAB=m
# CONFIG_TABLET_USB_PEGASUS is not set
# CONFIG_TABLET_SERIAL_WACOM4 is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_PROPERTIES=y
# CONFIG_TOUCHSCREEN_ADS7846 is not set
# CONFIG_TOUCHSCREEN_AD7877 is not set
# CONFIG_TOUCHSCREEN_AD7879 is not set
# CONFIG_TOUCHSCREEN_ATMEL_MXT is not set
# CONFIG_TOUCHSCREEN_AUO_PIXCIR is not set
# CONFIG_TOUCHSCREEN_BU21013 is not set
# CONFIG_TOUCHSCREEN_CY8CTMG110 is not set
# CONFIG_TOUCHSCREEN_CYTTSP_CORE is not set
# CONFIG_TOUCHSCREEN_CYTTSP4_CORE is not set
# CONFIG_TOUCHSCREEN_DYNAPRO is not set
# CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
# CONFIG_TOUCHSCREEN_EETI is not set
# CONFIG_TOUCHSCREEN_EGALAX_SERIAL is not set
# CONFIG_TOUCHSCREEN_FUJITSU is not set
# CONFIG_TOUCHSCREEN_GOODIX is not set
# CONFIG_TOUCHSCREEN_ILI210X is not set
# CONFIG_TOUCHSCREEN_GUNZE is not set
# CONFIG_TOUCHSCREEN_EKTF2127 is not set
# CONFIG_TOUCHSCREEN_ELAN is not set
# CONFIG_TOUCHSCREEN_ELO is not set
CONFIG_TOUCHSCREEN_WACOM_W8001=m
CONFIG_TOUCHSCREEN_WACOM_I2C=m
# CONFIG_TOUCHSCREEN_MAX11801 is not set
# CONFIG_TOUCHSCREEN_MCS5000 is not set
# CONFIG_TOUCHSCREEN_MMS114 is not set
# CONFIG_TOUCHSCREEN_MELFAS_MIP4 is not set
# CONFIG_TOUCHSCREEN_MTOUCH is not set
# CONFIG_TOUCHSCREEN_INEXIO is not set
# CONFIG_TOUCHSCREEN_MK712 is not set
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
# CONFIG_TOUCHSCREEN_EDT_FT5X06 is not set
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
# CONFIG_TOUCHSCREEN_PIXCIR is not set
# CONFIG_TOUCHSCREEN_WDT87XX_I2C is not set
# CONFIG_TOUCHSCREEN_WM97XX is not set
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
# CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
# CONFIG_TOUCHSCREEN_TSC_SERIO is not set
# CONFIG_TOUCHSCREEN_TSC2004 is not set
# CONFIG_TOUCHSCREEN_TSC2005 is not set
# CONFIG_TOUCHSCREEN_TSC2007 is not set
# CONFIG_TOUCHSCREEN_RM_TS is not set
# CONFIG_TOUCHSCREEN_SILEAD is not set
# CONFIG_TOUCHSCREEN_SIS_I2C is not set
# CONFIG_TOUCHSCREEN_ST1232 is not set
# CONFIG_TOUCHSCREEN_SUR40 is not set
# CONFIG_TOUCHSCREEN_SURFACE3_SPI is not set
# CONFIG_TOUCHSCREEN_SX8654 is not set
# CONFIG_TOUCHSCREEN_TPS6507X is not set
# CONFIG_TOUCHSCREEN_ZFORCE is not set
# CONFIG_TOUCHSCREEN_ROHM_BU21023 is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_AD714X is not set
# CONFIG_INPUT_BMA150 is not set
# CONFIG_INPUT_E3X0_BUTTON is not set
CONFIG_INPUT_PCSPKR=m
# CONFIG_INPUT_MMA8450 is not set
# CONFIG_INPUT_MPU3050 is not set
CONFIG_INPUT_APANEL=m
# CONFIG_INPUT_GP2A is not set
# CONFIG_INPUT_GPIO_BEEPER is not set
# CONFIG_INPUT_GPIO_TILT_POLLED is not set
# CONFIG_INPUT_GPIO_DECODER is not set
CONFIG_INPUT_ATLAS_BTNS=m
CONFIG_INPUT_ATI_REMOTE2=m
CONFIG_INPUT_KEYSPAN_REMOTE=m
# CONFIG_INPUT_KXTJ9 is not set
CONFIG_INPUT_POWERMATE=m
CONFIG_INPUT_YEALINK=m
CONFIG_INPUT_CM109=m
CONFIG_INPUT_UINPUT=m
# CONFIG_INPUT_PCF8574 is not set
# CONFIG_INPUT_PWM_BEEPER is not set
# CONFIG_INPUT_GPIO_ROTARY_ENCODER is not set
# CONFIG_INPUT_ADXL34X is not set
# CONFIG_INPUT_IMS_PCU is not set
# CONFIG_INPUT_CMA3000 is not set
CONFIG_INPUT_XEN_KBDDEV_FRONTEND=m
# CONFIG_INPUT_IDEAPAD_SLIDEBAR is not set
# CONFIG_INPUT_DRV260X_HAPTICS is not set
# CONFIG_INPUT_DRV2665_HAPTICS is not set
# CONFIG_INPUT_DRV2667_HAPTICS is not set
# CONFIG_RMI4_CORE is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
CONFIG_SERIO_ALTERA_PS2=m
# CONFIG_SERIO_PS2MULT is not set
CONFIG_SERIO_ARC_PS2=m
CONFIG_HYPERV_KEYBOARD=m
# CONFIG_USERIO is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_TTY=y
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_VT_CONSOLE_SLEEP=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_UNIX98_PTYS=y
# CONFIG_LEGACY_PTYS is not set
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_ROCKETPORT is not set
CONFIG_CYCLADES=m
# CONFIG_CYZ_INTR is not set
CONFIG_MOXA_INTELLIO=m
CONFIG_MOXA_SMARTIO=m
CONFIG_SYNCLINK=m
CONFIG_SYNCLINKMP=m
CONFIG_SYNCLINK_GT=m
CONFIG_NOZOMI=m
# CONFIG_ISI is not set
CONFIG_N_HDLC=m
CONFIG_N_GSM=m
# CONFIG_TRACE_SINK is not set
CONFIG_DEVMEM=y
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
CONFIG_SERIAL_EARLYCON=y
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
CONFIG_SERIAL_8250_PNP=y
# CONFIG_SERIAL_8250_FINTEK is not set
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_DMA=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_NR_UARTS=32
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
CONFIG_SERIAL_8250_RSA=y
# CONFIG_SERIAL_8250_FSL is not set
CONFIG_SERIAL_8250_DW=y
# CONFIG_SERIAL_8250_RT288X is not set
CONFIG_SERIAL_8250_LPSS=y
CONFIG_SERIAL_8250_MID=y
# CONFIG_SERIAL_8250_MOXA is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
# CONFIG_SERIAL_MAX310X is not set
# CONFIG_SERIAL_UARTLITE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=m
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_SC16IS7XX is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_IFX6X60 is not set
CONFIG_SERIAL_ARC=m
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
CONFIG_PRINTER=m
# CONFIG_LP_CONSOLE is not set
CONFIG_PPDEV=m
CONFIG_HVC_DRIVER=y
CONFIG_HVC_IRQ=y
CONFIG_HVC_XEN=y
CONFIG_HVC_XEN_FRONTEND=y
CONFIG_VIRTIO_CONSOLE=y
CONFIG_IPMI_HANDLER=m
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
# CONFIG_IPMI_SSIF is not set
CONFIG_IPMI_WATCHDOG=m
CONFIG_IPMI_POWEROFF=m
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=m
CONFIG_HW_RANDOM_INTEL=m
CONFIG_HW_RANDOM_AMD=m
CONFIG_HW_RANDOM_VIA=m
CONFIG_HW_RANDOM_VIRTIO=y
CONFIG_HW_RANDOM_TPM=m
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=8192
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
# CONFIG_HPET_MMAP_DEFAULT is not set
CONFIG_HANGCHECK_TIMER=m
CONFIG_UV_MMTIMER=m
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS_CORE=y
CONFIG_TCG_TIS=y
# CONFIG_TCG_TIS_SPI is not set
# CONFIG_TCG_TIS_I2C_ATMEL is not set
# CONFIG_TCG_TIS_I2C_INFINEON is not set
# CONFIG_TCG_TIS_I2C_NUVOTON is not set
CONFIG_TCG_NSC=m
CONFIG_TCG_ATMEL=m
CONFIG_TCG_INFINEON=m
# CONFIG_TCG_XEN is not set
# CONFIG_TCG_CRB is not set
# CONFIG_TCG_VTPM_PROXY is not set
# CONFIG_TCG_TIS_ST33ZP24_I2C is not set
# CONFIG_TCG_TIS_ST33ZP24_SPI is not set
CONFIG_TELCLOCK=m
CONFIG_DEVPORT=y
# CONFIG_XILLYBUS is not set

#
# I2C support
#
CONFIG_I2C=y
CONFIG_ACPI_I2C_OPREGION=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_MUX=m

#
# Multiplexer I2C Chip support
#
# CONFIG_I2C_MUX_GPIO is not set
# CONFIG_I2C_MUX_PCA9541 is not set
# CONFIG_I2C_MUX_PCA954x is not set
# CONFIG_I2C_MUX_PINCTRL is not set
# CONFIG_I2C_MUX_REG is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=y
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCA=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
CONFIG_I2C_AMD756=m
CONFIG_I2C_AMD756_S4882=m
CONFIG_I2C_AMD8111=m
CONFIG_I2C_I801=y
CONFIG_I2C_ISCH=m
CONFIG_I2C_ISMT=m
CONFIG_I2C_PIIX4=m
CONFIG_I2C_NFORCE2=m
CONFIG_I2C_NFORCE2_S4985=m
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
CONFIG_I2C_SIS96X=m
CONFIG_I2C_VIA=m
CONFIG_I2C_VIAPRO=m

#
# ACPI drivers
#
CONFIG_I2C_SCMI=m

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_CBUS_GPIO is not set
CONFIG_I2C_DESIGNWARE_CORE=m
CONFIG_I2C_DESIGNWARE_PLATFORM=m
CONFIG_I2C_DESIGNWARE_PCI=m
# CONFIG_I2C_DESIGNWARE_BAYTRAIL is not set
# CONFIG_I2C_EMEV2 is not set
# CONFIG_I2C_GPIO is not set
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_PCA_PLATFORM=m
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=m
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_DIOLAN_U2C=m
CONFIG_I2C_PARPORT=m
CONFIG_I2C_PARPORT_LIGHT=m
# CONFIG_I2C_ROBOTFUZZ_OSIF is not set
# CONFIG_I2C_TAOS_EVM is not set
CONFIG_I2C_TINY_USB=m
CONFIG_I2C_VIPERBOARD=m

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_STUB=m
# CONFIG_I2C_SLAVE is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
# CONFIG_SPI_ALTERA is not set
# CONFIG_SPI_AXI_SPI_ENGINE is not set
# CONFIG_SPI_BITBANG is not set
# CONFIG_SPI_BUTTERFLY is not set
# CONFIG_SPI_CADENCE is not set
CONFIG_SPI_DESIGNWARE=m
# CONFIG_SPI_DW_PCI is not set
# CONFIG_SPI_DW_MMIO is not set
# CONFIG_SPI_GPIO is not set
# CONFIG_SPI_LM70_LLP is not set
# CONFIG_SPI_OC_TINY is not set
CONFIG_SPI_PXA2XX=m
CONFIG_SPI_PXA2XX_PCI=m
# CONFIG_SPI_ROCKCHIP is not set
# CONFIG_SPI_SC18IS602 is not set
# CONFIG_SPI_XCOMM is not set
# CONFIG_SPI_XILINX is not set
# CONFIG_SPI_ZYNQMP_GQSPI is not set

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
# CONFIG_SPI_LOOPBACK_TEST is not set
# CONFIG_SPI_TLE62X0 is not set
# CONFIG_SPMI is not set
# CONFIG_HSI is not set

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
CONFIG_PPS_CLIENT_LDISC=m
CONFIG_PPS_CLIENT_PARPORT=m
CONFIG_PPS_CLIENT_GPIO=m

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y
CONFIG_DP83640_PHY=m
CONFIG_PINCTRL=y

#
# Pin controllers
#
CONFIG_PINMUX=y
CONFIG_PINCONF=y
CONFIG_GENERIC_PINCONF=y
# CONFIG_DEBUG_PINCTRL is not set
# CONFIG_PINCTRL_AMD is not set
CONFIG_PINCTRL_BAYTRAIL=y
# CONFIG_PINCTRL_CHERRYVIEW is not set
# CONFIG_PINCTRL_BROXTON is not set
# CONFIG_PINCTRL_SUNRISEPOINT is not set
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIO_ACPI=y
CONFIG_GPIOLIB_IRQCHIP=y
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_SYSFS=y

#
# Memory mapped GPIO drivers
#
# CONFIG_GPIO_AMDPT is not set
# CONFIG_GPIO_DWAPB is not set
# CONFIG_GPIO_GENERIC_PLATFORM is not set
# CONFIG_GPIO_ICH is not set
CONFIG_GPIO_LYNXPOINT=m
# CONFIG_GPIO_MOCKUP is not set
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_ZX is not set

#
# Port-mapped I/O GPIO drivers
#
# CONFIG_GPIO_F7188X is not set
# CONFIG_GPIO_IT87 is not set
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_SCH311X is not set

#
# I2C GPIO expanders
#
# CONFIG_GPIO_ADP5588 is not set
# CONFIG_GPIO_MAX7300 is not set
# CONFIG_GPIO_MAX732X is not set
# CONFIG_GPIO_PCA953X is not set
# CONFIG_GPIO_PCF857X is not set
# CONFIG_GPIO_SX150X is not set
# CONFIG_GPIO_TPIC2810 is not set
# CONFIG_GPIO_TS4900 is not set

#
# MFD GPIO expanders
#

#
# PCI GPIO expanders
#
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders
#
# CONFIG_GPIO_MAX7301 is not set
# CONFIG_GPIO_MC33880 is not set
# CONFIG_GPIO_PISOSR is not set

#
# SPI or I2C GPIO expanders
#

#
# USB GPIO expanders
#
# CONFIG_GPIO_VIPERBOARD is not set
# CONFIG_W1 is not set
# CONFIG_POWER_AVS is not set
CONFIG_POWER_RESET=y
# CONFIG_POWER_RESET_RESTART is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_SBS is not set
# CONFIG_BATTERY_BQ27XXX is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_ISP1704 is not set
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_GPIO is not set
# CONFIG_CHARGER_BQ2415X is not set
# CONFIG_CHARGER_BQ24190 is not set
# CONFIG_CHARGER_BQ24257 is not set
# CONFIG_CHARGER_BQ24735 is not set
# CONFIG_CHARGER_BQ25890 is not set
CONFIG_CHARGER_SMB347=m
# CONFIG_BATTERY_GAUGE_LTC2941 is not set
# CONFIG_CHARGER_RT9455 is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=m
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=m
CONFIG_SENSORS_ABITUGURU3=m
# CONFIG_SENSORS_AD7314 is not set
CONFIG_SENSORS_AD7414=m
CONFIG_SENSORS_AD7418=m
CONFIG_SENSORS_ADM1021=m
CONFIG_SENSORS_ADM1025=m
CONFIG_SENSORS_ADM1026=m
CONFIG_SENSORS_ADM1029=m
CONFIG_SENSORS_ADM1031=m
CONFIG_SENSORS_ADM9240=m
CONFIG_SENSORS_ADT7X10=m
# CONFIG_SENSORS_ADT7310 is not set
CONFIG_SENSORS_ADT7410=m
CONFIG_SENSORS_ADT7411=m
CONFIG_SENSORS_ADT7462=m
CONFIG_SENSORS_ADT7470=m
CONFIG_SENSORS_ADT7475=m
CONFIG_SENSORS_ASC7621=m
CONFIG_SENSORS_K8TEMP=m
CONFIG_SENSORS_K10TEMP=m
CONFIG_SENSORS_FAM15H_POWER=m
CONFIG_SENSORS_APPLESMC=m
CONFIG_SENSORS_ASB100=m
CONFIG_SENSORS_ATXP1=m
CONFIG_SENSORS_DS620=m
CONFIG_SENSORS_DS1621=m
CONFIG_SENSORS_DELL_SMM=m
CONFIG_SENSORS_I5K_AMB=m
CONFIG_SENSORS_F71805F=m
CONFIG_SENSORS_F71882FG=m
CONFIG_SENSORS_F75375S=m
CONFIG_SENSORS_FSCHMD=m
# CONFIG_SENSORS_FTSTEUTATES is not set
CONFIG_SENSORS_GL518SM=m
CONFIG_SENSORS_GL520SM=m
CONFIG_SENSORS_G760A=m
# CONFIG_SENSORS_G762 is not set
# CONFIG_SENSORS_GPIO_FAN is not set
# CONFIG_SENSORS_HIH6130 is not set
CONFIG_SENSORS_IBMAEM=m
CONFIG_SENSORS_IBMPEX=m
# CONFIG_SENSORS_I5500 is not set
CONFIG_SENSORS_CORETEMP=m
CONFIG_SENSORS_IT87=m
# CONFIG_SENSORS_JC42 is not set
# CONFIG_SENSORS_POWR1220 is not set
CONFIG_SENSORS_LINEAGE=m
# CONFIG_SENSORS_LTC2945 is not set
# CONFIG_SENSORS_LTC2990 is not set
CONFIG_SENSORS_LTC4151=m
CONFIG_SENSORS_LTC4215=m
# CONFIG_SENSORS_LTC4222 is not set
CONFIG_SENSORS_LTC4245=m
# CONFIG_SENSORS_LTC4260 is not set
CONFIG_SENSORS_LTC4261=m
# CONFIG_SENSORS_MAX1111 is not set
CONFIG_SENSORS_MAX16065=m
CONFIG_SENSORS_MAX1619=m
CONFIG_SENSORS_MAX1668=m
CONFIG_SENSORS_MAX197=m
# CONFIG_SENSORS_MAX31722 is not set
CONFIG_SENSORS_MAX6639=m
CONFIG_SENSORS_MAX6642=m
CONFIG_SENSORS_MAX6650=m
CONFIG_SENSORS_MAX6697=m
# CONFIG_SENSORS_MAX31790 is not set
CONFIG_SENSORS_MCP3021=m
# CONFIG_SENSORS_ADCXX is not set
CONFIG_SENSORS_LM63=m
# CONFIG_SENSORS_LM70 is not set
CONFIG_SENSORS_LM73=m
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=m
CONFIG_SENSORS_LM83=m
CONFIG_SENSORS_LM85=m
CONFIG_SENSORS_LM87=m
CONFIG_SENSORS_LM90=m
CONFIG_SENSORS_LM92=m
CONFIG_SENSORS_LM93=m
CONFIG_SENSORS_LM95234=m
CONFIG_SENSORS_LM95241=m
CONFIG_SENSORS_LM95245=m
CONFIG_SENSORS_PC87360=m
CONFIG_SENSORS_PC87427=m
CONFIG_SENSORS_NTC_THERMISTOR=m
# CONFIG_SENSORS_NCT6683 is not set
CONFIG_SENSORS_NCT6775=m
# CONFIG_SENSORS_NCT7802 is not set
# CONFIG_SENSORS_NCT7904 is not set
CONFIG_SENSORS_PCF8591=m
CONFIG_PMBUS=m
CONFIG_SENSORS_PMBUS=m
CONFIG_SENSORS_ADM1275=m
CONFIG_SENSORS_LM25066=m
CONFIG_SENSORS_LTC2978=m
# CONFIG_SENSORS_LTC3815 is not set
CONFIG_SENSORS_MAX16064=m
# CONFIG_SENSORS_MAX20751 is not set
CONFIG_SENSORS_MAX34440=m
CONFIG_SENSORS_MAX8688=m
# CONFIG_SENSORS_TPS40422 is not set
CONFIG_SENSORS_UCD9000=m
CONFIG_SENSORS_UCD9200=m
CONFIG_SENSORS_ZL6100=m
# CONFIG_SENSORS_SHT15 is not set
CONFIG_SENSORS_SHT21=m
# CONFIG_SENSORS_SHT3x is not set
# CONFIG_SENSORS_SHTC1 is not set
CONFIG_SENSORS_SIS5595=m
CONFIG_SENSORS_DME1737=m
CONFIG_SENSORS_EMC1403=m
# CONFIG_SENSORS_EMC2103 is not set
CONFIG_SENSORS_EMC6W201=m
CONFIG_SENSORS_SMSC47M1=m
CONFIG_SENSORS_SMSC47M192=m
CONFIG_SENSORS_SMSC47B397=m
CONFIG_SENSORS_SCH56XX_COMMON=m
CONFIG_SENSORS_SCH5627=m
CONFIG_SENSORS_SCH5636=m
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_ADC128D818 is not set
CONFIG_SENSORS_ADS1015=m
CONFIG_SENSORS_ADS7828=m
# CONFIG_SENSORS_ADS7871 is not set
CONFIG_SENSORS_AMC6821=m
CONFIG_SENSORS_INA209=m
CONFIG_SENSORS_INA2XX=m
# CONFIG_SENSORS_INA3221 is not set
# CONFIG_SENSORS_TC74 is not set
CONFIG_SENSORS_THMC50=m
CONFIG_SENSORS_TMP102=m
# CONFIG_SENSORS_TMP103 is not set
CONFIG_SENSORS_TMP401=m
CONFIG_SENSORS_TMP421=m
CONFIG_SENSORS_VIA_CPUTEMP=m
CONFIG_SENSORS_VIA686A=m
CONFIG_SENSORS_VT1211=m
CONFIG_SENSORS_VT8231=m
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83791D=m
CONFIG_SENSORS_W83792D=m
CONFIG_SENSORS_W83793=m
CONFIG_SENSORS_W83795=m
# CONFIG_SENSORS_W83795_FANCTRL is not set
CONFIG_SENSORS_W83L785TS=m
CONFIG_SENSORS_W83L786NG=m
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83627EHF=m

#
# ACPI drivers
#
CONFIG_SENSORS_ACPI_POWER=m
CONFIG_SENSORS_ATK0110=m
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
CONFIG_THERMAL_WRITABLE_TRIPS=y
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
# CONFIG_THERMAL_DEFAULT_GOV_POWER_ALLOCATOR is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
CONFIG_THERMAL_GOV_STEP_WISE=y
CONFIG_THERMAL_GOV_BANG_BANG=y
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_THERMAL_GOV_POWER_ALLOCATOR is not set
# CONFIG_THERMAL_EMULATION is not set
CONFIG_INTEL_POWERCLAMP=m
CONFIG_X86_PKG_TEMP_THERMAL=m
# CONFIG_INTEL_SOC_DTS_THERMAL is not set

#
# ACPI INT340X thermal drivers
#
# CONFIG_INT340X_THERMAL is not set
CONFIG_INTEL_PCH_THERMAL=m
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set
# CONFIG_WATCHDOG_SYSFS is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=m
# CONFIG_WDAT_WDT is not set
# CONFIG_XILINX_WATCHDOG is not set
# CONFIG_ZIIRAVE_WATCHDOG is not set
# CONFIG_CADENCE_WATCHDOG is not set
# CONFIG_DW_WATCHDOG is not set
# CONFIG_MAX63XX_WATCHDOG is not set
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
CONFIG_ALIM1535_WDT=m
CONFIG_ALIM7101_WDT=m
CONFIG_F71808E_WDT=m
CONFIG_SP5100_TCO=m
CONFIG_SBC_FITPC2_WATCHDOG=m
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=m
CONFIG_IBMASR=m
# CONFIG_WAFER_WDT is not set
CONFIG_I6300ESB_WDT=y
CONFIG_IE6XX_WDT=m
CONFIG_ITCO_WDT=y
CONFIG_ITCO_VENDOR_SUPPORT=y
CONFIG_IT8712F_WDT=m
CONFIG_IT87_WDT=m
CONFIG_HP_WATCHDOG=m
CONFIG_HPWDT_NMI_DECODING=y
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
CONFIG_NV_TCO=m
# CONFIG_60XX_WDT is not set
# CONFIG_CPU5_WDT is not set
CONFIG_SMSC_SCH311X_WDT=m
# CONFIG_SMSC37B787_WDT is not set
CONFIG_VIA_WDT=m
CONFIG_W83627HF_WDT=m
CONFIG_W83877F_WDT=m
CONFIG_W83977F_WDT=m
CONFIG_MACHZ_WDT=m
# CONFIG_SBC_EPX_C3_WATCHDOG is not set
# CONFIG_INTEL_MEI_WDT is not set
# CONFIG_NI903X_WDT is not set
# CONFIG_MEN_A21_WDT is not set
CONFIG_XEN_WDT=m

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=m
CONFIG_WDTPCI=m

#
# USB-based Watchdog Cards
#
CONFIG_USBPCWATCHDOG=m

#
# Watchdog Pretimeout Governors
#
# CONFIG_WATCHDOG_PRETIMEOUT_GOV is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=m
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
CONFIG_SSB_SDIOHOST_POSSIBLE=y
CONFIG_SSB_SDIOHOST=y
# CONFIG_SSB_DEBUG is not set
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y
# CONFIG_SSB_DRIVER_GPIO is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=m
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
# CONFIG_BCMA_HOST_SOC is not set
CONFIG_BCMA_DRIVER_PCI=y
CONFIG_BCMA_DRIVER_GMAC_CMN=y
# CONFIG_BCMA_DRIVER_GPIO is not set
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_AS3711 is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_AAT2870_CORE is not set
# CONFIG_MFD_BCM590XX is not set
# CONFIG_MFD_AXP20X_I2C is not set
# CONFIG_MFD_CROS_EC is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_DA9052_SPI is not set
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_MFD_DA9055 is not set
# CONFIG_MFD_DA9062 is not set
# CONFIG_MFD_DA9063 is not set
# CONFIG_MFD_DA9150 is not set
# CONFIG_MFD_DLN2 is not set
# CONFIG_MFD_EXYNOS_LPASS is not set
# CONFIG_MFD_MC13XXX_SPI is not set
# CONFIG_MFD_MC13XXX_I2C is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_HTC_I2CPLD is not set
# CONFIG_MFD_INTEL_QUARK_I2C_GPIO is not set
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=m
# CONFIG_INTEL_SOC_PMIC is not set
# CONFIG_MFD_INTEL_LPSS_ACPI is not set
# CONFIG_MFD_INTEL_LPSS_PCI is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_KEMPLD is not set
# CONFIG_MFD_88PM800 is not set
# CONFIG_MFD_88PM805 is not set
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_MAX14577 is not set
# CONFIG_MFD_MAX77693 is not set
# CONFIG_MFD_MAX77843 is not set
# CONFIG_MFD_MAX8907 is not set
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
# CONFIG_MFD_MT6397 is not set
# CONFIG_MFD_MENF21BMC is not set
# CONFIG_EZX_PCAP is not set
CONFIG_MFD_VIPERBOARD=m
# CONFIG_MFD_RETU is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_UCB1400_CORE is not set
# CONFIG_MFD_RDC321X is not set
CONFIG_MFD_RTSX_PCI=m
# CONFIG_MFD_RT5033 is not set
# CONFIG_MFD_RTSX_USB is not set
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_SEC_CORE is not set
# CONFIG_MFD_SI476X_CORE is not set
CONFIG_MFD_SM501=m
# CONFIG_MFD_SM501_GPIO is not set
# CONFIG_MFD_SKY81452 is not set
# CONFIG_MFD_SMSC is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_SYSCON is not set
# CONFIG_MFD_TI_AM335X_TSCADC is not set
# CONFIG_MFD_LP3943 is not set
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_PALMAS is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65086 is not set
# CONFIG_MFD_TPS65090 is not set
# CONFIG_MFD_TPS65217 is not set
# CONFIG_MFD_TI_LP873X is not set
# CONFIG_MFD_TPS65218 is not set
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS65910 is not set
# CONFIG_MFD_TPS65912_I2C is not set
# CONFIG_MFD_TPS65912_SPI is not set
# CONFIG_MFD_TPS80031 is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
# CONFIG_MFD_WL1273_CORE is not set
# CONFIG_MFD_LM3533 is not set
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=m
# CONFIG_MFD_ARIZONA_I2C is not set
# CONFIG_MFD_ARIZONA_SPI is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM831X_SPI is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
# CONFIG_REGULATOR is not set
CONFIG_MEDIA_SUPPORT=m

#
# Multimedia core support
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
CONFIG_MEDIA_RADIO_SUPPORT=y
# CONFIG_MEDIA_SDR_SUPPORT is not set
CONFIG_MEDIA_RC_SUPPORT=y
# CONFIG_MEDIA_CONTROLLER is not set
CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_V4L2=m
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_VIDEO_TUNER=m
CONFIG_VIDEOBUF_GEN=m
CONFIG_VIDEOBUF_DMA_SG=m
CONFIG_VIDEOBUF_VMALLOC=m
CONFIG_VIDEOBUF_DVB=m
CONFIG_VIDEOBUF2_CORE=m
CONFIG_VIDEOBUF2_MEMOPS=m
CONFIG_VIDEOBUF2_VMALLOC=m
CONFIG_VIDEOBUF2_DMA_SG=m
CONFIG_VIDEOBUF2_DVB=m
CONFIG_DVB_CORE=m
CONFIG_DVB_NET=y
CONFIG_TTPCI_EEPROM=m
CONFIG_DVB_MAX_ADAPTERS=8
CONFIG_DVB_DYNAMIC_MINORS=y

#
# Media drivers
#
CONFIG_RC_CORE=m
CONFIG_RC_MAP=m
CONFIG_RC_DECODERS=y
CONFIG_LIRC=m
CONFIG_IR_LIRC_CODEC=m
CONFIG_IR_NEC_DECODER=m
CONFIG_IR_RC5_DECODER=m
CONFIG_IR_RC6_DECODER=m
CONFIG_IR_JVC_DECODER=m
CONFIG_IR_SONY_DECODER=m
CONFIG_IR_SANYO_DECODER=m
CONFIG_IR_SHARP_DECODER=m
CONFIG_IR_MCE_KBD_DECODER=m
CONFIG_IR_XMP_DECODER=m
CONFIG_RC_DEVICES=y
CONFIG_RC_ATI_REMOTE=m
CONFIG_IR_ENE=m
# CONFIG_IR_HIX5HD2 is not set
CONFIG_IR_IMON=m
CONFIG_IR_MCEUSB=m
CONFIG_IR_ITE_CIR=m
CONFIG_IR_FINTEK=m
CONFIG_IR_NUVOTON=m
CONFIG_IR_REDRAT3=m
CONFIG_IR_STREAMZAP=m
CONFIG_IR_WINBOND_CIR=m
# CONFIG_IR_IGORPLUGUSB is not set
CONFIG_IR_IGUANA=m
CONFIG_IR_TTUSBIR=m
# CONFIG_RC_LOOPBACK is not set
CONFIG_IR_GPIO_CIR=m
CONFIG_MEDIA_USB_SUPPORT=y

#
# Webcam devices
#
CONFIG_USB_VIDEO_CLASS=m
CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV=y
CONFIG_USB_GSPCA=m
CONFIG_USB_M5602=m
CONFIG_USB_STV06XX=m
CONFIG_USB_GL860=m
CONFIG_USB_GSPCA_BENQ=m
CONFIG_USB_GSPCA_CONEX=m
CONFIG_USB_GSPCA_CPIA1=m
# CONFIG_USB_GSPCA_DTCS033 is not set
CONFIG_USB_GSPCA_ETOMS=m
CONFIG_USB_GSPCA_FINEPIX=m
CONFIG_USB_GSPCA_JEILINJ=m
CONFIG_USB_GSPCA_JL2005BCD=m
# CONFIG_USB_GSPCA_KINECT is not set
CONFIG_USB_GSPCA_KONICA=m
CONFIG_USB_GSPCA_MARS=m
CONFIG_USB_GSPCA_MR97310A=m
CONFIG_USB_GSPCA_NW80X=m
CONFIG_USB_GSPCA_OV519=m
CONFIG_USB_GSPCA_OV534=m
CONFIG_USB_GSPCA_OV534_9=m
CONFIG_USB_GSPCA_PAC207=m
CONFIG_USB_GSPCA_PAC7302=m
CONFIG_USB_GSPCA_PAC7311=m
CONFIG_USB_GSPCA_SE401=m
CONFIG_USB_GSPCA_SN9C2028=m
CONFIG_USB_GSPCA_SN9C20X=m
CONFIG_USB_GSPCA_SONIXB=m
CONFIG_USB_GSPCA_SONIXJ=m
CONFIG_USB_GSPCA_SPCA500=m
CONFIG_USB_GSPCA_SPCA501=m
CONFIG_USB_GSPCA_SPCA505=m
CONFIG_USB_GSPCA_SPCA506=m
CONFIG_USB_GSPCA_SPCA508=m
CONFIG_USB_GSPCA_SPCA561=m
CONFIG_USB_GSPCA_SPCA1528=m
CONFIG_USB_GSPCA_SQ905=m
CONFIG_USB_GSPCA_SQ905C=m
CONFIG_USB_GSPCA_SQ930X=m
CONFIG_USB_GSPCA_STK014=m
# CONFIG_USB_GSPCA_STK1135 is not set
CONFIG_USB_GSPCA_STV0680=m
CONFIG_USB_GSPCA_SUNPLUS=m
CONFIG_USB_GSPCA_T613=m
CONFIG_USB_GSPCA_TOPRO=m
# CONFIG_USB_GSPCA_TOUPTEK is not set
CONFIG_USB_GSPCA_TV8532=m
CONFIG_USB_GSPCA_VC032X=m
CONFIG_USB_GSPCA_VICAM=m
CONFIG_USB_GSPCA_XIRLINK_CIT=m
CONFIG_USB_GSPCA_ZC3XX=m
CONFIG_USB_PWC=m
# CONFIG_USB_PWC_DEBUG is not set
CONFIG_USB_PWC_INPUT_EVDEV=y
# CONFIG_VIDEO_CPIA2 is not set
CONFIG_USB_ZR364XX=m
CONFIG_USB_STKWEBCAM=m
CONFIG_USB_S2255=m
# CONFIG_VIDEO_USBTV is not set

#
# Analog TV USB devices
#
CONFIG_VIDEO_PVRUSB2=m
CONFIG_VIDEO_PVRUSB2_SYSFS=y
CONFIG_VIDEO_PVRUSB2_DVB=y
# CONFIG_VIDEO_PVRUSB2_DEBUGIFC is not set
CONFIG_VIDEO_HDPVR=m
CONFIG_VIDEO_USBVISION=m
# CONFIG_VIDEO_STK1160_COMMON is not set
# CONFIG_VIDEO_GO7007 is not set

#
# Analog/digital TV USB devices
#
CONFIG_VIDEO_AU0828=m
CONFIG_VIDEO_AU0828_V4L2=y
# CONFIG_VIDEO_AU0828_RC is not set
CONFIG_VIDEO_CX231XX=m
CONFIG_VIDEO_CX231XX_RC=y
CONFIG_VIDEO_CX231XX_ALSA=m
CONFIG_VIDEO_CX231XX_DVB=m
CONFIG_VIDEO_TM6000=m
CONFIG_VIDEO_TM6000_ALSA=m
CONFIG_VIDEO_TM6000_DVB=m

#
# Digital TV USB devices
#
CONFIG_DVB_USB=m
# CONFIG_DVB_USB_DEBUG is not set
CONFIG_DVB_USB_DIB3000MC=m
CONFIG_DVB_USB_A800=m
CONFIG_DVB_USB_DIBUSB_MB=m
# CONFIG_DVB_USB_DIBUSB_MB_FAULTY is not set
CONFIG_DVB_USB_DIBUSB_MC=m
CONFIG_DVB_USB_DIB0700=m
CONFIG_DVB_USB_UMT_010=m
CONFIG_DVB_USB_CXUSB=m
CONFIG_DVB_USB_M920X=m
CONFIG_DVB_USB_DIGITV=m
CONFIG_DVB_USB_VP7045=m
CONFIG_DVB_USB_VP702X=m
CONFIG_DVB_USB_GP8PSK=m
CONFIG_DVB_USB_NOVA_T_USB2=m
CONFIG_DVB_USB_TTUSB2=m
CONFIG_DVB_USB_DTT200U=m
CONFIG_DVB_USB_OPERA1=m
CONFIG_DVB_USB_AF9005=m
CONFIG_DVB_USB_AF9005_REMOTE=m
CONFIG_DVB_USB_PCTV452E=m
CONFIG_DVB_USB_DW2102=m
CONFIG_DVB_USB_CINERGY_T2=m
CONFIG_DVB_USB_DTV5100=m
CONFIG_DVB_USB_FRIIO=m
CONFIG_DVB_USB_AZ6027=m
CONFIG_DVB_USB_TECHNISAT_USB2=m
CONFIG_DVB_USB_V2=m
CONFIG_DVB_USB_AF9015=m
CONFIG_DVB_USB_AF9035=m
CONFIG_DVB_USB_ANYSEE=m
CONFIG_DVB_USB_AU6610=m
CONFIG_DVB_USB_AZ6007=m
CONFIG_DVB_USB_CE6230=m
CONFIG_DVB_USB_EC168=m
CONFIG_DVB_USB_GL861=m
CONFIG_DVB_USB_LME2510=m
CONFIG_DVB_USB_MXL111SF=m
CONFIG_DVB_USB_RTL28XXU=m
# CONFIG_DVB_USB_DVBSKY is not set
CONFIG_DVB_TTUSB_BUDGET=m
CONFIG_DVB_TTUSB_DEC=m
CONFIG_SMS_USB_DRV=m
CONFIG_DVB_B2C2_FLEXCOP_USB=m
# CONFIG_DVB_B2C2_FLEXCOP_USB_DEBUG is not set
# CONFIG_DVB_AS102 is not set

#
# Webcam, TV (analog/digital) USB devices
#
CONFIG_VIDEO_EM28XX=m
# CONFIG_VIDEO_EM28XX_V4L2 is not set
CONFIG_VIDEO_EM28XX_ALSA=m
CONFIG_VIDEO_EM28XX_DVB=m
CONFIG_VIDEO_EM28XX_RC=m
CONFIG_MEDIA_PCI_SUPPORT=y

#
# Media capture support
#
# CONFIG_VIDEO_MEYE is not set
# CONFIG_VIDEO_SOLO6X10 is not set
# CONFIG_VIDEO_TW5864 is not set
# CONFIG_VIDEO_TW68 is not set
# CONFIG_VIDEO_TW686X is not set
# CONFIG_VIDEO_ZORAN is not set

#
# Media capture/analog TV support
#
CONFIG_VIDEO_IVTV=m
# CONFIG_VIDEO_IVTV_ALSA is not set
CONFIG_VIDEO_FB_IVTV=m
# CONFIG_VIDEO_HEXIUM_GEMINI is not set
# CONFIG_VIDEO_HEXIUM_ORION is not set
# CONFIG_VIDEO_MXB is not set
# CONFIG_VIDEO_DT3155 is not set

#
# Media capture/analog/hybrid TV support
#
CONFIG_VIDEO_CX18=m
CONFIG_VIDEO_CX18_ALSA=m
CONFIG_VIDEO_CX23885=m
CONFIG_MEDIA_ALTERA_CI=m
# CONFIG_VIDEO_CX25821 is not set
CONFIG_VIDEO_CX88=m
CONFIG_VIDEO_CX88_ALSA=m
CONFIG_VIDEO_CX88_BLACKBIRD=m
CONFIG_VIDEO_CX88_DVB=m
CONFIG_VIDEO_CX88_ENABLE_VP3054=y
CONFIG_VIDEO_CX88_VP3054=m
CONFIG_VIDEO_CX88_MPEG=m
CONFIG_VIDEO_BT848=m
CONFIG_DVB_BT8XX=m
CONFIG_VIDEO_SAA7134=m
CONFIG_VIDEO_SAA7134_ALSA=m
CONFIG_VIDEO_SAA7134_RC=y
CONFIG_VIDEO_SAA7134_DVB=m
CONFIG_VIDEO_SAA7164=m

#
# Media digital TV PCI Adapters
#
CONFIG_DVB_AV7110_IR=y
CONFIG_DVB_AV7110=m
CONFIG_DVB_AV7110_OSD=y
CONFIG_DVB_BUDGET_CORE=m
CONFIG_DVB_BUDGET=m
CONFIG_DVB_BUDGET_CI=m
CONFIG_DVB_BUDGET_AV=m
CONFIG_DVB_BUDGET_PATCH=m
CONFIG_DVB_B2C2_FLEXCOP_PCI=m
# CONFIG_DVB_B2C2_FLEXCOP_PCI_DEBUG is not set
CONFIG_DVB_PLUTO2=m
CONFIG_DVB_DM1105=m
CONFIG_DVB_PT1=m
# CONFIG_DVB_PT3 is not set
CONFIG_MANTIS_CORE=m
CONFIG_DVB_MANTIS=m
CONFIG_DVB_HOPPER=m
CONFIG_DVB_NGENE=m
CONFIG_DVB_DDBRIDGE=m
# CONFIG_DVB_SMIPCIE is not set
# CONFIG_DVB_NETUP_UNIDVB is not set
# CONFIG_V4L_PLATFORM_DRIVERS is not set
# CONFIG_V4L_MEM2MEM_DRIVERS is not set
# CONFIG_V4L_TEST_DRIVERS is not set
# CONFIG_DVB_PLATFORM_DRIVERS is not set

#
# Supported MMC/SDIO adapters
#
CONFIG_SMS_SDIO_DRV=m
CONFIG_RADIO_ADAPTERS=y
CONFIG_RADIO_TEA575X=m
# CONFIG_RADIO_SI470X is not set
# CONFIG_RADIO_SI4713 is not set
# CONFIG_USB_MR800 is not set
# CONFIG_USB_DSBR is not set
# CONFIG_RADIO_MAXIRADIO is not set
# CONFIG_RADIO_SHARK is not set
# CONFIG_RADIO_SHARK2 is not set
# CONFIG_USB_KEENE is not set
# CONFIG_USB_RAREMONO is not set
# CONFIG_USB_MA901 is not set
# CONFIG_RADIO_TEA5764 is not set
# CONFIG_RADIO_SAA7706H is not set
# CONFIG_RADIO_TEF6862 is not set
# CONFIG_RADIO_WL1273 is not set

#
# Texas Instruments WL128x FM driver (ST based)
#

#
# Supported FireWire (IEEE 1394) Adapters
#
CONFIG_DVB_FIREDTV=m
CONFIG_DVB_FIREDTV_INPUT=y
CONFIG_MEDIA_COMMON_OPTIONS=y

#
# common driver options
#
CONFIG_VIDEO_CX2341X=m
CONFIG_VIDEO_TVEEPROM=m
CONFIG_CYPRESS_FIRMWARE=m
CONFIG_DVB_B2C2_FLEXCOP=m
CONFIG_VIDEO_SAA7146=m
CONFIG_VIDEO_SAA7146_VV=m
CONFIG_SMS_SIANO_MDTV=m
CONFIG_SMS_SIANO_RC=y
# CONFIG_SMS_SIANO_DEBUGFS is not set

#
# Media ancillary drivers (tuners, sensors, i2c, spi, frontends)
#
CONFIG_MEDIA_SUBDRV_AUTOSELECT=y
CONFIG_MEDIA_ATTACH=y
CONFIG_VIDEO_IR_I2C=m

#
# Audio decoders, processors and mixers
#
CONFIG_VIDEO_TVAUDIO=m
CONFIG_VIDEO_TDA7432=m
CONFIG_VIDEO_MSP3400=m
CONFIG_VIDEO_CS3308=m
CONFIG_VIDEO_CS5345=m
CONFIG_VIDEO_CS53L32A=m
CONFIG_VIDEO_WM8775=m
CONFIG_VIDEO_WM8739=m
CONFIG_VIDEO_VP27SMPX=m

#
# RDS decoders
#
CONFIG_VIDEO_SAA6588=m

#
# Video decoders
#
CONFIG_VIDEO_SAA711X=m

#
# Video and audio decoders
#
CONFIG_VIDEO_SAA717X=m
CONFIG_VIDEO_CX25840=m

#
# Video encoders
#
CONFIG_VIDEO_SAA7127=m

#
# Camera sensor devices
#

#
# Flash devices
#

#
# Video improvement chips
#
CONFIG_VIDEO_UPD64031A=m
CONFIG_VIDEO_UPD64083=m

#
# Audio/Video compression chips
#
CONFIG_VIDEO_SAA6752HS=m

#
# Miscellaneous helper chips
#
CONFIG_VIDEO_M52790=m

#
# Sensors used on soc_camera driver
#
CONFIG_MEDIA_TUNER=m
CONFIG_MEDIA_TUNER_SIMPLE=m
CONFIG_MEDIA_TUNER_TDA8290=m
CONFIG_MEDIA_TUNER_TDA827X=m
CONFIG_MEDIA_TUNER_TDA18271=m
CONFIG_MEDIA_TUNER_TDA9887=m
CONFIG_MEDIA_TUNER_TEA5761=m
CONFIG_MEDIA_TUNER_TEA5767=m
CONFIG_MEDIA_TUNER_MT20XX=m
CONFIG_MEDIA_TUNER_MT2060=m
CONFIG_MEDIA_TUNER_MT2063=m
CONFIG_MEDIA_TUNER_MT2266=m
CONFIG_MEDIA_TUNER_MT2131=m
CONFIG_MEDIA_TUNER_QT1010=m
CONFIG_MEDIA_TUNER_XC2028=m
CONFIG_MEDIA_TUNER_XC5000=m
CONFIG_MEDIA_TUNER_XC4000=m
CONFIG_MEDIA_TUNER_MXL5005S=m
CONFIG_MEDIA_TUNER_MXL5007T=m
CONFIG_MEDIA_TUNER_MC44S803=m
CONFIG_MEDIA_TUNER_MAX2165=m
CONFIG_MEDIA_TUNER_TDA18218=m
CONFIG_MEDIA_TUNER_FC0011=m
CONFIG_MEDIA_TUNER_FC0012=m
CONFIG_MEDIA_TUNER_FC0013=m
CONFIG_MEDIA_TUNER_TDA18212=m
CONFIG_MEDIA_TUNER_E4000=m
CONFIG_MEDIA_TUNER_FC2580=m
CONFIG_MEDIA_TUNER_M88RS6000T=m
CONFIG_MEDIA_TUNER_TUA9001=m
CONFIG_MEDIA_TUNER_SI2157=m
CONFIG_MEDIA_TUNER_IT913X=m
CONFIG_MEDIA_TUNER_R820T=m
CONFIG_MEDIA_TUNER_QM1D1C0042=m

#
# Multistandard (satellite) frontends
#
CONFIG_DVB_STB0899=m
CONFIG_DVB_STB6100=m
CONFIG_DVB_STV090x=m
CONFIG_DVB_STV6110x=m
CONFIG_DVB_M88DS3103=m

#
# Multistandard (cable + terrestrial) frontends
#
CONFIG_DVB_DRXK=m
CONFIG_DVB_TDA18271C2DD=m
CONFIG_DVB_SI2165=m
CONFIG_DVB_MN88472=m
CONFIG_DVB_MN88473=m

#
# DVB-S (satellite) frontends
#
CONFIG_DVB_CX24110=m
CONFIG_DVB_CX24123=m
CONFIG_DVB_MT312=m
CONFIG_DVB_ZL10036=m
CONFIG_DVB_ZL10039=m
CONFIG_DVB_S5H1420=m
CONFIG_DVB_STV0288=m
CONFIG_DVB_STB6000=m
CONFIG_DVB_STV0299=m
CONFIG_DVB_STV6110=m
CONFIG_DVB_STV0900=m
CONFIG_DVB_TDA8083=m
CONFIG_DVB_TDA10086=m
CONFIG_DVB_TDA8261=m
CONFIG_DVB_VES1X93=m
CONFIG_DVB_TUNER_ITD1000=m
CONFIG_DVB_TUNER_CX24113=m
CONFIG_DVB_TDA826X=m
CONFIG_DVB_TUA6100=m
CONFIG_DVB_CX24116=m
CONFIG_DVB_CX24117=m
CONFIG_DVB_CX24120=m
CONFIG_DVB_SI21XX=m
CONFIG_DVB_TS2020=m
CONFIG_DVB_DS3000=m
CONFIG_DVB_MB86A16=m
CONFIG_DVB_TDA10071=m

#
# DVB-T (terrestrial) frontends
#
CONFIG_DVB_SP8870=m
CONFIG_DVB_SP887X=m
CONFIG_DVB_CX22700=m
CONFIG_DVB_CX22702=m
CONFIG_DVB_DRXD=m
CONFIG_DVB_L64781=m
CONFIG_DVB_TDA1004X=m
CONFIG_DVB_NXT6000=m
CONFIG_DVB_MT352=m
CONFIG_DVB_ZL10353=m
CONFIG_DVB_DIB3000MB=m
CONFIG_DVB_DIB3000MC=m
CONFIG_DVB_DIB7000M=m
CONFIG_DVB_DIB7000P=m
CONFIG_DVB_TDA10048=m
CONFIG_DVB_AF9013=m
CONFIG_DVB_EC100=m
CONFIG_DVB_STV0367=m
CONFIG_DVB_CXD2820R=m
CONFIG_DVB_RTL2830=m
CONFIG_DVB_RTL2832=m
CONFIG_DVB_SI2168=m
# CONFIG_DVB_AS102_FE is not set

#
# DVB-C (cable) frontends
#
CONFIG_DVB_VES1820=m
CONFIG_DVB_TDA10021=m
CONFIG_DVB_TDA10023=m
CONFIG_DVB_STV0297=m

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
CONFIG_DVB_NXT200X=m
CONFIG_DVB_OR51211=m
CONFIG_DVB_OR51132=m
CONFIG_DVB_BCM3510=m
CONFIG_DVB_LGDT330X=m
CONFIG_DVB_LGDT3305=m
CONFIG_DVB_LGDT3306A=m
CONFIG_DVB_LG2160=m
CONFIG_DVB_S5H1409=m
CONFIG_DVB_AU8522=m
CONFIG_DVB_AU8522_DTV=m
CONFIG_DVB_AU8522_V4L=m
CONFIG_DVB_S5H1411=m

#
# ISDB-T (terrestrial) frontends
#
CONFIG_DVB_S921=m
CONFIG_DVB_DIB8000=m
CONFIG_DVB_MB86A20S=m

#
# ISDB-S (satellite) & ISDB-T (terrestrial) frontends
#
CONFIG_DVB_TC90522=m

#
# Digital terrestrial only tuners/PLL
#
CONFIG_DVB_PLL=m
CONFIG_DVB_TUNER_DIB0070=m
CONFIG_DVB_TUNER_DIB0090=m

#
# SEC control devices for DVB-S
#
CONFIG_DVB_DRX39XYJ=m
CONFIG_DVB_LNBP21=m
CONFIG_DVB_LNBP22=m
CONFIG_DVB_ISL6405=m
CONFIG_DVB_ISL6421=m
CONFIG_DVB_ISL6423=m
CONFIG_DVB_A8293=m
CONFIG_DVB_LGS8GXX=m
CONFIG_DVB_ATBM8830=m
CONFIG_DVB_TDA665x=m
CONFIG_DVB_IX2505V=m
CONFIG_DVB_M88RS2000=m
CONFIG_DVB_AF9033=m

#
# Tools to develop new frontends
#
# CONFIG_DVB_DUMMY_FE is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=y
CONFIG_AGP_SIS=y
CONFIG_AGP_VIA=y
CONFIG_INTEL_GTT=y
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=64
CONFIG_VGA_SWITCHEROO=y
CONFIG_DRM=m
CONFIG_DRM_MIPI_DSI=y
# CONFIG_DRM_DP_AUX_CHARDEV is not set
CONFIG_DRM_KMS_HELPER=m
CONFIG_DRM_KMS_FB_HELPER=y
CONFIG_DRM_FBDEV_EMULATION=y
CONFIG_DRM_LOAD_EDID_FIRMWARE=y
CONFIG_DRM_TTM=m

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=m
CONFIG_DRM_I2C_SIL164=m
CONFIG_DRM_I2C_NXP_TDA998X=m
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_AMDGPU is not set

#
# ACP (Audio CoProcessor) Configuration
#
# CONFIG_DRM_NOUVEAU is not set
CONFIG_DRM_I915=m
# CONFIG_DRM_I915_PRELIMINARY_HW_SUPPORT is not set
CONFIG_DRM_I915_USERPTR=y
# CONFIG_DRM_I915_GVT is not set
# CONFIG_DRM_VGEM is not set
CONFIG_DRM_VMWGFX=m
CONFIG_DRM_VMWGFX_FBCON=y
CONFIG_DRM_GMA500=m
CONFIG_DRM_GMA600=y
CONFIG_DRM_GMA3600=y
CONFIG_DRM_UDL=m
CONFIG_DRM_AST=m
CONFIG_DRM_MGAG200=m
CONFIG_DRM_CIRRUS_QEMU=m
CONFIG_DRM_QXL=m
# CONFIG_DRM_BOCHS is not set
# CONFIG_DRM_VIRTIO_GPU is not set
CONFIG_DRM_PANEL=y

#
# Display Panels
#
CONFIG_DRM_BRIDGE=y

#
# Display Interface Bridges
#
# CONFIG_DRM_ANALOGIX_ANX78XX is not set
# CONFIG_DRM_LEGACY is not set

#
# Frame buffer Devices
#
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_CMDLINE=y
CONFIG_FB_NOTIFY=y
# CONFIG_FB_DDC is not set
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=m
CONFIG_FB_SYS_COPYAREA=m
CONFIG_FB_SYS_IMAGEBLIT=m
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=m
CONFIG_FB_DEFERRED_IO=y
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
# CONFIG_FB_MODE_HELPERS is not set
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
CONFIG_FB_VESA=y
CONFIG_FB_EFI=y
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_OPENCORES is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I740 is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_SM501 is not set
# CONFIG_FB_SMSCUFX is not set
# CONFIG_FB_UDL is not set
# CONFIG_FB_IBM_GXT4500 is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_XEN_FBDEV_FRONTEND is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
# CONFIG_FB_AUO_K190X is not set
CONFIG_FB_HYPERV=m
# CONFIG_FB_SIMPLE is not set
# CONFIG_FB_SM712 is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
# CONFIG_LCD_L4F00242T03 is not set
# CONFIG_LCD_LMS283GF05 is not set
# CONFIG_LCD_LTV350QV is not set
# CONFIG_LCD_ILI922X is not set
# CONFIG_LCD_ILI9320 is not set
# CONFIG_LCD_TDO24M is not set
# CONFIG_LCD_VGG2432A4 is not set
CONFIG_LCD_PLATFORM=m
# CONFIG_LCD_S6E63M0 is not set
# CONFIG_LCD_LD9040 is not set
# CONFIG_LCD_AMS369FG06 is not set
# CONFIG_LCD_LMS501KF03 is not set
# CONFIG_LCD_HX8357 is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_GENERIC is not set
# CONFIG_BACKLIGHT_PWM is not set
CONFIG_BACKLIGHT_APPLE=m
# CONFIG_BACKLIGHT_PM8941_WLED is not set
# CONFIG_BACKLIGHT_SAHARA is not set
# CONFIG_BACKLIGHT_ADP8860 is not set
# CONFIG_BACKLIGHT_ADP8870 is not set
# CONFIG_BACKLIGHT_LM3630A is not set
# CONFIG_BACKLIGHT_LM3639 is not set
# CONFIG_BACKLIGHT_LP855X is not set
# CONFIG_BACKLIGHT_GPIO is not set
# CONFIG_BACKLIGHT_LV5207LP is not set
# CONFIG_BACKLIGHT_BD6107 is not set
# CONFIG_VGASTATE is not set
CONFIG_HDMI=y

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_DUMMY_CONSOLE=y
CONFIG_DUMMY_CONSOLE_COLUMNS=80
CONFIG_DUMMY_CONSOLE_ROWS=25
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
CONFIG_SOUND=m
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_HWDEP=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_JACK=y
CONFIG_SND_JACK_INPUT_DEV=y
CONFIG_SND_SEQUENCER=m
CONFIG_SND_SEQ_DUMMY=m
CONFIG_SND_OSSEMUL=y
# CONFIG_SND_MIXER_OSS is not set
# CONFIG_SND_PCM_OSS is not set
CONFIG_SND_PCM_TIMER=y
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_HRTIMER=m
CONFIG_SND_SEQ_HRTIMER_DEFAULT=y
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_MAX_CARDS=32
# CONFIG_SND_SUPPORT_OLD_API is not set
CONFIG_SND_PROC_FS=y
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_DMA_SGBUF=y
CONFIG_SND_RAWMIDI_SEQ=m
CONFIG_SND_OPL3_LIB_SEQ=m
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
CONFIG_SND_EMU10K1_SEQ=m
CONFIG_SND_MPU401_UART=m
CONFIG_SND_OPL3_LIB=m
CONFIG_SND_VX_LIB=m
CONFIG_SND_AC97_CODEC=m
CONFIG_SND_DRIVERS=y
CONFIG_SND_PCSP=m
CONFIG_SND_DUMMY=m
CONFIG_SND_ALOOP=m
CONFIG_SND_VIRMIDI=m
CONFIG_SND_MTPAV=m
# CONFIG_SND_MTS64 is not set
# CONFIG_SND_SERIAL_U16550 is not set
CONFIG_SND_MPU401=m
# CONFIG_SND_PORTMAN2X4 is not set
CONFIG_SND_AC97_POWER_SAVE=y
CONFIG_SND_AC97_POWER_SAVE_DEFAULT=5
CONFIG_SND_PCI=y
CONFIG_SND_AD1889=m
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
CONFIG_SND_ALI5451=m
CONFIG_SND_ASIHPI=m
CONFIG_SND_ATIIXP=m
CONFIG_SND_ATIIXP_MODEM=m
CONFIG_SND_AU8810=m
CONFIG_SND_AU8820=m
CONFIG_SND_AU8830=m
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
CONFIG_SND_BT87X=m
# CONFIG_SND_BT87X_OVERCLOCK is not set
CONFIG_SND_CA0106=m
CONFIG_SND_CMIPCI=m
CONFIG_SND_OXYGEN_LIB=m
CONFIG_SND_OXYGEN=m
# CONFIG_SND_CS4281 is not set
CONFIG_SND_CS46XX=m
CONFIG_SND_CS46XX_NEW_DSP=y
CONFIG_SND_CTXFI=m
CONFIG_SND_DARLA20=m
CONFIG_SND_GINA20=m
CONFIG_SND_LAYLA20=m
CONFIG_SND_DARLA24=m
CONFIG_SND_GINA24=m
CONFIG_SND_LAYLA24=m
CONFIG_SND_MONA=m
CONFIG_SND_MIA=m
CONFIG_SND_ECHO3G=m
CONFIG_SND_INDIGO=m
CONFIG_SND_INDIGOIO=m
CONFIG_SND_INDIGODJ=m
CONFIG_SND_INDIGOIOX=m
CONFIG_SND_INDIGODJX=m
CONFIG_SND_EMU10K1=m
CONFIG_SND_EMU10K1X=m
CONFIG_SND_ENS1370=m
CONFIG_SND_ENS1371=m
# CONFIG_SND_ES1938 is not set
CONFIG_SND_ES1968=m
CONFIG_SND_ES1968_INPUT=y
CONFIG_SND_ES1968_RADIO=y
# CONFIG_SND_FM801 is not set
CONFIG_SND_HDSP=m
CONFIG_SND_HDSPM=m
CONFIG_SND_ICE1712=m
CONFIG_SND_ICE1724=m
CONFIG_SND_INTEL8X0=m
CONFIG_SND_INTEL8X0M=m
CONFIG_SND_KORG1212=m
CONFIG_SND_LOLA=m
CONFIG_SND_LX6464ES=m
CONFIG_SND_MAESTRO3=m
CONFIG_SND_MAESTRO3_INPUT=y
CONFIG_SND_MIXART=m
# CONFIG_SND_NM256 is not set
CONFIG_SND_PCXHR=m
# CONFIG_SND_RIPTIDE is not set
CONFIG_SND_RME32=m
CONFIG_SND_RME96=m
CONFIG_SND_RME9652=m
# CONFIG_SND_SONICVIBES is not set
CONFIG_SND_TRIDENT=m
CONFIG_SND_VIA82XX=m
CONFIG_SND_VIA82XX_MODEM=m
CONFIG_SND_VIRTUOSO=m
CONFIG_SND_VX222=m
# CONFIG_SND_YMFPCI is not set

#
# HD-Audio
#
CONFIG_SND_HDA=m
CONFIG_SND_HDA_INTEL=m
CONFIG_SND_HDA_HWDEP=y
# CONFIG_SND_HDA_RECONFIG is not set
CONFIG_SND_HDA_INPUT_BEEP=y
CONFIG_SND_HDA_INPUT_BEEP_MODE=0
# CONFIG_SND_HDA_PATCH_LOADER is not set
CONFIG_SND_HDA_CODEC_REALTEK=m
CONFIG_SND_HDA_CODEC_ANALOG=m
CONFIG_SND_HDA_CODEC_SIGMATEL=m
CONFIG_SND_HDA_CODEC_VIA=m
CONFIG_SND_HDA_CODEC_HDMI=m
CONFIG_SND_HDA_CODEC_CIRRUS=m
CONFIG_SND_HDA_CODEC_CONEXANT=m
CONFIG_SND_HDA_CODEC_CA0110=m
CONFIG_SND_HDA_CODEC_CA0132=m
CONFIG_SND_HDA_CODEC_CA0132_DSP=y
CONFIG_SND_HDA_CODEC_CMEDIA=m
CONFIG_SND_HDA_CODEC_SI3054=m
CONFIG_SND_HDA_GENERIC=m
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=0
CONFIG_SND_HDA_CORE=m
CONFIG_SND_HDA_DSP_LOADER=y
CONFIG_SND_HDA_I915=y
CONFIG_SND_HDA_PREALLOC_SIZE=512
CONFIG_SND_SPI=y
CONFIG_SND_USB=y
CONFIG_SND_USB_AUDIO=m
CONFIG_SND_USB_UA101=m
CONFIG_SND_USB_USX2Y=m
CONFIG_SND_USB_CAIAQ=m
CONFIG_SND_USB_CAIAQ_INPUT=y
CONFIG_SND_USB_US122L=m
CONFIG_SND_USB_6FIRE=m
# CONFIG_SND_USB_HIFACE is not set
# CONFIG_SND_BCD2000 is not set
# CONFIG_SND_USB_POD is not set
# CONFIG_SND_USB_PODHD is not set
# CONFIG_SND_USB_TONEPORT is not set
# CONFIG_SND_USB_VARIAX is not set
CONFIG_SND_FIREWIRE=y
CONFIG_SND_FIREWIRE_LIB=m
# CONFIG_SND_DICE is not set
# CONFIG_SND_OXFW is not set
CONFIG_SND_ISIGHT=m
# CONFIG_SND_FIREWORKS is not set
# CONFIG_SND_BEBOB is not set
# CONFIG_SND_FIREWIRE_DIGI00X is not set
# CONFIG_SND_FIREWIRE_TASCAM is not set
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set
CONFIG_AC97_BUS=m

#
# HID support
#
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
CONFIG_HIDRAW=y
CONFIG_UHID=m
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
CONFIG_HID_ACRUX=m
# CONFIG_HID_ACRUX_FF is not set
CONFIG_HID_APPLE=y
CONFIG_HID_APPLEIR=m
# CONFIG_HID_ASUS is not set
CONFIG_HID_AUREAL=m
CONFIG_HID_BELKIN=y
# CONFIG_HID_BETOP_FF is not set
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
# CONFIG_HID_CORSAIR is not set
CONFIG_HID_PRODIKEYS=m
# CONFIG_HID_CMEDIA is not set
# CONFIG_HID_CP2112 is not set
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=m
# CONFIG_DRAGONRISE_FF is not set
# CONFIG_HID_EMS_FF is not set
CONFIG_HID_ELECOM=m
# CONFIG_HID_ELO is not set
CONFIG_HID_EZKEY=y
# CONFIG_HID_GEMBIRD is not set
# CONFIG_HID_GFRM is not set
CONFIG_HID_HOLTEK=m
# CONFIG_HOLTEK_FF is not set
# CONFIG_HID_GT683R is not set
CONFIG_HID_KEYTOUCH=m
CONFIG_HID_KYE=m
CONFIG_HID_UCLOGIC=m
CONFIG_HID_WALTOP=m
CONFIG_HID_GYRATION=m
CONFIG_HID_ICADE=m
CONFIG_HID_TWINHAN=m
CONFIG_HID_KENSINGTON=y
CONFIG_HID_LCPOWER=m
CONFIG_HID_LED=m
# CONFIG_HID_LENOVO is not set
CONFIG_HID_LOGITECH=y
CONFIG_HID_LOGITECH_DJ=m
CONFIG_HID_LOGITECH_HIDPP=m
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
# CONFIG_LOGIG940_FF is not set
# CONFIG_LOGIWHEELS_FF is not set
CONFIG_HID_MAGICMOUSE=y
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_MULTITOUCH=m
CONFIG_HID_NTRIG=y
CONFIG_HID_ORTEK=m
CONFIG_HID_PANTHERLORD=m
# CONFIG_PANTHERLORD_FF is not set
# CONFIG_HID_PENMOUNT is not set
CONFIG_HID_PETALYNX=m
CONFIG_HID_PICOLCD=m
CONFIG_HID_PICOLCD_FB=y
CONFIG_HID_PICOLCD_BACKLIGHT=y
CONFIG_HID_PICOLCD_LCD=y
CONFIG_HID_PICOLCD_LEDS=y
CONFIG_HID_PICOLCD_CIR=y
CONFIG_HID_PLANTRONICS=y
CONFIG_HID_PRIMAX=m
CONFIG_HID_ROCCAT=m
CONFIG_HID_SAITEK=m
CONFIG_HID_SAMSUNG=m
CONFIG_HID_SONY=m
# CONFIG_SONY_FF is not set
CONFIG_HID_SPEEDLINK=m
CONFIG_HID_STEELSERIES=m
CONFIG_HID_SUNPLUS=m
# CONFIG_HID_RMI is not set
CONFIG_HID_GREENASIA=m
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_HYPERV_MOUSE=m
CONFIG_HID_SMARTJOYPLUS=m
# CONFIG_SMARTJOYPLUS_FF is not set
CONFIG_HID_TIVO=m
CONFIG_HID_TOPSEED=m
CONFIG_HID_THINGM=m
CONFIG_HID_THRUSTMASTER=m
# CONFIG_THRUSTMASTER_FF is not set
CONFIG_HID_WACOM=m
CONFIG_HID_WIIMOTE=m
# CONFIG_HID_XINMO is not set
CONFIG_HID_ZEROPLUS=m
# CONFIG_ZEROPLUS_FF is not set
CONFIG_HID_ZYDACRON=m
# CONFIG_HID_SENSOR_HUB is not set
# CONFIG_HID_ALPS is not set

#
# USB HID support
#
CONFIG_USB_HID=y
CONFIG_HID_PID=y
CONFIG_USB_HIDDEV=y

#
# I2C HID support
#
CONFIG_I2C_HID=m

#
# Intel ISH HID support
#
# CONFIG_INTEL_ISH_HID is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEFAULT_PERSIST=y
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_OTG is not set
# CONFIG_USB_OTG_WHITELIST is not set
# CONFIG_USB_LEDS_TRIGGER_USBPORT is not set
CONFIG_USB_MON=y
CONFIG_USB_WUSB=m
CONFIG_USB_WUSB_CBAF=m
# CONFIG_USB_WUSB_CBAF_DEBUG is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_XHCI_HCD=y
CONFIG_USB_XHCI_PCI=y
CONFIG_USB_XHCI_PLATFORM=y
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_EHCI_PCI=y
# CONFIG_USB_EHCI_HCD_PLATFORM is not set
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1362_HCD is not set
# CONFIG_USB_FOTG210_HCD is not set
# CONFIG_USB_MAX3421_HCD is not set
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_PCI=y
# CONFIG_USB_OHCI_HCD_PLATFORM is not set
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_U132_HCD is not set
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_WHCI_HCD is not set
CONFIG_USB_HWA_HCD=m
# CONFIG_USB_HCD_BCMA is not set
# CONFIG_USB_HCD_SSB is not set
# CONFIG_USB_HCD_TEST_MODE is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=m
CONFIG_USB_PRINTER=m
CONFIG_USB_WDM=m
CONFIG_USB_TMC=m

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
CONFIG_USB_STORAGE_REALTEK=m
CONFIG_REALTEK_AUTOPM=y
CONFIG_USB_STORAGE_DATAFAB=m
CONFIG_USB_STORAGE_FREECOM=m
CONFIG_USB_STORAGE_ISD200=m
CONFIG_USB_STORAGE_USBAT=m
CONFIG_USB_STORAGE_SDDR09=m
CONFIG_USB_STORAGE_SDDR55=m
CONFIG_USB_STORAGE_JUMPSHOT=m
CONFIG_USB_STORAGE_ALAUDA=m
CONFIG_USB_STORAGE_ONETOUCH=m
CONFIG_USB_STORAGE_KARMA=m
CONFIG_USB_STORAGE_CYPRESS_ATACB=m
CONFIG_USB_STORAGE_ENE_UB6250=m
# CONFIG_USB_UAS is not set

#
# USB Imaging devices
#
CONFIG_USB_MDC800=m
CONFIG_USB_MICROTEK=m
# CONFIG_USBIP_CORE is not set
# CONFIG_USB_MUSB_HDRC is not set
CONFIG_USB_DWC3=y
# CONFIG_USB_DWC3_HOST is not set
CONFIG_USB_DWC3_GADGET=y
# CONFIG_USB_DWC3_DUAL_ROLE is not set

#
# Platform Glue Driver Support
#
CONFIG_USB_DWC3_PCI=y
# CONFIG_USB_DWC2 is not set
# CONFIG_USB_CHIPIDEA is not set
# CONFIG_USB_ISP1760 is not set

#
# USB port drivers
#
CONFIG_USB_USS720=m
CONFIG_USB_SERIAL=y
CONFIG_USB_SERIAL_CONSOLE=y
CONFIG_USB_SERIAL_GENERIC=y
# CONFIG_USB_SERIAL_SIMPLE is not set
CONFIG_USB_SERIAL_AIRCABLE=m
CONFIG_USB_SERIAL_ARK3116=m
CONFIG_USB_SERIAL_BELKIN=m
CONFIG_USB_SERIAL_CH341=m
CONFIG_USB_SERIAL_WHITEHEAT=m
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=m
CONFIG_USB_SERIAL_CP210X=m
CONFIG_USB_SERIAL_CYPRESS_M8=m
CONFIG_USB_SERIAL_EMPEG=m
CONFIG_USB_SERIAL_FTDI_SIO=m
CONFIG_USB_SERIAL_VISOR=m
CONFIG_USB_SERIAL_IPAQ=m
CONFIG_USB_SERIAL_IR=m
CONFIG_USB_SERIAL_EDGEPORT=m
CONFIG_USB_SERIAL_EDGEPORT_TI=m
# CONFIG_USB_SERIAL_F81232 is not set
CONFIG_USB_SERIAL_GARMIN=m
CONFIG_USB_SERIAL_IPW=m
CONFIG_USB_SERIAL_IUU=m
CONFIG_USB_SERIAL_KEYSPAN_PDA=m
CONFIG_USB_SERIAL_KEYSPAN=m
CONFIG_USB_SERIAL_KLSI=m
CONFIG_USB_SERIAL_KOBIL_SCT=m
CONFIG_USB_SERIAL_MCT_U232=m
# CONFIG_USB_SERIAL_METRO is not set
CONFIG_USB_SERIAL_MOS7720=m
CONFIG_USB_SERIAL_MOS7715_PARPORT=y
CONFIG_USB_SERIAL_MOS7840=m
# CONFIG_USB_SERIAL_MXUPORT is not set
CONFIG_USB_SERIAL_NAVMAN=m
CONFIG_USB_SERIAL_PL2303=m
CONFIG_USB_SERIAL_OTI6858=m
CONFIG_USB_SERIAL_QCAUX=m
CONFIG_USB_SERIAL_QUALCOMM=m
CONFIG_USB_SERIAL_SPCP8X5=m
CONFIG_USB_SERIAL_SAFE=m
CONFIG_USB_SERIAL_SAFE_PADDED=y
CONFIG_USB_SERIAL_SIERRAWIRELESS=m
CONFIG_USB_SERIAL_SYMBOL=m
# CONFIG_USB_SERIAL_TI is not set
CONFIG_USB_SERIAL_CYBERJACK=m
CONFIG_USB_SERIAL_XIRCOM=m
CONFIG_USB_SERIAL_WWAN=m
CONFIG_USB_SERIAL_OPTION=m
CONFIG_USB_SERIAL_OMNINET=m
CONFIG_USB_SERIAL_OPTICON=m
CONFIG_USB_SERIAL_XSENS_MT=m
# CONFIG_USB_SERIAL_WISHBONE is not set
CONFIG_USB_SERIAL_SSU100=m
CONFIG_USB_SERIAL_QT2=m
CONFIG_USB_SERIAL_DEBUG=m

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=m
CONFIG_USB_EMI26=m
CONFIG_USB_ADUTUX=m
CONFIG_USB_SEVSEG=m
# CONFIG_USB_RIO500 is not set
CONFIG_USB_LEGOTOWER=m
CONFIG_USB_LCD=m
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
CONFIG_USB_IDMOUSE=m
CONFIG_USB_FTDI_ELAN=m
CONFIG_USB_APPLEDISPLAY=m
CONFIG_USB_SISUSBVGA=m
CONFIG_USB_SISUSBVGA_CON=y
CONFIG_USB_LD=m
# CONFIG_USB_TRANCEVIBRATOR is not set
CONFIG_USB_IOWARRIOR=m
# CONFIG_USB_TEST is not set
# CONFIG_USB_EHSET_TEST_FIXTURE is not set
CONFIG_USB_ISIGHTFW=m
# CONFIG_USB_YUREX is not set
CONFIG_USB_EZUSB_FX2=m
CONFIG_USB_HSIC_USB3503=m
# CONFIG_USB_HSIC_USB4604 is not set
# CONFIG_USB_LINK_LAYER_TEST is not set
# CONFIG_USB_CHAOSKEY is not set
# CONFIG_UCSI is not set
CONFIG_USB_ATM=m
CONFIG_USB_SPEEDTOUCH=m
CONFIG_USB_CXACRU=m
CONFIG_USB_UEAGLEATM=m
CONFIG_USB_XUSBATM=m

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
CONFIG_NOP_USB_XCEIV=y
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_USB_ISP1301 is not set
CONFIG_USB_GADGET=y
# CONFIG_USB_GADGET_DEBUG is not set
# CONFIG_USB_GADGET_DEBUG_FILES is not set
# CONFIG_USB_GADGET_DEBUG_FS is not set
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2

#
# USB Peripheral Controller
#
# CONFIG_USB_FOTG210_UDC is not set
# CONFIG_USB_GR_UDC is not set
# CONFIG_USB_R8A66597 is not set
# CONFIG_USB_PXA27X is not set
# CONFIG_USB_MV_UDC is not set
# CONFIG_USB_MV_U3D is not set
# CONFIG_USB_M66592 is not set
# CONFIG_USB_BDC_UDC is not set
# CONFIG_USB_AMD5536UDC is not set
# CONFIG_USB_NET2272 is not set
# CONFIG_USB_NET2280 is not set
# CONFIG_USB_GOKU is not set
# CONFIG_USB_EG20T is not set
# CONFIG_USB_DUMMY_HCD is not set
CONFIG_USB_LIBCOMPOSITE=m
CONFIG_USB_F_MASS_STORAGE=m
# CONFIG_USB_CONFIGFS is not set
# CONFIG_USB_ZERO is not set
# CONFIG_USB_AUDIO is not set
# CONFIG_USB_ETH is not set
# CONFIG_USB_G_NCM is not set
# CONFIG_USB_GADGETFS is not set
# CONFIG_USB_FUNCTIONFS is not set
CONFIG_USB_MASS_STORAGE=m
# CONFIG_USB_GADGET_TARGET is not set
# CONFIG_USB_G_SERIAL is not set
# CONFIG_USB_MIDI_GADGET is not set
# CONFIG_USB_G_PRINTER is not set
# CONFIG_USB_CDC_COMPOSITE is not set
# CONFIG_USB_G_ACM_MS is not set
# CONFIG_USB_G_MULTI is not set
# CONFIG_USB_G_HID is not set
# CONFIG_USB_G_DBGP is not set
# CONFIG_USB_G_WEBCAM is not set
# CONFIG_USB_LED_TRIG is not set
# CONFIG_USB_ULPI_BUS is not set
CONFIG_UWB=m
CONFIG_UWB_HWA=m
CONFIG_UWB_WHCI=m
CONFIG_UWB_I1480U=m
CONFIG_MMC=m
# CONFIG_MMC_DEBUG is not set

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=m
CONFIG_MMC_BLOCK_MINORS=8
CONFIG_MMC_BLOCK_BOUNCE=y
CONFIG_SDIO_UART=m
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=m
CONFIG_MMC_SDHCI_PCI=m
CONFIG_MMC_RICOH_MMC=y
CONFIG_MMC_SDHCI_ACPI=m
CONFIG_MMC_SDHCI_PLTFM=m
# CONFIG_MMC_WBSD is not set
CONFIG_MMC_TIFM_SD=m
# CONFIG_MMC_SPI is not set
CONFIG_MMC_CB710=m
CONFIG_MMC_VIA_SDMMC=m
CONFIG_MMC_VUB300=m
CONFIG_MMC_USHC=m
# CONFIG_MMC_USDHI6ROL0 is not set
CONFIG_MMC_REALTEK_PCI=m
# CONFIG_MMC_TOSHIBA_PCI is not set
# CONFIG_MMC_MTK is not set
CONFIG_MEMSTICK=m
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set
CONFIG_MSPRO_BLOCK=m
# CONFIG_MS_BLOCK is not set

#
# MemoryStick Host Controller Drivers
#
CONFIG_MEMSTICK_TIFM_MS=m
CONFIG_MEMSTICK_JMICRON_38X=m
CONFIG_MEMSTICK_R592=m
CONFIG_MEMSTICK_REALTEK_PCI=m
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y
# CONFIG_LEDS_CLASS_FLASH is not set

#
# LED drivers
#
CONFIG_LEDS_LM3530=m
# CONFIG_LEDS_LM3642 is not set
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_GPIO is not set
CONFIG_LEDS_LP3944=m
# CONFIG_LEDS_LP3952 is not set
CONFIG_LEDS_LP55XX_COMMON=m
CONFIG_LEDS_LP5521=m
CONFIG_LEDS_LP5523=m
CONFIG_LEDS_LP5562=m
# CONFIG_LEDS_LP8501 is not set
# CONFIG_LEDS_LP8860 is not set
CONFIG_LEDS_CLEVO_MAIL=m
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_PCA963X is not set
# CONFIG_LEDS_DAC124S085 is not set
# CONFIG_LEDS_PWM is not set
# CONFIG_LEDS_BD2802 is not set
CONFIG_LEDS_INTEL_SS4200=m
# CONFIG_LEDS_LT3593 is not set
# CONFIG_LEDS_TCA6507 is not set
# CONFIG_LEDS_TLC591XX is not set
# CONFIG_LEDS_LM355x is not set

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
CONFIG_LEDS_BLINKM=m
# CONFIG_LEDS_MLXCPLD is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=m
CONFIG_LEDS_TRIGGER_ONESHOT=m
# CONFIG_LEDS_TRIGGER_DISK is not set
# CONFIG_LEDS_TRIGGER_MTD is not set
CONFIG_LEDS_TRIGGER_HEARTBEAT=m
CONFIG_LEDS_TRIGGER_BACKLIGHT=m
# CONFIG_LEDS_TRIGGER_CPU is not set
# CONFIG_LEDS_TRIGGER_GPIO is not set
CONFIG_LEDS_TRIGGER_DEFAULT_ON=m

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=m
CONFIG_LEDS_TRIGGER_CAMERA=m
# CONFIG_LEDS_TRIGGER_PANIC is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC_ATOMIC_SCRUB=y
CONFIG_EDAC_SUPPORT=y
CONFIG_EDAC=y
CONFIG_EDAC_LEGACY_SYSFS=y
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_DECODE_MCE=m
CONFIG_EDAC_MM_EDAC=m
CONFIG_EDAC_AMD64=m
# CONFIG_EDAC_AMD64_ERROR_INJECTION is not set
CONFIG_EDAC_E752X=m
CONFIG_EDAC_I82975X=m
CONFIG_EDAC_I3000=m
CONFIG_EDAC_I3200=m
# CONFIG_EDAC_IE31200 is not set
CONFIG_EDAC_X38=m
CONFIG_EDAC_I5400=m
CONFIG_EDAC_I7CORE=m
CONFIG_EDAC_I5000=m
CONFIG_EDAC_I5100=m
CONFIG_EDAC_I7300=m
CONFIG_EDAC_SBRIDGE=m
# CONFIG_EDAC_SKX is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_MC146818_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_SYSTOHC is not set
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_ABB5ZES3 is not set
# CONFIG_RTC_DRV_ABX80X is not set
CONFIG_RTC_DRV_DS1307=m
CONFIG_RTC_DRV_DS1307_HWMON=y
# CONFIG_RTC_DRV_DS1307_CENTURY is not set
CONFIG_RTC_DRV_DS1374=m
# CONFIG_RTC_DRV_DS1374_WDT is not set
CONFIG_RTC_DRV_DS1672=m
CONFIG_RTC_DRV_MAX6900=m
CONFIG_RTC_DRV_RS5C372=m
CONFIG_RTC_DRV_ISL1208=m
CONFIG_RTC_DRV_ISL12022=m
CONFIG_RTC_DRV_X1205=m
CONFIG_RTC_DRV_PCF8523=m
# CONFIG_RTC_DRV_PCF85063 is not set
CONFIG_RTC_DRV_PCF8563=m
CONFIG_RTC_DRV_PCF8583=m
CONFIG_RTC_DRV_M41T80=m
CONFIG_RTC_DRV_M41T80_WDT=y
CONFIG_RTC_DRV_BQ32K=m
# CONFIG_RTC_DRV_S35390A is not set
CONFIG_RTC_DRV_FM3130=m
# CONFIG_RTC_DRV_RX8010 is not set
CONFIG_RTC_DRV_RX8581=m
CONFIG_RTC_DRV_RX8025=m
CONFIG_RTC_DRV_EM3027=m
# CONFIG_RTC_DRV_RV8803 is not set

#
# SPI RTC drivers
#
# CONFIG_RTC_DRV_M41T93 is not set
# CONFIG_RTC_DRV_M41T94 is not set
# CONFIG_RTC_DRV_DS1302 is not set
# CONFIG_RTC_DRV_DS1305 is not set
# CONFIG_RTC_DRV_DS1343 is not set
# CONFIG_RTC_DRV_DS1347 is not set
# CONFIG_RTC_DRV_DS1390 is not set
# CONFIG_RTC_DRV_MAX6916 is not set
# CONFIG_RTC_DRV_R9701 is not set
# CONFIG_RTC_DRV_RX4581 is not set
# CONFIG_RTC_DRV_RX6110 is not set
# CONFIG_RTC_DRV_RS5C348 is not set
# CONFIG_RTC_DRV_MAX6902 is not set
# CONFIG_RTC_DRV_PCF2123 is not set
# CONFIG_RTC_DRV_MCP795 is not set
CONFIG_RTC_I2C_AND_SPI=y

#
# SPI and I2C RTC drivers
#
CONFIG_RTC_DRV_DS3232=m
# CONFIG_RTC_DRV_PCF2127 is not set
CONFIG_RTC_DRV_RV3029C2=m
CONFIG_RTC_DRV_RV3029_HWMON=y

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
CONFIG_RTC_DRV_DS1286=m
CONFIG_RTC_DRV_DS1511=m
CONFIG_RTC_DRV_DS1553=m
# CONFIG_RTC_DRV_DS1685_FAMILY is not set
CONFIG_RTC_DRV_DS1742=m
CONFIG_RTC_DRV_DS2404=m
CONFIG_RTC_DRV_STK17TA8=m
# CONFIG_RTC_DRV_M48T86 is not set
CONFIG_RTC_DRV_M48T35=m
CONFIG_RTC_DRV_M48T59=m
CONFIG_RTC_DRV_MSM6242=m
CONFIG_RTC_DRV_BQ4802=m
CONFIG_RTC_DRV_RP5C01=m
CONFIG_RTC_DRV_V3020=m

#
# on-CPU RTC drivers
#

#
# HID Sensor RTC drivers
#
# CONFIG_RTC_DRV_HID_SENSOR_TIME is not set
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
CONFIG_DMA_ENGINE=y
CONFIG_DMA_VIRTUAL_CHANNELS=y
CONFIG_DMA_ACPI=y
# CONFIG_INTEL_IDMA64 is not set
# CONFIG_INTEL_IOATDMA is not set
# CONFIG_QCOM_HIDMA_MGMT is not set
# CONFIG_QCOM_HIDMA is not set
CONFIG_DW_DMAC_CORE=y
CONFIG_DW_DMAC=m
CONFIG_DW_DMAC_PCI=y
CONFIG_HSU_DMA=y

#
# DMA Clients
#
CONFIG_ASYNC_TX_DMA=y
CONFIG_DMATEST=m

#
# DMABUF options
#
# CONFIG_SYNC_FILE is not set
CONFIG_AUXDISPLAY=y
CONFIG_KS0108=m
CONFIG_KS0108_PORT=0x378
CONFIG_KS0108_DELAY=2
CONFIG_CFAG12864B=m
CONFIG_CFAG12864B_RATE=20
# CONFIG_IMG_ASCII_LCD is not set
CONFIG_UIO=m
CONFIG_UIO_CIF=m
CONFIG_UIO_PDRV_GENIRQ=m
# CONFIG_UIO_DMEM_GENIRQ is not set
CONFIG_UIO_AEC=m
CONFIG_UIO_SERCOS3=m
CONFIG_UIO_PCI_GENERIC=m
# CONFIG_UIO_NETX is not set
# CONFIG_UIO_PRUSS is not set
# CONFIG_UIO_MF624 is not set
CONFIG_VFIO_IOMMU_TYPE1=m
CONFIG_VFIO_VIRQFD=m
CONFIG_VFIO=m
# CONFIG_VFIO_NOIOMMU is not set
CONFIG_VFIO_PCI=m
# CONFIG_VFIO_PCI_VGA is not set
CONFIG_VFIO_PCI_MMAP=y
CONFIG_VFIO_PCI_INTX=y
CONFIG_VFIO_PCI_IGD=y
CONFIG_IRQ_BYPASS_MANAGER=m
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_PCI_LEGACY=y
CONFIG_VIRTIO_BALLOON=y
# CONFIG_VIRTIO_INPUT is not set
# CONFIG_VIRTIO_MMIO is not set

#
# Microsoft Hyper-V guest support
#
CONFIG_HYPERV=m
CONFIG_HYPERV_UTILS=m
CONFIG_HYPERV_BALLOON=m

#
# Xen driver support
#
CONFIG_XEN_BALLOON=y
# CONFIG_XEN_SELFBALLOONING is not set
# CONFIG_XEN_BALLOON_MEMORY_HOTPLUG is not set
CONFIG_XEN_SCRUB_PAGES=y
CONFIG_XEN_DEV_EVTCHN=m
CONFIG_XEN_BACKEND=y
CONFIG_XENFS=m
CONFIG_XEN_COMPAT_XENFS=y
CONFIG_XEN_SYS_HYPERVISOR=y
CONFIG_XEN_XENBUS_FRONTEND=y
# CONFIG_XEN_GNTDEV is not set
# CONFIG_XEN_GRANT_DEV_ALLOC is not set
CONFIG_SWIOTLB_XEN=y
CONFIG_XEN_TMEM=m
CONFIG_XEN_PCIDEV_BACKEND=m
# CONFIG_XEN_SCSI_BACKEND is not set
CONFIG_XEN_PRIVCMD=m
CONFIG_XEN_ACPI_PROCESSOR=m
# CONFIG_XEN_MCE_LOG is not set
CONFIG_XEN_HAVE_PVMMU=y
CONFIG_XEN_EFI=y
CONFIG_XEN_AUTO_XLATE=y
CONFIG_XEN_ACPI=y
CONFIG_XEN_SYMS=y
CONFIG_XEN_HAVE_VPMU=y
CONFIG_STAGING=y
# CONFIG_SLICOSS is not set
# CONFIG_PRISM2_USB is not set
# CONFIG_COMEDI is not set
# CONFIG_RTL8192U is not set
CONFIG_RTLLIB=m
CONFIG_RTLLIB_CRYPTO_CCMP=m
CONFIG_RTLLIB_CRYPTO_TKIP=m
CONFIG_RTLLIB_CRYPTO_WEP=m
CONFIG_RTL8192E=m
CONFIG_R8712U=m
# CONFIG_R8188EU is not set
# CONFIG_RTS5208 is not set
# CONFIG_VT6655 is not set
# CONFIG_VT6656 is not set
# CONFIG_FB_SM750 is not set
# CONFIG_FB_XGI is not set

#
# Speakup console speech
#
# CONFIG_SPEAKUP is not set
# CONFIG_STAGING_MEDIA is not set

#
# Android
#
# CONFIG_LTE_GDM724X is not set
CONFIG_FIREWIRE_SERIAL=m
CONFIG_FWTTY_MAX_TOTAL_PORTS=64
CONFIG_FWTTY_MAX_CARD_PORTS=32
# CONFIG_LNET is not set
# CONFIG_DGNC is not set
# CONFIG_GS_FPGABOOT is not set
# CONFIG_CRYPTO_SKEIN is not set
# CONFIG_UNISYSSPAR is not set
# CONFIG_FB_TFT is not set
# CONFIG_WILC1000_SDIO is not set
# CONFIG_WILC1000_SPI is not set
# CONFIG_MOST is not set

#
# Old ISDN4Linux (deprecated)
#
# CONFIG_KS7010 is not set
# CONFIG_GREYBUS is not set
CONFIG_X86_PLATFORM_DEVICES=y
CONFIG_ACER_WMI=m
CONFIG_ACERHDF=m
# CONFIG_ALIENWARE_WMI is not set
CONFIG_ASUS_LAPTOP=m
# CONFIG_DELL_SMBIOS is not set
CONFIG_DELL_WMI_AIO=m
# CONFIG_DELL_SMO8800 is not set
# CONFIG_DELL_RBTN is not set
CONFIG_FUJITSU_LAPTOP=m
# CONFIG_FUJITSU_LAPTOP_DEBUG is not set
CONFIG_FUJITSU_TABLET=m
CONFIG_AMILO_RFKILL=m
CONFIG_HP_ACCEL=m
# CONFIG_HP_WIRELESS is not set
CONFIG_HP_WMI=m
CONFIG_MSI_LAPTOP=m
CONFIG_PANASONIC_LAPTOP=m
CONFIG_COMPAL_LAPTOP=m
CONFIG_SONY_LAPTOP=m
CONFIG_SONYPI_COMPAT=y
CONFIG_IDEAPAD_LAPTOP=m
CONFIG_THINKPAD_ACPI=m
CONFIG_THINKPAD_ACPI_ALSA_SUPPORT=y
# CONFIG_THINKPAD_ACPI_DEBUGFACILITIES is not set
# CONFIG_THINKPAD_ACPI_DEBUG is not set
# CONFIG_THINKPAD_ACPI_UNSAFE_LEDS is not set
CONFIG_THINKPAD_ACPI_VIDEO=y
CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
CONFIG_SENSORS_HDAPS=m
# CONFIG_INTEL_MENLOW is not set
CONFIG_EEEPC_LAPTOP=m
CONFIG_ASUS_WMI=m
CONFIG_ASUS_NB_WMI=m
CONFIG_EEEPC_WMI=m
# CONFIG_ASUS_WIRELESS is not set
CONFIG_ACPI_WMI=m
CONFIG_MSI_WMI=m
CONFIG_TOPSTAR_LAPTOP=m
CONFIG_TOSHIBA_BT_RFKILL=m
# CONFIG_TOSHIBA_HAPS is not set
# CONFIG_TOSHIBA_WMI is not set
CONFIG_ACPI_CMPC=m
# CONFIG_INTEL_HID_EVENT is not set
# CONFIG_INTEL_VBTN is not set
CONFIG_INTEL_IPS=m
# CONFIG_INTEL_PMC_CORE is not set
# CONFIG_IBM_RTL is not set
CONFIG_SAMSUNG_LAPTOP=m
CONFIG_MXM_WMI=m
CONFIG_INTEL_OAKTRAIL=m
CONFIG_SAMSUNG_Q10=m
CONFIG_APPLE_GMUX=m
# CONFIG_INTEL_RST is not set
# CONFIG_INTEL_SMARTCONNECT is not set
CONFIG_PVPANIC=y
# CONFIG_INTEL_PMC_IPC is not set
# CONFIG_SURFACE_PRO3_BUTTON is not set
# CONFIG_INTEL_PUNIT_IPC is not set
# CONFIG_CHROME_PLATFORMS is not set
CONFIG_CLKDEV_LOOKUP=y
CONFIG_HAVE_CLK_PREPARE=y
CONFIG_COMMON_CLK=y

#
# Common Clock Framework
#
# CONFIG_COMMON_CLK_SI5351 is not set
# CONFIG_COMMON_CLK_CDCE706 is not set
# CONFIG_COMMON_CLK_CS2000_CP is not set
# CONFIG_COMMON_CLK_NXP is not set
# CONFIG_COMMON_CLK_PWM is not set
# CONFIG_COMMON_CLK_PXA is not set
# CONFIG_COMMON_CLK_PIC32 is not set

#
# Hardware Spinlock drivers
#

#
# Clock Source drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# CONFIG_ATMEL_PIT is not set
# CONFIG_SH_TIMER_CMT is not set
# CONFIG_SH_TIMER_MTU2 is not set
# CONFIG_SH_TIMER_TMU is not set
# CONFIG_EM_TIMER_STI is not set
# CONFIG_MAILBOX is not set
CONFIG_IOMMU_API=y
CONFIG_IOMMU_SUPPORT=y

#
# Generic IOMMU Pagetable Support
#
CONFIG_IOMMU_IOVA=y
CONFIG_AMD_IOMMU=y
CONFIG_AMD_IOMMU_V2=m
CONFIG_DMAR_TABLE=y
CONFIG_INTEL_IOMMU=y
# CONFIG_INTEL_IOMMU_SVM is not set
# CONFIG_INTEL_IOMMU_DEFAULT_ON is not set
CONFIG_INTEL_IOMMU_FLOPPY_WA=y
CONFIG_IRQ_REMAP=y

#
# Remoteproc drivers
#
# CONFIG_STE_MODEM_RPROC is not set

#
# Rpmsg drivers
#

#
# SOC (System On Chip) specific Drivers
#

#
# Broadcom SoC drivers
#
# CONFIG_SUNXI_SRAM is not set
# CONFIG_SOC_TI is not set
CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND=m
# CONFIG_DEVFREQ_GOV_PERFORMANCE is not set
# CONFIG_DEVFREQ_GOV_POWERSAVE is not set
# CONFIG_DEVFREQ_GOV_USERSPACE is not set
# CONFIG_DEVFREQ_GOV_PASSIVE is not set

#
# DEVFREQ Drivers
#
# CONFIG_PM_DEVFREQ_EVENT is not set
# CONFIG_EXTCON is not set
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
CONFIG_NTB=m
# CONFIG_NTB_AMD is not set
# CONFIG_NTB_INTEL is not set
# CONFIG_NTB_PINGPONG is not set
# CONFIG_NTB_TOOL is not set
# CONFIG_NTB_PERF is not set
# CONFIG_NTB_TRANSPORT is not set
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
# CONFIG_PWM_LPSS_PCI is not set
# CONFIG_PWM_LPSS_PLATFORM is not set
# CONFIG_PWM_PCA9685 is not set
CONFIG_ARM_GIC_MAX_NR=1
# CONFIG_IPACK_BUS is not set
# CONFIG_RESET_CONTROLLER is not set
# CONFIG_FMC is not set

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
# CONFIG_PHY_PXA_28NM_HSIC is not set
# CONFIG_PHY_PXA_28NM_USB2 is not set
# CONFIG_BCM_KONA_USB2_PHY is not set
CONFIG_POWERCAP=y
CONFIG_INTEL_RAPL=m
# CONFIG_MCB is not set

#
# Performance monitor support
#
CONFIG_RAS=y
# CONFIG_MCE_AMD_INJ is not set
# CONFIG_THUNDERBOLT is not set

#
# Android
#
# CONFIG_ANDROID is not set
CONFIG_LIBNVDIMM=m
CONFIG_BLK_DEV_PMEM=m
CONFIG_ND_BLK=m
CONFIG_ND_CLAIM=y
CONFIG_ND_BTT=m
CONFIG_BTT=y
CONFIG_ND_PFN=m
CONFIG_NVDIMM_PFN=y
CONFIG_NVDIMM_DAX=y
CONFIG_DEV_DAX=m
CONFIG_DEV_DAX_PMEM=m
CONFIG_NR_DEV_DAX=32768
CONFIG_NVMEM=m
# CONFIG_STM is not set
# CONFIG_INTEL_TH is not set

#
# FPGA Configuration Support
#
# CONFIG_FPGA is not set

#
# Firmware Drivers
#
CONFIG_EDD=m
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=m
CONFIG_DCDBAS=m
CONFIG_DMIID=y
CONFIG_DMI_SYSFS=y
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
CONFIG_ISCSI_IBFT_FIND=y
CONFIG_ISCSI_IBFT=m
# CONFIG_FW_CFG_SYSFS is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# EFI (Extensible Firmware Interface) Support
#
CONFIG_EFI_VARS=y
CONFIG_EFI_ESRT=y
CONFIG_EFI_VARS_PSTORE=y
CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE=y
CONFIG_EFI_RUNTIME_MAP=y
# CONFIG_EFI_FAKE_MEMMAP is not set
CONFIG_EFI_RUNTIME_WRAPPERS=y
# CONFIG_EFI_BOOTLOADER_CONTROL is not set
# CONFIG_EFI_CAPSULE_LOADER is not set
# CONFIG_EFI_TEST is not set
CONFIG_UEFI_CPER=y

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_FS_IOMAP=y
# CONFIG_EXT2_FS is not set
# CONFIG_EXT3_FS is not set
CONFIG_EXT4_FS=y
CONFIG_EXT4_USE_FOR_EXT2=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_ENCRYPTION is not set
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_XFS_FS=y
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
# CONFIG_XFS_RT is not set
# CONFIG_XFS_WARN is not set
# CONFIG_XFS_DEBUG is not set
CONFIG_GFS2_FS=m
CONFIG_GFS2_FS_LOCKING_DLM=y
# CONFIG_OCFS2_FS is not set
CONFIG_BTRFS_FS=m
CONFIG_BTRFS_FS_POSIX_ACL=y
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
# CONFIG_BTRFS_DEBUG is not set
# CONFIG_BTRFS_ASSERT is not set
# CONFIG_NILFS2_FS is not set
CONFIG_F2FS_FS=m
CONFIG_F2FS_STAT_FS=y
CONFIG_F2FS_FS_XATTR=y
CONFIG_F2FS_FS_POSIX_ACL=y
# CONFIG_F2FS_FS_SECURITY is not set
# CONFIG_F2FS_CHECK_FS is not set
# CONFIG_F2FS_FS_ENCRYPTION is not set
# CONFIG_F2FS_IO_TRACE is not set
# CONFIG_F2FS_FAULT_INJECTION is not set
CONFIG_FS_DAX=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
# CONFIG_EXPORTFS_BLOCK_OPS is not set
CONFIG_FILE_LOCKING=y
CONFIG_MANDATORY_FILE_LOCKING=y
# CONFIG_FS_ENCRYPTION is not set
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
CONFIG_FANOTIFY_ACCESS_PERMISSIONS=y
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_PRINT_QUOTA_WARNING=y
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=y
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_QUOTACTL_COMPAT=y
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=m
CONFIG_CUSE=m
CONFIG_OVERLAY_FS=m

#
# Caches
#
CONFIG_FSCACHE=m
CONFIG_FSCACHE_STATS=y
# CONFIG_FSCACHE_HISTOGRAM is not set
# CONFIG_FSCACHE_DEBUG is not set
# CONFIG_FSCACHE_OBJECT_LIST is not set
CONFIG_CACHEFILES=m
# CONFIG_CACHEFILES_DEBUG is not set
# CONFIG_CACHEFILES_HISTOGRAM is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=m
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="ascii"
# CONFIG_FAT_DEFAULT_UTF8 is not set
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
# CONFIG_PROC_CHILDREN is not set
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_ARCH_HAS_GIGANTIC_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_EFIVAR_FS=y
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ORANGEFS_FS is not set
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_JFFS2_FS is not set
# CONFIG_UBIFS_FS is not set
# CONFIG_LOGFS is not set
CONFIG_CRAMFS=m
CONFIG_SQUASHFS=m
CONFIG_SQUASHFS_FILE_CACHE=y
# CONFIG_SQUASHFS_FILE_DIRECT is not set
CONFIG_SQUASHFS_DECOMP_SINGLE=y
# CONFIG_SQUASHFS_DECOMP_MULTI is not set
# CONFIG_SQUASHFS_DECOMP_MULTI_PERCPU is not set
CONFIG_SQUASHFS_XATTR=y
CONFIG_SQUASHFS_ZLIB=y
# CONFIG_SQUASHFS_LZ4 is not set
CONFIG_SQUASHFS_LZO=y
CONFIG_SQUASHFS_XZ=y
# CONFIG_SQUASHFS_4K_DEVBLK_SIZE is not set
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_QNX6FS_FS is not set
# CONFIG_ROMFS_FS is not set
CONFIG_PSTORE=y
CONFIG_PSTORE_ZLIB_COMPRESS=y
# CONFIG_PSTORE_LZO_COMPRESS is not set
# CONFIG_PSTORE_LZ4_COMPRESS is not set
# CONFIG_PSTORE_CONSOLE is not set
# CONFIG_PSTORE_PMSG is not set
# CONFIG_PSTORE_FTRACE is not set
CONFIG_PSTORE_RAM=m
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
# CONFIG_EXOFS_FS is not set
CONFIG_ORE=m
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
# CONFIG_NFS_V2 is not set
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=m
# CONFIG_NFS_SWAP is not set
CONFIG_NFS_V4_1=y
CONFIG_NFS_V4_2=y
CONFIG_PNFS_FILE_LAYOUT=m
CONFIG_PNFS_BLOCK=m
CONFIG_PNFS_OBJLAYOUT=m
CONFIG_PNFS_FLEXFILE_LAYOUT=m
CONFIG_NFS_V4_1_IMPLEMENTATION_ID_DOMAIN="kernel.org"
# CONFIG_NFS_V4_1_MIGRATION is not set
CONFIG_NFS_V4_SECURITY_LABEL=y
CONFIG_ROOT_NFS=y
# CONFIG_NFS_USE_LEGACY_DNS is not set
CONFIG_NFS_USE_KERNEL_DNS=y
CONFIG_NFS_DEBUG=y
CONFIG_NFSD=m
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
CONFIG_NFSD_V4=y
# CONFIG_NFSD_BLOCKLAYOUT is not set
# CONFIG_NFSD_SCSILAYOUT is not set
# CONFIG_NFSD_FLEXFILELAYOUT is not set
CONFIG_NFSD_V4_SECURITY_LABEL=y
# CONFIG_NFSD_FAULT_INJECTION is not set
CONFIG_GRACE_PERIOD=y
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_NFS_ACL_SUPPORT=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=m
CONFIG_SUNRPC_BACKCHANNEL=y
CONFIG_RPCSEC_GSS_KRB5=m
CONFIG_SUNRPC_DEBUG=y
# CONFIG_CEPH_FS is not set
CONFIG_CIFS=m
CONFIG_CIFS_STATS=y
# CONFIG_CIFS_STATS2 is not set
CONFIG_CIFS_WEAK_PW_HASH=y
CONFIG_CIFS_UPCALL=y
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
CONFIG_CIFS_ACL=y
CONFIG_CIFS_DEBUG=y
# CONFIG_CIFS_DEBUG2 is not set
CONFIG_CIFS_DFS_UPCALL=y
CONFIG_CIFS_SMB2=y
# CONFIG_CIFS_SMB311 is not set
# CONFIG_CIFS_FSCACHE is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set
CONFIG_9P_FS=y
CONFIG_9P_FS_POSIX_ACL=y
# CONFIG_9P_FS_SECURITY is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=m
CONFIG_NLS_CODEPAGE_852=m
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=m
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=m
CONFIG_NLS_CODEPAGE_866=m
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=m
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=m
CONFIG_NLS_ISO8859_8=m
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=m
CONFIG_NLS_ISO8859_6=m
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=m
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_KOI8_R=m
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_MAC_ROMAN=m
CONFIG_NLS_MAC_CELTIC=m
CONFIG_NLS_MAC_CENTEURO=m
CONFIG_NLS_MAC_CROATIAN=m
CONFIG_NLS_MAC_CYRILLIC=m
CONFIG_NLS_MAC_GAELIC=m
CONFIG_NLS_MAC_GREEK=m
CONFIG_NLS_MAC_ICELAND=m
CONFIG_NLS_MAC_INUIT=m
CONFIG_NLS_MAC_ROMANIAN=m
CONFIG_NLS_MAC_TURKISH=m
CONFIG_NLS_UTF8=m
CONFIG_DLM=m
CONFIG_DLM_DEBUG=y

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y

#
# printk and dmesg options
#
CONFIG_PRINTK_TIME=y
CONFIG_MESSAGE_LOGLEVEL_DEFAULT=4
CONFIG_BOOT_PRINTK_DELAY=y
CONFIG_DYNAMIC_DEBUG=y

#
# Compile-time checks and compiler options
#
# CONFIG_DEBUG_INFO is not set
# CONFIG_ENABLE_WARN_DEPRECATED is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
# CONFIG_UNUSED_SYMBOLS is not set
# CONFIG_PAGE_OWNER is not set
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_SECTION_MISMATCH_WARN_ONLY=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_STACK_VALIDATION is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
# CONFIG_PAGE_EXTENSION is not set
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_PAGE_POISONING is not set
# CONFIG_DEBUG_PAGE_REF is not set
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_MEMORY_NOTIFIER_ERROR_INJECT=m
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_HAVE_ARCH_KASAN=y
# CONFIG_KASAN is not set
CONFIG_ARCH_HAS_KCOV=y
# CONFIG_KCOV is not set
CONFIG_DEBUG_SHIRQ=y

#
# Debug Lockups and Hangs
#
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=1
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_WQ_WATCHDOG is not set
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_PANIC_TIMEOUT=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHED_INFO=y
CONFIG_SCHEDSTATS=y
# CONFIG_SCHED_STACK_END_CHECK is not set
# CONFIG_DEBUG_TIMEKEEPING is not set
CONFIG_TIMER_STATS=y

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_LOCK_TORTURE_TEST=m
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_LIST=y
# CONFIG_DEBUG_PI_LIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
# CONFIG_PROVE_RCU is not set
CONFIG_SPARSE_RCU_POINTER=y
CONFIG_TORTURE_TEST=m
# CONFIG_RCU_PERF_TEST is not set
CONFIG_RCU_TORTURE_TEST=m
# CONFIG_RCU_TORTURE_TEST_SLOW_PREINIT is not set
# CONFIG_RCU_TORTURE_TEST_SLOW_INIT is not set
# CONFIG_RCU_TORTURE_TEST_SLOW_CLEANUP is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=60
# CONFIG_RCU_TRACE is not set
# CONFIG_RCU_EQS_DEBUG is not set
# CONFIG_DEBUG_WQ_FORCE_RR_CPU is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_CPU_HOTPLUG_STATE_CONTROL is not set
CONFIG_NOTIFIER_ERROR_INJECTION=m
# CONFIG_CPU_NOTIFIER_ERROR_INJECT is not set
CONFIG_PM_NOTIFIER_ERROR_INJECT=m
# CONFIG_NETDEV_NOTIFIER_ERROR_INJECT is not set
# CONFIG_FAULT_INJECTION is not set
CONFIG_LATENCYTOP=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_FENTRY=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
# CONFIG_IRQSOFF_TRACER is not set
CONFIG_SCHED_TRACER=y
# CONFIG_HWLAT_TRACER is not set
CONFIG_FTRACE_SYSCALLS=y
CONFIG_TRACER_SNAPSHOT=y
# CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP is not set
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
CONFIG_STACK_TRACER=y
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_KPROBE_EVENT=y
CONFIG_UPROBE_EVENT=y
CONFIG_PROBE_EVENTS=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_FUNCTION_PROFILER=y
CONFIG_FTRACE_MCOUNT_RECORD=y
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
# CONFIG_HIST_TRIGGERS is not set
# CONFIG_TRACEPOINT_BENCHMARK is not set
CONFIG_RING_BUFFER_BENCHMARK=m
# CONFIG_RING_BUFFER_STARTUP_TEST is not set
# CONFIG_TRACE_ENUM_MAP_FILE is not set
CONFIG_TRACING_EVENTS_GPIO=y

#
# Runtime Testing
#
CONFIG_LKDTM=m
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_RBTREE_TEST=m
CONFIG_INTERVAL_TREE_TEST=m
CONFIG_PERCPU_TEST=m
CONFIG_ATOMIC64_SELFTEST=y
CONFIG_ASYNC_RAID6_TEST=m
# CONFIG_TEST_HEXDUMP is not set
# CONFIG_TEST_STRING_HELPERS is not set
CONFIG_TEST_KSTRTOX=m
# CONFIG_TEST_PRINTF is not set
# CONFIG_TEST_BITMAP is not set
# CONFIG_TEST_UUID is not set
# CONFIG_TEST_RHASHTABLE is not set
# CONFIG_TEST_HASH is not set
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
# CONFIG_DMA_API_DEBUG is not set
CONFIG_TEST_LKM=m
CONFIG_TEST_USER_COPY=m
CONFIG_TEST_BPF=m
CONFIG_TEST_FIRMWARE=m
CONFIG_TEST_UDELAY=m
# CONFIG_MEMTEST is not set
# CONFIG_TEST_STATIC_KEYS is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_ARCH_HAS_UBSAN_SANITIZE_ALL=y
# CONFIG_ARCH_WANTS_UBSAN_NO_NULL is not set
# CONFIG_UBSAN is not set
CONFIG_ARCH_HAS_DEVMEM_IS_ALLOWED=y
CONFIG_STRICT_DEVMEM=y
# CONFIG_IO_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
# CONFIG_EARLY_PRINTK_EFI is not set
# CONFIG_X86_PTDUMP_CORE is not set
# CONFIG_X86_PTDUMP is not set
# CONFIG_EFI_PGT_DUMP is not set
CONFIG_DEBUG_RODATA_TEST=y
# CONFIG_DEBUG_WX is not set
CONFIG_DEBUG_SET_MODULE_RONX=y
CONFIG_DEBUG_NX_TEST=m
CONFIG_DOUBLEFAULT=y
# CONFIG_DEBUG_TLBFLUSH is not set
# CONFIG_IOMMU_DEBUG is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_X86_DECODER_SELFTEST=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
# CONFIG_DEBUG_ENTRY is not set
# CONFIG_DEBUG_NMI_SELFTEST is not set
CONFIG_X86_DEBUG_FPU=y
# CONFIG_PUNIT_ATOM_DEBUG is not set

#
# Security options
#
CONFIG_KEYS=y
CONFIG_PERSISTENT_KEYRINGS=y
CONFIG_BIG_KEYS=y
CONFIG_TRUSTED_KEYS=y
CONFIG_ENCRYPTED_KEYS=y
# CONFIG_KEY_DH_OPERATIONS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_NETWORK_XFRM=y
# CONFIG_SECURITY_PATH is not set
CONFIG_INTEL_TXT=y
CONFIG_LSM_MMAP_MIN_ADDR=65535
CONFIG_HAVE_HARDENED_USERCOPY_ALLOCATOR=y
CONFIG_HAVE_ARCH_HARDENED_USERCOPY=y
# CONFIG_HARDENED_USERCOPY is not set
CONFIG_SECURITY_SELINUX=y
CONFIG_SECURITY_SELINUX_BOOTPARAM=y
CONFIG_SECURITY_SELINUX_BOOTPARAM_VALUE=1
CONFIG_SECURITY_SELINUX_DISABLE=y
CONFIG_SECURITY_SELINUX_DEVELOP=y
CONFIG_SECURITY_SELINUX_AVC_STATS=y
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
# CONFIG_SECURITY_SMACK is not set
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
# CONFIG_SECURITY_LOADPIN is not set
# CONFIG_SECURITY_YAMA is not set
CONFIG_INTEGRITY=y
CONFIG_INTEGRITY_SIGNATURE=y
CONFIG_INTEGRITY_ASYMMETRIC_KEYS=y
CONFIG_INTEGRITY_TRUSTED_KEYRING=y
CONFIG_INTEGRITY_AUDIT=y
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
CONFIG_IMA_LSM_RULES=y
# CONFIG_IMA_TEMPLATE is not set
CONFIG_IMA_NG_TEMPLATE=y
# CONFIG_IMA_SIG_TEMPLATE is not set
CONFIG_IMA_DEFAULT_TEMPLATE="ima-ng"
CONFIG_IMA_DEFAULT_HASH_SHA1=y
# CONFIG_IMA_DEFAULT_HASH_SHA256 is not set
# CONFIG_IMA_DEFAULT_HASH_SHA512 is not set
# CONFIG_IMA_DEFAULT_HASH_WP512 is not set
CONFIG_IMA_DEFAULT_HASH="sha1"
# CONFIG_IMA_WRITE_POLICY is not set
# CONFIG_IMA_READ_POLICY is not set
CONFIG_IMA_APPRAISE=y
CONFIG_IMA_TRUSTED_KEYRING=y
# CONFIG_IMA_BLACKLIST_KEYRING is not set
# CONFIG_IMA_LOAD_X509 is not set
CONFIG_EVM=y
CONFIG_EVM_ATTR_FSUUID=y
# CONFIG_EVM_LOAD_X509 is not set
CONFIG_DEFAULT_SECURITY_SELINUX=y
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_DEFAULT_SECURITY="selinux"
CONFIG_XOR_BLOCKS=m
CONFIG_ASYNC_CORE=m
CONFIG_ASYNC_MEMCPY=m
CONFIG_ASYNC_XOR=m
CONFIG_ASYNC_PQ=m
CONFIG_ASYNC_RAID6_RECOV=m
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_RNG_DEFAULT=y
CONFIG_CRYPTO_AKCIPHER2=y
CONFIG_CRYPTO_AKCIPHER=y
CONFIG_CRYPTO_KPP2=y
CONFIG_CRYPTO_RSA=y
# CONFIG_CRYPTO_DH is not set
# CONFIG_CRYPTO_ECDH is not set
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_USER=m
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=m
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_NULL2=y
CONFIG_CRYPTO_PCRYPT=m
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=m
# CONFIG_CRYPTO_MCRYPTD is not set
CONFIG_CRYPTO_AUTHENC=m
CONFIG_CRYPTO_TEST=m
CONFIG_CRYPTO_ABLK_HELPER=m
CONFIG_CRYPTO_GLUE_HELPER_X86=m

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=m
CONFIG_CRYPTO_GCM=m
# CONFIG_CRYPTO_CHACHA20POLY1305 is not set
CONFIG_CRYPTO_SEQIV=y
CONFIG_CRYPTO_ECHAINIV=m

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=m
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=m
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=m
# CONFIG_CRYPTO_KEYWRAP is not set

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=m
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=m
CONFIG_CRYPTO_VMAC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=m
CONFIG_CRYPTO_CRC32=m
CONFIG_CRYPTO_CRC32_PCLMUL=m
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_CRCT10DIF_PCLMUL=m
CONFIG_CRYPTO_GHASH=m
# CONFIG_CRYPTO_POLY1305 is not set
# CONFIG_CRYPTO_POLY1305_X86_64 is not set
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=m
CONFIG_CRYPTO_RMD128=m
CONFIG_CRYPTO_RMD160=m
CONFIG_CRYPTO_RMD256=m
CONFIG_CRYPTO_RMD320=m
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=m
CONFIG_CRYPTO_SHA256_SSSE3=m
CONFIG_CRYPTO_SHA512_SSSE3=m
# CONFIG_CRYPTO_SHA1_MB is not set
# CONFIG_CRYPTO_SHA256_MB is not set
# CONFIG_CRYPTO_SHA512_MB is not set
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=m
# CONFIG_CRYPTO_SHA3 is not set
CONFIG_CRYPTO_TGR192=m
CONFIG_CRYPTO_WP512=m
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=m

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=y
CONFIG_CRYPTO_AES_NI_INTEL=m
CONFIG_CRYPTO_ANUBIS=m
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_BLOWFISH_COMMON=m
CONFIG_CRYPTO_BLOWFISH_X86_64=m
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAMELLIA_X86_64=m
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=m
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=m
CONFIG_CRYPTO_CAST_COMMON=m
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST5_AVX_X86_64=m
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_CAST6_AVX_X86_64=m
CONFIG_CRYPTO_DES=m
# CONFIG_CRYPTO_DES3_EDE_X86_64 is not set
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_SALSA20=m
CONFIG_CRYPTO_SALSA20_X86_64=m
# CONFIG_CRYPTO_CHACHA20 is not set
# CONFIG_CRYPTO_CHACHA20_X86_64 is not set
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=m
CONFIG_CRYPTO_SERPENT_AVX_X86_64=m
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=m
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_X86_64=m
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=m
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=m
CONFIG_CRYPTO_LZO=y
# CONFIG_CRYPTO_842 is not set
# CONFIG_CRYPTO_LZ4 is not set
# CONFIG_CRYPTO_LZ4HC is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
CONFIG_CRYPTO_DRBG_MENU=y
CONFIG_CRYPTO_DRBG_HMAC=y
# CONFIG_CRYPTO_DRBG_HASH is not set
# CONFIG_CRYPTO_DRBG_CTR is not set
CONFIG_CRYPTO_DRBG=y
CONFIG_CRYPTO_JITTERENTROPY=y
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
CONFIG_CRYPTO_USER_API_SKCIPHER=y
# CONFIG_CRYPTO_USER_API_RNG is not set
# CONFIG_CRYPTO_USER_API_AEAD is not set
CONFIG_CRYPTO_HASH_INFO=y
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=m
CONFIG_CRYPTO_DEV_PADLOCK_AES=m
CONFIG_CRYPTO_DEV_PADLOCK_SHA=m
# CONFIG_CRYPTO_DEV_CCP is not set
# CONFIG_CRYPTO_DEV_QAT_DH895xCC is not set
# CONFIG_CRYPTO_DEV_QAT_C3XXX is not set
# CONFIG_CRYPTO_DEV_QAT_C62X is not set
# CONFIG_CRYPTO_DEV_QAT_DH895xCCVF is not set
# CONFIG_CRYPTO_DEV_QAT_C3XXXVF is not set
# CONFIG_CRYPTO_DEV_QAT_C62XVF is not set
# CONFIG_CRYPTO_DEV_CHELSIO is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_X509_CERTIFICATE_PARSER=y
# CONFIG_PKCS7_MESSAGE_PARSER is not set

#
# Certificates for signature checking
#
CONFIG_SYSTEM_TRUSTED_KEYRING=y
CONFIG_SYSTEM_TRUSTED_KEYS=""
# CONFIG_SYSTEM_EXTRA_CERTIFICATE is not set
# CONFIG_SECONDARY_TRUSTED_KEYRING is not set
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_IRQFD=y
CONFIG_HAVE_KVM_IRQ_ROUTING=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_MMIO=y
CONFIG_KVM_ASYNC_PF=y
CONFIG_HAVE_KVM_MSI=y
CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT=y
CONFIG_KVM_VFIO=y
CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT=y
CONFIG_KVM_COMPAT=y
CONFIG_HAVE_KVM_IRQ_BYPASS=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=m
CONFIG_KVM_INTEL=m
CONFIG_KVM_AMD=m
CONFIG_KVM_MMU_AUDIT=y
# CONFIG_KVM_DEVICE_ASSIGNMENT is not set
CONFIG_VHOST_NET=m
# CONFIG_VHOST_SCSI is not set
# CONFIG_VHOST_VSOCK is not set
CONFIG_VHOST=m
# CONFIG_VHOST_CROSS_ENDIAN_LEGACY is not set
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_RAID6_PQ=m
CONFIG_BITREVERSE=y
# CONFIG_HAVE_ARCH_BITREVERSE is not set
CONFIG_RATIONAL=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
CONFIG_ARCH_HAS_FAST_MULTIPLIER=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
CONFIG_CRC8=m
# CONFIG_AUDIT_ARCH_COMPAT_GENERIC is not set
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=m
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_INTERVAL_TREE=y
CONFIG_RADIX_TREE_MULTIORDER=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPUMASK_OFFSTACK=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_GLOB=y
# CONFIG_GLOB_SELFTEST is not set
CONFIG_NLATTR=y
CONFIG_CLZ_TAB=y
CONFIG_CORDIC=m
# CONFIG_DDR is not set
CONFIG_IRQ_POLL=y
CONFIG_MPILIB=y
CONFIG_SIGNATURE=y
CONFIG_OID_REGISTRY=y
CONFIG_UCS2_STRING=y
CONFIG_FONT_SUPPORT=y
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
# CONFIG_SG_SPLIT is not set
CONFIG_SG_POOL=y
CONFIG_ARCH_HAS_SG_CHAIN=y
CONFIG_ARCH_HAS_PMEM_API=y
CONFIG_ARCH_HAS_MMIO_FLUSH=y
CONFIG_SBITMAP=y

--3uo+9/B/ebqu+fSQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=job-script

#!/bin/sh

export_top_env()
{
	export suite='fio-basic'
	export testcase='fio-basic'
	export category='benchmark'
	export runtime=200
	export nr_task=28
	export time_based='tb'
	export job_origin='/lkp/lkp/.src-20161104-174523/allot/cyclic:linux-devel:devel-hourly/lkp-hsw-ep6/fio-basic-2pmem-256G.yaml'
	export queue='bisect'
	export testbox='lkp-hsw-ep6'
	export tbox_group='lkp-hsw-ep6'
	export submit_id='581ef5360b9a93d7a17daf23'
	export job_file='/lkp/scheduled/lkp-hsw-ep6/fio-basic-2pmem-ext4-200s-50%-tb-randwrite-4k-libaio-200G-performance-debian-x86_64-2016-08-31.cgz-adad5aa544e281d84f837b2786809611cb35a999-20161106-120737-15szmnn-0.yaml'
	export id='cfe63e1c069609dae21c6bbea8e11ec27e8e270d'
	export model='Haswell-EP'
	export nr_cpu=56
	export memory='256G'
	export ssd_partitions=
	export swap_partitions=
	export rootfs_partition=
	export brand='Intel(R) Xeon(R) CPU E5-2695 v3 @ 2.30GHz'
	export need_kconfig='CONFIG_LIBNVDIMM
CONFIG_BTT
CONFIG_BLK_DEV_PMEM
CONFIG_X86_PMEM_LEGACY
CONFIG_EXT4_FS'
	export commit='adad5aa544e281d84f837b2786809611cb35a999'
	export kconfig='x86_64-rhel-7.2'
	export compiler='gcc-6'
	export rootfs='debian-x86_64-2016-08-31.cgz'
	export enqueue_time='2016-11-06 17:17:43 +0800'
	export _id='581ef5360b9a93d7a17daf23'
	export user='lkp'
	export head_commit='843cc18ce2cbbbac78f53891f9cd739aefd8ba36'
	export base_commit='a909d3e636995ba7c349e2ca5dbb528154d4ac30'
	export branch='linux-devel/devel-hourly-2016110602'
	export result_root='/result/fio-basic/2pmem-ext4-200s-50%-tb-randwrite-4k-libaio-200G-performance/lkp-hsw-ep6/debian-x86_64-2016-08-31.cgz/x86_64-rhel-7.2/gcc-6/adad5aa544e281d84f837b2786809611cb35a999/0'
	export LKP_SERVER='inn'
	export max_uptime=1200
	export initrd='/osimage/debian/debian-x86_64-2016-08-31.cgz'
	export bootloader_append='root=/dev/ram0
user=lkp
job=/lkp/scheduled/lkp-hsw-ep6/fio-basic-2pmem-ext4-200s-50%-tb-randwrite-4k-libaio-200G-performance-debian-x86_64-2016-08-31.cgz-adad5aa544e281d84f837b2786809611cb35a999-20161106-120737-15szmnn-0.yaml
ARCH=x86_64
kconfig=x86_64-rhel-7.2
branch=linux-devel/devel-hourly-2016110602
commit=adad5aa544e281d84f837b2786809611cb35a999
BOOT_IMAGE=/pkg/linux/x86_64-rhel-7.2/gcc-6/adad5aa544e281d84f837b2786809611cb35a999/vmlinuz-4.9.0-rc3-00264-gadad5aa
memmap=104G!4G
memmap=104G!132G
max_uptime=1200
RESULT_ROOT=/result/fio-basic/2pmem-ext4-200s-50%-tb-randwrite-4k-libaio-200G-performance/lkp-hsw-ep6/debian-x86_64-2016-08-31.cgz/x86_64-rhel-7.2/gcc-6/adad5aa544e281d84f837b2786809611cb35a999/0
LKP_SERVER=inn
debug
apic=debug
sysrq_always_enabled
rcupdate.rcu_cpu_stall_timeout=100
net.ifnames=0
printk.devkmsg=on
panic=-1
softlockup_panic=1
nmi_watchdog=panic
oops=panic
load_ramdisk=2
prompt_ramdisk=0
systemd.log_level=err
ignore_loglevel
earlyprintk=ttyS0,115200
console=ttyS0,115200
console=tty0
vga=normal
rw'
	export lkp_initrd='/lkp/lkp/lkp-x86_64.cgz'
	export modules_initrd='/pkg/linux/x86_64-rhel-7.2/gcc-6/adad5aa544e281d84f837b2786809611cb35a999/modules.cgz'
	export bm_initrd='/osimage/deps/debian-x86_64-2016-08-31.cgz/lkp_2016-11-02.cgz,/osimage/deps/debian-x86_64-2016-08-31.cgz/rsync-rootfs_2016-09-02.cgz,/osimage/deps/debian-x86_64-2016-08-31.cgz/run-ipconfig_2016-09-02.cgz,/osimage/deps/debian-x86_64-2016-08-31.cgz/fs_2016-11-02.cgz,/osimage/deps/debian-x86_64-2016-08-31.cgz/fio_2016-11-02.cgz,/osimage/deps/debian-x86_64-2016-08-31.cgz/iostat_2016-11-02.cgz,/osimage/deps/debian-x86_64-2016-08-31.cgz/turbostat_2016-09-02.cgz,/osimage/pkg/debian-x86_64-2016-08-31.cgz/turbostat-x86_64_2016-09-02.cgz,/osimage/deps/debian-x86_64-2016-08-31.cgz/perf_2016-11-02.cgz,/osimage/pkg/debian-x86_64-2016-08-31.cgz/perf-x86_64.cgz,/osimage/deps/debian-x86_64-2016-08-31.cgz/hw_2016-11-02.cgz'
	export site='inn'
	export LKP_CGI_PORT=80
	export LKP_CIFS_PORT=139
	export repeat_to=2
	export kernel='/pkg/linux/x86_64-rhel-7.2/gcc-6/adad5aa544e281d84f837b2786809611cb35a999/vmlinuz-4.9.0-rc3-00264-gadad5aa'
	export dequeue_time='2016-11-06 17:23:27 +0800'
	export job_initrd='/lkp/scheduled/lkp-hsw-ep6/fio-basic-2pmem-ext4-200s-50%-tb-randwrite-4k-libaio-200G-performance-debian-x86_64-2016-08-31.cgz-adad5aa544e281d84f837b2786809611cb35a999-20161106-120737-15szmnn-0.cgz'

	[ -n "$LKP_SRC" ] ||
	export LKP_SRC=/lkp/${user:-lkp}/src
}

run_job()
{
	echo $$ > $TMP/run-job.pid

	. $LKP_SRC/lib/http.sh
	. $LKP_SRC/lib/job.sh
	. $LKP_SRC/lib/env.sh

	export_top_env

	run_setup bp1_memmap='104G!4G' bp2_memmap='104G!132G' $LKP_SRC/setup/boot_params

	run_setup nr_pmem=2 $LKP_SRC/setup/disk

	run_setup fs='ext4' $LKP_SRC/setup/fs

	run_setup rw='randwrite' bs='4k' ioengine='libaio' test_size='200G' $LKP_SRC/setup/fio-setup-basic

	run_setup $LKP_SRC/setup/cpufreq_governor 'performance'

	run_monitor $LKP_SRC/monitors/wrapper kmsg
	run_monitor $LKP_SRC/monitors/wrapper iostat
	run_monitor $LKP_SRC/monitors/wrapper heartbeat
	run_monitor $LKP_SRC/monitors/wrapper vmstat
	run_monitor $LKP_SRC/monitors/wrapper numa-numastat
	run_monitor $LKP_SRC/monitors/wrapper numa-vmstat
	run_monitor $LKP_SRC/monitors/wrapper numa-meminfo
	run_monitor $LKP_SRC/monitors/wrapper proc-vmstat
	run_monitor $LKP_SRC/monitors/wrapper proc-stat
	run_monitor $LKP_SRC/monitors/wrapper meminfo
	run_monitor $LKP_SRC/monitors/wrapper slabinfo
	run_monitor $LKP_SRC/monitors/wrapper interrupts
	run_monitor $LKP_SRC/monitors/wrapper lock_stat
	run_monitor $LKP_SRC/monitors/wrapper latency_stats
	run_monitor $LKP_SRC/monitors/wrapper softirqs
	run_monitor $LKP_SRC/monitors/one-shot/wrapper bdi_dev_mapping
	run_monitor $LKP_SRC/monitors/wrapper diskstats
	run_monitor $LKP_SRC/monitors/wrapper nfsstat
	run_monitor $LKP_SRC/monitors/wrapper cpuidle
	run_monitor $LKP_SRC/monitors/wrapper cpufreq-stats
	run_monitor $LKP_SRC/monitors/wrapper turbostat
	run_monitor $LKP_SRC/monitors/wrapper sched_debug
	run_monitor $LKP_SRC/monitors/wrapper perf-stat
	run_monitor $LKP_SRC/monitors/no-stdout/wrapper perf-profile
	run_monitor $LKP_SRC/monitors/wrapper oom-killer
	run_monitor $LKP_SRC/monitors/plain/watchdog
	run_monitor $LKP_SRC/monitors/wrapper nfs-hang

	run_test $LKP_SRC/tests/wrapper fio
}

extract_stats()
{
	$LKP_SRC/stats/wrapper fio
	$LKP_SRC/stats/wrapper kmsg
	$LKP_SRC/stats/wrapper iostat
	$LKP_SRC/stats/wrapper vmstat
	$LKP_SRC/stats/wrapper numa-numastat
	$LKP_SRC/stats/wrapper numa-vmstat
	$LKP_SRC/stats/wrapper numa-meminfo
	$LKP_SRC/stats/wrapper proc-vmstat
	$LKP_SRC/stats/wrapper meminfo
	$LKP_SRC/stats/wrapper slabinfo
	$LKP_SRC/stats/wrapper interrupts
	$LKP_SRC/stats/wrapper lock_stat
	$LKP_SRC/stats/wrapper latency_stats
	$LKP_SRC/stats/wrapper softirqs
	$LKP_SRC/stats/wrapper diskstats
	$LKP_SRC/stats/wrapper nfsstat
	$LKP_SRC/stats/wrapper cpuidle
	$LKP_SRC/stats/wrapper turbostat
	$LKP_SRC/stats/wrapper sched_debug
	$LKP_SRC/stats/wrapper perf-stat
	$LKP_SRC/stats/wrapper perf-profile

	$LKP_SRC/stats/wrapper time fio.time
	$LKP_SRC/stats/wrapper time
	$LKP_SRC/stats/wrapper dmesg
	$LKP_SRC/stats/wrapper kmsg
	$LKP_SRC/stats/wrapper stderr
	$LKP_SRC/stats/wrapper last_state
}

"$@"

--3uo+9/B/ebqu+fSQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="job.yaml"

---

#! jobs/fio-basic-2pmem-256G.yaml
suite: fio-basic
testcase: fio-basic
category: benchmark
boot_params:
  bp1_memmap: 104G!4G
  bp2_memmap: 104G!132G
disk: 2pmem
fs: ext4
runtime: 200s
nr_task: 50%
time_based: tb
fio-setup-basic:
  rw: randwrite
  bs: 4k
  ioengine: libaio
  test_size: 200G
fio: 
job_origin: "/lkp/lkp/.src-20161104-174523/allot/cyclic:linux-devel:devel-hourly/lkp-hsw-ep6/fio-basic-2pmem-256G.yaml"

#! queue options
queue: bisect
testbox: lkp-hsw-ep6
tbox_group: lkp-hsw-ep6
submit_id: 581ef5360b9a93d7a17daf23
job_file: "/lkp/scheduled/lkp-hsw-ep6/fio-basic-2pmem-ext4-200s-50%-tb-randwrite-4k-libaio-200G-performance-debian-x86_64-2016-08-31.cgz-adad5aa544e281d84f837b2786809611cb35a999-20161106-120737-15szmnn-0.yaml"
id: cfe63e1c069609dae21c6bbea8e11ec27e8e270d

#! hosts/lkp-hsw-ep6
model: Haswell-EP
nr_cpu: 56
memory: 256G
ssd_partitions: 
swap_partitions: 
rootfs_partition: 
brand: Intel(R) Xeon(R) CPU E5-2695 v3 @ 2.30GHz

#! include/category/benchmark
kmsg: 
iostat: 
heartbeat: 
vmstat: 
numa-numastat: 
numa-vmstat: 
numa-meminfo: 
proc-vmstat: 
proc-stat: 
meminfo: 
slabinfo: 
interrupts: 
lock_stat: 
latency_stats: 
softirqs: 
bdi_dev_mapping: 
diskstats: 
nfsstat: 
cpuidle: 
cpufreq-stats: 
turbostat: 
sched_debug: 
perf-stat: 
perf-profile: 

#! include/category/ALL
cpufreq_governor: performance

#! include/disk/nr_pmem
need_kconfig:
- CONFIG_LIBNVDIMM
- CONFIG_BTT
- CONFIG_BLK_DEV_PMEM
- CONFIG_X86_PMEM_LEGACY
- CONFIG_EXT4_FS

#! include/queue/cyclic
commit: adad5aa544e281d84f837b2786809611cb35a999

#! include/fs/OTHERS

#! default params
kconfig: x86_64-rhel-7.2
compiler: gcc-6
rootfs: debian-x86_64-2016-08-31.cgz
enqueue_time: 2016-11-06 17:17:43.156009489 +08:00
_id: 581ef5360b9a93d7a17daf23

#! schedule options
user: lkp
head_commit: 843cc18ce2cbbbac78f53891f9cd739aefd8ba36
base_commit: a909d3e636995ba7c349e2ca5dbb528154d4ac30
branch: linux-devel/devel-hourly-2016110602
result_root: "/result/fio-basic/2pmem-ext4-200s-50%-tb-randwrite-4k-libaio-200G-performance/lkp-hsw-ep6/debian-x86_64-2016-08-31.cgz/x86_64-rhel-7.2/gcc-6/adad5aa544e281d84f837b2786809611cb35a999/0"
LKP_SERVER: inn
max_uptime: 1200
initrd: "/osimage/debian/debian-x86_64-2016-08-31.cgz"
bootloader_append:
- root=/dev/ram0
- user=lkp
- job=/lkp/scheduled/lkp-hsw-ep6/fio-basic-2pmem-ext4-200s-50%-tb-randwrite-4k-libaio-200G-performance-debian-x86_64-2016-08-31.cgz-adad5aa544e281d84f837b2786809611cb35a999-20161106-120737-15szmnn-0.yaml
- ARCH=x86_64
- kconfig=x86_64-rhel-7.2
- branch=linux-devel/devel-hourly-2016110602
- commit=adad5aa544e281d84f837b2786809611cb35a999
- BOOT_IMAGE=/pkg/linux/x86_64-rhel-7.2/gcc-6/adad5aa544e281d84f837b2786809611cb35a999/vmlinuz-4.9.0-rc3-00264-gadad5aa
- memmap=104G!4G
- memmap=104G!132G
- max_uptime=1200
- RESULT_ROOT=/result/fio-basic/2pmem-ext4-200s-50%-tb-randwrite-4k-libaio-200G-performance/lkp-hsw-ep6/debian-x86_64-2016-08-31.cgz/x86_64-rhel-7.2/gcc-6/adad5aa544e281d84f837b2786809611cb35a999/0
- LKP_SERVER=inn
- debug
- apic=debug
- sysrq_always_enabled
- rcupdate.rcu_cpu_stall_timeout=100
- net.ifnames=0
- printk.devkmsg=on
- panic=-1
- softlockup_panic=1
- nmi_watchdog=panic
- oops=panic
- load_ramdisk=2
- prompt_ramdisk=0
- systemd.log_level=err
- ignore_loglevel
- earlyprintk=ttyS0,115200
- console=ttyS0,115200
- console=tty0
- vga=normal
- rw
lkp_initrd: "/lkp/lkp/lkp-x86_64.cgz"
modules_initrd: "/pkg/linux/x86_64-rhel-7.2/gcc-6/adad5aa544e281d84f837b2786809611cb35a999/modules.cgz"
bm_initrd: "/osimage/deps/debian-x86_64-2016-08-31.cgz/lkp_2016-11-02.cgz,/osimage/deps/debian-x86_64-2016-08-31.cgz/rsync-rootfs_2016-09-02.cgz,/osimage/deps/debian-x86_64-2016-08-31.cgz/run-ipconfig_2016-09-02.cgz,/osimage/deps/debian-x86_64-2016-08-31.cgz/fs_2016-11-02.cgz,/osimage/deps/debian-x86_64-2016-08-31.cgz/fio_2016-11-02.cgz,/osimage/deps/debian-x86_64-2016-08-31.cgz/iostat_2016-11-02.cgz,/osimage/deps/debian-x86_64-2016-08-31.cgz/turbostat_2016-09-02.cgz,/osimage/pkg/debian-x86_64-2016-08-31.cgz/turbostat-x86_64_2016-09-02.cgz,/osimage/deps/debian-x86_64-2016-08-31.cgz/perf_2016-11-02.cgz,/osimage/pkg/debian-x86_64-2016-08-31.cgz/perf-x86_64.cgz,/osimage/deps/debian-x86_64-2016-08-31.cgz/hw_2016-11-02.cgz"
site: inn

#! /lkp/lkp/.src-20161104-174523/include/site/inn
LKP_CGI_PORT: 80
LKP_CIFS_PORT: 139
oom-killer: 
watchdog: 
nfs-hang: 

#! runtime status
repeat_to: 2

#! user overrides
kernel: "/pkg/linux/x86_64-rhel-7.2/gcc-6/adad5aa544e281d84f837b2786809611cb35a999/vmlinuz-4.9.0-rc3-00264-gadad5aa"
dequeue_time: 2016-11-06 17:23:27.087849058 +08:00
job_state: finished
loadavg: '25.64'

--3uo+9/B/ebqu+fSQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=reproduce

modprobe nd_e820
dmsetup remove_all
wipefs -a --force /dev/pmem0
wipefs -a --force /dev/pmem1
mkfs -t ext4 -q -F /dev/pmem0
mkfs -t ext4 -q -F /dev/pmem1
mkdir -p /fs/pmem0
mount -t ext4 /dev/pmem0 /fs/pmem0
mkdir -p /fs/pmem1
mount -t ext4 /dev/pmem1 /fs/pmem1

for file in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
do
	echo performance > $file
done

echo '
[global]
bs=4k
ioengine=libaio
iodepth=32
size=7669584457
direct=0
runtime=200
invalidate=1
fallocate=posix
group_reporting

time_based

[task_0]
rw=randwrite
directory=/fs/pmem0
numjobs=14

[task_1]
rw=randwrite
directory=/fs/pmem1
numjobs=14' | fio --output-format=json -

--3uo+9/B/ebqu+fSQ
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
Developer Access Program for Intel Xeon Phi Processors
Access to Intel Xeon Phi processor-based developer platforms.
With one year of Intel Parallel Studio XE.
Training and support from Colfax.
Order your platform today. http://sdm.link/xeonphi
--3uo+9/B/ebqu+fSQ
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Linux-NTFS-Dev mailing list
Linux-NTFS-Dev@lists.sourceforge.net
https://lists.sourceforge.net/lists/listinfo/linux-ntfs-dev

--3uo+9/B/ebqu+fSQ--
