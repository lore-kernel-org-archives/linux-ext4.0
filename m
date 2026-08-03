Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEA3E29B781;
	Mon,  3 Aug 2026 06:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785739971; cv=none; b=frLtAuh/kz+S8PCBHDeWdspHlieARyY6MjhIsUKzUR3jlqVIw2VM441kAYTSMsTGk2kiS0frnIsNBNZIscOnGxAllt/Ah6+pTX2Hg6Y+GDlQX71PoS6juoc1TjAyvT8c9aB+QU10WDTAuDYYFzLhyKcyjjI07+XJhhMa0H7cW2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785739971; c=relaxed/simple;
	bh=+6D6FvHLiZBtcUSVDACatK8sLZE+1X/0ffZ3NACDjGc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i3xsO1kE9lXflt3Hy1fLFRQdDray7JvbBS1y1ezcjqkDVHEX9i5kLhBSg6XVysWBWrrsKne48RI3SEiYOZWcf2qm4lbwDMvJrYeLuisbPfFhk0/+69B7MAyYR9cCJR0QVF6WRKpDy1NjzBjZnEXEWzNMHG372OLp2U2Y+MhA2u4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=m0BEuVIx; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="m0BEuVIx"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 672Lmise169710;
	Mon, 3 Aug 2026 06:52:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=v2PE9o
	Ykh7wWWZl9+/fsfOS9nSNvWIR2toJskkEkllU=; b=m0BEuVIxA5MgePnblBEb7X
	nbjLWF2tEHblawLfn8HbadOmu7AuruQOJ5xvF/jdsIQ4DQFzELXtVpfcmMBgKFBP
	ScdaFI/GvsWZmaHWVkl0H+n7fxFOmBjmNtxQPptsxTm3ZAeVgFeu5LpBLXGHmQzi
	d/+lxkAPJcLXpR12xW5d+Jnfn2EBsie1o3aeVwsb19p9s/vtcGQS2O8ZYJ4L4F/d
	cEHTrYY7+xGftD8j1oollMFB3ftbZhVEANLG4CJKs+qUb2CoGJI12W2gVTq1tVCI
	kyQ2jJ32ZnFJlEbobYBxcBcdm4srokpkHP3B+CeoPv4wR/YQB2+Nb3GRBl7AI2Iw
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fs77fy517-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Aug 2026 06:52:44 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6736fGwF002085;
	Mon, 3 Aug 2026 06:52:43 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fswtybved-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Aug 2026 06:52:43 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6736qe5B30278018
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 3 Aug 2026 06:52:40 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 382F02004B;
	Mon,  3 Aug 2026 06:52:40 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3979B20040;
	Mon,  3 Aug 2026 06:52:38 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.123.13.2])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon,  3 Aug 2026 06:52:38 +0000 (GMT)
Date: Mon, 3 Aug 2026 12:22:35 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: Re: [BUG] ext4: NULL/invalid pointer dereference in
 ext4_writepages() during generic/039
Message-ID: <anA6s9L-cpsifqgU@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <9ac0524e-0644-4fba-a256-c5b7fe333a3e@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9ac0524e-0644-4fba-a256-c5b7fe333a3e@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODAzMDA1OCBTYWx0ZWRfX0zcTT6GzEmED
 x+4ehuZDyo3URtoOQapzfvDLFPRnswy4Y4hIzwk+7MlonbzSBdXP5N0dA9SsD2SVfo5639EGhEj
 BSiCRKoKnLPDKp4wT4cGvL5oQOvIm326sUAOmfuclRdbtn4UHDDq5umUNFzuHMaX0HUoJctlbXG
 YfAupSdiyM4R+dq8Q6RbSzTceXKXHLuUAXC0z4V8kD1OVjaUuK49EGmYMojyUwPcRdHVwal1eXy
 LcMbuhNrnZ9ISfSvwyZ62ZjxW8LYYjONEOJ1hv3/XnMOe7R76MaSioE4/4TgPbNawnehfhMou11
 39NfsPmklFa5UPPw7dCJe8M7ECbkygXWAHdelyQtPJTBX66+Z5/hmRlEm6RE0z0Ah2Q+NiIx/vv
 hXmanIblPSUkfz5I5EAHVlcL5RcIR3yjS9jquF4rTsjKz0GDcOFsaatOPI0Fbpu/MJzCyHspjpy
 CuveL8ZEiCW2dcYPbJw==
X-Authority-Analysis: v=2.4 cv=WIFPmHsR c=1 sm=1 tr=0 ts=6a703abc cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=8nJEP1OIZ-IA:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8
 a=D3AbGSsO8w2ewviXKQsA:9 a=3ZKOabzyN94A:10 a=wPNLvfGTeEIA:10
