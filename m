Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.215.174
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795272595;
	b=0kTPeOuV5/1FD0A3F7E7h1+3rHUJRXOWtn5msG6lCGXqKSpUCkD49+WbwEE5OZz+LOSm
	 vsYi1G94+33xevsOmw3vFgHUvsYJem9bqX1cVdkUqA42WezO6Lc9+msaI2El0olO+Ijir
	 RxW2Ww0Yc5HaJ5pWH3KcthbqlVqtWtwimH4f1KA7+6RDmasARqzTqxjKk4GQSKEAYJuLa
	 axMa45GFIXmwqb2rBHB6MbMY995v/uTtp+5qs+ExscWxNgZef6PPKLo3N0P4A+PWA3RbP
	 hQ/SxTN3Wu1bm2/nsBFUWGKKDMVanvF+2UJ1OCC1eRlj22rTeFJFP2AM/jX8ZHaiK6A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795272595;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=KMleV59mDasfc9ZrDI02cJ4rVcYzhncPH8nN8fIqQw0=;
	b=RoWDqTwicpjjm1PqoAUvyA34AChwLqyHwanaOWdZmagIPkQ4Zv/x0zL1zMnxJEQyoopP
	 0+l3GPZdYJRDlFpG3ZveURTcuUgs0ZR2IHCgGZHCeEaxvozNfkfPcXGaIIt4DpL26PvPz
	 C/9jk2LA6shBD0pTkYXWh6VzK7NGyPnkn7hr63I8ArF65N2NCWwugY9B2ull1z02lBtpH
	 bh1Brw14oS+ofoOZThqbMS6cQXZw05aIVFyATuBMl0uQx+DRKWb6JqemgKGxvJWHz3aCw
	 5TY9BdkMpACEUX3qN/4iUL3mK1E0KVJnCLc4YWqlYIEDYlVEMdUqASNTaKoDK1T1DKg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MLkrnOPN;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.215.174
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BA42606A32A
	for <linux-ext4@vger.kernel.org>; Sat, 21 Nov 2026 14:49:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3BA42606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MLkrnOPN
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-cdb2893531bso1061917a12.1
        for <linux-ext4@vger.kernel.org>; Sat, 21 Nov 2026 06:49:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795272594; cv=none;
        d=google.com; s=arc-20260327;
        b=DBd1JBtkT3YwPAS6BFnrpw2qjezfHrQDxMoQQcfpoKen5qUECUGYTFu3uv58jZmUpG
         eEcH6mc200D4xb7Eco6SFfa4/LfBjj5nOWu42kw4hzhXXQVGIWU1zaTnDfGmIlABHDR4
         z/8zWBofkXEjNA8d1hz6IOOwVP7bPX52+RRxkbRgKFvmfQbr0Nfkeg7F4A0wec8j0o6m
         pFhlON3VqXLB10o1TwAiYNf3RIcBtp/tALi524Cm04Vorh8vfHvM8t31MtX/mLgmqCU1
         T2gOuohqUmTvJPWDXz4MzHSxCnW4WPwbdyTxBMdeNz2Bn6lg4UfilBAQuH+hCVdCIIhm
         1DhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=KMleV59mDasfc9ZrDI02cJ4rVcYzhncPH8nN8fIqQw0=;
        fh=5Uutpn8cusi5upw90ddxO671qoM28IjTHwlkGvgR360=;
        b=LSBdgKdos2mCZwKKUaitxpWX5ASQ5XrgYbsbT47ZNCLxhjRjqZFJ6Bc0JZLxwjOJzv
         Et8dG8B5sEt3rhFnmjUpdik9D0J8gGVREf44LlF6nF02FXZU8Om4P48DTFbsFbYoYoF8
         4MYqrsJpC55NV+kvWmZUPdqO+UzwxGYIXAW+qiWLl2dh11Z71P639CQDpXN8RGWyjYl7
         v6YuMlVVy5W0QD225LPf2YCKmLRVYzw8VZzogoUIMV0GTbuvoDYLusp6CpODaipyKKFa
         ahZvHPuav1/ZT0LlEaRf8riFmCY3b1jsILW6nPo9u1CG8Ausq1kGM+Ap5A67i3283GGP
         hp+g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795272594; x=1795877394; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=KMleV59mDasfc9ZrDI02cJ4rVcYzhncPH8nN8fIqQw0=;
        b=MLkrnOPNCstSi8svs6c1/FDow3Ugv34GJJ0zqaByDNgJM1EvDQpemdnCCYYuMQwuF6
         Urp0eqa0oOqVX3ivri+0b6p+E2lyNnPCSeGULskaa8ObcP7L7xAmq03oROwvjZii4vqS
         ZI4GLeDDHpdLzrnZEXJ2w/KqTHnShY/bOgs1/d/hMfvUeeXZjOaZ4zrE0+eGBNqaQZMQ
         L2SmPBNvCZvGv7BPkez5dDF0XnuiqCXZylE+rCV0/1tiPmjkyYGf5b2b6m+k96lQYp91
         Vb6Obz5nWK9Pna6LgIoOKH226aeqgnuSCN/srMhSdJFIKNaSFu35PcVK5LtiyMt815Cy
         T0kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795272594; x=1795877394;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=KMleV59mDasfc9ZrDI02cJ4rVcYzhncPH8nN8fIqQw0=;
        b=hAXYEHeJ74gZKt+IBwAhLiJs5lOJPn26Wgc83OnNdSE7DT/H5+jbcDEVmay6onL6RH
         Dcew3mHEVM85sBvq4pU8I74uyJ96WMrn5b6GlXmLlGlLpDdcWEGr58DU9my0HqMvZhy7
         hShwEwYd859or7LUsf9RNqhz4rtutfZEhYTIF8LY1gbahBu/xERVQcCXz5vfsv1/A/XK
         NOPXmYCDvRpOK22u38K3HleRlxNY2kd3d1wl0Z/qQV2+KLeubEw4SjsymYaVXL/cuq0i
         Q9GHs5R7HWQJtfACG3+tgF7DGNr9eCiuzDU1kzkMgaBlpD5Mfl7kOB1J30MorvmhAKhm
         AmDg==
