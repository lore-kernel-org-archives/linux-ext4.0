Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F3A13822A9
	for <linux-ext4@vger.kernel.org>; Mon, 23 Mar 2026 22:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774303432; cv=pass; b=p5JafiOqghQq5dJdgOrbth3nr+ObjGDIkD2HeOKrE3woH/jHGzH0cqcpWMfFUHUzaJGDlyRYdqY9sTlVceBYBydaAiPinfo8KZfJsY5WLOm9RzEZsziFY1FCNYb+JOp1OH2xml0Htf9ECZfRVlJ5RcxKRNLzt7Zy2lHw7pBwkxY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774303432; c=relaxed/simple;
	bh=isQFDI7d05AvIlrp9iqnyQriaU043z6DYylvG6vWhF4=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=ZNWG4LeUSHtTwfG2RUyKhGJTz7+j7WRKwC+VasAL4jMkran5fNfsLFm6HG6f/Mv4JC0F+dtdW9VWGyucX/o3DHOAyZlS8XTy0fT9zIR3R5Mjs9lDuS4P7HPddi6cjlkfpNCBCd8WRzXaY2EwiEwuoB2OKQWIFP3qtTzX1pY2pAs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=K3fNt6Hz; arc=pass smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="K3fNt6Hz"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-509062d829dso100751cf.1
        for <linux-ext4@vger.kernel.org>; Mon, 23 Mar 2026 15:03:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774303430; cv=none;
        d=google.com; s=arc-20240605;
        b=O1BGZhxktQxPcxqWasjfe8MTObbVtNb0qeC5K+D5AWZdRCuzow6gIRhc9E0O0YJ4Mn
         csVpOLGw688vupwV6ERkasp3LTiOxGD+aCAj+zcxDd1S1NIvcvPEd1MxgbFPtjbXBWvK
         fb1J0bwnygg5iaWTeyG+l8U3q0PQ/ReFxUJYDBKw6WlZXxyygc1TqDMvsmwKJOm4KzDM
         kgjG3WygqXtMwVbLY5a1mCBMh6kVSHEX7l7ox34JiETqZyO8Oi4jNVGQKVSIvl7FKno8
         ICJueo8AW0JkU5G0ia7vFNN8/A6oHIbhA2ci04qDC396ISTZI9BfMOoKdKhMwoxYtI6J
         FxqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=o1eGtSxZYUuz2uzB/0xmbY0GGzJTsHFF98WP24mcOxI=;
        fh=CBMiLPm+KsLFkfrdbBvPh2UEFXHn7tfuOwf8n0+jNnI=;
        b=eP71rj4txN2NdF9hgv/YjgiOJVX1GkpWstjIOqjdvT23RZLu+P8ZVy1b3Imm6gCy+0
         NwBjqi52I0LmLNFSlwnw5tKG/BgfZp8sXTZcfO2mc9JU03XkZ5C4RewRRLW6H5LOyJxz
         XOzhH9o0a+Tv45Ue2VCg6yuFquVF7ZCVbbsxzGDznMPOXI0KuS5VT4HjCO01HlCyw5Ux
         FjV/iADHD6GlwzQDXSq37hCheJDF3hoo/TruLJp6u/X3KySGmjlL2Smz6aElvl5QifO7
         efm0Sxjm7uVV2K+i0d/VAVnOS/Xfvq6T9NJW6Koh5jPQG+t+t9OZ9z+HO2LA3SPVFS+6
         0WBA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774303430; x=1774908230; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=o1eGtSxZYUuz2uzB/0xmbY0GGzJTsHFF98WP24mcOxI=;
        b=K3fNt6HzXpYnOTnwLtrEjVhhBv7zXHOrjFBtbAxr+ZyS7FR2fUfxCnZWbOSCEmrN0A
         LCQcPnw6Cow7sGLE0ftcBkWmtyaZkG9XfjNhyY911L3hu2NmurLlPdvOB99h8OXY1Zjx
         tJMiasHwW3RvN5cOsQ7jEDr640+2Ofc2nHTW6PJ/UJmCwvL92iVHBmYaetkxp9c8oj9y
         xruAfeWok1v5EP1VlX/oczgtAhlBRa90mOK5hf82vL8dNFZOuSrddVwdDb7JKa6N2Sct
         FFF3/slkc7qnL5QzRsRp6R7EfNdH5C4dtpO9Vr9+kQD8iTzV1/gU1BuiD8pKJzgfWkoy
         2Kgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774303430; x=1774908230;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o1eGtSxZYUuz2uzB/0xmbY0GGzJTsHFF98WP24mcOxI=;
        b=lhPZe0GNo9jgUlNOBpszMGlps0zKqS5LIMxPWsnpkf59BfcvRzHHYmMjGiri7W22cu
         q7H47e2pPlm+Uw6MXv+EtipqjTzi7jaw7oNGYjCUHtMLGbPr0QCl+HhXs8/zNWiok6je
         rIyVgwld0ABWeBzLlY4ShvirStIV1p9wniRJq2b/p8S/orQ5PZsQyUOusKCFT91C8dDT
         QB7pwUie5BRHE0j4qnvAZd+VORTbtETx/I4Xj8mmOeqP7oDtulccOCj4T/yJQazlqkmt
         xudg5HeEWA3DCu7lMig6l7KexzTarPb+JjP+tWOTX8qZFGDPKS+kjn3qonPHcuEVFF3L
         s2Rw==