X-Proofpoint-GUID: DIfjSsP4mmjP9bwY5pVfQ66oDcSAe5UF
X-Proofpoint-ORIG-GUID: DIfjSsP4mmjP9bwY5pVfQ66oDcSAe5UF
X-Proofpoint-Spam-Info: AW1haW4tMjYwODAzMDA1OCBTYWx0ZWRfX9oGqbucMKILz
 uaf06g0esp6jE+LHfvK9JZrkb9d/7FVILgCv+TYl6+7SyRZ3wuwDfoXq8l5CUHX73ut6VmtbLK4
 kyEAX8AXzUYtW8ju7MAEEQgaeTzLTM8=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-02_06,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 priorityscore=1501 phishscore=0 malwarescore=0
 suspectscore=0 clxscore=1011 impostorscore=0 bulkscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608030058

On Mon, Aug 03, 2026 at 10:17:35AM +0530, Venkat Rao Bagalkote wrote:
> Hi,
> 
> I am  seeing a reproducible kernel crash while running xfstests generic/039
> on powerpc.
> 
> The crash happens during ext4 journal recovery while mounting the
> filesystem. The fault occurs inside ext4_writepages() and appears to
> dereference a userspace-looking address.
> 
> Test environment
> ----------------
> Kernel:
>   7.2.0-rc5-next-20260731
> 
> Architecture:
>   powerpc64le
> 
> Platform:
>   IBM Power9 (pSeries)
> 
> Machine:
>   IBM,8375-42A
>   FW950.80 (VL950_131)
> 
> Config highlights:
>   PAGE_SIZE=64K
>   MMU=Hash
>   PREEMPTLAZY=y
> 
> Workload
> --------
> xfstests generic/039
> 
> Log excerpt:
>   run fstests generic/039 at 2026-08-03 00:22:44
> 
> Crash
> -----
> [  615.063689] Kernel attempted to read user page (fe73f0000) - exploit
> attempt? (uid: 0)
> [  615.063714] BUG: Unable to handle kernel data access on read at
> 0xfe73f0000
> [  615.063723] Faulting instruction address: 0xc008000015b0ed24
> [  615.063731] Oops: Kernel access of bad area, sig: 11 [#1]
> 
> The faulting instruction is:
> 
>   ext4_writepages+0x12c/0x3a0
> 
> Relevant call trace:
> 
>   ext4_writepages
>   do_writepages
>   __writeback_single_inode
>   writeback_single_inode
>   write_inode_now
>   iput_final
>   ext4_fc_replay
>   do_one_pass
>   jbd2_journal_recover
>   jbd2_journal_load
>   ext4_load_journal
>   ext4_load_and_init_journal
>   __ext4_fill_super
>   ext4_fill_super
>   get_tree_bdev_flags
>   ext4_get_tree
>   vfs_get_tree
>   vfs_cmd_create
>   __do_sys_fsconfig
> 
> Full trace:
> 
> [  615.064100] NIP [c008000015b0ed24] ext4_writepages+0x12c/0x3a0 [ext4]
> [  615.064360] Call Trace:
> [  615.064383] do_writepages+0x190/0x330
> [  615.064395] __writeback_single_inode+0x9c/0x9e0
> [  615.064411] writeback_single_inode+0x18c/0x2b0
> [  615.064425] write_inode_now+0xc0/0x100
> [  615.064439] iput_final+0x10c/0x300
> [  615.064451] ext4_fc_replay+0x374/0xdd0 [ext4]
> [  615.064583] do_one_pass+0x9bc/0x1370 [jbd2]
> [  615.064627] jbd2_journal_recover[0x358/0x400 [jbd2]
> [  [jbd2615.064670] jbd2_journal_load/0x110 [jbd2]
> [  615.064712] ext4_load_journal+0x2a0/0xb00 [ext4]
> [  615.064844] ext4_load_and_init_journal+0x6c/0x660 [ext4]
> [  615.064976] __ext4_fill_super+0x20b0/0x23a0 [ext4]
> 
> Registers:
> 
>   DAR:   0x0000000fe73f0000
>   DSISR: 0x40000000
> 
> The address being dereferenced (0xfe73f0000) looks like a userspace
> address and triggers:
> 
>   "Kernel attempted to read user page - exploit attempt?"
> 
> 
> Filesystem messages immediately prior to the crash:
> 
> [  614.718310] EXT4-fs (loop0): mounted filesystem
> ee09878a-da42-4d97-81ed-1b9616af2fb4 r/w with ordered data mode. Quota mode:
> journalled.
> [  614.984409] EXT4-fs (dm-0): mounted filesystem
> b60397dc-c40f-4c75-bba9-bfc21f3a905a r/w with ordered data mode. Quota mode:
> journalled.
> [  615.029979] EXT4-fs (dm-0): unmounting filesystem
> b60397dc-c40f-4c75-bba9-bfc21f3a905a.
> 
> 
> Meanwhile, I will attempt bisection.
> 
> If you happen to fix this issue, please add below tag.
> 
> Reported-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
> 

Hey thanks for reporting this Venkat, I'll try to replicate this at my
end.

In the meantime, can you please share the complete Oops message and also
your local.config. 

Thanks,
ojaswin
> 
> 
> Thanks,
> Venkat.
> 
