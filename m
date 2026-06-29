Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C0CE3BBFB3
	for <linux-ext4@vger.kernel.org>; Mon, 29 Jun 2026 07:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782716685; cv=pass; b=B6NFiM9qvfrWamR+YNEc6siJWxx5paRyWN00dG2NnZJPtCFUussdKUe2UUSP4q/5i38yVV2C4ey8Ozu4hsPb8f89tKWoBCOxHNzfu9YHJmya0OK+KIIS7wYCyd6j+JHfCPRgsjdZP44rqIBfK4/6ejl1VmjoFSzPXRNnHGQiGn8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782716685; c=relaxed/simple;
	bh=fXSOPNn/tgVP6on0PNHI2b8JgvAXy3h9raj6L5zjy7o=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=ek2l3zXKQkaubDXbHPl5gEK6g24p0P/Hn7H+S3TYp0V7Gs7c9UJKg30f7b1Ded3VHNSFvaZzs1v+7/6z8AJPkFUGoYvFUv5AEJDPNn8afw7pvwyWxGHOoQQzA9+LI0ePr/xC7gCe++NQytR7DJIBx4S+6oDc4OKIFxNWyTHylyo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=n9TECdOf; arc=pass smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="n9TECdOf"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-51a868b6962so37981621cf.2
        for <linux-ext4@vger.kernel.org>; Mon, 29 Jun 2026 00:04:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782716683; cv=none;
        d=google.com; s=arc-20260327;
        b=UwFMCZLBxEGASaPJ+hYT8T/PLXJyTvpw5Uz/97hxFy0ZZ479tS2OCkXBbIS/RhVPyp
         tyf2lDNEnNdIm36ffGSdnf7wAfQKyfPExHnv8FqcjKchifKBBPyz0a+gTCjIjdx/1S+O
         iHKJIzm1Cni7uwonL+WZNs4isynhpqDz/w+KUelzSIne1Q7CvEomV6y9aT7BFGmGTwBp
         /BDE0Yy4zYgwCGC/UtjddXKXWrsfifWMm3k9IQn4wCmoyytJLeINuvilnIJWemQacee7
         Nn/VVk6LK+ooW8ZBI200TFjlqPTx0LEz10nL+6Ti8lU1vFHqv0AhaJyS5xwwUOiZe5BM
         RG4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=fXSOPNn/tgVP6on0PNHI2b8JgvAXy3h9raj6L5zjy7o=;
        fh=BGmL7FjYrbTto+Q1gxqEaj+9hKTO5JMKP8E9fZEJHwA=;
        b=W+R2lWgGQZbmaDaKrOxwOF/P/ThHZhfcGgXlD+57xXWELQjJ/b6njjkTfZNWZN1ITK
         iZ6u3zkKKs79CF+tsOSGGCztch245KKON19KKlEByEh8BoNT7ldq46fqzt8sxif0VT0z
         q9prXRjdEuz1/0Ysmas2ziITtHEyuJNBw+iDd6llHh1P7jEsnnX/v/qH3PrlJpqaaxcu
         zLrpBr5G5uXqJc7mYtXOdPm6qIbOrRwiEvPBL8FM+K5VL2g7a+ZCcjzzhFk4ZGx3yk9B
         cg9rjPfmS3J8q2CJZcCC8R1Wnjr8dQcXxZgcD5gG7S0mNnov63XyeP0X3Ls99C8OuUHR
         7pLg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782716683; x=1783321483; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=fXSOPNn/tgVP6on0PNHI2b8JgvAXy3h9raj6L5zjy7o=;
        b=n9TECdOfAhN9wq921k/p98cM3nt1L1NM6JN+rgVx9vMn8twPj8dunJgVBgESs4IwRI
         2jIKvl6NBlOUOiv93BnG0aHoLIyX3dNrS5G7aV/Ldar4cUx3Vyc2e1Xrar2EiKwRD+Ik
         DNHn6RbvJzCD/ho6oqk54Qid45noRSfvpcF8p0QoAtDCqDRemoNsK+R9ymO+WeyZaaaj
         g/Dx8wPBHVY3COpFV1YML44HklyoaRDUxVFRSRr7mhyLD8Sq4IDUqnVRHSyesxRaIbyh
         9sWm8+JTJ/klQ1expHfCkdI9+WXBqmGP7vUI7V7XrygoOPJj4ouGNg6Yh7ij7lW7C95Y
         BsTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782716683; x=1783321483;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fXSOPNn/tgVP6on0PNHI2b8JgvAXy3h9raj6L5zjy7o=;
        b=I7EqZ/HdiqdIfK/pMW10HZYzIjWenWLiPKzcNS/DV1qCrT4IoYP2p3gDl0/m2od6zV
         RnOlVs/xX9BQMKPX+cNvEtNJVlOVRXQ8AAmhFKhZXOjwwxzH6W7+dfCpfen+S5MYq4k/
         JQw36aXE04dpwczECQGDLO6zgmPzf2MTrc/hF2XmB1FXxmIdPq50EubM7uKOMUszlvGj
         RsCOv5L1NVKhEP0JkyIx/UVrsxb5niYN4UIk27/+yKMONCgNz6bhMYGRbF3ZNT3nxZcL
         wNJHOZSWJD74zwMHjm2MRMySW1L4jycgr2bZ1ul9ZUuuXkm1qE36uhWBgNf1YIgm0PkF
         vTcg==
