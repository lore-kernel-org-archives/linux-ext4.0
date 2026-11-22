Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795371876;
	b=JLxPNqSs91AAqohstj0Z3EftzYyXV0V5PDeZfw/Rujp4KoK5/LmEvBiRw6vhCywsHBjX
	 RDJfT5GtDp1o4er3nMpihNwTFkSzSMi8KW3r6jDNSk9ZVpOF9Qb4dzRAmeuyqwvP1VHkG
	 zRx2449vYnpu8aetu2khDg3EE4HsTU7kBkz01z+b/Y9o/rmfvK+drPN4sdam38iKb2rA8
	 IDqOhrCnrUTJmEMR8n01zaZUKdLyGmgvuvrU78zJQ0XLlWNgDUcUTA8HPxJAvTUSOsCDf
	 qXyyd3voBtJj/ve91XuobYkxONE0js3hAryxT+9eGnEPiYC6dyNJRPa5Oh67oBN0NJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795371876;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=76A4WPudZsZy4CJtPE5LMtql++Tj2dohb2B1StvtAx0=;
	b=HItrWYSroMDQTMgyEc+b6ooA+YnHaK2J39c9XPFfGRluR/TJpFP2mmvGIVndvC48Q6Oe
	 CTwcKm71SbpdEoWyc5HMUBlcAWsyO91FYVLB+6YlWmO24+Vt8970B7FqEilAcSn/t1jeN
	 +syPNVeGAU2wHBFkaiMyDFpyah5eohfMxJaWr8p9CQMZ9e/97ipogS+YP8H2cGjaywhtT
	 I3GbkSfqYx93MhU9WJOB2SYw+d5FEapCena+kRTbIUjv/xUM/XBYHoKs18c3kxvA1kAms
	 yxdVYaborRR8DmC3YGvDMOgq3yO70sjIUAhYGSjcdH0Mer7xbCZjjwhG5LRttkOCLPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=aDml5vAB;
	arc=none smtp.remote-ip=209.85.128.51
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D377F606A32A
	for <linux-ext4@vger.kernel.org>; Sun, 22 Nov 2026 18:24:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D377F606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=aDml5vAB
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4b79502c27aso22377505e9.1
        for <linux-ext4@vger.kernel.org>; Sun, 22 Nov 2026 10:24:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795371874; x=1795976674; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=76A4WPudZsZy4CJtPE5LMtql++Tj2dohb2B1StvtAx0=;
        b=aDml5vABEDkKy8vsbL8COyzwkkoQ65IJ/EAggkdXqeEmF24s9kd24MeYsbiaxzwR0W
         Cw3o2WQcaja8UqOGtGtCT561ukMh7lAg6gLEqaOYI3LKQxSergdTZCvR7yEbM1fmcZel
         ghDhF62n0JAq/SmNfVwRF7lVKklbAKmY4ZFtyojZmn3Xud2A5fK+ndU9kyYD7kCPqLUH
         yOyQ45G6TPLx3G+EsReFD6vLfhe+kvNLWbbe5NJcIHAdZjlX9Jo/yvZ6LY1w0IlyrpD8
         RTAXzloYIEBO081PQjjcraJE9wilm6GBqDtHCqDCzPXHnA21vymOwXgQh3kFs5Gi1qwJ
         qhUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795371874; x=1795976674;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=76A4WPudZsZy4CJtPE5LMtql++Tj2dohb2B1StvtAx0=;
        b=NSC82bYdRs2ffOkVT03sY8otwzO/NdPQ3XPaqkXFl09UD6FoTdY32a6MWE0UYgyNtp
         TuecoCjF98MmS8t99lwqKRio4MJIPWHjCYz8ys1m1sR8LvoprBJNXVIEpRiz9yDIt+z5
         e6IRJk4Db4k0NA9hFst23IYHWzZcjqMwBo1s/AibQZJDHzpwZJAi09dhRhocIrvs++/1
         hHEMkLwvomuXUfcFKp5VKg164kgRJu9UJtRxe29AYLJ4SSgnRTA18drxfL3McOtf32c4
         vVZLSMF0DtKeYO7yp9NCx++52g9mx3hQCw2N68Tz8D5/sr3ZVy9RN6QWryvc6ceZG+2W
         RxUA==
X-Forwarded-Encrypted: i=1; AL+hErEniHR7OZHtVMA3xjydgX+UlFgDsnLeOcES8wJxJbi8bZzYCGQuWCJ9/zUMt7oooz6FwUnHBWjmfFjF@vger.kernel.org
X-Gm-Message-State: APuU4Z8F0ACU3DKl0earS8FpnOpESmrREkyIn8VmECuTbtFpHdLZ98zN
	rzRHgU9otM0rvDVnCa4A0FQJI2uU0GZRggVBCTzwPRCYwNFTdr9tS/ti/cgEdTNg
