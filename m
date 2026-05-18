Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 518F83EDAD6
	for <linux-ext4@vger.kernel.org>; Mon, 18 May 2026 14:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779115442; cv=none; b=hPS2V3OxLxLziw6JivHT7rulRfpbg3PagAJHqo5HKw9VhTx1AH256dQOw3QV2kLBmZNDtApQQ/EmAmyitH/5cBIv3LegkOMeBdv8a0RNnq9h6txY2I494sEY0oepYhdt5hacxhVTRWywZZVsK03QO1MDcBFBur6TmbaRLBpM32Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779115442; c=relaxed/simple;
	bh=DyV8E3gxpcSupU2HjznTUlS9YPVeCW8iPycUi9wK0EM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Id+zgbUN4fDQB2QybSYi7SBAEizQw/e9KQkDWmFkfYQmxpSMB7IHMQ49cFu10t/Rtz5KY+A+6dNdzR+3gY2q3RyR6yYZ+QGBYp7SuZ6iUVFPtQY7lO+q2n2yRppR9yFLBith1nhE+/+5Da+LH3nn39zzrIdksCILTIAwjFheTfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M4+tDHig; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M4+tDHig"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-83945063f70so1625281b3a.0
        for <linux-ext4@vger.kernel.org>; Mon, 18 May 2026 07:44:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779115441; x=1779720241; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Aw3Z5TVg60gqBwRTovyIOoXICrBGxM4+/44g78bnGc4=;
        b=M4+tDHigKh0ivz8gpaqr/o19kEk9bNx2U3Mj4EY08txi1IAUE6OR+8wwYW03j3GRTy
         h0RB1/Vq6EW4E+FQcM4zykvp5Fjt6u5kM7aigRyTme6flDmDDD98GjYhW1S0Cz9ki2dI
         pokBK9vGiah9n7hQM7L6drNHDw+tHDmbJyrX/HSQe9df80Hw3vfX8OdiNpxi1AGACbcM
         PR3jVsBI1IRPoJfVyaM6jwyDDVs3VqsmX6ktFeZLtjt2JekQlRNxl31pzq48IfidX0fJ
         iWogToX+yW3IOalChrMvvafe+OHhayufbWju0muC89ze2IkYf25dw7VtgXxcEs5H3303
         Al+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779115441; x=1779720241;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Aw3Z5TVg60gqBwRTovyIOoXICrBGxM4+/44g78bnGc4=;
        b=dQCU7VLMM9UnHLpBAMgXZYBrGNU9KYsvcrwQRChDstI21W4rveN0XLkr+u9QAoN77N
         4xwJnD1NuZHCgQ6o0bItly3X2bzd+8Kj2tFFmRBOR3rBO+kDz0FZZ+slhgn4oisqeNUv
         29r+p+hrDiXrvZxMlVNgDk7kFOFGM+kr/2a+dOp6OVpGULxi3yV4VgVzvLBlp+I9GE40
         6Lik19eXW9Kc1FtGcbouLQ8QjZJ1oQf7Tf/xQCCr8Xgno7BY6U3cp2HAYG7EtzeRlgNE
         eUnO1E3zxd+cBcut7Lv6+wEX/rPbD2IKdhMZ6kcIkVg7ftz+UhdUBFqX24yJv4keBW5F
         styA==
X-Forwarded-Encrypted: i=1; AFNElJ87x3Tpxf6s+2jql5XIYdpW+GhVM0xOa4PkalL14QVFxZUFyw9cyW3RWXgjhY8UQOk35UJmAD2fDDHZ@vger.kernel.org
X-Gm-Message-State: AOJu0YzSDG3n1vLdxNni+pMxOEg0SAst7AQ5gqlZPXlwRDcXA409jCkW
	Os6Am5QwfqsO82wx1HUEzZzdz19eNqYCUAvTvCj+3lEI9YWD0au10O0w
