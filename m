Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2D813A75A8;
	Mon,  3 Aug 2026 19:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785786561; cv=none; b=bRi4TZ61MpO8VqNtY6RwfUPRozvKDzD4h34SQ202ssDCpT6jxz7CvohbqXZVQFQ0JcLhHGdDpREtrr844zojQt7qIifQT7OziO7Qw8mZxbmdaExhRg6pi0HZDzuKNzi+FwkNrjqNpJF8ImPsQ0sc2OEBznPvyhpV0kuBZBj900M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785786561; c=relaxed/simple;
	bh=g4vNJ2wZSkVyjJP8TMxAGxz4toJ5n2P8twvobtwTZgo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bDmniXWu1+CgVA6HpbOew7wRa34NMJKHGtqyDKISkCOVylrU6URHztL5ydxIjpX4HewfjHKLyB+8D7gmYhE910UdGcqdGiV/EpsMlCGIduGUsmAMNlhDMH4LOOxJDxw5VfvN5Z7yITSDwjiZq6L/JxpAUEpYq5Q1k0BfaXgbiYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=p5/baSqx; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="p5/baSqx"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 673JlhsP1125402;
	Mon, 3 Aug 2026 19:49:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=pTN2Ea
	jAAJZyHuvcSLGVh+dparz03GcVK7ScN6NkYQk=; b=p5/baSqxyMbJiL/fyMiaKa
	D3/TyFOiDeaxv1qI56WJix7Fm4GozzZQN54Fni1gKktGb6RYmtOZZ9884MrPoLeG
	rHALSOmGD5T6Gnj+N2NHGY5+lmET0jnnyhmQFS4yrHhrQCfpuvrVhE2VcdTpTmmO
	kVB6khbNq093DN6JYJOv6aqjDHq6DMnNNSGA/1UAndhFj4QF6Vrce+/tc2lfUIGu
	spEqcCkId+Ad+l/CHYrNNfx052HP4Yc0IzpZXZoqgEjdT/A0a+kCdxZg785J/a+e
	+wUVNb8/91VkC1ad0I5FsCcNJ/DoUdn7DeDQLqMopHGsHTEj2mgKJeZZ88Nf2bXw
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fs8fqjh8m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Aug 2026 19:49:02 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 673JfI4h017714;
	Mon, 3 Aug 2026 19:49:00 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fsvmh6vcm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Aug 2026 19:49:00 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 673Jmuhg49545548
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 3 Aug 2026 19:48:56 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1584620043;
	Mon,  3 Aug 2026 19:48:56 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AC4E220040;
	Mon,  3 Aug 2026 19:48:52 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.124.213.195])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon,  3 Aug 2026 19:48:52 +0000 (GMT)
Date: Tue, 4 Aug 2026 01:18:49 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>
Subject: Re: [BUG] ext4: NULL/invalid pointer dereference in
 ext4_writepages() during generic/039
Message-ID: <anDwoVwYf8EBCm6-@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <9ac0524e-0644-4fba-a256-c5b7fe333a3e@linux.ibm.com>
 <anA6s9L-cpsifqgU@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <anA6s9L-cpsifqgU@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: YNkyaLVHA1ra8K_sXEI2R0PUBqj0mge1
X-Proofpoint-ORIG-GUID: YNkyaLVHA1ra8K_sXEI2R0PUBqj0mge1
X-Proofpoint-Spam-Info: AW1haW4tMjYwODAzMDE3NSBTYWx0ZWRfX/nAmQdkbELTL
 Z0e75kr/tXclUs/91RbGWL8b0Q6Had8dDPmz4GAXSJQ3oB3n26Qfm5yHJMYcZSfU12BecZaxD7+
 OY0kuhWQIPgmxHRNP4p4A99xUxsW7Ts=