X-Gm-Gg: AZFdTZe8Qh0c2nUmfMbo0pQ8bjUfLbW/j3Yd9J62dD/jHX/KDnZUboUyALPkU62palN
	xd1xWGsC8rpla/RlCoDea8wI237dHJySg0OGEj3hOtukrcVlHV8NRU82cj9arsAEAuCVOkCtZvk
	a5G+ddUDJUSmuDNEv5hnS6CkX22HZOt0dxgog2YN39vrdUMZfFeyCSYht40p1Dyf+bgrE9bg/ks
	JGY+jDKwLZDXRP/3I/aipZmgsVWZD1vitxGvpXErMQInL49u16r8IQA1cvRpqVnOhNp/ogWBGz3
	SFdImFbIA0WlEpbnMYWMdEp9WWIjB1iQS4blrv1y3uOJpO4SN0tnSziWY6qEERFfTG3MrbhoJHH
	GcNzmA4MDE03+AXg5ZBMPyZfkYWCf2F70i6aC+iT9GT9n7N/bBFsN+aIUY2S8WkuVdwYpCMl0Kt
	VQUnkGOOg5ruhtOHDBa2YDF9USbat+9BgzfcHbygQgP13IHjW0FJS+NPgC+iHNGOxxd2HR5sFh9
	ajzi2zcsAhezzjiKW4E7MFrtGB0xBkB47DHTr1/2OfdyMHKVmk6szLWuLo87fWF5Dsix5EJOY89
	R8+RKh8S4PdkNs1sxLwkJwEnnRF2xB9+ywfcr+TAmQX+TFHIJkRH52wA
X-Received: by 2002:a05:600c:1549:b0:4bb:741d:ea8 with SMTP id 5b1f17b1804b1-4bb8880ad4amr190688825e9.7.1795371874103;
        Sun, 22 Nov 2026 10:24:34 -0800 (PST)
Received: from DESKTOP-V28CTA4.localdomain ([103.125.177.105])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb905f0f1csm112711375e9.0.2026.11.22.10.24.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2026 10:24:33 -0800 (PST)
From: Arbab Haider <arbabhaider649@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: Eric Sandeen <sandeen@redhat.com>,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+1d23ad199a3bfd6f9149@syzkaller.appspotmail.com,
	stable@vger.kernel.org,
	Arbab Haider <arbabhaider649@gmail.com>
Subject: [PATCH] ext2: handle NULL fc->source in ext2_msg_fc()
Date: Sun, 22 Nov 2026 23:23:31 +0500
Message-ID: <20261122182331.13740-2-arbabhaider649@gmail.com>
X-Mailer: git-send-email 2.53.0
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

With the new mount API (fsopen()/fsconfig()), userspace can pass mount
options such as "nobh", "dax", or "reservation" before setting the
"source" parameter, leaving fc->source as NULL during option parsing.

In ext2_msg_fc(), when fc->purpose != FS_CONTEXT_FOR_RECONFIGURE,
strrchr(fc->source, '/') is called unconditionally without checking if
fc->source is non-NULL, causing a kernel NULL pointer dereference:

  KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
  RIP: 0010:strrchr+0x24/0x80
  ext2_msg_fc+0x157/0x1e3

Check fc->source before calling strrchr(), and omit the "(%s)" device
prefix when s_id is NULL or empty (e.g., when source is unset, empty,
or ends with '/').

Tested locally in QEMU (x86_64, KASAN+UBSAN) using fsopen()/fsconfig()
with NULL, empty, trailing-slash, relative, and full-path sources.

Reported-by: syzbot+1d23ad199a3bfd6f9149@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=1d23ad199a3bfd6f9149
Fixes: 98f18c76c2c3 ("ext2: create ext2_msg_fc for use during parsing")
Cc: stable@vger.kernel.org
Signed-off-by: Arbab Haider <arbabhaider649@gmail.com>
---
 fs/ext2/super.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 54a6c26d0..c99367652 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -89,20 +89,25 @@ static void ext2_msg_fc(struct fs_context *fc, const char *prefix,
 
 	if (fc->purpose == FS_CONTEXT_FOR_RECONFIGURE) {
 		s_id = fc->root->d_sb->s_id;
-	} else {
+	} else if (fc->source) {
 		/* get last path component of source */
 		s_id = strrchr(fc->source, '/');
 		if (s_id)
 			s_id++;
 		else
 			s_id = fc->source;
+	} else {
+		s_id = NULL;
 	}
 	va_start(args, fmt);
 
 	vaf.fmt = fmt;
 	vaf.va = &args;
 
-	printk("%sEXT2-fs (%s): %pV\n", prefix, s_id, &vaf);
+	if (s_id && *s_id)
+		printk("%sEXT2-fs (%s): %pV\n", prefix, s_id, &vaf);
+	else
+		printk("%sEXT2-fs: %pV\n", prefix, &vaf);
 
 	va_end(args);
 }
-- 
2.53.0

