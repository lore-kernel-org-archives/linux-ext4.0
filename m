From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: problem(?) in ext4 or mke2fs
Date: Sun, 03 Apr 2011 11:40:52 -0700
Message-ID: <4D98BF34.6040503@redhat.com>
References: <BANLkTi=gE-utOo479RU8qcWM99NpBrFmvQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Zeev Tarantov <zeev.tarantov@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43047 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753001Ab1DCSkl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 3 Apr 2011 14:40:41 -0400
In-Reply-To: <BANLkTi=gE-utOo479RU8qcWM99NpBrFmvQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 4/3/11 11:07 AM, Zeev Tarantov wrote:
> While testing zram I ran a script that creates a block devices,
> creates a filesystem on in and untars Qt on that filesystem.
> I was surprised to find ext4_mb_scan_aligned near the top of the profile output.
> This was evidently because the command "mke2fs -t ext4 -m 0 -I 128 -O
> ^has_journal,^ext_attr <block device>"
>  created a filesystem with (output of tune2fs):
> RAID stride:              1
> RAID stripe width:        1

mke2fs queries the block device for its geometry, based on what is
reported via sysfs:

/*
 * Sets the geometry of a device (stripe/stride), and returns the
 * device's alignment offset, if any, or a negative error.
 */
static int get_device_geometry( ...
...
        min_io = blkid_topology_get_minimum_io_size(tp);
        opt_io = blkid_topology_get_optimal_io_size(tp);
...

        fs_param->s_raid_stride = min_io / blocksize;
        fs_param->s_raid_stripe_width = opt_io / blocksize;

What does 

# blockdev --getiomin --getioopt /dev/<yourdevice>

say for your device?

The device may be reporting odd values, but mke2fs probably
should be smart enough not to set block-sized stripe unit and width...

-Eric



> I thought this strange and removed these values using debugfs:
> set_super_value raid_stride 0
> set_super_value raid_stripe_width 0
> 
> With this "fix" the symbol ext4_mb_scan_aligned disappeared from perf's output:
> 
>     18.98%     -3.66%  gzip                            [.] zip
>      0.00%    +14.84%  [kernel.kallsyms]               [k] ext4_mb_scan_aligned
>     17.91%     -3.44%  gzip                            [.]
> treat_file.part.4.2264
>     13.73%     -2.47%  [csnappy_compress]              [k]
> snappy_compress_fragment
>      3.96%     -0.77%  [kernel.kallsyms]               [k]
> copy_user_generic_string
>      3.05%     -0.41%  libc-2.13.so                    [.] __memcpy_ssse3
>      0.89%     +1.49%  [kernel.kallsyms]               [k] _raw_spin_lock
>      2.63%     -0.49%  [kernel.kallsyms]               [k] __memcpy
>      1.61%     -0.17%  [kernel.kallsyms]               [k] __memset
>      0.78%     -0.11%  [kernel.kallsyms]               [k] ext4_mark_iloc_dirty
>      0.63%     -0.11%  [kernel.kallsyms]               [k] system_call
>      0.66%     -0.14%  gzip                            [.] treat_stdin.2262
>      0.58%     -0.12%  libc-2.13.so                    [.] _int_malloc
> 
> This is using mke2fs 1.41.14 (22-Dec-2010) on Linux 2.6.38.2.
> 
> Is this expected behavior? Do you need me to provide more information?
> 
> regards,
> -Z.T.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

