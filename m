Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794528893;
	b=NOI1DnMEgauJW2iogvV108DHS67/GJPiiilm+NzHKjtrprxLfYarssUxV57PlXpMltZf
	 EtcDdJMNtKBuV8ZI4nzOGQ2rDQD6HDDCZV8/IRlbTsymX6VRqtr2Cunn3YKZXWe2h325U
	 NL907FS1LdeKiyC1m0E0RNVI93AqXcGpcy8y4EEytrY58Q/Ct3IXD+rD0eGFfTdNqhdTs
	 KtTurQlhKWrKvx9xhflqhqIG2+yeFMq065yLhYiK177rFa9SoqtMuKw7NmKBihtfppqJz
	 30tjBTx0epvQSt/J55qLoxkAhlY0MZubhkfCQ2PDxys2lXPfQWMmVfSxXpledJ76WPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794528893;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:X-ThreadId:Date:From:To:Cc:Message-Id:In-Reply-To:
	 References:Subject:Content-Type:Content-Transfer-Encoding;
	bh=NwR2wSyV2KhYxI0PF/ZwLwdA5AHcVcrKPi/WugyKj04=;
	b=xKh63Il+SSPmwWwbT989bGoGRhNlT1YN7qDecKV8kS+GxIYRC3Y6swbqIWaKbPAr05N1
	 z4YuY/6mqfbDNUyRI7r80qbVkBnYE7PFZ/izUbxZLXLTpeZtZZfvDHSo66hNY+DKfkxIf
	 +10lEWvm9ozrXW6IgUA9WauoLVyHpOB/huBF582nbkjvXMcS4P6ox4zea9Bqmymudwi+U
	 5IyW9zHePMJBW32osRf+4NB4J4/sYRxfCnjA4O+qx623IKlzpUmR4eSzaBY5DRWDIAG/w
	 KZglzoh6nbm5XevciuekkkfOb4qBawB8J7yN45KPn9wrqX8o9ehivu1mxpgNsB193JQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hOVrJR0F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BD15606A321;
	Fri, 13 Nov 2026 00:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hOVrJR0F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1E711F000C4;
	Fri, 13 Nov 2026 00:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794528893;
	bh=NwR2wSyV2KhYxI0PF/ZwLwdA5AHcVcrKPi/WugyKj04=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=hOVrJR0FwgSdBlB/ZCfPGBgGzEKKmzIDIX2eGD89a5EtSDpsXU8fmqI/d+8NTAjht
	 kiGhNke1nxh2Wh7Nw7YPXuW3mN+sSVUFpqrHS5mLfBKK4yx2S9Z12a14fqsoN8hrVU
	 pldGiEO9vLG+Y7qVvbjqtSbDxRPdWyP/eVR3C8gx+LydBEN1kTPK7gDinxABFYmUFu
	 22FMxLkLQlcmgF1MZ5Dbv7E7NlbmrJamOTKeunZ9OnERCrwMkVVMSOA91RUDTwRgmP
	 9UzJtVRX3a5CKhP79nSB2HEKKSxTbtg3eyYhGO+EGdgGdUpFAtLzY/WO05HCW3Ix+4
	 foS+EQEYH1fNQ==
Received: from stl-compute-04.internal (stl-compute-04.internal [10.204.2.64])
	by mailfauth.stl.internal (Postfix) with ESMTP id 66D34780043;
	Thu, 12 Nov 2026 19:14:52 -0500 (EST)
Received: from stl-imap-13 ([10.204.2.104])
  by stl-compute-04.internal (MEProxy); Thu, 12 Nov 2026 19:14:52 -0500
X-ME-Sender: <xms:fFb2asM5SkzXMZe6KFy_fjhaukTl80OF49wPq7Ms-nEIwb_cvazRhQ>
    <xme:fFb2atyd0mB09GY0L5yli96HBY4mtyuoX3ViD7_g4BaVLCzZq5MKi9BOF86RQkXeQ
    XWUMBVWKjNpX46AJstxALcm8n8am7ikUdemanGX5kOjvDZZyoEof7s>
