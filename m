Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B990126FD93;
	Mon,  3 Aug 2026 04:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785732469; cv=none; b=LICzf5iy2/9XUEWQsAO5BoAF5YE9WbHpttD17QqirUDyH6LYjoRJk2F++2IDFxSQHwRGmUiTdsX+g3qloOVff5HX942wf16e12qGMTwXyFi4Jj4vkrxHB2yy7DRNgb7VM8VdaWpjTvwH10rmhRpoCiZ2opU6BJGv24MgFb+17KI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785732469; c=relaxed/simple;
	bh=nc9+VKRRyzbveSGldMDM8u2JNc9MYxLwkMCAjybbhAU=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=Uy3tIZE3E0faszINR+xKb7ADxVSsKo1HidecnWNgsjy3XSGMLSg9uZ/2Fbq314sfhEcNpvTFAtKYLLFsSziQ5hM+oGTe0K1jmo01sfm5nhxr09e3MYXDoiCEWw107Jj+qFZzNNvC7Se/CWVerlIxq+aJtOuRVYjqb9kg9yTMsBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Jd82uRLC; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Jd82uRLC"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 672LmVlS169288;
	Mon, 3 Aug 2026 04:47:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pp1; bh=5AagMPrbfVWLSPSHL4sqi7MnRh3D
	OamQMJjcTqc0Lqk=; b=Jd82uRLCCmFx/w5DA29mqj7u0Dns6ARufvi6dmrpkKWs
	+RK456vHE7gCHrZ2pmLJlkS5UFJsXUz2jp/4vCAFIvP1IIb0c1/UmgUjUwXSRV8h
	15Ie5+d5RqueTWQ50mpc2W2vtYNYNg+3geA3kvwQ797GAp7SaDokdPxvopibOWgN
	Sc9QUMirfv3r3aRP5k+pOiXpitOtIO+Re7vFffvMSw8Z2F2EciLdBdFinRDsKmGU
	ThPjeHdQ4qKBdLYMAwS1072NqXge9I+f3n+vCXvrlw/DaH8xjBFcGWvalCLqpNLq
	fffq+YvMbzok2WStE8iX9wp8c7guvseDopT+MqsvJw==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fs77fxr43-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Aug 2026 04:47:42 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6734fFoR026008;
	Mon, 3 Aug 2026 04:47:41 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fsu4qbwj1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Aug 2026 04:47:41 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6734leQH24183310
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 3 Aug 2026 04:47:40 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 802BE5805D;
	Mon,  3 Aug 2026 04:47:40 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A6BD858065;
	Mon,  3 Aug 2026 04:47:37 +0000 (GMT)
Received: from [9.61.248.87] (unknown [9.61.248.87])
	by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  3 Aug 2026 04:47:37 +0000 (GMT)
Message-ID: <9ac0524e-0644-4fba-a256-c5b7fe333a3e@linux.ibm.com>
Date: Mon, 3 Aug 2026 10:17:35 +0530
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-GB
To: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        ojaswin@linux.ibm.com, Christophe Leroy <christophe.leroy@csgroup.eu>,
        Madhavan Srinivasan <maddy@linux.ibm.com>
From: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Subject: [BUG] ext4: NULL/invalid pointer dereference in ext4_writepages()
 during generic/039
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODAzMDAzOSBTYWx0ZWRfXziExb8VGKV4d
 wllNnCRC81Yamm6jG4IQn5VSSyAndFz4Crpd0lD0/CtqZa2vxPiHWh3wywfhQHOFnEI/AqxNe9g
 NU04nbwf/FllispLGEQ6oFYYeTTWRspg5am9qF8ApbSIcbkYqGhJ0BjHpZzja8La5CaDjOjnLHI
 jGMlpA7nzMm/q7ystI6cycIW+QhfhDkpFleu8jBYKughav4E24hP4a/q9hTzUsi5Q4iP8WlMowB
 xUiTJXEkx+Kvi9PJ3uK1Yxe79slfaz0sLbMcUk/gkUDKgwv3U+bJQ6NsS8xXt+WMkfjaPwzhvV1
 GIJ5qxKFJdXVkQV4bysurYur7lzpBZ+3pq3XhwL7L16MbMVj9RT09sv1L0AkmdRT4UM68N27y92
 XuPmsImZ1BO8mun0GoVd+XGN42JXtDK3uPTiniyeXsBaB71qbmi0Yq+UubHcyJTmTWAgc6HyuVl
 MGf8bT6tfdDEq+O99WA==
