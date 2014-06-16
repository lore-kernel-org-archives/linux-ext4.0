From: Tanya Brokhman <tlinder@codeaurora.org>
Subject: Quadrant write performance degradation - kernel3.10 vs kernel3.4
Date: Mon, 16 Jun 2014 09:02:08 +0300
Message-ID: <539E8860.3010602@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: kdorfman@codeaurora.org, merez@codeaurora.org,
	Dolev Raviv <draviv@codeaurora.org>, tlinder@codeaurora.org
To: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello,
Recently we encountered a performance degradation on 3.10kernel based=20
build, compared to 3.4 based one, when running the fs_write Quadrant=20
benchmark.
We profiled the test and came to the conclusion that the root cause of=20
the degradation is in the vfs_write call stack (overhead of 2611.2us is=
=20
observed in 3.10 kernel compared to 3.4):

ret_fast_syscall
SyS_write
vfs_write (total time spent: 3.10kernel-21295us, 3.4kernel-18683.79us)
do_sync_write
ext4_file_write
generic_file_aio_write (total time spent: 3.10kernel-19124.4us,=20
3.4kernel-16815us)
__generic_file_aio_write
generic_file_buffered_write
ext4_da_write_begin (total time spent: 3.10kernel-10935.2us,=20
3.4kernel-8444.6us)
__block_write_begin
ext4_da_get_block_prep (total time spent: 3.10kernel-5402.6us,=20
3.4kernel-3576.8us)
ext4_es_lookup_extent  (total time spent: 3.10kernel-2219.7us,=20
3.4kernel-0us)


We tried to revert just the ext4 code back to 3.4 (on a 3.10 kernel)=20
build and got an improvement of 50% in the test result.
When looking deeper into the changes made to the ext4 FS between 3.4 an=
d=20
3.10 versions we stumbled across two major features making an explicit=20
tradeoff in favor of robustness and good design over performance in som=
e=20
use cases:

1) Metadata Checksums=20
http://kernelnewbies.org/Linux_3.5#head-e8ea0d70436ea63590eac3dc25a7b41=
7333147f8
=93As far as performance impact goes, it shouldn't be noticeable for=20
common desktop and server workloads. A mail server ffsb simulation show=
=20
nearly no change. On a test doing only file creation and deletion and=20
extent tree modifications, a performance drop of about 20 percent was=20
measured. However, it's a workload very heavily oriented towards=20
metadata, in most real-world workloads metadata is usually a small=20
fraction of total IO, so unless your workload is metadata-oriented, the=
=20
cost of enabling this feature should be negligible.=94

2) Extents status tracking:=20
https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/tr=
ee/fs/ext4/extents_status.c?id=3Drefs/tags/v3.10.42#n20
=93There is a cache extent for write access, so if writes are not very=20
random, adding space operations are in O(1) time.=94

We tried pick up several performance-enhancement patches from the=20
community, released between 3.10 and 3.14 kernel versions. The=20
performance was almost the same.

I was wondering what performance tests were performed on these features=
?=20
Has anyone encountered same issue?

Best Regards
Tanya Brokhman
--=20
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a mem=
ber
of Code Aurora Forum, hosted by The Linux Foundation
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