X-Authority-Analysis: v=2.4 cv=K8cS2SWI c=1 sm=1 tr=0 ts=6a70f0ae cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=8nJEP1OIZ-IA:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=PuqN6qLYsbgiXAgkHtkA:9 a=3ZKOabzyN94A:10 a=wPNLvfGTeEIA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODAzMDE3NSBTYWx0ZWRfX9zs+p/A4GEFd
 lm/QFEY4vdkj7ixUNCfZybhH7cot1E+3Cga/8YHR2t4VlLvKFs4PnZMlgb9o5J5NAVhq6HLeA+4
 CDSpQstpihVXqEUw0A19Kqmp8L/vVSz/GmurVzQxsQ3feH4r+5Yv8KGD5ry2XzqZqOIViuUGEIq
 HeJoIA1lUSySDg0sWzZJTSiLlCNw59ymUjdGzj2KFXCMc+1dUUjEniyYjCaQb9spIdXXuwYxZIw
 D3qp1eC+B5HgMAQItPi6HMQMv/PzXR2HKaWACPpLS5eo5ZTdO9gvP0VJC6cC5GdB1k8QmvWR6l5
 AeKqmVXp1Gj+VWumVZ62dqn3sVN+yeIq4juUDy7aW8FHJxUgD6WfcCTgWNis0Qs5cSkrY9oerrn
 XqbX7GzpOVTk3N8pXvDtYVmsuUszgEmTnAurBFCcroiKw07jcz0GFiKS1+OVLY9s/dpetWu78YI
 pfyU1WSkJdtFikCe60Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-03_05,2026-08-03_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 impostorscore=0 bulkscore=0 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 phishscore=0 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608030175

