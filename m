Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795632031;
	b=ZgN9QBUkylhTQF6xSbbDebKzIQFE9Zrws3xPCmCzMaH0c96Lu+JLt6aiyOQmx9oAvy0d
	 /wACoz82O+s6VO3ybzcNCk7SZxiBg87EUPoeE9W7ztzALvjneo9Dxm+gofnHbVRRuKj2g
	 jb0mjXYD8Mb8hdP5dIwUfGpKd8Mo/5cBodhyfdgw7b475VMIi/Uk0KIoazQltunQJD4FN
	 /vZ60ctB+iwc/t3d8XkfkEyFrc9rPKvuB9HFJNF7cI01hv/t0I4WTGi8wHLgKxAD3gCA0
	 oGiiskpS4OC5f80IhfS1gZvuU6bCnk47YKlesbWvGvAEQfB5tLXflsiLxK3Jla33d/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795632031;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=eFpNfukvpRxA9ZSwbqvjegicm52kayQGu2t0jHfEpps=;
	b=XLFAgrtnMvna2O/dRXSCLzourRUBhIaIHxgS2scxTTcb8kOAxXX4BOkwFMaIIKYhgfc4
	 BBt366WryrbB2xCSv6xwcY2b9leXkHARrSVgn91rh3vy5agOU0jvqj1RrqH0bKMTTq8Pm
	 k1yDU95NiQCQt+J3fcZLB037QmhCHHM7XvrIfVOUO9Fj452iZP+1RRcTe8Bk5ToYBRy5K
	 efbT1sIQL7DG2i4tT94zg7mbPMQ6LtpFBO2lpn9L6x/ssByp+PA8NAJxODVSlukL0buyY
	 LvX+EfCpg3nu8s7s+gdUTTDdPoBAz5AQOIdVYlyslOON6MJ5REQE0dYzxwgIg/AeCxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=niXPV2SW;
	arc=none smtp.remote-ip=74.125.82.170
Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 703F5606A321
	for <linux-ext4@vger.kernel.org>; Wed, 25 Nov 2026 18:40:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 703F5606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=niXPV2SW
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-3863db981d4so8611499eec.0
        for <linux-ext4@vger.kernel.org>; Wed, 25 Nov 2026 10:40:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795632030; x=1796236830; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=eFpNfukvpRxA9ZSwbqvjegicm52kayQGu2t0jHfEpps=;
        b=niXPV2SWbN2ZyIEZcaIIsSMrAHiorSnrf6Z5bc3szs6AMgtrgkbV7KJCEZ6f94aTZv
         Lc/6MuQYcGd/AJTcWz/VdgmgZtDV8CFOwHG11V1GKfZIhHN4DQVhUPK9BBRxPLI6RVuA
         Z5pOUzWP2cuXVTel+8qnjc7lqDybkBDX7h0TyrcImOM7zlYc6HCtrWm1eP5dS3Tr9pRJ
         X+jnLGw/847yhr6m4QBCB3fB7RUtKpQ+SuqYomB8jAW717jL5LE7sjpOMhjkslbJZA6I
         OpvYmKEwuDyPa2g6uc1MVedVTGiggdkGkmg4xKQEx7XUeoe2oJz6psClyyHx1aJipCOE
         /4Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795632030; x=1796236830;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eFpNfukvpRxA9ZSwbqvjegicm52kayQGu2t0jHfEpps=;
        b=GyDzLfHIgNz03ThI0aU9fiHsdbiMKW79agp4NvqB9WgkOyoEFtZYNKMxgOybyRWL2y
         iZcjKzN6YODROt/JjHEFBvHTHSd08i2/a7zAseZbQm79knb1iQpRw5UYpYTFR15HAjp/
         t9uLRIbAviacLB7dVuzQ3UXcUGRhXf9p5edUJblO4dC5Sm8Hd1zIqXB+paTFjlNI0HDi
         sD0a/ra6rZHFk24WIrNMjQ8GZ0Ykuvz0U/awrGQjJnn7mCH3fJbPvhdwTTEC3bqaVpzs
         ZRoEM3pZvh0QaDiqVUTyXHrovZ6sjoMETPLsEKcKUEkfTNOuAaMxAUuKt5dNR2L+BijT
         69vA==