X-Forwarded-Encrypted: i=1; AJvYcCU/bVv3XI/2u1RX9kFllFnSXyBO8SdvdKayompaXiuU8rqzjlwXaIGp4ekYOkgkq4S1r/qUv2FGzqAd@vger.kernel.org
X-Gm-Message-State: AOJu0YyBSGP7kl8NUNI+omXKlEPcj+FbnBzZooUfwJH572hGAXNYpAI4
	imyuzsBN+y/9ZGJrs41lwfT9nKH8qUcZDe0lDzkA0EBRD3mYFym9SMX2eJ/NRcIHuA2dYNeFJn3
	7SeMRhRix2/ACPEtUz2f7lLxKWD9/VtWIhvbI5Oa9
X-Gm-Gg: ATEYQzy7mKxdGj0HCEUgAZbTbR4r1Sl89PI+6p+tHbojUSUYM7GlAxx0iyC6AZQBzrT
	25rnffgbds8ozDGzXunUl2dqRHedf9T0+lSsNm56a1rsPLslYNDbZLFx06o/Y8AIXaJGQkwm6vB
	HV1jSExaCp0CkJRR2NIDnzM8lXXNM/uXHA8ZouA3ISZQfZgBtUZfkYS34u2w2348HEJsMrmyqNh
	+yt8Aa9EPYaqPHzEaDBAwsEheVBnVrokWvltsWCYgQlDUIu57P5hNQ5HqBhmJthj2BMNRbjrxVV
	mKTJhDvpSSLEhdPJzZhF9AX+dk3DlEOW9d0=
X-Received: by 2002:a05:622a:9009:b0:506:1f23:e22c with SMTP id
 d75a77b69052e-50b6fb9bd95mr4925811cf.6.1774303429792; Mon, 23 Mar 2026
 15:03:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Chenglong Tang <chenglongtang@google.com>
Date: Mon, 23 Mar 2026 15:03:39 -0700
X-Gm-Features: AQROBzCJ71kjMcg47Y9l0d3oTHYV_D4QnyFW5DxoPbe2RkRTxMNDx_bzID4OPcQ
Message-ID: <CAOdxtTadAFH01Vui1FvWfcmQ8jH1O45owTzUcpYbNvBxnLeM7Q@mail.gmail.com>
Subject: [REGRESSION] fs/overlayfs/ext4: Severe jbd2 lock contention and
 journal starvation on concurrent copy-up (v6.6 -> v6.12)
To: linux-unionfs@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	regressions@lists.linux.dev
Cc: jack@suse.com, Jan Kara <jack@suse.cz>, miklos@szeredi.hu, 
	Amir Goldstein <amir73il@gmail.com>, tytso@mit.edu, adilger.kernel@dilger.ca, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, Kevin Berry <kpberry@google.com>, 
	Robert Kolchmeyer <rkolchmeyer@google.com>, Deepa Dinamani <deepadinamani@google.com>, 
	He Gao <hegao@google.com>