X-Authority-Analysis: v=2.4 cv=WIFPmHsR c=1 sm=1 tr=0 ts=6a701d6e cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8
 a=pyDeDfM9kf01-BYV5vUA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: FNwGH8O9EyLn6EmfCOYLjCicUULJ8Rwt
X-Proofpoint-ORIG-GUID: FNwGH8O9EyLn6EmfCOYLjCicUULJ8Rwt
X-Proofpoint-Spam-Info: AW1haW4tMjYwODAzMDAzOSBTYWx0ZWRfXzIJsGiIl7kes
 gwtLUDNUuwa7DSfdtlVYd1toiItEt3W7wembwyIxpVhGZ0JX2jvGkMpLrL+Bh8h0iP/EtuO/T6m
 IjGnrIIGAEOJCbOSPABzIsah/KshBc4=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-02_06,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 priorityscore=1501 phishscore=0 malwarescore=0
 suspectscore=0 clxscore=1011 impostorscore=0 bulkscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608030039

Hi,

I am  seeing a reproducible kernel crash while running xfstests 
generic/039 on powerpc.

The crash happens during ext4 journal recovery while mounting the
filesystem. The fault occurs inside ext4_writepages() and appears to
dereference a userspace-looking address.

Test environment
----------------
Kernel:
   7.2.0-rc5-next-20260731

Architecture:
   powerpc64le

Platform:
   IBM Power9 (pSeries)

Machine:
   IBM,8375-42A
   FW950.80 (VL950_131)

Config highlights:
   PAGE_SIZE=64K
   MMU=Hash
   PREEMPTLAZY=y

Workload
--------
xfstests generic/039

Log excerpt:
   run fstests generic/039 at 2026-08-03 00:22:44

Crash
-----
[  615.063689] Kernel attempted to read user page (fe73f0000) - exploit 
attempt? (uid: 0)
[  615.063714] BUG: Unable to handle kernel data access on read at 
0xfe73f0000
[  615.063723] Faulting instruction address: 0xc008000015b0ed24
[  615.063731] Oops: Kernel access of bad area, sig: 11 [#1]

The faulting instruction is:

   ext4_writepages+0x12c/0x3a0

Relevant call trace:

   ext4_writepages
   do_writepages
   __writeback_single_inode
   writeback_single_inode
   write_inode_now
   iput_final
   ext4_fc_replay
   do_one_pass
   jbd2_journal_recover
   jbd2_journal_load
   ext4_load_journal
   ext4_load_and_init_journal
   __ext4_fill_super
   ext4_fill_super
   get_tree_bdev_flags
   ext4_get_tree
   vfs_get_tree
   vfs_cmd_create
   __do_sys_fsconfig

Full trace:

[  615.064100] NIP [c008000015b0ed24] ext4_writepages+0x12c/0x3a0 [ext4]
[  615.064360] Call Trace:
[  615.064383] do_writepages+0x190/0x330
[  615.064395] __writeback_single_inode+0x9c/0x9e0
[  615.064411] writeback_single_inode+0x18c/0x2b0
[  615.064425] write_inode_now+0xc0/0x100
[  615.064439] iput_final+0x10c/0x300
[  615.064451] ext4_fc_replay+0x374/0xdd0 [ext4]
[  615.064583] do_one_pass+0x9bc/0x1370 [jbd2]
[  615.064627] jbd2_journal_recover[0x358/0x400 [jbd2]
[  [jbd2615.064670] jbd2_journal_load/0x110 [jbd2]
[  615.064712] ext4_load_journal+0x2a0/0xb00 [ext4]
[  615.064844] ext4_load_and_init_journal+0x6c/0x660 [ext4]
[  615.064976] __ext4_fill_super+0x20b0/0x23a0 [ext4]

Registers:

   DAR:   0x0000000fe73f0000
   DSISR: 0x40000000

The address being dereferenced (0xfe73f0000) looks like a userspace
address and triggers:

   "Kernel attempted to read user page - exploit attempt?"


Filesystem messages immediately prior to the crash:

[  614.718310] EXT4-fs (loop0): mounted filesystem 
ee09878a-da42-4d97-81ed-1b9616af2fb4 r/w with ordered data mode. Quota 
mode: journalled.
[  614.984409] EXT4-fs (dm-0): mounted filesystem 
b60397dc-c40f-4c75-bba9-bfc21f3a905a r/w with ordered data mode. Quota 
mode: journalled.
[  615.029979] EXT4-fs (dm-0): unmounting filesystem 
b60397dc-c40f-4c75-bba9-bfc21f3a905a.


Meanwhile, I will attempt bisection.

If you happen to fix this issue, please add below tag.

Reported-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>




Thanks,
Venkat.

