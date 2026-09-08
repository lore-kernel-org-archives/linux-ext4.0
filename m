Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3A3818FC80;
	Tue,  8 Sep 2026 01:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788830184; cv=none; b=YytFWexcSc0xVkgK962CzJ18P3QAF/J1hxobJsmbH+g/RlC0LYNO5gMD8u2VlPCoVvWW6YJkYAtz2IY4xvoGcXFZHwHAVCirx+00qVnkrCQ814YEmtjFYVukNb3oLgP/Uu+YA+hefb3ZMQd7QEQmkZTsZCqJrQF5B25JINF0sZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788830184; c=relaxed/simple;
	bh=vxp3qCvMghC6ryRaA0/g6oPFOQFbS9MsZj0eJLwoCwo=;
	h=Message-ID:Subject:From:To:In-Reply-To:References:Content-Type:
	 Date:MIME-Version; b=MPYKG8KKDMKcRye26J562by7ra5KSjYFW2a0dKjml+xCekc/O08OviEADTuuoOH/332/CRA0lMbdUbBi2W4ayOeHneZwpMCHceSiDz6gVj8Y0gtZ+ANrmHmz7614OEEalNw0YhTnCvDc+/5fachQffRHSTc4WpLfwhVxsimI44w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Sr4AVm/c; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Sr4AVm/c"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68801PbZ3378439;
	Tue, 8 Sep 2026 01:16:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=s1U4lP
	NDu8kEbUQWU8tVyZFXqvqACjhbyIk1i2Ifl58=; b=Sr4AVm/cBz9fPC0BBPPP5s
	vGB9PtWmfKGWEe0yDB8J/MO5KpqWFud5Cv2bWOAgDbgHc/Iw5gVhgvK84F1VsP8A
	idtkbZn6HV5CNAQZiWjRRdo9y26YHTWnZbjrcOZbjvauenAPKvaqJFxFOrvCogKg
	K801jfDeWzFOutbhW29sa2EE8ePF3ZVNefzBvcGA4vcUYmAQzn3rhArsoiAWFzQe
	JhtIcppDW/HicUODROrjupGmMsduh4i4DPYv0HW5IlG5idqdsH4sBD6vqCRoTCoZ
	i0llF7Jh7+ocLrISGx05LYVs4Eka8b5Qz32dMFR+dk0CKde1SYuYoZJw1jxpvgUQ
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ggbf3uquv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 08 Sep 2026 01:16:01 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6881BNX0005645;
	Tue, 8 Sep 2026 01:15:59 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([172.16.1.5])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4ggxwh0sy8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 08 Sep 2026 01:15:59 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
	by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6881FxZw16253566
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 8 Sep 2026 01:15:59 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 29BA558059;
	Tue,  8 Sep 2026 01:15:59 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3E37D58057;
	Tue,  8 Sep 2026 01:15:58 +0000 (GMT)
Received: from li-43857255-d5e6-4659-90f1-fc5cee4750ad.ibm.com (unknown [9.61.40.70])
	by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  8 Sep 2026 01:15:58 +0000 (GMT)
Message-ID: <4472cfce69b1b334abb7b83df20fb1499af6522c.camel@linux.ibm.com>
Subject: Re: [syzbot] [ext4?] possible deadlock in process_measurement (6)
From: Mimi Zohar <zohar@linux.ibm.com>
To: syzbot <syzbot+c0bfa7a9a227036e8454@syzkaller.appspotmail.com>,
        dmitry.kasatkin@gmail.com, eric.snowberg@oracle.com,
        gregkh@linuxfoundation.org, jmorris@namei.org,
        linux-ext4@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-usb@vger.kernel.org, paul@paul-moore.com,
        roberto.sassu@huawei.com, serge@hallyn.com,
        syzkaller-bugs@googlegroups.com