X-Gm-Message-State: AOJu0Yw0ckUIK01CHzIN7l3kMgcIRAiH+B0O7t5N6ZUictKa3vvdRo+c
	PvFWLlrg8J/vXz0H0JK7kfZdOO1cuO5d1ELfSc9sJmdf/2LcRc+SicxRWtyPxuJrLnKoUu2+lmS
	eiHVn6TXwCajncVD345DTj0N8aSNhqF0=
X-Gm-Gg: AfdE7ckvgnIW4DA85G2Ci/hpy/U2CpPq9Tm4ygG67tgncefrRnmvT15nXU79k/dxbb1
	r+GGMZNexlHzXx0mwGeuKrqwjIE0MH718lesjxDJzVRcpbfPlhi71/7ZXWwauFfUhOXB1b7FqII
	PiIFeXFnCojRE9yqtS/yf8KZ50QCSrWiOMbVQuLF+7ixboHQIFWDyCODNclLebMJPtLkMr+bW1I
	d8jjr/FtdcWqYHq9gfEdWYTHjWScqHchkGKXD+O8340lyP7iQuNO/l2NraFk2cmY+zwqQg6
X-Received: by 2002:ac8:5ad3:0:b0:51c:88b:d7e3 with SMTP id
 d75a77b69052e-51c088bda64mr3834151cf.3.1782716683212; Mon, 29 Jun 2026
 00:04:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: ZW Tang <tangzw515@gmail.com>
Date: Mon, 29 Jun 2026 15:04:32 +0800
X-Gm-Features: AVVi8CdPW6zuBc138c34ah_PzMRiDMjReKNS7Ir7irk9DIqZo2K6AaE53A6nmCY
Message-ID: <CAA2SOT6Yxxc1xhYkkv4EXYo+dQ8TR5rUbWqOxA2pof9n00TvcQ@mail.gmail.com>
Subject: [BUG] ext4: kernel BUG in ext4_do_writepages during writeback on
 crafted ext4 image
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"

Hi,

I am reporting a kernel BUG triggered by a syzkaller C reproducer on
Linux 7.1.0-rc5. The crash happens in the ext4 writeback path while a
writeback worker is flushing an ext4 filesystem image mounted by the
reproducer.

The system hits a BUG_ON in ext4_do_writepages():

kernel BUG at fs/ext4/inode.c:2825!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI

The reproducer mounts crafted ext4 images through syz_mount_image$ext4,
creates/truncates a file on the mounted filesystem, and then performs
file operations such as sendfile() and mmap(MAP_SHARED). The crash is
then triggered asynchronously from the writeback worker.

This looks like a possible ext4 writeback state inconsistency involving
delayed allocation / journalled-data handling. In particular,
ext4_do_writepages() appears to enter a path where journalled data should
not be present, but the internal ext4 invariant is violated and the
kernel hits BUG_ON.

Reproducer:
C reproducer: https://pastebin.com/Qmq84vS2
console output: https://pastebin.com/Y8KsMt6r
kernel config: https://pastebin.com/raw/fUwrL2uz

Kernel:
HEAD commit:e7ae89a0c97c
git tree: torvalds/linux
kernel version: 7.1.0-rc5 #2 PREEMPT(lazy) (QEMU Ubuntu 24.10)

Crash log:

kernel BUG at fs/ext4/inode.c:2825!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 2419 Comm: kworker/u8:8 Not tainted 7.1.0-rc5 #2
PREEMPT(lazy)
Hardware name: QEMU Ubuntu 24.10 PC (i440FX + PIIX, 1996), BIOS
1.16.3-debian-1.16.3-2 04/01/2014
Workqueue: writeback wb_workfn (flush-7:1)
RIP: 0010:ext4_do_writepages+0x2682/0x3580 inode.c:-1

Call Trace:

ext4_writepages+0x2d7/0x590 inode.c:-1
do_writepages+0x1f6/0x500
__writeback_single_inode+0xb5/0xa90 fs-writeback.c:-1
writeback_sb_inodes+0x5d1/0xd60 fs-writeback.c:-1
wb_writeback+0x175/0x820 fs-writeback.c:-1
wb_workfn+0x1de/0xa10
process_scheduled_works+0x997/0x11d0 workqueue.c:-1
worker_thread+0x453/0xa50 workqueue.c:-1
kthread+0x37b/0x4a0 kthread.c:-1
ret_from_fork+0x435/0x710
ret_from_fork_asm+0x1a/0x30

Modules linked in:
---[ end trace 0000000000000000 ]---

Thanks
