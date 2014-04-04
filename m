From: Daniel J Blueman <daniel@numascale.com>
Subject: ext4 performance falloff
Date: Sat, 05 Apr 2014 01:00:55 +0800
Message-ID: <533EE547.3030504@numascale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Steffen Persvold <sp@numascale.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>
To: linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On a larger system 1728 cores/4.5TB memory and 3.13.9, I'm seeing very 
low 600KB/s cached write performance to a local ext4 filesystem:

# mkfs.ext4 /dev/sda5
# mount /dev/sda5 /mnt
# dd if=/dev/zero of=/mnt/test bs=1M count=10
10+0 records in
10+0 records out
10485760 bytes (10 MB) copied, 17.4307 s, 602 kB/s

Whereas eg on XFS, performance is much more reasonable:

# mkfs.xfs /dev/sda5
# mount /dev/sda5 /mnt
# dd if=/dev/zero of=/mnt/test bs=1M count=100
100+0 records in
100+0 records out
104857600 bytes (105 MB) copied, 2.39329 s, 43.8 MB/s

Perf shows the time spent in bitmask iteration:

     98.77%       dd  [kernel.kallsyms]  [k] find_next_bit 

                  |
                  --- find_next_bit
                     |
                     |--99.92%-- __percpu_counter_sum
                     |          ext4_has_free_clusters
                     |          ext4_claim_free_clusters
                     |          ext4_mb_new_blocks
                     |          ext4_ext_map_blocks
                     |          ext4_map_blocks
                     |          _ext4_get_block
                     |          ext4_get_block
                     |          __block_write_begin
                     |          ext4_write_begin
                     |          ext4_da_write_begin
                     |          generic_file_buffered_write
                     |          __generic_file_aio_write
                     |          generic_file_aio_write
                     |          ext4_file_write
                     |          do_sync_write
                     |          vfs_write
                     |          sys_write
                     |          system_call_fastpath
                     |          __write_nocancel
                     |          0x0
                      --0.08%-- [...]

Analysis shows that ext4 is reading from all cores' cpu-local data (thus 
expensive off-NUMA-node access) for each block written:

if (free_clusters - (nclusters + rsv + dirty_clusters) <
				EXT4_FREECLUSTERS_WATERMARK) {
	free_clusters  = percpu_counter_sum_positive(fcc);
	dirty_clusters = percpu_counter_sum_positive(dcc);
}

This threshold is defined as:

#define EXT4_FREECLUSTERS_WATERMARK (4 * (percpu_counter_batch * 
nr_cpu_ids))

I can see why this may get overlooked for systems with commensurate 
local storage, but some filesystems reasonably don't need to scale with 
core count. The filesystem I'm testing on and the rootfs (as it has 
/tmp) are 50GB.

There must be a good rationale for this being dependent on the number of 
cores rather than just the ratio of used space, right?

Thanks,
   Daniel
-- 
Daniel J Blueman
Principal Software Engineer, Numascale
