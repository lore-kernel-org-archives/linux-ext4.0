Received: from mail-lf2-f13.google.com (mail-lf2-f13.google.com [74.125.229.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A2E629DB64
	for <linux-ext4@vger.kernel.org>; Wed, 16 Sep 2026 08:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789549123; cv=none; b=OW1bfRWbh1erLy4xndOIstPnDXf/OrKn7IxzOUbbIZsPVwnoqbONNDPZNyqikhwIQeOJXBZGlCJLWAf1gkWJXBXhRQLnVLxONmHDQzVgoJN4axxu02GdEnsSqivZwM9zVCAQEmq+nfYfn+TlBF2s6hT3douxVzz2B1RVKtlEhpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789549123; c=relaxed/simple;
	bh=SWwmwhF/lK4mo6tWeHvhs/9NiTbhXGi4xKIfITy1hB8=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=JRB4FNKUg5cgx5peuUlqts7SAiF+KpK2P2rLN034grjydQIVqT0tDh4BSrqDwHsygBoDDKNuWOgiSwYTeGtBjaf1ci5pXBUS5Fey8b0rQ0xU9rb+IK5WOnUtS+JnOuvWigvC7GXm1drQOuM8amnKOLgTgai1r62KTSNbDUHFM1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e7pF3zUC; arc=none smtp.client-ip=74.125.229.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e7pF3zUC"
Received: by mail-lf2-f13.google.com with SMTP id 2adb3069b0e04-5b5e4f1b846so814021e87.0
        for <linux-ext4@vger.kernel.org>; Wed, 16 Sep 2026 01:58:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789549114; x=1790153914; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:subject:from:cc:to
         :content-language:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=27wF7sOQsQpdHjhuENpiyoOL73aDFHmGdfUlXCBklxY=;
        b=e7pF3zUCXshEKteKLt2eWVUuZJVoL4RvAiX8KoIBhctkGhbp4MYOIMKQ/Dq9JnggrT
         N+2LwljIh91qVJX/Qin/pRNuOQbE3SGt75kBnstv7Qoho6vhGYG+NmcBdBd1pVvISBjV
         i0aidjFiScpO6BmrKN+7Krbd5JVJg7uWxNqZxgR59VmPjqq56yB/BqUrQk1BPPhCU9Pe
         kXi+GN2s2TF9QUqIbKz/0l0oo8LSJiqSjHBzj6iu08++fsJ3tAkj/7R9f9z9JHxmXBbm
         7WPGb2808GBj4M+Q8iDfsvmH+e46GXdGUO4FflaK7YACQI4yqzR6LfrWroyFZOCNTU+F
         W5gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789549114; x=1790153914;
        h=content-transfer-encoding:content-type:subject:from:cc:to
         :content-language:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=27wF7sOQsQpdHjhuENpiyoOL73aDFHmGdfUlXCBklxY=;
        b=vH8fzzTQiAsIE6xjKc8mFLNoJMoSUVb/ZDm124+zceqzuB/Vcwif7eWtKsj/t+nBOw
         ItbpIlI7fE3Y1OLyJ0OWlGAkbeI8+djVycEhwJVOsFwn7+Jt0akDdNuRMgHyVXijp043
         jmq6ilytG91NOJyUMibErf7vUkQ/hwlafgYe5uTIMjBXQ+2hEJwQslIqO1jxwwm8PzjZ
         +7rSBCmYPzhcdfqo95HyvcHcAXD+ajcbQSlDADSiBeZzwoiZ8+DWPIGN3iWU5EiI+w/H
         Q0LXKUIUNyH0ZWUpu63/BrzpQqVuFZHMh2OOGkl+q7UnpPGfyPLL70qCHPLRkfpQFOlT
         GdNA==
X-Gm-Message-State: AFuF++mhKWLx904uIYa1CC5aDAxQ/Sz9OWfreP/Zm2eoMj0YKmKEg4aH
	bY5g1cPpvsrqslN2baA7Eq4wn+VQkVdrhcN0gjf/Rgxbza6nCwieZ+fb
X-Gm-Gg: AYBFou1ArrmDDlqPiUGouyVCwt9nccmfyprEibJNzOsDrLcMabacejYI6j/tgWuENMg
	SaxcyhikMU4Gtn7m0sa10RpIQ81YfJ3pWuXqb/QaPtW0TZcOBORsJblTexXhGq/BIzsIM4K5LDl
	cDCscGcgvanuNsTax5qiLPOa94WFmAT4hfpghyxHy2utEKsbXkhi/kfLc1H/ksrkl0RK3Ej29k0
	T6KPR2T2wQPj3fnJBisO7v2UU6Orh3Z59gii96tkN+PCNEEtQRWVII29uUyteZfOh6TxY6rfVJ1
	Dmv8O3mCzSWmWoPIbOEOOYDC8DCeFu/0Sk2cd8Cfvu/omVe481e4BaPR+4WYbSfBCvNGPXjRysR
	tybVTEZLE3iZ6gPE3hB9HyxJMVCvCHJ0PtiyNf1/1Sq+TPZIZH+zHcoi7Q5JqHt/ITXPYb4lknB
	qLsMw1z0FjhFpby28+QWAaRvNHsfN0HKhsYPu80Oln6/rOQvEzw9cu3glLbaD/Jh9+IVAmhmt7/
	oxlrlZ45XcarvzcpnfnUTcMVGXl+ebE
X-Received: by 2002:a05:6512:3a87:b0:5b7:a150:8795 with SMTP id 2adb3069b0e04-5b8b663ddc9mr521527e87.36.1789549113541;
        Wed, 16 Sep 2026 01:58:33 -0700 (PDT)
Received: from [10.128.170.180] ([77.234.210.12])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b8b57e229csm661272e87.66.2026.09.16.01.58.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Sep 2026 01:58:32 -0700 (PDT)
Message-ID: <66b5fc3d-620d-4582-9b30-50c85984f612@gmail.com>
Date: Wed, 16 Sep 2026 11:58:29 +0300
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: tytso@mit.edu
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
From: Vyacheslav Kovalevsky <slava.kovalevskiy.2014@gmail.com>
Subject: [BUG] ext4: generic/764 failed when using fast_commit option (error
 loading journal)
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hello, when testing ext4 with fast_commit enabled (Ubuntu 24.04, Linux 
6.8) I encountered this test failure:

```log
generic/764        [failed, exit status 1]- output mismatch (see 
/root/xfstests-dev/results//generic/764.out.bad)
     --- tests/generic/764.out   2026-09-16 08:04:58.023597440 +0000
     +++ /root/xfstests-dev/results//generic/764.out.bad 2026-09-16 
08:36:05.821198201 +0000
     @@ -1,2 +1,5 @@
      QA output created by 764
     -Silence is golden
     +mount: /mnt/scratch: mount(2) system call failed: Structure needs 
cleaning.
     +       dmesg(1) may have more information after failed mount 
system call.
     +mount -o acl,user_xattr /dev/mapper/flakey-test.764 /mnt/scratch 
failed
     +(see /root/xfstests-dev/results//generic/764.full for details)
     ...
     (Run 'diff -u /root/xfstests-dev/tests/generic/764.out 
/root/xfstests-dev/results//generic/764.out.bad'  to see the entire diff)
check: possible mount failures (see 
/root/xfstests-dev/results//generic/764.mountfail)
```

764.out.bad:

```log
root@ubuntu:~/xfstests-dev# cat ./results/generic/764.out.bad
QA output created by 764
mount: /mnt/scratch: mount(2) system call failed: Structure needs cleaning.
        dmesg(1) may have more information after failed mount system call.
mount -o acl,user_xattr /dev/mapper/flakey-test.764 /mnt/scratch failed
(see /root/xfstests-dev/results//generic/764.full for details)
```

764.mountfail:

```log
[ 1224.887075] run fstests generic/764 at 2026-09-16 08:36:05
[ 1225.042597] EXT4-fs (dm-0): mounted filesystem 
7cfe268c-25e3-4c01-90c7-c933198fe125 r/w with ordered data mode. Quota 
mode: none.
[ 1225.062913] EXT4-fs (dm-0): unmounting filesystem 
7cfe268c-25e3-4c01-90c7-c933198fe125.
[ 1225.078714] JBD2: journal recovery failed
[ 1225.078717] EXT4-fs (dm-0): error loading journal
```

Config info:

```log
FSTYP         -- ext4
PLATFORM      -- Linux/x86_64 ubuntu 6.8.0-139-generic #139-Ubuntu SMP 
PREEMPT_DYNAMIC Sat Aug  1 03:52:05 UTC 2026
MKFS_OPTIONS  -- -F -O fast_commit /dev/loop1
MOUNT_OPTIONS -- -o acl,user_xattr /dev/loop1 /mnt/scratch
```

OS information:

```json
{
         "Hostname" : "ubuntu",
         "StaticHostname" : "ubuntu",
         "PrettyHostname" : null,
         "DefaultHostname" : "localhost",
         "HostnameSource" : "static",
         "IconName" : "computer-vm",
         "Chassis" : "vm",
         "Deployment" : null,
         "Location" : null,
         "KernelName" : "Linux",
         "KernelRelease" : "6.8.0-139-generic",
         "KernelVersion" : "#139-Ubuntu SMP PREEMPT_DYNAMIC Sat Aug  1 
03:52:05 UTC 2026",
         "OperatingSystemPrettyName" : "Ubuntu 24.04.5 LTS",
         "OperatingSystemCPEName" : null,
         "OperatingSystemHomeURL" : "https://www.ubuntu.com/",
         "HardwareVendor" : "QEMU",
         "HardwareModel" : "Standard PC _Q35 + ICH9, 2009_",
         "HardwareSerial" : null,
         "FirmwareVersion" : "Arch Linux 1.17.0-2-2",
         "FirmwareVendor" : "SeaBIOS",
         "FirmwareDate" : 1396310400000000,
         "MachineID" : "91b0356bbe954341a29ab510f38d09be",
         "BootID" : "c5a11924033a42469f837e676984f813",
         "ProductUUID" : null
}
```

Also tested on Linux 7.2 (upstream) & 6.17.0-29-generic (Ubuntu 25.10).

I reported this issue previously here (did not know about the existing 
test failing):
<https://lore.kernel.org/linux-ext4/CAAJYhwzHRMipEy=mrH_FwELcSCCk9zK7ifzy0cuuWMzX3wmVtg@mail.gmail.com/>.

