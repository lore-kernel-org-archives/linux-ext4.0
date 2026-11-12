Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.230.64
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794504753;
	b=ovc9i9O07w2O61NZICyO5qSyF0pYetKjclmfPpFJgePs6jrlUpAaxysws0zYhBkMntbN
	 4d18yP8MR/KTgMqo+A2BnLyoIlw73wrsyWj/4h84l6yOdfwtxhDNIe5kcZpkg3WJ/a99r
	 jmeTej4GAIVxXNK4KPVqrObWpSb3EExSBrMzAcowu2I4K0n1TUmsc2TgDcg8QaAD6SFDl
	 xy+NXHRSy8znPzpalzEx/xjveKcCfySYuLNjCPVM4Oacv5FRmgjE9gutS+PWmzDkArreP
	 J668qwFK34GYUGwvAiTG1FLGxA0DC1uat1Pjf5pTjxCHH9fZ4sfnb/fU5HPpbrj2FKA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794504753;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=s5V3bXROIFxLDuWE2BBD8g0HHc+Zbd6IebFzaUb0eQI=;
	b=Dq+xig8eR5MaZzUdqqw8KrxhB018OBxjDCaHXpGIk9JiCiq9SNwB9KOhJlVeAXRzXCFX
	 nJRMna8jx2r3KKA4xS6WyDgWysqGQVdk2WmQy47BIn0Gn0KydVPOwVgxCUaf8o7OF2uLB
	 UJIjUS7IMDl5p3hvC2KQh+th2eGG37XYKg68FuuP1Sa98JgOLCQ6iah6x8fEXe0PUxtSO
	 TR9m34M8x2gLFQ+bm0K8RUH3+TcNI4aF3h1asQlHNPjYnQMoppDaHzVReg/nT+LbNhNJg
	 tVu0NhBJ+CM6xTsQhT0qzvL8nNLixoXWIF0E2LDxWl/aYthD+HYIBr8M5QbaKP9qIsA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=L0Dd9L67;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.230.64
Received: from mail-lr2-f0.google.com (mail-lr2-f0.google.com [74.125.230.64])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEACC606A33D
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 17:32:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EEACC606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=L0Dd9L67
Received: by mail-lr2-f0.google.com with SMTP id 38308e7fff4ca-3ab1cf59ff4so30274781fa.0
        for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 09:32:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794504751; cv=none;
        d=google.com; s=arc-20260327;
        b=RIqOL+fsWTm6RlSmuZa69fl//rEPhpUJNX3Giwr9CfH8ek5tGwex/XsqiFi0btDX2d
         RijsZfp7jbeMvwgmxX5ketJHd3sAbGlTa7H50hoWXJCCtUOpMWZwR9/lhcUuqp5xOGdq
         rKD4vptbC3DnOAGlpZsLvnICHwnE1UkHnNTBEFLI6xHtxNk2Lx/P1NPbXsbM5k1kumbH
         oaHEY1McepcB0bKQWmDSl/8/cAthrQti06H4Fd2Droujeo5syMEtfmuhhFr5Aefv2o8S
         cO/AEhhOkJJCxTvwvJsbjDW7dnES1JamPxEn9gxQVEFZDM0jUzdBzfm3QnHArshGfEuf
         yUtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=s5V3bXROIFxLDuWE2BBD8g0HHc+Zbd6IebFzaUb0eQI=;
        fh=AwMEPUXbb1RpnLGwcMxXPWcT1xDFmxH64A8+Z5McMhw=;
        b=oUJudNsZVikvE2KLHKYX1fk7APO9YFU8yvL9MR+6NSSlNKAjNphQN8E8IKZDueskmG
         yhZhkNeNP8u90J+UHccYfkhD1AfrxM986Xfj3Gws/z6nZzqhBwJJ9ZBCAq/GJBtjrGkm
         FuN3XIuRA1GnXHKTur3n8Lpqy1p1hUolkQMrXeziwZ2V3mX5kDX9bZ0EiBfheqRfNbP/
         Y6ehkviI0aQ4m0yRxeU7WtASEzcaNC5AtWhNekoI784vtBapRzV4WBAsnGvF0slfissA
         91UnqoMIcSUV0bgdc+zmeihz8AVCz1wj9U2Qcy6QCHI9uSPs90inRhaw8KN5is6pCpLP
         ro+w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794504751; x=1795109551; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=s5V3bXROIFxLDuWE2BBD8g0HHc+Zbd6IebFzaUb0eQI=;
        b=L0Dd9L678HnGQBiapI44UhkX1fyM7RuM2bOjunp+d1YuCvCpiPXIs204xKBFhpPxfu
         BtcucDtXk5rtF8XEMuNfUAPZ68W7V+AQkGtBBuLgnaZ3Swxha4VRidkOHQI2jwq5kvTB
         o3Jsm8NgMt7hu/a/R+cd774Dppfr14rAz/CU0PpxeH/7nCXEgpwoDRq3w+kan9GuO6AC
         KcpvsyOLwqeXOqaFzso+lOOK4MxywDBZfRtm9nkV2oV+i7QulE3CDmZzVpGv6wqDVekj
         WWI18M/42G6hNfE1pRA3VMuIa/Jiv6Ef1lpMUfNCF+Mi9ddyDyHyLgzQyll0aqk/n/b+
         x1gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794504751; x=1795109551;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=s5V3bXROIFxLDuWE2BBD8g0HHc+Zbd6IebFzaUb0eQI=;
        b=ooshWPLIE2CVWtLG31YnI9oNLqyq4PI9rS0P7GL2koJVrE854EXgDpBOK31hRHBmv1
         laTdbdYvGozpamqiwIw/QU4lPPX0hzOWL18qJlBBreiQsE3VkpXkzSd8hJYssBiyDc3Y
         tSHDWJk9Bn9Q0hjdXWXZDXd1nGZz8yQoCNJdZcCS7VyRYRjuFKhmhIlGbwT5OSVqP/bv
         oZkessizq+/S0LtfQ0Sxqv9m1uBIHakT4m5fLgsBfXt40DTvUhZkuAIe6DQooF3nIaIh
         78XEbcnGUwdIeG5yFV3MoANKGRoAFoPF90nVH9I8qnbfTKzenFBLH2XNbdoTV/PyOzUn
         eLeQ==