X-Forwarded-Encrypted: i=1; AL+hErHhxV8N33dDzWPgD3k41A1b7gWWL/FpE/oQEn7MnrhF+27RIwU+eJYOlRjy3/idS5m7tZQzA5/SXxtZ@vger.kernel.org
X-Gm-Message-State: APuU4Z+OxkPNcKkKWVql5FBtycT0RoRxK15a/nB3t80wIpQlscT4Cs2F
	7MPsj0CCpDLsfFqzRrT6yMTp5nY+ipOCbU/lS84bgfIep0RP5VYoEmZgv5YLLHo/6MagYdPLXLn
	c0jKVWg4EjdOEEJ+k80F5JcekgfSll/H9mOpb63ZOgw==
X-Gm-Gg: AZFdTZcQJrNU6KS+Q1RSXFTKmeCPe1VbW6jUR1njnv4g9JMALQTx5ZBr3zOfBpD7/VE
	mMxZ68ihwnAjd9VIGx3+DLN+IorMzFhsaElDW64ab5ip92uPs9hWquGCATj4CVojNyJB+j0nNv1
	VwKnQ0Cvs8Q2NP4QjlInJpHgVDTcaTxtNRT8s1MlCP3+8kVsUvnZGOL6whYJlZa8IyH9ZVaP351
	AFElrcDWvfy3vR1XotsI3m3hWJKrEhhWwWcoek1YHkFeVacLHI4KnydF7cYhLxGKDV0XAHxJLGi
	IatanKvIrZ/Rsur8masGMZ2mymzKUuut/3ifhuA2gsIth3tOtUuLB+cLRmOnrM864YNSlIjZJiQ
	ek51O90aJRdNpE0URDN5hrdHsDovk5TRo05FZCug=