In-Reply-To: <6a9bef47.37659fcc.e790.0002.GAE@google.com>
References: <6a9bef47.37659fcc.e790.0002.GAE@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Date: Mon, 07 Sep 2026 21:15:57 -0400
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: y3u33XTbqxAlkzLHysLZ7EtHkTdMXq0o
X-Proofpoint-GUID: CY2xsYk1QLwcJMexzNHgEfLslaTfMju7
X-Authority-Analysis: v=2.4 cv=DbEnbPtW c=1 sm=1 tr=0 ts=6a9f61d1 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=edf1wS77AAAA:8
 a=3g80flMcAAAA:8 a=hSkVLCK3AAAA:8 a=eFkcf2jx4er14yNRBNsA:9
 a=BhMdqm2Wqc4Q2JL7t0yJfBCtM/Y=:19 a=QEXdDO2ut3YA:10 a=slFVYn995OdndYK6izCD:22
 a=DcSpbTIhAlouE1Uv7lRv:22 a=3urWGuTZa-U-TZ_dHwj2:22 a=cQPPKAXgyycSBL8etih5:22
 a=-WsGb18yrIRSV60qWLiz:22 a=NWVoK91CQySWRX1oVYDe:22 a=lAIPu-TSoPCgWs-2gwLQ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA4MDAwOCBTYWx0ZWRfX01sFBUVqb5HP
 VFv4aAfWVC7SlmWoMjbPk1whe6PegvdiSl9zACDAAzyRjT/lTqIKBslXaODZHCytaDHX7OdMX4z
 N2cr/Nkz7CzF/r/Q2eKKdrQhE0VUcuwsyfQ+qFYWRffnPuB2ozOZZjCIuPgAnoYDassBQIpxa5B
 +fHVtXn5kh0CKduLR/N17PyMQejY69QiZAan/kOIke0W/Jf4nouN3KaNMQ0M4/z65IzADuNBmgu
 jxjh3SLu7S9NaPgzDAO0h7wczRma3RNU8gn13T4RsS3Pde4e3pWgcARRVhatlq8eCRMeqlpm+uO
 0FoLFEQPUu2LvIk3kXBwPdJiRw0LYytZ3tzQE0w1Fqxld4TMYj86FtjiepqpXVJn1QYNccK4sWM
 vllNqMiAntjKuwC/0+dq7mCD1hOjdO4YaQakDUlGBVg/ofGqW/tj9h5FsikhtYmEX26qfESxDkP
 QvJwJ7kz6sXYk9QQT1w==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA4MDAwOCBTYWx0ZWRfX1c2LW1L13V07
 Pk/GMy2qJN5N6AhWr5zPtTNMlp31CGugQCGOXkv1c1FIob5nSzMA9lUEZysFqMUZaMm+aFI19Rf
 1IlS7n6FrqlQ7m6eLxaHWTdkJwwxKsU=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-07_07,2026-09-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 impostorscore=0 adultscore=0 spamscore=0
 clxscore=1011 suspectscore=0 bulkscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609080008

On Sat, 2026-09-05 at 03:30 -0700, syzbot wrote:
> syzbot has found a reproducer for the following issue on:
>=20
> HEAD commit:    654ae5d73c05 Merge tag 'drm-fixes-2026-09-05' of https://=
g..
> git tree:       upstream
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=3D14c568f958000=
0
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3Db454dc6b1b7ac=
d30
> dashboard link: https://syzkaller.appspot.com/bug?extid=3Dc0bfa7a9a227036=
e8454
> compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e25=
5-1~exp1~20260613092250.77), Debian LLD 22.1.8
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D12c568f9580=
000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D17cc6b4958000=
0
>=20
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/49c1a99f815b/dis=
k-654ae5d7.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/6fcecf1b8c8d/vmlinu=
x-654ae5d7.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/fa54b23691ca/b=
zImage-654ae5d7.xz
> mounted in repro: https://storage.googleapis.com/syzbot-assets/7be96c47c4=
4b/mount_0.gz
>   fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=3D1204=
1125580000)
>=20
> IMPORTANT: if you fix the issue, please add the following tag to the comm=
it:
> Reported-by: syzbot+c0bfa7a9a227036e8454@syzkaller.appspotmail.com

The patches for excluding IMA measure and appraise rules for configfs were
upstreamed in 7.3-rc2:

8e22ce504f8a ("ima: don't measure/appraise files on configfs")
ab84c314417e ("configfs: move CONFIGFS_MAGIC definition to magic.h")

Mimi

