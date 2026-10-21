Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.158.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792569910;
	b=BQrUjXQvcnRmy2NLcnMFyEAfhOi8x5QyTXDLmJPw9e5DlV1MFXI10L9eDGg0FdQZaRPX
	 rAZZmGrNxTt6r7xCekcYHC5FjiEWjFHJyE3Ojo7OxhLRqpFxQLP2bcGIQAY3P7d021pdL
	 qerKCyfhq2/iErsFET9P5NFBGagWiPJ3umsInOqWijFG0Ygq/bpeK0HX/zRzF3SO84/k6
	 Xm4Tj6U1W0bWK+ZarSehJqEGFqthuQTij5LwmmN5Os5tOKi9d0UdsGfPzgfsyk/U0CAyE
	 +CQsV36FOett+sCFwFAbcIaN76vKqacdhnzUsYQjvZ3BV8EjEL2/TLdh0tHcjIoUlPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792569910;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-TM-AS-GCONF:X-Proofpoint-Reinject:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Info:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=5SiSOmgntifWep9/vcUkd3FyFlinf0yZ1waE0Teg3lY=;
	b=Cy5yGXm4hCJoL3LbWmSy+LLZif9tZwwF/Jv0Ro54sQu1TPhRAGJWW8UWM+p4vQ7IxCK3
	 1zT5aSos14TCVlRVA6lcyZcXvXr0mK1bAy2bZmh4U1ZQRJuh5l24BHxjpKXET9OQ3FU6y
	 NUI9wrTIMc5vuHh8gD3Uafm37FzEyXRVucJnHFmCXaXsd2xE09VHsuZVPMtafvkFuVwO/
	 njlYM5RXpApKO3rRY4P1ta6ByhJibiZlfc2SyNl605ZvN5bPoh/10ehN2Q9Vj5OFXtY0L
	 uRt7ToBT4IWpqMusGUrKCr9iylSOqcu1U/8sZGLTkweZc3ORQCkdXN9HGrlsTWz1P4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=mSwc3+L2;
	arc=none smtp.remote-ip=148.163.158.5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1181B606A319;
	Wed, 21 Oct 2026 08:05:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1181B606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=mSwc3+L2
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69L5ijA9359953;
	Wed, 21 Oct 2026 08:04:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=5SiSOmgntifWep9/vcUkd3FyFlinf0
	yZ1waE0Teg3lY=; b=mSwc3+L2vj4lPySFIR+IP8tG8VVcyJkAHjd1ZN7O5Q9/Mx
	qRSHbmyK2L6fzm5Cm8HtJetR+0Sjgm16Lm9h4ypdoJXw2hK+ss59UHKRIjKeSMWj
	yT/kWF4rcdaJJp10IpqkahPEX4oBbxMpja4VIFGgSXWoj1SpOdwQCQpwUthv+nTm
	hXY/oK2gqfdcANgpTCh1tcr+KVy1IIZdxX8ZPjMljrPKntkKGJsQYzhP95DPg2mD
	hTS/r51znAxabASZzoni+phbvajiHfsr9JJkzeU+gTKIzS2C9EyWBbhKfcHuFDrN
	cCNZcY0dFyz6v9l+RC3SQ/lAI9ZbDhRVAUsuXuPA==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hdw59yf0b-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 21 Oct 2026 08:04:04 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 69L5nt841455843;
	Wed, 21 Oct 2026 08:04:03 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4hefss200u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 21 Oct 2026 08:04:03 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 69L842bj48824638
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Oct 2026 08:04:02 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EC73620040;
	Wed, 21 Oct 2026 08:04:01 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 706EE2004B;
	Wed, 21 Oct 2026 08:03:57 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.16.155])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 21 Oct 2026 08:03:57 +0000 (GMT)
Date: Wed, 21 Oct 2026 13:33:54 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: syzbot ci <syzbot+ci46f64f7b6a2a188e@syzkaller.appspotmail.com>,
        syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com,
        adilger.kernel@dilger.ca, chengzhihao1@huawei.com, djwong@kernel.org,
        hch@infradead.org, jack@suse.cz, libaokun@linux.alibaba.com,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, ritesh.list@gmail.com, tytso@mit.edu,
        wangkefeng.wang@huawei.com, yangerkun@huawei.com, yi.zhang@huawei.com,
        yizhang089@gmail.com, yukuai@fnnas.com
