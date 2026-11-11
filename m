Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794367679;
	b=e1o9HGt6bZZH5JD1MROIbeisM6A8gsfsDAUWdqcsNuoR2UDbIS92PCXlwf7Fh7o22x6Y
	 jWPL/4A5iAxZg0OClOHU0sCtKjyebCZ5+EEfOo6JfG0787CvJPXEDiuSHe5PDsFYpzve7
	 cFglIkwgBttPlgaONkRoMGacjo2wuTalvju+yT+CzBaojeBd9z2zkB39RpZysR+uzrgUG
	 MYycx0y0ugeCTTYgElRyxMXxlVR1png9WWQE7E+5lKhd1kP9qGltx3p83iG2upzJUNWRS
	 CPrCLgseVzrd2SDcOmEsWGj+ltMf9fq6ZFFoApaaxQfjZVkhUNk7BvYyJNRgaNVlNug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794367679;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=NnXwX3mhbFBCtPNDjVP4JRFl+h/k9geedy1O43m05/8=;
	b=2mNglRn6Pm9ag7gmMjBNAtvUvnFNMQVjLi/+oDy47w+wYwvEZ9T1dgCA4QMwrtm3fU7A
	 8Vju6plG7pf97gWUVEdd5BLFiGfXtnx+Fun8xn4SGZP884lxITRlzvlUOn6m+MAFjS3ws
	 MJ79viafCjwSfD92RP7xkh6FZPzBlaBfINRTrSVq0iTcd5o5QQm8NzV2yS6/6FDfviXLN
	 5dZPy5+KQc1SPPxZ6z8NQdDRyOtiOjbWGsLsnDd2LR8RALpaLIv62MRUKyl6kk4ISzh7Q
	 H22DZM10sY1U7N2JLua0q65ptCIg4aKcSbl2kASWa/8N9pGpV3gmD634A0MJc98+D3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=G7Yr1kXW;
	arc=none smtp.remote-ip=74.125.82.180
Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 184CA606A32E
	for <linux-ext4@vger.kernel.org>; Wed, 11 Nov 2026 03:27:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 184CA606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=G7Yr1kXW
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-37000e7234bso289021eec.1
        for <linux-ext4@vger.kernel.org>; Tue, 10 Nov 2026 19:27:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794367678; x=1794972478; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NnXwX3mhbFBCtPNDjVP4JRFl+h/k9geedy1O43m05/8=;
        b=G7Yr1kXWbesBwpFdZxtyKSaOTaPcCqab4Vwc9kB5tcK7PIA0OTosLbaJRrmXvpwsvy
         hcm36lv3wOZvjpV9buuI26VHBIfDEp9vXd7DPkv12CrYECDocIWEJNp2e7QLnI64wtNj
         sDKBTkgPOwX78JeqXlftRRouzqWW/X4KaeaRnm3o42wHWPXt2cXOL8HwB5v+ykJAK6ie
         PvIudyMmSMWa3zSsHdqmI8KwSkinUGeuBkDfZtZDaZs52ZgxxXR9ow778MoMBk+vIKiy
         4T/RQeJT/Vizec+IbKM17Ly/Y4MUyqlliHkqL+lBNOJu/wuJhuaBHnarboElTtcpL+xs
         ZI6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794367678; x=1794972478;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NnXwX3mhbFBCtPNDjVP4JRFl+h/k9geedy1O43m05/8=;
        b=lXzvYruVm7SWll4qvNI671GHRCEotQfjeEcmSfV4Bai7MWBQFpjFzWiQdfv6ThusyI
         l2eOwFHeiPw8jVbbjIigps+Aiqw8kUySOlSRd7IOPVXS0VudK1VbWgIvuaWtmLoLOTie
         sCRz3cipXbG1n79JBx0DJpTBBUpuyGHE4we6P58353G7MYI+HfxKVSxcUMDFVsucqjIr
         J3lfie5WaunompiXBuaVrWZrWaMc+1bFOyDygWy/aOhWsc74Vakj/LTbKbRF7pLqTrPk
         opFifuTL9xVJFGtDiXCpTASfzfmb3FLc+VcewmWPR7w5dB5B3TKvfxBBjab3b9ZJ8i7X
         Q8bw==