X-Forwarded-Encrypted: i=1; AL+hErE5ojjZU/v3IqXU6sM5LeC2GiPpwUtI1AKV/lL0prDl3Me3pTqWLd6mQDRj032GgiqJ7ISXcET0TaQr@vger.kernel.org
X-Gm-Message-State: APuU4Z/H+BVD+crtNYTXil+2wOZc9+QMeD1/5ZQZYN+BtFciW9vblazB
	Bl8Ik8WBNlsMtRyv9+TTHPulrS9ILN0I/jirDd77ldL/ZiuX//YUlSYsWMWw2bGNFas500tzcZ/
	4C5/M37xAZU4xmx/dnvcW86WOL9yabiw=
X-Gm-Gg: AYBFou0KRKnTwgjro8oohLrMz5A56gVAg/I1jsz9sCsqEQSuMSMaFhlKIdDyWN7ie4X
	4NVA3z1iBbkKG4FrKpz9NloA7DLY2vNK0pimMjjnMpA44wQ3iyg1Rq4i+1UBWANzdsEuvrIfhVl
	0InACL7FEPyxpD7I1idg/2kzb6OxY9AETduqu0RpkLkVDbY2rPEyn0hIk0INEtMHKotamevOQJK
	AzJ6wJIa0/QU8N8ycJd2NIj3aJtXf74lBlVJNfb0PmvkugmSAIVcahGh8hOTBMfauw+TVCdydi1
	CFHlHWDx1OFvcoilHKIttErY6UysBxQRbz6Mm+CFG40jydfHfrdMfknZJVG5nn4UT4B6+amW0po
	xdeN4XlJ+tGnr5WhBfQGlKfIpd0B4hp8Ak7+OuXQ/4KmnbwBkIfG8+xMjMuG0UWXFgc7H