X-Gm-Message-State: APuU4Z+rJbcnk+BaRaAQGWYEhaakG8fwLljVIi6nRZDp0xwB5bJmkOah
	4/2Xz8rPkpyASAgbSqTwZP8tf75WU5/LiBRFPHkLUF9a550h3lv6dh2G
X-Gm-Gg: AZFdTZdZu6z1dH2OMA0Inw3+DMky0X/CIvOs9g3BEXUafpG79iGr8w3bpltifJi2aWH
	+pYhFPGdgeHIz7wpe56FGfMMQVQKCweqNhpb9griGn1XlkYCLnF2mXxzjP2cbA7Qc/Q5Wxn1NCt
	qLlTegpg1FbpBeeRQ0pOBJZDZqYLqK2c0QKDG4TqrVPp2VuNHUgYhbcSeQaKDMMxAZsZnqBJ0sB
	WArA+V5BumszNaA+hLa5o6jtgELnKlqE6OG4Ztad6B1WZ0hezegh9sK+RfiIn+SQEEcVOY9WceY
	fA7JdPboYDKSFqGSo+1eI0Rute/Q9+NZ8sUHtz5v8FggGi8j/9MorqCiF1pGfpMBguJdIVU0imf
	Fk2naaBXJfi/+p/oNJrXDJ6+vf4qztX4JkwlkDOwQrskPc4ZlX6lENWoETmMK5R+FdAZLSyfl2b
	QgSnAmhr7LiGrYZ6IfAmHA0DlsJHA6pBQvdLBo2dngSgCujiz7BvulwpCqQxu+svi1MJWd6/tTU
	Ted+zrzLJCYeKGcUTlAcJHCxIpmJEfTnVeOhB3zfVSkk6bAMv17qoEiAsCh+SPOSfNgE0Y3Iemu
	OlNMmejdJbvR8weXw3ifqQ==
X-Received: by 2002:a05:7300:6da7:b0:36c:3b8a:8090 with SMTP id 5a478bee46e88-3856c9a302amr1376516eec.2.1795632030315;
        Wed, 25 Nov 2026 10:40:30 -0800 (PST)
Received: from a1-free ([2603:c021:8021:f000:0:1865:8c38:18fc])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-385666e7f59sm57393496eec.6.2026.11.25.10.40.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 10:40:29 -0800 (PST)
From: TAKANO Mitsuhiro <takano32@gmail.com>
To: Theodore Ts'o <tytso@mit.edu>,
	Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	TAKANO Mitsuhiro <takano32@gmail.com>
Subject: [PATCH] jbd2: Document the h_invalid flag of a handle
Date: Wed, 25 Nov 2026 18:40:27 +0000
Message-ID: <20261125184027.2402549-1-takano32@gmail.com>
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

struct jbd2_journal_handle has an h_invalid bit: ext4 sets it when it
has given up on the handle, and __ext4_journal_stop() BUG_ONs when the
bit is clear.  The kernel-doc comment lists the other three flags and
not this one, so kernel-doc reports the member twice:

  Warning: include/linux/jbd2.h:523 struct member 'h_invalid' not
  described in 'jbd2_journal_handle'

Add the line next to h_aborted.

Verification: kernel-doc -none include/linux/jbd2.h prints that warning
twice before the change and nothing after it.

Signed-off-by: TAKANO Mitsuhiro <takano32@gmail.com>
---
 include/linux/jbd2.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index e3886963ba00..361aa5dbe395 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -482,6 +482,7 @@ struct jbd2_revoke_table_s;
  * @h_sync: Flag for sync-on-close.
  * @h_reserved: Flag for handle for reserved credits.
  * @h_aborted: Flag indicating fatal error on handle.
+ * @h_invalid: Flag indicating the handle must not be used any more.
  * @h_type: For handle statistics.
  * @h_line_no: For handle statistics.
  * @h_start_jiffies: Handle Start time.

base-commit: b6a9fa34ce4187cb69d3c588a4bbffc31ce5db8f
-- 
2.53.0