X-Gm-Gg: Acq92OEkq+M3HTuQVCWCKsTFCFR9Gcrr9xTH132Vy0ilk15rQ+aG4G86V7o1seLN7Sy
	scrhZA4d1eSp/1PC/sMh1gnUQxJmL4Kyp83/l1hPbTku+FsobgTaDuaQHvy3EL5Y3vdshKnnB0P
	W+eDmY1QctwUEPcXaeKYpoI/YYszwvHQb4t67IiFunag6DyWmYgmEAysXsccknmDjXEvqLUN+Yc
	L9zrSeT/BdopmKbSGa6+bTtCjHuA1btCB4qf7lkCIo2XVeZ2zejTrKi2c0+ez6qy69Hp/Ozl6Jj
	8TyqxlOMXyv6Zrq0fLojGC0B0EDPtNk/mXICrxQ0hvDDZY22qGDbPjyl2XFd5lnL7F584od1zIu
	LBfOl7Oc07bmsBaCHOOdsF7dAsOQkjiZuw3Ot08nU63LzNF4i8AmtdRX+nttHfp/nD2fC3tx+Z0
	iqAGhqy7VlxyAoTJwRq6GzPmp0vaw=
X-Received: by 2002:a05:6a00:a227:b0:82c:9c90:6ea0 with SMTP id d2e1a72fcca58-83f33ad8782mr12373366b3a.3.1779115440605;
        Mon, 18 May 2026 07:44:00 -0700 (PDT)
Received: from [192.168.50.90] ([116.87.14.48])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-83f2b9bec8fsm13165150b3a.33.2026.05.18.07.43.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2026 07:44:00 -0700 (PDT)
Message-ID: <aa4f29f5-b683-4d07-bc5f-fa5520ba2302@gmail.com>
Date: Mon, 18 May 2026 22:43:56 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/9] fstests: verify fanotify isolation on cloned
 filesystems
To: Christoph Hellwig <hch@infradead.org>, Anand Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-f2fs@vger.kernel.org, amir73il@gmail.com, zlang@redhat.com,
 =?UTF-8?Q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
References: <cover.1777357320.git.asj@kernel.org>
 <5857d9f33de7f0ea8ddd12c36334c6463c0bfe0f.1777357321.git.asj@kernel.org>
 <agK83s6NBxpbDREJ@infradead.org>
Content-Language: en-US
From: Anand Jain <anajain.sg@gmail.com>
In-Reply-To: <agK83s6NBxpbDREJ@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/5/26 13:38, Christoph Hellwig wrote:
> On Tue, Apr 28, 2026 at 02:42:54PM +0800, Anand Jain wrote:
>> Verify that fanotify events are correctly routed to the appropriate
>> watcher when cloned filesystems are mounted.
>> Helps verify kernel's event notification distinguishes between devices
>> sharing the same FSID/UUID.
> 
> Do these tests pass with all major file systems?  Or does this reproduce
> the previous btrfs issues in this area?


Yes. The major FSs (BTRFS, EXT4, XFS, and F2FS) all pass, except
EXT4 does not run `generic/801` because statfs `f_fsid` is not
unique when the cloned FS is mounted. Also, BTRFS requires the
kernel patch mentioned in test cases `generic/802` and `generic/804`.

`generic/801` fails in an SELinux environment; this can be
fixed with the following changes in `generic/801` I'll add
this change in v5.

-------
diff --git a/tests/generic/801 b/tests/generic/801
index e1282f4e3d71..384e82120d4e 100644
--- a/tests/generic/801
+++ b/tests/generic/801
@@ -23,6 +23,10 @@ _cleanup()
        umount $mnt1 $mnt2 2>/dev/null
        _loop_image_destroy "${devs[@]}" 2> /dev/null
        rm -r -f $tmp.*
+
+       if [ -n "$old_selinux_state" ]; then
+               setenforce "$old_selinux_state"
+       fi
 }

 monitor_fanotify()
@@ -49,6 +53,14 @@ mnt2=$TEST_DIR/$seq/mnt2
 mkdir -p $mnt1
 mkdir -p $mnt2

+# Setting SELINUX_MOUNT_OPTIONS to null still fails fanotify with
+# permission failure, so set SELinux to permissive if it is enforcing.
+if command -v getenforce &>/dev/null && [ "$(getenforce)" = "Enforcing"
]; then
+       old_selinux_state="Enforcing"
+       setenforce Permissive
+else
+       old_selinux_state=""
+fi
 _mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[0]}
$mnt1 || \
                                                _fail "Failed to mount dev1"
 _mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[1]}
$mnt2 || \
(END)
-------