Content-Type: text/plain; charset="UTF-8"

Hi all,

We are tracking a severe performance regression in Google's
Container-Optimized OS (COS) that appeared when moving from the 6.6
LTS kernel to the 6.12 LTS kernel.

Under concurrent CI workloads (specifically, many containers doing
Python package compilation / .pyc generation simultaneously), the 6.12
kernel suffers from massive jbd2 journal contention. Processes hang
for 20-30 seconds waiting for VFS locks and journal space. On 6.6, the
exact same workload completes in ~4 seconds.

# Environment:
* Host FS: ext4 (backed by standard cloud block storage)
* Container FS: OverlayFS (Docker)
* Machine: n2d-highmem-96 (96 vCPU, high memory)
* Good Kernel: 6.6.87
* Bad Kernels: 6.12.55, 6.12.68

# The Bottleneck
During the 20+ second hang, `cat /proc/<pid>/stack` reveals three
distinct groups of blocked processes thrashing on the jbd2 journal.
The OverlayFS copy-up mechanism seems to be generating so many
synchronous ext4 transactions that it exhausts the jbd2 transaction
buffers.

1. Journal Space Exhaustion (Waiting to start transaction):
[<0>] __jbd2_log_wait_for_space+0xa3/0x240
[<0>] start_this_handle+0x42d/0x8a0
[<0>] jbd2__journal_start+0x103/0x1e0
[<0>] __ext4_journal_start_sb+0x129/0x1c0
[<0>] __ext4_new_inode+0x7cd/0x1290
[<0>] ext4_create+0xbc/0x1b0
[<0>] vfs_create+0x192/0x250
[<0>] ovl_create_real+0xd5/0x170
[<0>] ovl_create_or_link+0x1d7/0x7f0

2. VFS Rename / Copy-up Contention (Blocked by the slow sync):
[<0>] lock_rename+0x29/0x50
[<0>] ovl_copy_up_flags+0x84c/0x12e0
[<0>] ovl_create_object+0x4a/0x120
[<0>] vfs_mkdir+0x1aa/0x260
[<0>] do_mkdirat+0xb9/0x240

3. Synchronous Flush Blocking:
[<0>] jbd2_log_wait_commit+0x107/0x150
[<0>] jbd2_journal_force_commit+0x9c/0xc0
[<0>] ext4_sync_file+0x278/0x310
[<0>] ovl_sync_file+0x2f/0x50
[<0>] ovl_copy_up_metadata+0x455/0x4b0

# Minimal Reproducer
The issue is easily reproducible by triggering 20 concurrent cold
Python imports in Docker, which forces OverlayFS to copy-up the
`__pycache__` directories and write the `.pyc` files.

```bash
# 1. Build a clean image with no pre-compiled bytecode
cat << 'EOF' > Dockerfile
FROM python:3.10-slim
RUN pip install --quiet google-cloud-compute
RUN find /usr/local -type d -name "__pycache__" -exec rm -rf {} +
EOF
docker build -t clean-import-test .

# 2. Fire 20 concurrent imports
for i in {1..20}; do
  docker run --rm clean-import-test bash -c 'time python -c "import
google.cloud.compute_v1"' > clean_test_cold_$i.log 2>&1 &
done
wait
grep "real" clean_test_cold_*.log
```

On 6.6.87, all 20 containers finish in ~4.3s.
On 6.12.x, they hang and finish between 17s and 27s. Bypassing disk
writes completely mitigates the regression on 6.12 (using
PYTHONDONTWRITEBYTECODE=1), confirming it is an ext4/overlayfs I/O
contention issue rather than a CPU scheduling one.

Because the regression spans from 6.6 to 6.12, bisection is quite
heavy. Before we initiate a full kernel bisect, does this symptom ring
a bell for any ext4 fast_commit, jbd2 locking, or OverlayFS
metacopy/sync changes introduced during this window?

Any pointers or patches you'd like us to test would be greatly appreciated.

Thanks,
Chenglong Tang
Google Container-Optimized OS Team
