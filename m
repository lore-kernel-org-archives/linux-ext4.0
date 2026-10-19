Received: from mail-dy1-f177.google.com (mail-dy1-f177.google.com [74.125.82.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 433994F96CC
	for <linux-ext4@vger.kernel.org>; Mon, 19 Oct 2026 13:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792415834; cv=none; b=Ql0sgQfXql3vU+2GPvYbQ9pIH4LUVLOpWvbQcmd/zQzrYEsjiB07Z0X9sRo2Hepe5Ilm+xSX770Vl75nceNSaZRXA6h0SPyjXEIJdZM0K1Vp4FbI+BPY8j2t6AxhJ5eh34JGPgAFQMF2CjmIdjxL7JjVVrPDUbPQoSRk4k9ErDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792415834; c=relaxed/simple;
	bh=v0N0ue0D/9q3twivEXd/Xex83WpXtVQPxtWDyAK2fGA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZLwHHWEFAmakZG9oZpNZs/f8rW7uyE2wtsBTLCTXcjlVw6EC6UDc+29NhsmJt/Q6VJnb9qw/veqE+7D2tsqypP1HAOo0aClSpzwxDEnYzjDpvUDpw5lLKjjWmlATHRpVuxbOY2HV6g7Q8+5GFv8KvjtQPXkk9Z4/O3XzYXpUPxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Yde7Hawg; arc=none smtp.client-ip=74.125.82.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Yde7Hawg"
Received: by mail-dy1-f177.google.com with SMTP id 5a478bee46e88-3645f0f3fcdso1946334eec.0
        for <linux-ext4@vger.kernel.org>; Mon, 19 Oct 2026 06:17:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792415832; x=1793020632; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Un2FQLn1cyVPuKINi4Pu+DXYqsg5kHet0ISFq98QOI4=;
        b=Yde7Hawgbgp7LWtm/0W5qeYIiMvIMT2Y8Hu1jgvtruw5W29wgReanuMdQAhnh3wFiV
         /AYbk/YBGFfWREQmkN1tc8m/kbPXB0hnV2DOOSSzaOPHnzzUJAjWWJckSD+ve+6InlNl
         E89QNCceEJEAAk7Pf/tMj/klDCgHymPZT6MPKwibVViU9Z2MGzGKa3+3gz+V5klUdy2S
         enAJHeEsbq7B0yjB4377qSIPJrucKhxR1Kw8aaVXAcNRlziPj7aeOO/OKbA4SWqpAON5
         gwqCLKQAky9E3YX9EtDJZyZ9sVPBvHTUgY5OG2bKBjScDNapZqmWR47lW7fVWyzEfxkB
         BQAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792415832; x=1793020632;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Un2FQLn1cyVPuKINi4Pu+DXYqsg5kHet0ISFq98QOI4=;
        b=PY61lw0Jyn505MHtknw2Z2584sbPAzvCClvVKvaOwQWNhss5PII2I0d24MlPr4Or7y
         CNe50LqW6wt2Xm52X4glhmNNImBiyNS7AMf5kvL+9bRHLJTBuKL8lrODy9QPbtllg162
         752ekd8SypMhIMKV17/MH2JJ1EWd7LlE7n1xI5LgKOZlj5ObPHYCBPvRC3F8GG2W/n+H
         YVHPzd7uQM0GJswQ3+ft/Aq9cwnSc9lkS7/Lorv2nNJv8Ff367PDuOhOf8gX9skjUjiu
         V/mcfOvvI7LNg4FxxTyq5i/n05cTIblBVSLRbb/ZX+mPpizw+PkYP8V/jkO405JRK+tW
         lnYA==
X-Forwarded-Encrypted: i=1; AKwUvBwNVFhIGfMT1w8Tk9mcAt9e288/Jd0N+/pO7Pn7LPnMzjxmJyGLqXNgtLBD6ZI8dwGg1CE7qfRFIWaY@vger.kernel.org
X-Gm-Message-State: AFq9FYILcwl/KTDhV0Bre2y4JJsjxl2VD0AhECruVwxU4BO86bszLB5o
	ALbqmSId4cvMn5v3kS34T2SU5Jjlc3/0h6xIYvGwoAZK5W36GXn3j+Vs
X-Gm-Gg: AYBFou1oP3CWVqQakJ5CDN0h9h+/1yqa2hpLAbPdjZkNc4rKC7eNy08UBb1ZyBLX16N
	THfA7wzhvzi8LrPrllkCpLJXpOH6tF/igSbbEEApebUaAjrLyYYH6grGSrh9knUbHelk8Y4mOH6
	oq+3Q34OXt3JhL1nyrMiWnxP8syUcNLljk+tOCbp9R6VpXbyoMOL9yP7S/RxYTcbdK+dP/Cvz+u
	fw2CagGM1/weQ/3jcFM1tafOy6glSvXG4EKeuT9Qw4GkZxdA6Kjze1tR1WPlislxjVenOEx4LVW
	LlJVNBz/48lM//fs91jqsIVyhAaj2Dew4omeiD3sZqfhM5dhXPzc1chrAYWcY6OI0ctx2oAAQwW
	sot6AaMFLIb6f0NRSxYNRECDF3Z58jCb14kOurf3SKn6c8UBcRTkSFZ+HiaML23o7YVPRLrfmuM
	ffIs7sZSpLs6Q6MqXWr/ScmY8MH9CKYiLl2SX2F+npLEW3rUHTspKox26wDDyoL5NYv6RLO8RVY
	FStbC/qU7/sISEoZSBLFDrQ
X-Received: by 2002:a05:7301:6196:20b0:34c:d1f2:b552 with SMTP id 5a478bee46e88-3619ea2377dmr10582267eec.4.1792415831916;
        Mon, 19 Oct 2026 06:17:11 -0700 (PDT)
Received: from csl-conti-dell7859.ntu.edu.sg ([155.69.199.57])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3608258aa66sm40785403eec.20.2026.10.19.06.17.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 06:17:11 -0700 (PDT)
From: Kaixuan Li <kaixuanli0131@gmail.com>
To: Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger@dilger.ca>,
	Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3] ext4: don't read past the UAPI struct in GROUP_ADD
Date: Mon, 19 Oct 2026 21:16:55 +0800
Message-Id: <20261019131655.2583227-1-kaixuanli0131@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260918111742.827428-1-kaixuan.li@ntu.edu.sg>
References: <20260918111742.827428-1-kaixuan.li@ntu.edu.sg>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

EXT4_IOC_GROUP_ADD casts the user pointer to struct ext4_new_group_input,
its UAPI type, but sizes the copy by struct ext4_new_group_data, the
internal type:

	struct ext4_new_group_data input;

	if (copy_from_user(&input, (struct ext4_new_group_input __user *)arg,
			sizeof(input)))

The UAPI struct is 40 bytes, the internal one 48.  A caller that follows
the UAPI and allocates 40 bytes gets 8 bytes read past its object, and the
ioctl returns EFAULT when those bytes are unmapped.  The two structs have
differed in size for as long as I can see back -- v6.12.9, v7.2.4 and
current master all have 40 against 48 -- so the copy has been over-reading
the UAPI object throughout.

The first 40 bytes of the two structs have the same layout, with the UAPI
'unused' in the slot of mdata_blocks, so copying that much fills every
field the UAPI defines.  free_clusters_count, the one field past it, is
overwritten by verify_group_input(), and mdata_blocks is read only on the
ext4_resize_fs() path, which builds its own group_data array.  Copy the
UAPI size into a zero-initialised struct.

Reproducible on v6.12.9 and v7.2.4 by placing a 40-byte struct at the end
of a mapped page whose successor is unmapped: the ioctl returns EFAULT.

Signed-off-by: Kaixuan Li <kaixuanli0131@gmail.com>
---
v3: initialise input with = {} and drop the tail memset (Jan Kara).
    Correct the description: the UAPI 'unused' shares its slot with
    mdata_blocks, so only free_clusters_count lies past the copy.

v2: https://lore.kernel.org/linux-ext4/20260918111742.827428-1-kaixuan.li@ntu.edu.sg/
v1: https://lore.kernel.org/linux-ext4/20260917151441.413135-1-kaixuan.li@ntu.edu.sg/

Built fs/ext4/ioctl.o warning-free with W=1 on x86_64 (gcc 11.4), and
checkpatch-clean.  The EFAULT reproducer behaves as before on v6.12.9 and
v7.2.4; the fix itself was not runtime-tested.

 fs/ext4/ioctl.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index c8387e6a2c6e..aab02575d90a 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -1674,10 +1674,10 @@ static long __ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	}
 
 	case EXT4_IOC_GROUP_ADD: {
-		struct ext4_new_group_data input;
+		struct ext4_new_group_input __user *uinput = (void __user *)arg;
+		struct ext4_new_group_data input = {};
 
-		if (copy_from_user(&input, (struct ext4_new_group_input __user *)arg,
-				sizeof(input)))
+		if (copy_from_user(&input, uinput, sizeof(*uinput)))
 			return -EFAULT;
 
 		return ext4_ioctl_group_add(filp, &input);
-- 
2.34.1

