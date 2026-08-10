Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F9243F5BE4
	for <linux-ext4@vger.kernel.org>; Mon, 10 Aug 2026 17:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786384576; cv=none; b=p8VHftj/eLAOg1mnp9WZNEbClKix+HXYWOfVYe9qWqClwLROj4uD73HG3aANKgKG3fjsSACmX1RtXmnCYG8ZHAMfFVllywWnst+EnFVlkSFT6OSHpdEN6U+0oOsEz1UXs5+7fiEH0iLhWKToeB3XufJk5+gdqo6GF56EfZKT02I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786384576; c=relaxed/simple;
	bh=CGG/y7IERwIQcNX2Tus0ZQ/9hpFVXyYjSyfwySzzaMA=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:Content-Type; b=m67FvChVESnNmFO3uPu96gXDeS9B621EnZqTP6NuvBlHwAiHXj8VwybQyAIYM5B/MEaUis+ojJPGmqmpiYkLOHoHfiyy5qyJuvYP+Zc12DNUWjstwh6E7AHwLzqsk4uJIBMmfpBjHJaSSvxtfJNyQQhOWsU2lRNC45mzXOndhZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=elder-tomes.com; spf=pass smtp.mailfrom=elder-tomes.com; dkim=pass (2048-bit key) header.d=elder-tomes-com.20251104.gappssmtp.com header.i=@elder-tomes-com.20251104.gappssmtp.com header.b=MoqsuiHA; arc=none smtp.client-ip=209.85.210.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=elder-tomes.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=elder-tomes.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=elder-tomes-com.20251104.gappssmtp.com header.i=@elder-tomes-com.20251104.gappssmtp.com header.b="MoqsuiHA"
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-7ee50eb2db4so1386460a34.3
        for <linux-ext4@vger.kernel.org>; Mon, 10 Aug 2026 10:56:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=elder-tomes-com.20251104.gappssmtp.com; s=20251104; t=1786384573; x=1786989373; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:content-language:cc:to
         :subject:from:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=tflGD3M0cvf3IU2EIUAvRhIRs15ivVgWVNj+J8eY9Pc=;
        b=MoqsuiHAD78eRe2gKRMcRtWZIpCUj7pCuQ5v7Ep4vHghAW3KRDTOMucCe8NdOkFCYn
         kMccS6J1W5m9eQe3IPiSPWtt1ZMfpYmCknAo89+tcLaMntepXSu/CCZn3o/GMNNTMpkK
         QWSyJzoXXt1NHq0tz64xUTh4ZdojMetImVHYGR7LxVuUoFpphD4REAJblc7sUc7Hf5Ko
         C8sqbv/IH04diqGmJNnjzAIgIgP4jQEYq7+EkzOQpNj36Z9c0yZ2rT6Bj9rWypxZpLU/
         1sJRdeDmyM27v4AnZ0x3JBeoXWCtYckXw6KXz+i6eNfdnxZlLiGXI96m5Lkq6eDtv6zA
         uFjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786384573; x=1786989373;
        h=content-transfer-encoding:content-type:content-language:cc:to
         :subject:from:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tflGD3M0cvf3IU2EIUAvRhIRs15ivVgWVNj+J8eY9Pc=;
        b=IhzXA7oYFIJVXhXsDS6d6s5dgaoBkTNBo5ZOR1HmnaFjzOagTyX6vmBcAeshfEdnTv
         iZiZkb2Mc6aoETvAa2wXiYULUqHx05ITCB8rNItypmvnJGrQNKtGDvRtqCV7oKZuQW+5
         dKieTNR5I8i0jCBrb7jaLCo4yZ3DwvkWc76bsVT3GvBQPewNCGd8lk2M3u+Ai9RqHh/J
         mrG0Lgkn3Y5sBZjMTopEuXY379S/MfVfMs2kfKXf9xPKL8FL+PtTQ07azcbO15JyJY13
         wxowsuTxoPI5z5VgIgbGE7xzqa5m0Oy3zNDCKXRdMrgMuUain7RSEsPvAxsvE7B9PjUS
         CihA==
X-Gm-Message-State: AOJu0Yxj7qUD8vzWpNMWvzG1nvDCscfjx5pLMxwyRrekYkk012RdG1le
	nkSMHeyuiFbcAG2Q97HeJ6GjoRNa/49xD/YoGuWxFe6x4rRE5F4x2jyhwKq5IZgkIN1ajE4o4mQ
	S4E1f
