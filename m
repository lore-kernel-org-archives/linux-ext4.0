From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: Quadrant write performance degradation - kernel3.10 vs
 kernel3.4
Date: Tue, 17 Jun 2014 09:52:46 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1406170949020.2148@localhost.localdomain>
References: <539E8860.3010602@codeaurora.org> <20140616192009.GD9743@birch.djwong.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1759557363-1402991570=:2148"
Cc: Tanya Brokhman <tlinder@codeaurora.org>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	kdorfman@codeaurora.org, merez@codeaurora.org,
	Dolev Raviv <draviv@codeaurora.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10823 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752550AbaFQHw4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Jun 2014 03:52:56 -0400
In-Reply-To: <20140616192009.GD9743@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1759557363-1402991570=:2148
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Mon, 16 Jun 2014, Darrick J. Wong wrote:

> Date: Mon, 16 Jun 2014 12:20:09 -0700
> From: Darrick J. Wong <darrick.wong@oracle.com>
> To: Tanya Brokhman <tlinder@codeaurora.org>
> Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
>     kdorfman@codeaurora.org, merez@codeaurora.org,
>     Dolev Raviv <draviv@codeaurora.org>
> Subject: Re: Quadrant write performance degradation - kernel3.10 vs kernel3.4
> 
> On Mon, Jun 16, 2014 at 09:02:08AM +0300, Tanya Brokhman wrote:
> > Hello,
> > Recently we encountered a performance degradation on 3.10kernel
> > based build, compared to 3.4 based one, when running the fs_write
> > Quadrant benchmark.
> > We profiled the test and came to the conclusion that the root cause
> > of the degradation is in the vfs_write call stack (overhead of
> > 2611.2us is observed in 3.10 kernel compared to 3.4):
> > 
> > ret_fast_syscall
> > SyS_write
> > vfs_write (total time spent: 3.10kernel-21295us, 3.4kernel-18683.79us)
> > do_sync_write
> > ext4_file_write
> > generic_file_aio_write (total time spent: 3.10kernel-19124.4us,
> > 3.4kernel-16815us)
> > __generic_file_aio_write
> > generic_file_buffered_write
> > ext4_da_write_begin (total time spent: 3.10kernel-10935.2us,
> > 3.4kernel-8444.6us)
> > __block_write_begin
> > ext4_da_get_block_prep (total time spent: 3.10kernel-5402.6us,
> > 3.4kernel-3576.8us)
> > ext4_es_lookup_extent  (total time spent: 3.10kernel-2219.7us,
> > 3.4kernel-0us)
> > 
> > 
> > We tried to revert just the ext4 code back to 3.4 (on a 3.10 kernel)
> > build and got an improvement of 50% in the test result.
> > When looking deeper into the changes made to the ext4 FS between 3.4
> > and 3.10 versions we stumbled across two major features making an
> > explicit tradeoff in favor of robustness and good design over
> > performance in some use cases:
> > 
> > 1) Metadata Checksums http://kernelnewbies.org/Linux_3.5#head-e8ea0d70436ea63590eac3dc25a7b417333147f8
> > “As far as performance impact goes, it shouldn't be noticeable for
> > common desktop and server workloads. A mail server ffsb simulation
> > show nearly no change. On a test doing only file creation and
> > deletion and extent tree modifications, a performance drop of about
> > 20 percent was measured. However, it's a workload very heavily
> > oriented towards metadata, in most real-world workloads metadata is
> > usually a small fraction of total IO, so unless your workload is
> > metadata-oriented, the cost of enabling this feature should be
> > negligible.”
> 
> Dumb question, but do you have metadata_csum enabled?  That would be a little
> surprising, since (afaik) the only way you can turn it on is via unreleased
> e2fsprogs-1.43.
> 
> (Otoh if you /do/ have it enabled and it's slowing you down, I'd like to hear
> about it. ;))
> 
> > 2) Extents status tracking: https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/tree/fs/ext4/extents_status.c?id=refs/tags/v3.10.42#n20
> > “There is a cache extent for write access, so if writes are not very
> > random, adding space operations are in O(1) time.”
> 
> I'm no expert on the extent status cache, but this seems like a possible cause.

Exactly, there has been some fixes since the introduction of extent
status tree, however I've noticed some performance going down as
well and I believe that extent status tree is to blame.

AFAIK you can not turn it off in any way, but there might be some
way to test it's overhead. Zheng, do you have any suggestions ?

Thanks!
-Lukas

> 
> --D
> > 
> > We tried pick up several performance-enhancement patches from the
> > community, released between 3.10 and 3.14 kernel versions. The
> > performance was almost the same.
> > 
> > I was wondering what performance tests were performed on these
> > features? Has anyone encountered same issue?
> > 
> > Best Regards
> > Tanya Brokhman
> > -- 
> > QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
> > of Code Aurora Forum, hosted by The Linux Foundation
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--8323328-1759557363-1402991570=:2148--