X-Forwarded-Encrypted: i=1; AL+hErEA8lJnXIJ9ya5eHjY60EGwATdU89HgP9ttHlhKjyI7tDPpaoVO2IJNGXscV1mYAs7NdO1IKCA1ntln@vger.kernel.org
X-Gm-Message-State: APuU4Z/eb9r/0R0O21K/bHqoq9RkaW3LJWK9D9lcnmlCz1uEfMDBnD7O
	M67U/1pT0M5DQ5H3CcBiT6AwfMfOYyEqQPcRBZQTms9Pc0L06k79Qp/p
X-Gm-Gg: AYBFou3IODpRcvD+7B9P8fiopwhhiUE0VzzEof9a7ynIuwCoefCfMNEjwhCFOmBNs5g
	buDJBlEubszPwHDfgkyPYmNNki0BTRxflTg5bafc7aTtPXqTYUAi1/lcBMFRM40mOG7+rv/HRmH
	oUUnUxdIQ/0SI/GCYwhq1t8ERZqJaMH3sIk6EbrasLogZwOBMQeY8FOPxop3WqT5raDJiPFWcps
	pOe7ftW16Zah4gE9sVro8hIOCeHslp0MIjStlTNiO/pcXlzBpfC+Cf+5nVIhfHWpO4pYQB0HEtB
	cwY3Rn9W3KlY+UvD+nsZgv1r5MqJvm3egZ3KAzXXboSVF6Grqj6grNA1+33/0K5Knr4zXMYfzSO
	/8CZXRtaEHakRusE5EW7n/yvjuNNfozAY8WwPJJCoyCy2z31IahiSEgn7fNuD1mCDkIxSSZR6a2
	uL0ickHVyQkxyMt35CE+Vz432PYP4p4Fah1gX92Uma/Bq1+tObNOMi7sPPfo6UFSrOpFKCVR/or
	83W7wTOBZyS2WlQ0n9o1KAZvjrT057XfTpWERtSI+mAAZG7ZlANh8kZhLs4orUMGlSn8Snz3NHd
	JMyV8znBqv56hHjUC5Pjk4kqnlw4XQwqOuULQeZDS3gpBdVuFWXa
X-Received: by 2002:a05:7301:c011:b0:36a:5042:85b1 with SMTP id 5a478bee46e88-37683a53694mr1662811eec.2.1794367678022;
        Tue, 10 Nov 2026 19:27:58 -0800 (PST)
Received: from localhost.localdomain ([152.136.45.109])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3752060dc0csm13113892eec.14.2026.11.10.19.27.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 19:27:57 -0800 (PST)
From: diasyzhangqing@gmail.com
To: Jan Kara <jack@suse.cz>
Cc: diasyzhangqing@gmail.com,
	Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	syzbot+d4ecb9a1e5b3dcf8baec@syzkaller.appspotmail.com,
	diasyzhang@tencent.com
Subject: Re: [PATCH] ext4: make concurrent DEFAULT shutdown waits killable
Date: Wed, 11 Nov 2026 11:27:43 +0800
Message-ID: <20261111032743.549426-1-diasyzhangqing@gmail.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <glup36pqwuh2wsxjozp3x4kne2spsud65ftlw744p72hmh54mx@hi2s256gr3iy>
References: <6af1e75f.3e87765f.91969.0010.GAE@google.com> <20261110132118.11265-1-diasyzhangqing@gmail.com> <glup36pqwuh2wsxjozp3x4kne2spsud65ftlw744p72hmh54mx@hi2s256gr3iy>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Tue 10-11-26 21:35:56, Jan Kara wrote:
> Err, no. This is really syzkaller self-inflicted damage we aren't going to
> work around. If anything you could make the wait on bd_fsfreeze_mutex
> in bdev_freeze() killable. That will actually be a sensible change and
> should address syzbot warning as well.

Thanks, that's indeed simpler.  All current callers of bdev_freeze()
(the generic FIFREEZE ioctl, ext4, ntfs, ntfs3, xfs) already propagate
the error, so only the wait itself needs to change:

---


#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
 block/bdev.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/block/bdev.c b/block/bdev.c
index f20f91b3176e..e57be2320423 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -301,7 +301,9 @@ int bdev_freeze(struct block_device *bdev)
 {
 	int error = 0;
 
-	mutex_lock(&bdev->bd_fsfreeze_mutex);
+	error = mutex_lock_killable(&bdev->bd_fsfreeze_mutex);
+	if (error)
+		return error;
 
 	/* A device being removed from its filesystem refuses freezes. */
 	if (!atomic_inc_unless_negative(&bdev->bd_fsfreeze_count)) {
-- 
2.43.7

