Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.6.134.125
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795664015;
	b=BGKpXLNPTjGlGpPhM6/BT7UaSVZobD6TtjJgrVX0f7UGeZnQluH53FMZPlgQcFTso3Fr
	 M5Bsd0tIGksEOYJhf5ov+WWcLj3451G8ebRUYjt19K0SZ6B2+1eTtP04lZDuTQFiNhNZ6
	 N8qB/h2o2PDMIHCR/es0Am80IGWQ0f0+6ttvo6aSDF/hXcx8fbM4VhlTJQiHXfasx/qzx
	 8zeKbcPa6BH23aOerzTXGvPGoePOmGW/UgDTy2l890EVr4QFZXsJpI54yLYGV///YnNE8
	 Bomq7DH136ecVeR9JQFoJVxotwAUyJ6bG97ANVUFOtScIEhB/74awmySckMxpC95sag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795664015;
	h=DMARC-Filter:DKIM-Signature:X-SONIC-DKIM-SIGN:X-YMail-OSG:X-Sonic-MF:
	 X-Sonic-ID:Received:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=YcM9NeytmDEp3ZHnhl05h0wZi5zVcYRHE8yN3GpV/uk=;
	b=ZDzV3D3cLhjH7/xuAhH/OLx1Um3IGkHm77t/zGJ8Kad85H+h2xkDUoO7LLVBhUlh7MWm
	 RQh0erNuljlaHINUM1vlSw5AWhrigCVTLoR3KeGaYWdSrgS9/DT1zJ7eoG1Ic1ZmEjMVv
	 nGHR59DzYndhVOaMAmPxXrGA4+JeJYigDFVJCv1emR1ww95ax58oeUl804skNqGFDbHDV
	 BhvbJ9ic/FZIRKC+jXY3707mAjw9dmawmqTN5I5ekzHBUOcBROHHvp0Djg5O8g2SwZKdW
	 C7djVA+8IOX/PhtKeZri0IhxBv3NA6GkclNGrS5Hzku5Hx8fG+X3LZ9FgZgwWbu1Ang==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=yahoo.com;
	spf=pass smtp.mailfrom=yahoo.com;
	dkim=pass header.d=yahoo.com header.i=@yahoo.com header.a=rsa-sha256 header.s=s2048 header.b=o8rJxBu4;
	arc=none smtp.remote-ip=74.6.134.125
Received: from sonic315-15.consmr.mail.bf2.yahoo.com (sonic315-15.consmr.mail.bf2.yahoo.com [74.6.134.125])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B0C4606A321
	for <linux-ext4@vger.kernel.org>; Thu, 26 Nov 2026 03:33:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2B0C4606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yahoo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.a=rsa-sha256 header.s=s2048 header.b=o8rJxBu4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1795664014; bh=YcM9NeytmDEp3ZHnhl05h0wZi5zVcYRHE8yN3GpV/uk=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To:Content-Type; b=o8rJxBu4ne1hHkdEfFFiMFwmWQ6R1ylvamcmZW9MQBZlRRdt+SmIgJ3Rp/0pzH3sPruKsyQKVg4LeyhjfxR0dc14XYX1hL/IzojXfg1iUCibMa0RTRPn8y2UGw1YOrME/KOV/ET2+O9EZcj7hyWboCsofxWmSmKk/uWpl2+yj6Q55mLndl985lTe2iUTgK0a2hMJFZS8SDqHohR3iiAuqJKUUMDHzKBWW/djteHwD42Bl5yaMjMMlFumX4Uymb+aEt5RmK5QKU87l62MIWVvgN7PgKH8HP4ltXiMwlUomK8CzAjvj+8KZ4ZEdFXckp6T9uD6itIo3tGB/AVmJDP9SQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1795664014; bh=/2Tlz5ND402ydS4wmF0R/ar/qtdz/i2oGCpEaZnYDZ5=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=Dg6+ljCRiE/2w9KXXZ8Lsivx32O2Xto0K217sQEXMCB929R8gw9YdXhYOf4Pb6HkcZ5AVPdaBKzCivm1gEvqi9IKocJqWVu1diI5CscKaiJmGqklkq1wUz1o4qPdv4vClxfxIyDYin0gU1E0AgPrh5mCSf8O81GGeqwdRl5wORJ8Bhh4Kk9RFVpHzpN6H3vjgYXEH54dODQY1RONiGxDqzbrwI8eYPJd/dukc8SijUfavp31vv/idt0pqeihxaiFSTxqzPK613DVKe+OtdbzSkux7QTQ4MBDc/WwJEw+2IoDUl1Bjhn1rFwhYeKLpG0pziAhXzUimgN9UiE9EKoxpg==