Subject: Re: [syzbot ci] Re: ext4: use iomap for regular file's buffered I/O
 path
Message-ID: <athx6i4FVmzaCWXE@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <6ac92a4c.70ed5d86.2ac85.0072.GAE@google.com>
 <34423908-aceb-4c57-9502-7da10b12e4a4@huaweicloud.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <34423908-aceb-4c57-9502-7da10b12e4a4@huaweicloud.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIxMDAzMCBTYWx0ZWRfXzsXyA2dIO8Qh
 y/lgMMVSbvT0U2Nq9ZyOneGzRpvSy0Faq8ihn/1UK2LKZ9YddgNlKEdlF825BLPLqNSijQ1l582
 FORg04Dq965Yg4NYcC77L8x7MCXIGRB6xfqbPwvmtd6dnWgWvBUv1PIBG1dDfQ60Zn+UhNOpN8E
 a5T1FS5SF5Qo48Ki8ur6woXkzOOOiPXF2A0m3+utnNX69IvtKKKanDhCfecJKn/z4dgtBeQj1CO
 1ovVnC9TPo5lfJJWFS7hCQHQgQGQCx48+aXxdzglkbGCQqKNeAfZqZ3VcslkwJpn0cBpDeZDscY
 iVxuRX/o4V+tXAIznLsygS3Fz+EDd3eCknMqjOtwwO58ZUu9fOZPAD0A01gbTJvR9a1sRCllf/v
 KqaxqxaNOMKuOl/tW2a7g+nJmiW4VlHlJY9S9YzFVL7F8SfgFtLPKP47AajB/JuSOG9kaQ6SO2A
 C65RVP1jDYv7HBySOQQ==
X-Proofpoint-ORIG-GUID: 5FeDTI84D-HXPvyT0PjDI3h5Bjndv76q
X-Proofpoint-GUID: EUjwOC3SLIJUZxBKbbjXIQr-QHKwup66
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIxMDAzMCBTYWx0ZWRfXzyM4Q7Plq2T5
 9jYPuWQYodPyxKp5xRX+4Jpdh7fk2hjfJSEOJGUhOJUSYJs71F2Et8LJ574HpRW6R1VtRCD10Eg
 CnVs5Hl8Cy4noapi5CLX8jpyirMVWrU=
X-Authority-Analysis: v=2.4 cv=ZfSIpcVA c=1 sm=1 tr=0 ts=6ad871f5 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=kj9zAlcOel0A:10 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=-ibLmwfWAAAA:8
 a=Oh2cFVv5AAAA:8 a=hSkVLCK3AAAA:8 a=4RBUngkUAAAA:8 a=LAgt6U_hPI2_JMarfT4A:9
 a=CjuIK1q_8ugA:10 a=A6MkUVyZPcTV1i89ro0M:22 a=7KeoIwV6GZqOttXkcoxL:22
 a=cQPPKAXgyycSBL8etih5:22 a=_sbA2Q-Kp09kWB8D3iXc:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-21_02,2026-10-19_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 malwarescore=0 spamscore=0 suspectscore=0
 clxscore=1011 phishscore=0 bulkscore=0 lowpriorityscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610210030