>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> WARNING: possible circular locking dependency detected
> syzkaller #0 Not tainted
> ------------------------------------------------------
> syz-executor428/5602 is trying to acquire lock:
> ffff88803f38b458 (&ima_iint_mutex_key[depth]){+.+.}-{4:4}, at: process_me=
asurement+0x7e0/0x1c20 security/integrity/ima/ima_main.c:319
>=20
> but task is already holding lock:
> ffff888038eee198 (&common->filesem){++++}-{4:4}, at: fsg_store_file+0x163=
/0x400 drivers/usb/gadget/function/storage_common.c:452
>=20
> which lock already depends on the new lock.
>=20
>=20
> the existing dependency chain (in reverse order) is:
>=20
> -> #3 (&common->filesem){++++}-{4:4}:
>        down_read+0x97/0x200 kernel/locking/rwsem.c:1574
>        fsg_show_file+0x2d/0x140 drivers/usb/gadget/function/storage_commo=
n.c:339
>        fill_read_buffer fs/configfs/file.c:68 [inline]
>        configfs_read_iter+0x2ba/0x620 fs/configfs/file.c:88
>        __kernel_read+0x4d3/0x970 fs/read_write.c:532
>        integrity_kernel_read+0x89/0xd0 security/integrity/iint.c:28
>        ima_calc_file_hash_tfm security/integrity/ima/ima_crypto.c:222 [in=
line]
>        ima_calc_file_hash+0x45d/0x8a0 security/integrity/ima/ima_crypto.c=
:280
>        ima_collect_measurement+0x521/0xa10 security/integrity/ima/ima_api=
.c:300
>        process_measurement+0x1282/0x1c20 security/integrity/ima/ima_main.=
c:425
>        ima_file_check+0xe1/0x130 security/integrity/ima/ima_main.c:685
>        security_file_post_open+0xb3/0x260 security/security.c:2755
>        do_open fs/namei.c:4839 [inline]
>        path_openat+0x148a/0x1d60 fs/namei.c:5000
>        do_file_open+0x23e/0x4a0 fs/namei.c:5029
>        do_sys_openat2+0x115/0x200 fs/open.c:1417
>        do_sys_open fs/open.c:1423 [inline]
>        __do_sys_openat fs/open.c:1439 [inline]
>        __se_sys_openat fs/open.c:1434 [inline]
>        __x64_sys_openat+0x138/0x170 fs/open.c:1434
>        do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>        do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>        entry_SYSCALL_64_after_hwframe+0x77/0x7f
>=20
> -> #2 (&p->frag_sem){.+.+}-{4:4}:
>        down_read+0x97/0x200 kernel/locking/rwsem.c:1574
>        fill_read_buffer fs/configfs/file.c:66 [inline]
>        configfs_read_iter+0x1cf/0x620 fs/configfs/file.c:88
>        __kernel_read+0x4d3/0x970 fs/read_write.c:532
>        integrity_kernel_read+0x89/0xd0 security/integrity/iint.c:28
>        ima_calc_file_hash_tfm security/integrity/ima/ima_crypto.c:222 [in=
line]
>        ima_calc_file_hash+0x45d/0x8a0 security/integrity/ima/ima_crypto.c=
:280
>        ima_collect_measurement+0x521/0xa10 security/integrity/ima/ima_api=
.c:300
>        process_measurement+0x1282/0x1c20 security/integrity/ima/ima_main.=
c:425
>        ima_file_check+0xe1/0x130 security/integrity/ima/ima_main.c:685
>        security_file_post_open+0xb3/0x260 security/security.c:2755
>        do_open fs/namei.c:4839 [inline]
>        path_openat+0x148a/0x1d60 fs/namei.c:5000
>        do_file_open+0x23e/0x4a0 fs/namei.c:5029
>        do_sys_openat2+0x115/0x200 fs/open.c:1417
>        do_sys_open fs/open.c:1423 [inline]
>        __do_sys_openat fs/open.c:1439 [inline]
>        __se_sys_openat fs/open.c:1434 [inline]
>        __x64_sys_openat+0x138/0x170 fs/open.c:1434
>        do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>        do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>        entry_SYSCALL_64_after_hwframe+0x77/0x7f
>=20
> -> #1 (&buffer->mutex){+.+.}-{4:4}:
>        __mutex_lock_common kernel/locking/rtmutex_api.c:559 [inline]
>        mutex_lock_nested+0x5a/0x1d0 kernel/locking/rtmutex_api.c:578
>        configfs_read_iter+0x73/0x620 fs/configfs/file.c:86
>        __kernel_read+0x4d3/0x970 fs/read_write.c:532
>        integrity_kernel_read+0x89/0xd0 security/integrity/iint.c:28
>        ima_calc_file_hash_tfm security/integrity/ima/ima_crypto.c:222 [in=
line]
>        ima_calc_file_hash+0x45d/0x8a0 security/integrity/ima/ima_crypto.c=
:280
>        ima_collect_measurement+0x521/0xa10 security/integrity/ima/ima_api=
.c:300
>        process_measurement+0x1282/0x1c20 security/integrity/ima/ima_main.=
c:425
>        ima_file_check+0xe1/0x130 security/integrity/ima/ima_main.c:685
>        security_file_post_open+0xb3/0x260 security/security.c:2755
>        do_open fs/namei.c:4839 [inline]
>        path_openat+0x148a/0x1d60 fs/namei.c:5000
>        do_file_open+0x23e/0x4a0 fs/namei.c:5029
>        do_sys_openat2+0x115/0x200 fs/open.c:1417
>        do_sys_open fs/open.c:1423 [inline]
>        __do_sys_openat fs/open.c:1439 [inline]
>        __se_sys_openat fs/open.c:1434 [inline]
>        __x64_sys_openat+0x138/0x170 fs/open.c:1434
>        do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>        do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>        entry_SYSCALL_64_after_hwframe+0x77/0x7f
>=20
> -> #0 (&ima_iint_mutex_key[depth]){+.+.}-{4:4}:
>        check_prev_add kernel/locking/lockdep.c:3181 [inline]
>        check_prevs_add kernel/locking/lockdep.c:3300 [inline]
>        validate_chain kernel/locking/lockdep.c:3924 [inline]
>        __lock_acquire+0x15ff/0x2e40 kernel/locking/lockdep.c:5254
>        lock_acquire+0x115/0x350 kernel/locking/lockdep.c:5908
>        __mutex_lock_common kernel/locking/rtmutex_api.c:559 [inline]
>        mutex_lock_nested+0x5a/0x1d0 kernel/locking/rtmutex_api.c:578
>        process_measurement+0x7e0/0x1c20 security/integrity/ima/ima_main.c=
:319
>        ima_file_check+0xe1/0x130 security/integrity/ima/ima_main.c:685
>        security_file_post_open+0xb3/0x260 security/security.c:2755
>        do_open fs/namei.c:4839 [inline]
>        path_openat+0x148a/0x1d60 fs/namei.c:5000
>        do_file_open+0x23e/0x4a0 fs/namei.c:5029
>        file_open_name fs/open.c:1375 [inline]
>        filp_open+0x16d/0x1d0 fs/open.c:1392
>        fsg_lun_open+0x6c/0xe00 drivers/usb/gadget/function/storage_common=
.c:194
>        fsg_store_file+0x19e/0x400 drivers/usb/gadget/function/storage_com=
mon.c:455
>        flush_write_buffer fs/configfs/file.c:207 [inline]
>        configfs_write_iter+0x33a/0x430 fs/configfs/file.c:229
>        new_sync_write fs/read_write.c:595 [inline]
>        vfs_write+0x61e/0xbb0 fs/read_write.c:687
>        ksys_write+0x156/0x270 fs/read_write.c:739
>        do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>        do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>        entry_SYSCALL_64_after_hwframe+0x77/0x7f
>=20
> other info that might help us debug this:
>=20
> Chain exists of:
>   &ima_iint_mutex_key[depth] --> &p->frag_sem --> &common->filesem
>=20
>  Possible unsafe locking scenario:
>=20
>        CPU0                    CPU1
>        ----                    ----
>   lock(&common->filesem);
>                                lock(&p->frag_sem);
>                                lock(&common->filesem);
>   lock(&ima_iint_mutex_key[depth]);
>=20
>  *** DEADLOCK ***
>=20
> locks held by syz-executor428/5602: 4, last CPU#0:
>  #0: ffff88801d734510 (sb_writers#8){.+.+}-{0:0}, at: file_start_write in=
clude/linux/fs.h:2753 [inline]
>  #0: ffff88801d734510 (sb_writers#8){.+.+}-{0:0}, at: vfs_write+0x231/0xb=
b0 fs/read_write.c:683
>  #1: ffff888028b16678 (&buffer->mutex){+.+.}-{4:4}, at: configfs_write_it=
er+0x81/0x430 fs/configfs/file.c:226
>  #2: ffff888025f30b68 (&p->frag_sem){.+.+}-{4:4}, at: flush_write_buffer =
fs/configfs/file.c:205 [inline]
>  #2: ffff888025f30b68 (&p->frag_sem){.+.+}-{4:4}, at: configfs_write_iter=
+0x23b/0x430 fs/configfs/file.c:229
>  #3: ffff888038eee198 (&common->filesem){++++}-{4:4}, at: fsg_store_file+=
0x163/0x400 drivers/usb/gadget/function/storage_common.c:452
>=20
> stack backtrace:
> CPU: 0 UID: 0 PID: 5602 Comm: syz-executor428 Not tainted syzkaller #0 PR=
EEMPT_{RT,(full)}=20
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS G=
oogle 07/24/2026
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  print_circular_bug+0x2e2/0x300 kernel/locking/lockdep.c:2059
>  check_noncircular+0x12f/0x150 kernel/locking/lockdep.c:2191
>  check_prev_add kernel/locking/lockdep.c:3181 [inline]
>  check_prevs_add kernel/locking/lockdep.c:3300 [inline]
>  validate_chain kernel/locking/lockdep.c:3924 [inline]
>  __lock_acquire+0x15ff/0x2e40 kernel/locking/lockdep.c:5254
>  lock_acquire+0x115/0x350 kernel/locking/lockdep.c:5908
>  __mutex_lock_common kernel/locking/rtmutex_api.c:559 [inline]
>  mutex_lock_nested+0x5a/0x1d0 kernel/locking/rtmutex_api.c:578
>  process_measurement+0x7e0/0x1c20 security/integrity/ima/ima_main.c:319
>  ima_file_check+0xe1/0x130 security/integrity/ima/ima_main.c:685
>  security_file_post_open+0xb3/0x260 security/security.c:2755
>  do_open fs/namei.c:4839 [inline]
>  path_openat+0x148a/0x1d60 fs/namei.c:5000
>  do_file_open+0x23e/0x4a0 fs/namei.c:5029
>  file_open_name fs/open.c:1375 [inline]
>  filp_open+0x16d/0x1d0 fs/open.c:1392
>  fsg_lun_open+0x6c/0xe00 drivers/usb/gadget/function/storage_common.c:194
>  fsg_store_file+0x19e/0x400 drivers/usb/gadget/function/storage_common.c:=
455
>  flush_write_buffer fs/configfs/file.c:207 [inline]
>  configfs_write_iter+0x33a/0x430 fs/configfs/file.c:229
>  new_sync_write fs/read_write.c:595 [inline]
>  vfs_write+0x61e/0xbb0 fs/read_write.c:687
>  ksys_write+0x156/0x270 fs/read_write.c:739
>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>  do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f29897e19a9
> Code: c0 79 93 eb d5 48 8d 7c 1d 00 eb 99 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 d8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffe566936c8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> RAX: ffffffffffffffda RBX: 00002000000002c0 RCX: 00007f29897e19a9
> RDX: 0000000000000005 RSI: 00002000000003c0 RDI: 0000000000000005
> RBP: 0000200000000200 R08: 00005555573c7560 R09: 00005555573c7560
> R10: 00005555573c7560 R11: 0000000000000246 R12: 6769666e6f632f2e
> R13: 0000000000000002 R14: 431bde82d7b634db R15: 00007f298984104b
>  </TASK>
> mass_storage.0/lun.0: file too small: file0
>=20
>=20
> ---
> If you want syzbot to run the reproducer, reply with:
> #syz test: git://repo/address.git branch-or-commit-hash
> If you attach or paste a git patch, syzbot will apply it before testing.