X-ME-Proxy-Cause: dmFkZTEXI+Qp90KuiWLSpiY+3WISfla3t4O0XbbPPLzuWlPj/w53GCXDMqpj4UDBkfkB7B
    +9qIf81kJMjgKczbDcNTSKKEz08QWe3MM4lnqHodiWHfA6997YNOE9PVpJO3VREUxeDi4x
    hEh4cI/41WtRSOUeY35G9T3zWKEE1qvebJz20/UQRdvT5IBinwe4a74+ikuEbltF9VjNGT
    HiIFiMuAWdbaeq1DXhjcLAe/LmCu5KLlKzvlyk+jz8BSiejDjF/2Ilq56hdFvZ0yN24JJC
    sTrOJjLRZazoAXe8k1sQZOgb+irWzWDGeZTiNbL9MTgfSgdQafOK38Ft3m/jxcdjvO5aO3
    4POmq8eFS+TRvDiq+PadVSTJ69Oq3Vp4WT3TDkp80H37n8RP6q8N98sdq50JsFnP98wSOG
    VBPYAcMui8hnv8Tzpcgzz9fKYNOtV0w3r7jJNoUVdCMBUaHSSCSniyKv6rz78MnMwIO/am
    HvpVh5xanLgk8xeoEGv3n1UV06UAqHmN0ufD05iHdL35LcD2sRThgWFzFAIStJIRWczPgl
    zvI634dfqRS/LBaKDPSdnVBZsxgC6DR83nUSWWGbYMw7oXCeeUPp0x82lnWNVYtMG4p6wh
    L+u672JGJGJSiEvfzaOsoXp/M0L9wLmG1m1sKixkFUOzP6XwppgkckXi0ADw
X-ME-Proxy: <xmx:fFb2amWZ6BIH7-S3ZTQPSkjz99pK9mf3ebApWQybQnPYb4Z4QT-f5A>
    <xmx:fFb2auBbjFSwXuwG4POKZo9Jc0P665BywutZ59XuCDq73vF8acYohg>
    <xmx:fFb2at5xuZQb9iLlpX5SrJGs4yHE_Tb6DG10TMVk9UcZ0x8QhMMq_A>
    <xmx:fFb2ahzWF4egzEzAAq5pWwSP1ooQa8MHqWA3Sc2bUWUGfL_yne9fjQ>
    <xmx:fFb2aszkZTzBIUV-o-TD9_0VM_hnM7E8lZIHfg_0-g0h0nCxvq7b899f>
Feedback-ID: iccae4b50:Fastmail
Received: by mailuser.stl.internal (Postfix, from userid 501)
	id 0F8FBF60084; Thu, 12 Nov 2026 19:14:52 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-ThreadId: A078c3q8o2BN
Date: Thu, 12 Nov 2026 19:14:30 -0500
From: "Chris Mason" <mason@kernel.org>
To: sashiko-reviews@lists.linux.dev, linux-ext4@vger.kernel.org
Cc: "Theodore Tso" <tytso@mit.edu>, "Carlos Maiolino" <cem@kernel.org>
Message-Id: <5efb8c04-ad07-4f39-98d0-2896c800b101@app.fastmail.com>
In-Reply-To: <sashiko-outbox-211908@kernel.org>
References: <20261112214604.67875-1-mason@kernel.org>
 <20261112214604.67875-7-mason@kernel.org> <sashiko-outbox-211908@kernel.org>
Subject: Re: [PATCH v9 06/14] xfs: recheck direct write alignment after write checks
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


I've done some handwaving around this sashiko complaint in the
letter, but here are actual details about why claude thinks this
is the correct path:

On Thu, Nov 12, 2026, at 5:22 PM, sashiko-bot@kernel.org wrote:
> [Severity: Medium]
> Does returning -EAGAIN from xfs_file_dio_write_aligned() without checking
> target->bt_logical_sectormask cause sector-unaligned O_DIRECT writes to
> bounce to buffered I/O instead of failing with -EINVAL?

Yes for reflinked and zoned files, and that's intentional.

The sector check in xfs_file_dio_write() has only ever seen the range as
it was submitted, so the unaligned path already does this in 7.4-rc2.
Here are O_DIRECT|O_APPEND writes to a 100 byte file, with 512 byte
sectors and 4k blocks:

                            7.4-rc2    v9
    plain, 4096 bytes       EINVAL     EINVAL
    plain, 512 bytes        EINVAL     EINVAL
    reflinked, 4096 bytes   EINVAL     works
    reflinked, 512 bytes    works      works
    zoned, 4096 bytes       EINVAL     works
    zoned, 512 bytes        works      works

So the patch makes the block aligned write behave like the 512 byte one.
A write cut short by RLIMIT_FSIZE goes the same way.  In every case that
works the new data is right, the other side of the reflink doesn't
change, and xfs_repair is clean.

Checking the sector mask again in the aligned path would only keep the
two paths different.  Checking it in the unaligned path as well would
fail writes that work today. 

> For non-CoW inodes, xfs_file_dio_write_unaligned() proceeds into
> iomap_dio_rw() where extending writes allocate unwritten blocks in
> xfs_direct_write_iomap_begin() before iomap_dio_bio_iter() rejects the
> bio alignment.

That part isn't new.  Before this patch the aligned path called
iomap_dio_rw() with the same range, so it allocated the same blocks
ahead of the same -EINVAL.

-chris