X-Received: by 2002:a05:6a21:6e04:b0:3e8:b7fd:6288 with SMTP id
 adf61e73a8af0-4014d159070mr6730389637.41.1795272594392; Sat, 21 Nov 2026
 06:49:54 -0800 (PST)
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
From: Yi Wen <shicenci@gmail.com>
Date: Sat, 21 Nov 2026 22:49:43 +0800
X-Gm-Features: Aa3M54o-c3umdLG_yLVUlZkiDbL2uREfVKI1Y1odDetEyJ0RRT4OIUMRc1PDQa4
Message-ID: <CAPHJ_V+_=Av8pAM+N+oc4JRmtqBjhcimh3B_pSy_N+5qecm6Mg@mail.gmail.com>
Subject: [BUG] mm/gup: WARNING: mm/page-writeback.c:2678 at __folio_mark_dirty
 on v7.4-rc3
To: David Hildenbrand <david@kernel.org>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi,

I am reporting a kernel WARNING triggered by a syzkaller reproducer on
Linux v7.4-rc3.

The reproducer triggers a WARNING in ext4_dirty_folio() when
process_vm_writev() writes to a file-backed mapping.

The call trace shows that the warning occurs during the GUP page
unpinning and dirtying path:

process_vm_writev()
  -> process_vm_rw_core()
    -> unpin_user_pages_dirty_lock()
      -> folio_mark_dirty()
        -> ext4_dirty_folio()

A second WARNING is subsequently triggered in __folio_mark_dirty() in
mm/page-writeback.c.

This appears to be related to the interaction between GUP-based page
dirtying and filesystem-managed folio metadata. In particular, the GUP
dirtying path may mark a file-backed folio dirty without ensuring that
the filesystem-specific metadata required by its dirty_folio()
implementation remains available.

This may be related to the known issue where GUP-based page dirtying
does not properly notify the filesystem through page_mkwrite(), as
well as the interaction between GUP dirtying and
filemap_release_folio().

Before these warnings, all four ext4 loop devices also report delayed
block allocation errors and abnormal free block accounting. These
errors may indicate an additional filesystem inconsistency and are
included in the console log for further investigation.

Reproducer:

C reproducer: https://pastebin.com/raw/VMwNSqrp
console output: https://pastebin.com/raw/43Ne65Vu
kernel config: https://pastebin.com/raw/dG24GcY1


Kernel:

HEAD commit: aebb7274476403040d582c61478df8f4a7bf9cd3

Kernel version: Linux v7.4-rc3

Environment: QEMU virtual machine

WARNING 1:

WARNING: fs/ext4/inode.c:4527 at ext4_dirty_folio+0xe3/0x110

Call Trace:

  ext4_dirty_folio+0xe3/0x110
  folio_mark_dirty+0xb9/0x120
  unpin_user_pages_dirty_lock+0x588/0x6e0
  process_vm_rw_core.isra.0+0x7ad/0x960
  process_vm_rw+0x1c1/0x260
  __x64_sys_process_vm_writev+0xe3/0x1b0
  do_syscall_64+0xee/0x4f0
  entry_SYSCALL_64_after_hwframe+0x4b/0x53

WARNING 2:

WARNING: mm/page-writeback.c:2678 at __folio_mark_dirty+0x644/0x780

Call Trace:

  __folio_mark_dirty+0x644/0x780
  block_dirty_folio+0x149/0x1a0
  folio_mark_dirty+0xb9/0x120
  unpin_user_pages_dirty_lock+0x588/0x6e0
  process_vm_rw_core.isra.0+0x7ad/0x960
  process_vm_rw+0x1c1/0x260
  __x64_sys_process_vm_writev+0xe3/0x1b0
  do_syscall_64+0xee/0x4f0
  entry_SYSCALL_64_after_hwframe+0x4b/0x53

Relevant ext4 messages:

EXT4-fs error (device loopX): ...
EXT4-fs (loopX): Delayed block allocation failed
EXT4-fs (loopX): This should not happen!
EXT4-fs (loopX): Total free blocks count 0
EXT4-fs (loopX): free_blocks=2415919104

The issue is reproducible on Linux v7.4-rc3.

The full console output and C reproducer are attached.

Best regards