On Sat, Oct 10, 2026 at 04:44:52PM +0800, Zhang Yi wrote:
> On 10/10/2026 1:54 AM, syzbot ci wrote:
> > syzbot ci has tested the following series
> > 
> 
> [...]
> 
> > and found the following issue:
> > WARNING in ext4_do_writepages
> > 
> > Full report is available here:
> > https://ci.syzbot.org/series/3711c951-acf4-4ebe-a920-9cc89b6be2ff
> > 
> > ***
> > 
> > WARNING in ext4_do_writepages
> > 
> > tree:      vfs
> > URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/vfs/vfs.git
> > base:      3d399224425573875b6f6f1181bd8cf9a28cc7d1
> > arch:      amd64
> > compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
> > config:    https://ci.syzbot.org/builds/c3c01f8c-846d-4c7a-955a-fd7427af6b0d/config
> > 
> > ------------[ cut here ]------------
> > !err
> > WARNING: fs/ext4/inode.c:2512 at ext4_do_writepages+0x33b3/0x44a0, CPU#0: kworker/u9:3/147
> > Modules linked in:
> > CPU: 0 UID: 0 PID: 147 Comm: kworker/u9:3 Not tainted syzkaller #0 PREEMPT(full) 
> > Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
> > Workqueue: writeback wb_workfn (flush-7:1)
> > RIP: 0010:ext4_do_writepages+0x33b3/0x44a0
> > Code: 0f 0b 90 e9 b6 d9 ff ff e8 6a e2 36 ff 90 0f 0b 90 e9 e6 dc ff ff e8 5c e2 36 ff 90 0f 0b 90 e9 94 df ff ff e8 4e e2 36 ff 90 <0f> 0b 90 bb ea ff ff ff e9 ae f8 ff ff e8 3b e2 36 ff 48 8d 3d 64
> > RSP: 0018:ffffc90003106ce0 EFLAGS: 00010293
> > RAX: ffffffff8290e912 RBX: 0000000000000000 RCX: ffff8881053f9e00
> > RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> > RBP: ffffc900031070f0 R08: ffff888025da4a37 R09: 1ffff11004bb4946
> > R10: dffffc0000000000 R11: ffffed1004bb4947 R12: ffffc900031071a0
> > R13: dffffc0000000000 R14: 0000000000000000 R15: 1ffff11004bb495d
> > FS:  0000000000000000(0000) GS:ffff88818d6c9000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 00005555565a5a28 CR3: 0000000031f66000 CR4: 00000000000006f0
> > Call Trace:
> >  <TASK>
> >  ext4_writepages+0x241/0x3b0
> >  do_writepages+0x338/0x560
> >  __writeback_single_inode+0x136/0x1220
> >  writeback_sb_inodes+0x9de/0x1b00
> >  wb_writeback+0x41c/0xad0
> >  wb_workfn+0x431/0x10f0
> >  process_scheduled_works+0xc3d/0x1630
> >  worker_thread+0xa47/0xfb0
> >  kthread+0x38b/0x480
> >  ret_from_fork+0x514/0xb70
> >  ret_from_fork_asm+0x1a/0x30
> >  </TASK>
> > 
> > 
> 
> This WARNING was newly introduced by patch 8, "ext4: skip block
> allocation for holes in the data submission path". It doesn't actually
> cause a new regression, it just appears to expose a pre-existing issue
> in the buffer_head buffered I/O path, where an inconsistency between
> the bh and extent state could potentially lead to allocating a block and
> writing data into a hole. The logic of the patch itself is fine. To
> avoid noise, I can drop the WARN_ON_ONCE() while still keeping return
> -EINVAL. Thoughts?

Hi Zhang,

I think we can keep the WARN_ON. Failing in writeback here will anyways
throw out some error messages about data loss so having an extra WARN
dump should be okay. It will help us find and eliminate paths that cause
this quickly, like your patch for the inline truncate fix.

Regards,
ojaswin

> 
> Thanks,
> Yi.
> 
> > ***
> > 
> > If these findings have caused you to resend the series or submit a
> > separate fix, please add the following tag to your commit message:
> >   Tested-by: syzbot@syzkaller.appspotmail.com
> > 
> > ---
> > This report is generated by a bot. It may contain errors.
> > syzbot ci engineers can be reached at syzkaller@googlegroups.com.
> > 
> > To test a fix for this bug, please reply with `#syz test`
> > (on a separate line) and attach the patch to the email.
> > 
> > Notes:
> > - The patch will be applied on top of the tested series (as an
> >   incremental fix).
> > - To test a new version of the whole series, please send it directly
> >   to syzbot@lists.linux.dev.
> > - Arguments like custom git repos and branches are not supported.
> 