X-Received: by 2002:a05:651c:a146:b0:3aa:fc64:a92c with SMTP id
 38308e7fff4ca-3ae2b430b8amr1043681fa.1.1794504750930; Thu, 12 Nov 2026
 09:32:30 -0800 (PST)
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
From: =?UTF-8?B?6ZOu?= <fengaojigui88@gmail.com>
Date: Fri, 13 Nov 2026 01:32:17 +0800
X-Gm-Features: AclHuK9cJaIHCQg15nBAB43EMz46f2DfLCGOhUselyLxLLlbksac8BXaZnqxYJg
Message-ID: <CAO-4RZ1s92WrO7Cq=x0AsMa5-4iKwzJ8VJ7h6aeSxG19z6B-dw@mail.gmail.com>
Subject: =?UTF-8?Q?=5BBUG=5D_ext4=3A_WARNING_in_ext4=5Fcheck=5Fmap=5Fextents=5Fenv_?=
	=?UTF-8?Q?=E2=80=94_mapping_without_inode=2Finvalidate_lock_=28fs=2Fext4=2Finode=2Ec=3A5?=
	=?UTF-8?Q?17=2C_v7=2E4=2Drc2=29?=
To: tytso@mit.edu
Cc: adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, jack@suse.cz, 
	linux-ext4@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Ted, Baokun, Jan,

We found a reproducible ext4 warning on v7.4-rc2 with syzkaller and
CONFIG_EXT4_DEBUG=y:

  ------------[ cut here ]------------
  !inode_is_locked(inode) &&
!rwsem_is_locked(&inode->i_mapping->invalidate_lock)
  WARNING: fs/ext4/inode.c:517 at
ext4_check_map_extents_env+0x4b4/0x590 fs/ext4/inode.c:517, CPU#0:
syz.8.7999/132148
  RIP: 0010:ext4_check_map_extents_env+0x4b4/0x590 fs/ext4/inode.c:517

The warning occurs when the ext4 extent-mapping path is reached without
either the inode lock or the mapping's invalidate_lock being held,
triggering the debug assertion in ext4_check_map_extents_env().

Call trace and observations:

We observed the same warning through the following call path in two
separate syzkaller crash reports:

  mmap
    -> uprobe_mmap
      -> install_breakpoint
        -> prepare_uprobe
          -> copy_insn
            -> __copy_insn
              -> read_mapping_page
                -> read_cache_page
                  -> filemap_read_folio
                    -> ext4_read_folio
                      -> ext4_mpage_readpages
                        -> ext4_map_blocks
                          -> ext4_check_map_extents_env
                            -> WARN_ON_ONCE

The call trace suggests that the warning is reached when the uprobe
subsystem reads an instruction from a file-backed mapping during mmap.

This causes a page-cache read through ext4_read_folio() and eventually
ext4_map_blocks(). The debug check reports that neither of the two
expected locks is held.

It is not yet clear whether this represents a missing locking
requirement in the file-read path or whether the debug assertion needs
to account for this particular execution path.

The warning itself depends on CONFIG_EXT4_DEBUG=y. Our guest also runs
with panic_on_warn=1, which escalates the warning to a kernel panic.

Kernel/configuration:

Kernel: 7.4.0-rc2-kernsight-kasan #1
Base: v7.4-rc2
CONFIG_KASAN=y
CONFIG_EXT4_FS=y
CONFIG_EXT4_DEBUG=y
CONFIG_PROVE_LOCKING=y
Boot parameters: oops=panic panic_on_warn=1

Reproduction:

The warning was observed during syzkaller fuzzing and reproduced by
our fuzzing pipeline on a fresh VM (pipeline outcome:
confirmed=true, status=verified).

The isolated triggering testcase has not reproduced the warning on
its own. The repository includes the larger multi-program workload
used by the reproducer pipeline.

The documented replay command is:

  syz-execprog -procs=8 -threaded -repeat=0 -executor ./syz-executor
repro.kernsight.prog

This uses parallel execution and repeated replay, rather than a
strictly sequential single-pass execution.

The full crash reports, reproducer programs, kernel configuration
and environment details are available at:

  https://github.com/Zheng-zheng-codes/ext4-check-map-extents-env-warning

The repository includes:

- README.md: warning summary, call trace and reproduction instructions
- reproducer/: syzkaller programs and state-priming material
- kernel.config: complete kernel configuration
- environment.txt: kernel hash, QEMU command line and syzkaller revision
- logs/: original execution logs and crash reports

Could you advise whether the uprobe-triggered file-read path requires
additional locking here, or whether this path should be handled
differently by the ext4 debug assertion?

Happy to provide additional crash instances or raw artifacts if useful.

Best regards,
Zheng Zheng