X-Gm-Gg: AR+sD10iZZ2jpt8zwJ8kNSJTkUAlG4BC2TLxhoqdSmH5BjxGeuki4txMaBevlWllzPv
	1SL8Qr26pZ0Q9456/TlliXxmXcA1Rw3msRQ75cZuFmQvb7MO6NidcaU9QOH1tI5J3m+S2aeoaPh
	zf0OrM2TTwGMk2WvX/+lGVOT+ALoy/gppmhgi09jb5cT6KBvi2nlPDc9JwKH1gaxiQew6Zy1ZQ5
	aESPJ85uizArrLEZW1f+Eg55qjvnKOma35jcKyXHVuhOWv6b6GDsnQ27lyDkCXtWQ6EcX7hknQx
	BXkyEbmZGjCmae0nLmfuaYxxMFLvb50hiRbDBkuy2lg3MGFDq5w1amjk4p27mSza0TpVQfZDX0P
	jzevb+RUeJYVd1f6TFymJfPRgDfmvzwhNbGh7hido57rGPHzuTa8QnI+7Qy0M9r1/0ua9R62hEo
	7vso2AW6pHt9EUs5Hzb4t4sNSholQZeynvJLisotuhREBUovltOUF/k00LOrEISExGs3AXwFrbJ
	+0HBAvAPjriG93U80Ik6Y1FesBrShddeJicHk0c
X-Received: by 2002:a4a:e847:0:b0:6ae:8a52:ffa5 with SMTP id 006d021491bc7-6b0352ab534mr12810951eaf.23.1786384572891;
        Mon, 10 Aug 2026 10:56:12 -0700 (PDT)
Received: from [192.168.0.86] (ip-204-57-18-28.co.bambroadband.net. [204.57.18.28])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6b02bc76279sm10195952eaf.7.2026.08.10.10.56.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2026 10:56:12 -0700 (PDT)
Message-ID: <4c130a23-7283-45a9-852a-b24ed78eb0d1@elder-tomes.com>
Date: Mon, 10 Aug 2026 11:56:11 -0600
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Levi Shafter <levi.shafter@elder-tomes.com>
Subject: [BUG] e2fsck: ignores SOURCE_DATE_EPOCH / E2FSPROGS_FAKE_TIME for
 s_lastcheck
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Sponsor: 21SoftWare LLC

Version: e2fsprogs 1.47.1 (also 1.47.0)

Summary

mke2fs and the ext2fs library honor SOURCE_DATE_EPOCH (and
E2FSPROGS_FAKE_TIME) for filesystem timestamps, but e2fsck does not. A
check pass therefore writes the current wall-clock time into the
superblock's last-check time (s_lastcheck) and last-write time
(s_wtime), so running e2fsck as part of a reproducible image build
produces a different filesystem on every run.

Details

lib/ext2fs/openfs.c sets fs->now from SOURCE_DATE_EPOCH /
E2FSPROGS_FAKE_TIME when opening a filesystem. e2fsck, however,
initializes its
own clock without consulting those variables and then uses it for the
superblock:

- e2fsck/e2fsck.c (e2fsck_allocate_context): context->now =
getenv("E2FSCK_TIME") ? strtoull(...) : time(0);
- e2fsck/unix.c: fs->now = ctx->now; (overwrites the library's value)
- e2fsck/unix.c: ext2fs_set_tstamp(sb, s_lastcheck, ctx->now);

An E2FSCK_TIME override already exists, so the mechanism is in place —
it's just not tied to the reproducibility variables the rest of the
suite uses.

Steps to Reproduce

dd if=/dev/zero of=test.img bs=1M count=16
SOURCE_DATE_EPOCH=1000000000 mke2fs -t ext4 -F -q test.img
SOURCE_DATE_EPOCH=1000000000 e2fsck -fy test.img >/dev/null
dumpe2fs -h test.img | grep -E 'Filesystem created|Last checked|Last write'

Actual: Filesystem created = 2001-09-09 (mke2fs honored the epoch), but
Last checked / Last write time = the current date (e2fsck used
time(0)).
Expected: with SOURCE_DATE_EPOCH set, all three reflect the epoch.

Impact

Reproducible-build pipelines (e.g. Yocto/OpenEmbedded) that run fsck
during image creation get non-reproducible ext2/3/4 images.
OpenEmbedded's wic currently works around this with a post-fsck debugfs
set_super_value pass.

Suggested fix

In e2fsck_allocate_context, when E2FSCK_TIME is unset, fall back to
SOURCE_DATE_EPOCH (and/or E2FSPROGS_FAKE_TIME) before time(0), matching
lib/ext2fs. Roughly:

time_env = getenv("E2FSCK_TIME");
if (!time_env)
	  time_env = getenv("SOURCE_DATE_EPOCH");
if (time_env)
	  context->now = (time_t) strtoull(time_env, NULL, 0);
else {
	  context->now = time(0);
	  if (context->now < 1262322000) /* January 1 2010 */
			  context->flags |= E2F_FLAG_TIME_INSANE;
}