X-YMail-OSG: CP1AjuIVM1ltWqCiIJXJ_jVj5a0za5zPAFcSWULMECVOwF3fXdsBlPO24_0jDlR
 NiGJdU2.T.sVjVaVnkzx6p.AtKDPsKUO_G2P_kgn2Z994nAr.7bW9i2cF9Sp9T8XmuFG8Fch3DPx
 2zO8JmAEqpgeQAvmMjMMKjcSq8WBLIw9nVMWucCr_8O8H8k2lxmj6FO6UFY92JNpXecgdh7z5wBS
 R7clQ7FSlKzSwP1EbvoHHvwt1mg1lbDc.nGT480c2enbzsMsXbSQBB56sYOJiVKHPTkuEioflBNG
 KW_7qw1MI8BdLPIkO9jqApxsntjQTNpc8bF.4GCJeDxtX8K__atPk.YNxuxI52H4Q31C5K2VEcww
 72fQAMi88C18lsb1e6gRj4TsdvJkFqG5rJ1VQVockeLIBe5HZgPKCCUTBTIiDMAzixWbpAbxDYcB
 XxA_Jk6PKR4.6toggNOdATGBacXP0U6zrOfGCbPHONhKmSI3Yug1CPsWgKQi8EtZwaxAZZuCodT6
 ILQzkRkuS42T32iIXmV6QAg1GmarezR_4.bc78luGRuLf67ejEmE0xBbGn4bNJ6TcaAfXpxvrzrx
 rL8vj6dBEhfnRVp92qwyzJ9CsTICt2JV2zWyXp2OHHv9P8o3DbeDihXnv9nuoJrreI94bL8WuZ7d
 9DxUxrnrv_TpD1AAw4K22mENQJBK7gL6H9gBiS8fPeblpnJxYOt0foGAOm4G4sW_t9sv._Qb7rQU
 nsVH8gGi4jJbSnRDv2J2k_LsHrE4iWgIRRODaZTv7X.F_Qfb5kmKPyeu2fC6k7sWuTOSfcCLDN97
 JfUGY.Zi5w84HqIi_OCmLMKLB8TLuODrD3POMWV07zX44dbW0deE7gdv0MzQLMlDABzu8kSKvcX5
 Ma9G88FX3XUvcG1V0OHKUBp9wOiXUTfpOsxaEcRdr0_svU8kLISG8Lc3thJf6fjdL6LQPIFjritd
 gAoX4ycfhq53ZsYBaLXSgev2WuKh7iQ_YpqArgj_z1aFRI7fG77u8ToVNCyqRqYISB3u0dBFQ4Ja
 uD2tdPPQgGKwf0.PKDUJWMeHXH1M2doKgTQVuCjgNAO4Bzyi0iD_ZO6OZLmP_7i6yT4ZhsdK_t73
 komPcy0TnTR64fg6wLugpGoY3POnElLhB5IFCaA.DaNid5t26noiWm8eWl9sHsL1lsVChyzJtwbq
 bMzP9M6kDg8s3QT6LeTvro_AjsuSAerIGExppMrldUJHwhGa5K1Tuc_9iUcqQ4yFz0DQhtB5jiwR
 EQfsDHExSlLAOwOYc4e1b2f8Pq38afZlhaKUNIKOtoYh1xz3KbQ1.iv2xHLFPpfgx44mezkBhD4a
 pg87NC7_cTt7g1NuEi7jsQ5r1PuEM4Ej6wn_SG213f3gEB5RM0RSEXrxFyZorMArUjrNOi4OyVBY
 _BsEXK5tubGtjhW_zRCvVc.Mj7QcLanSVYWfmj_UKMXQKqY5phQ0pQU5upOxQCh3s1ur_7k3fasq
 sjz62Ky4_2A4kZuQGIUTmdWjJRoFiRMbTiHPYVS3OeIzwK.I7ijRf8lYgSo5_tSG3tk9GcynmRO_
 P76HcX7IiEMWQ_yhf6cgiJtU.uvoS1Og.G8YTFW3.BEkziRvtZg88MM2ICqAx2jVlOhGeewwsTQV
 nMv4aoljAf1216rN819muqIe109Ynl8z3u7QC5tmIvxyBewS0ATp_.OJzwX0MhwFUk8T6XZ1GoBE
 tJHOUZwjTacQnGT.lAQVRo5fnkQ581CHZ6fPdvDvjdYpVDzls8iv8BBS0HFkuTLjO2BFkkbEwcgq
 Gr4IYl8lOJ4mdaohYSIWaV.y60OCccq3RWikLymRGTCV5IBaDhWsmOsR2lzycj5XkTBnncexgcCu
 rIwEG3SmzoYUpsCBgz7VsNhDl3RNkTXXmNDd4nrKCpyhN5vdIARjHElXA4ygLZfIIloIqb4tP8eT
 xU2jRpi_PLNJkncvjzTzCi2z9KQC3xCw4lWgf2zoaSIpgigCjPrZSakerfcH9sow.uX2s07y.ZBY
 QCC2TjVO_HGfD4OCfXZI6AmSsSzUKspWDIlZNdYBsLrXzBC8pv8Qs5O5pCIEB1OLwkT0EWC8ZwNu
 PBuFHiAwPRKCFniup0IRx9zPy_43TagBhDNdFPnZC.dBrVHkWGhkXJggsdmIjLV4Hee_bkqO1srM
 lt_IPPWcmtkMfzxqNnfiEseUa4FZi7cU9fE2NX0xqSwMO8LJQmDeuNGFxkYwFPvVQF9oeB4_FRyg
 M4MiSgvDs5ZheEEydnUG0y5H_YytPyl7jqQonB.bfzH.mMB7KAA--