On Mon, Aug 03, 2026 at 12:22:35PM +0530, Ojaswin Mujoo wrote:
> On Mon, Aug 03, 2026 at 10:17:35AM +0530, Venkat Rao Bagalkote wrote:
> > Hi,
> > 
> > I am  seeing a reproducible kernel crash while running xfstests generic/039
> > on powerpc.
> > 
> > The crash happens during ext4 journal recovery while mounting the
> > filesystem. The fault occurs inside ext4_writepages() and appears to
> > dereference a userspace-looking address.
> > 
> > Test environment
> > ----------------
> > Kernel:
> >   7.2.0-rc5-next-20260731
> > 
> > Architecture:
> >   powerpc64le
> > 
> > Platform:
> >   IBM Power9 (pSeries)
> > 
> > Machine:
> >   IBM,8375-42A
> >   FW950.80 (VL950_131)
> > 
> > Config highlights:
> >   PAGE_SIZE=64K
> >   MMU=Hash
> >   PREEMPTLAZY=y
> > 
> > Workload
> > --------
> > xfstests generic/039
> > 
> > Log excerpt:
> >   run fstests generic/039 at 2026-08-03 00:22:44
> > 
> > Crash
> > -----
> > [  615.063689] Kernel attempted to read user page (fe73f0000) - exploit
> > attempt? (uid: 0)
> > [  615.063714] BUG: Unable to handle kernel data access on read at
> > 0xfe73f0000
> > [  615.063723] Faulting instruction address: 0xc008000015b0ed24
> > [  615.063731] Oops: Kernel access of bad area, sig: 11 [#1]
> > 
> > The faulting instruction is:
> > 
> >   ext4_writepages+0x12c/0x3a0
> > 
> > Relevant call trace:
> > 
> >   ext4_writepages
> >   do_writepages
> >   __writeback_single_inode
> >   writeback_single_inode
> >   write_inode_now
> >   iput_final
> >   ext4_fc_replay
> >   do_one_pass
> >   jbd2_journal_recover
> >   jbd2_journal_load
> >   ext4_load_journal
> >   ext4_load_and_init_journal
> >   __ext4_fill_super
> >   ext4_fill_super
> >   get_tree_bdev_flags
> >   ext4_get_tree
> >   vfs_get_tree
> >   vfs_cmd_create
> >   __do_sys_fsconfig
> > 
> > Full trace:
> > 
> > [  615.064100] NIP [c008000015b0ed24] ext4_writepages+0x12c/0x3a0 [ext4]
> > [  615.064360] Call Trace:
> > [  615.064383] do_writepages+0x190/0x330
> > [  615.064395] __writeback_single_inode+0x9c/0x9e0
> > [  615.064411] writeback_single_inode+0x18c/0x2b0
> > [  615.064425] write_inode_now+0xc0/0x100
> > [  615.064439] iput_final+0x10c/0x300
> > [  615.064451] ext4_fc_replay+0x374/0xdd0 [ext4]
> > [  615.064583] do_one_pass+0x9bc/0x1370 [jbd2]
> > [  615.064627] jbd2_journal_recover[0x358/0x400 [jbd2]
> > [  [jbd2615.064670] jbd2_journal_load/0x110 [jbd2]
> > [  615.064712] ext4_load_journal+0x2a0/0xb00 [ext4]
> > [  615.064844] ext4_load_and_init_journal+0x6c/0x660 [ext4]
> > [  615.064976] __ext4_fill_super+0x20b0/0x23a0 [ext4]
> > 
> > Registers:
> > 
> >   DAR:   0x0000000fe73f0000
> >   DSISR: 0x40000000
> > 
> > The address being dereferenced (0xfe73f0000) looks like a userspace
> > address and triggers:
> > 
> >   "Kernel attempted to read user page - exploit attempt?"
> > 
> > 
> > Filesystem messages immediately prior to the crash:
> > 
> > [  614.718310] EXT4-fs (loop0): mounted filesystem
> > ee09878a-da42-4d97-81ed-1b9616af2fb4 r/w with ordered data mode. Quota mode:
> > journalled.
> > [  614.984409] EXT4-fs (dm-0): mounted filesystem
> > b60397dc-c40f-4c75-bba9-bfc21f3a905a r/w with ordered data mode. Quota mode:
> > journalled.
> > [  615.029979] EXT4-fs (dm-0): unmounting filesystem
> > b60397dc-c40f-4c75-bba9-bfc21f3a905a.
> > 
> > 
> > Meanwhile, I will attempt bisection.
> > 
> > If you happen to fix this issue, please add below tag.
> > 
> > Reported-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
> > 
> 
> Hey thanks for reporting this Venkat, I'll try to replicate this at my
> end.
> 
> In the meantime, can you please share the complete Oops message and also
> your local.config. 
> 
> Thanks,
> ojaswin

(+cc Jan, Christian)

Okay so I'm able to replicate this in an x86 machine as well with 4kb
block size. The issue is replicable in vfs/vfs.all and is occurring
after Jan's change to nojournal mode writeout [1], with fast_commit.

The issue is as follows:

  __ext4_fill_super
    ext4_load_and_init_journal
      ...
      jbd2_journal_recover
        do_one_pass
          fc_do_one_pass
            ...
            ext4_fc_replay_unlink
              __ext4_unlink
                __ext4_mark_iloc_dirty
                  if (sbi->s_journal == NULL)  // s_journal is not set yet
                    set_inode_metadata_writeback(inode); // sets I_METADATA_WRITEBACK
              iput(inode)
                iput_final(inode)
                  ...
                  writeback_single_inode
                    __writeback_single_inode  // since I_METADATA_WRITEBACK is set
                      ...
                      ext4_writepages
                        ext4_writepages_down_read
                          percpu_down_read(sbi->s_writepages_rwsem)
                             <--- OOPS because this is initialized
                                  later in ext4_percpu_param_init()

A simple fix seems to be to move ext4_percpu_param_init() call before
ext4_load_journal() so that we can safely call ext4_writepages(). The
below diff seems to be fixing the issue for me, does this look okay to
you Jan?

Also, venkat can you please help test this in your system:

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 2877a6cf6d09..6e05f191542c 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5511,6 +5511,10 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
                        goto failed_mount3a;
        }

+       err = ext4_percpu_param_init(sbi);
+       if (err)
+               goto failed_mount3a;
+
        err = -EINVAL;
        /*
         * The first inode we look at is the journal inode.  Don't try
@@ -5659,10 +5663,6 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
                        clear_opt2(sb, MB_OPTIMIZE_SCAN);
        }

-       err = ext4_percpu_param_init(sbi);
-       if (err)
-               goto failed_mount5;
-
        err = ext4_mb_init(sb);
        if (err) {
                ext4_msg(sb, KERN_ERR, "failed to initialize mballoc (%d)",
@@ -5764,7 +5764,6 @@ failed_mount8: __maybe_unused
        ext4_mb_release(sb);
        ext4_flex_groups_free(sbi);
 failed_mount5:
-       ext4_percpu_param_destroy(sbi);
        ext4_ext_release(sb);
        ext4_release_system_zone(sb);
 failed_mount4a:
@@ -5785,6 +5784,7 @@ failed_mount8: __maybe_unused
                ext4_journal_destroy(sbi, sbi->s_journal);
        }
 failed_mount3a:
+       ext4_percpu_param_destroy(sbi);
        ext4_es_unregister_shrinker(sbi);
 failed_mount3:
        /* flush s_sb_upd_work before sbi destroy */

[1] https://lore.kernel.org/linux-ext4/20260727104923.3828017-37-jack@suse.cz/
> > 
> > 
> > Thanks,
> > Venkat.
> > 