X-Sonic-MF: <deaner92@yahoo.com>
X-Sonic-ID: 0b7a824f-7bf0-4139-a5b5-2ff63710ff0d
Received: from sonic.gate.mail.ne1.yahoo.com by sonic315.consmr.mail.bf2.yahoo.com with HTTP; Thu, 26 Nov 2026 03:33:34 +0000
Received: by hermes--production-bf1-8768df57c-64qn4 (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 28e7f0a650024974c67d26ee33943d03;
          Thu, 26 Nov 2026 03:33:29 +0000 (UTC)
From: Jeremy Dean Clifton <deaner92@yahoo.com>
To: syzbot+4507914ec56d21bb39ed@syzkaller.appspotmail.com
Cc: brauner@kernel.org,
	clm@fb.com,
	dsterba@suse.com,
	jack@suse.cz,
	josef@toxicpanda.com,
	viro@zeniv.linux.org.uk,
	hdanton@sina.com,
	linux-block@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [block?] [ext4?] [btrfs?] INFO: rcu detected stall in sys_mount (8)
Date: Thu, 26 Nov 2026 03:33:27 +0000
Message-ID: <20261126033327.416414-1-deaner92@yahoo.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <68af0313.a70a0220.3cafd4.0020.GAE@google.com>
References: <68af0313.a70a0220.3cafd4.0020.GAE@google.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

#syz fix: fix the softlockups in attach_recursive_mnt()

The original arm64 report (soft lockup in skip_mnt_tree() via
commit_tree()/attach_recursive_mnt()) is fixed by commit 0ddfb62f5d01
("fix the softlockups in attach_recursive_mnt()"). Hillf's test of the
vfs fixes branch on 2025-08-27 already showed the reproducer no longer
triggers.

I also ran that reproducer on current mainline (7.4-rc4, arm64 QEMU,
2 vCPUs, KASAN + lockdep), with a debug print timing the mount_lock
section of attach_recursive_mnt(). The largest attach (32768 copies)
held mount_lock for 16-19 ms, and no soft lockup or RCU stall
appeared in 300 s, including after killing the reproducer to tear the
namespace down.
