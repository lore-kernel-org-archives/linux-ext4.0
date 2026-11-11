Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794401573;
	b=mVJk5AOufNa94QbG302e1+BQ9MwIy/Wh4tK6BNBEqIic95LXXQkPgdr2AEoZSMoLYk1q
	 No4G+YoyYBA968Bw7aFMthX/SP+25USzZg+zlDQ2R6FC+4BG3+rBeIdRJpmK78spmYAxB
	 JerIZvhhW1fg3EZXmLjh1QZ3G4PFxeWEE9DDNs0M9HPpCeTVEww9oZC6oybboiXvOsp3Y
	 IuwIh6xx1NinbtNACuLYegaeBLAcmYgcE+6udeqTqbsTkSPcEZ9godBePYgPokWtIJcff
	 wo1OAACuhr7Qk/zDn6ngBV/+PQtKNPAbDxsfXUTyWN046Sx5To9k38Jhwk6u5tCLsFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794401573;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=WUIiY6/aqEcIQI9igCGxNqtAW7lC+kJkajoHFMnyrno=;
	b=4K6gz830I0+mhjWO4BoJqfoaEyIoqlHI4UsBy9ZIFIHYcf7OLEph2FETy9ZtMRQijfgb
	 lSScoPEIBjzwQeJr2thigWEWkH1ASWlgtWfixFXyH6sARPIn/1nACIxHahj9/kY6AptbK
	 jYLryBsYL/IiYiYzUvppKtPiLKAHRnvZlUmG5ILLdrHI3EGJzYSUF3KLkhvPK9rRdjzox
	 FhIwo/ip6hx6cAvSPEkrkeOYCnOntbbL0N8csYieSbBOdBnE5HKQhrPio50aJNTt6JMWZ
	 z5ETKzNqHfqZK0I1BfwHlYvLUyeCAnm5ZMQJX2YRhFWRM+lM1yDU76I1nUX7TzXE96g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ionos.com;
	spf=pass smtp.mailfrom=ionos.com;
	dkim=pass header.d=ionos.com header.i=@ionos.com header.a=rsa-sha256 header.s=google header.b=cBL0sfsp;
	arc=none smtp.remote-ip=209.85.128.42
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25F2B606A324
	for <linux-ext4@vger.kernel.org>; Wed, 11 Nov 2026 12:52:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 25F2B606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.a=rsa-sha256 header.s=google header.b=cBL0sfsp
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4a35d5d4a20so37133815e9.2
        for <linux-ext4@vger.kernel.org>; Wed, 11 Nov 2026 04:52:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1794401571; x=1795006371; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=WUIiY6/aqEcIQI9igCGxNqtAW7lC+kJkajoHFMnyrno=;
        b=cBL0sfsppJmbAWH3u6JYGpy00djNtx9prs+tozwdSBTBJ7ZfbuCJ9y10EHpF6her5s
         aCkBHSXO2HzYP49eKWbKuFLt1bINOAkNXV9aWjYgCK1vVId+ezyewSlHDQMQVt/isZrF
         y4g8G01XaAXj5WbYxXaKDR7ssGDjlgYYjHTC9fQ2PYmjSjJngWsUxPe3zUdJaomt7Ktg
         y+I8RHHWiDezcsley7OiYrLssMTlasL3jekpFk7vVRaT/Qq48w/Cs76SEbXgFtbcrbeH
         sNA3b9QwYTX9dEdQZh1VzOfjzDRaLE+d0ebGh1sHGt7gjdEmw3QTrjkRSQ27ZaqYg6xC
         iVcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794401571; x=1795006371;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WUIiY6/aqEcIQI9igCGxNqtAW7lC+kJkajoHFMnyrno=;
        b=EiQ1UkiL7gQcf6bvucZuJGYnPJ5q7Lb0UrNGHW9JPAEW0DbQd7OA3h+vPF7OGLOsCN
         mlS78RPIquiB3w9kH7XbUgfl5bWLgjEUC3OZibzqVkpyyRrs6eKksYCPzxOABECBfZFl
         MeEHRucXROdtp5nk4u+TnuqXdHVeJEULyRxlFFPgJnRibeyaWjRxqeE/tzP5UvYJFDOA
         928ez3sZuuN12xFvE1kbBR10kHx7M9Xbb/JzXSVyPkil/xjacjLozmQ+2QSnaHCTz3X4
         iegXhqWvWdtbpqZE/v4WxHrfXyLt16vFnd7YtQbYtZ1i6JIJ9e73uVb20HLySpCT2Hiu
         WqFg==
X-Forwarded-Encrypted: i=1; AL+hErHgv7/rnK2f7j3N6JpVHzAC4DbH/fTM36O8UspgYBWt6iwpo1g79UNvutfqgFwtZSIDsodjIoGwVQuT@vger.kernel.org
X-Gm-Message-State: APuU4Z/YN1WOTStwybmrLEAOU+CGEfedE4+ikWaWaSRE7gO6DmRoD4Yt
	sx1aH92pODLIVSvJAk2XJFANHPSsfAwFR6qhmZH2GI1SEQnbDC+eDA9ZLk5QhJcCdk8=
X-Gm-Gg: AYBFou1PxH4bnVCixJJYs1jLbnp8H5NpLT7nFnci0QulRTrRX/1c7XFFjztfZp3zCdg
	0cckgpZC4u6HH2u2Bs4UOitsKWJFF34v4IEhby0rQGTJdLdgMYA9okZfLst9sQciGaPIZzdGvGZ
	BPIkmxvLQ7XOUiAaF87fPSbpzYq1AowzuS1aKR6W5dQvmcFFL2ZbCU4DcZgDJ74RFjW5q+Idvyt
	0wtrdq+AphG5xu4PXPv8dZEoBnm9DJfT7YG+BFd6yq3ZZjIbbyWUs/pK5HDU6gTqxdY/I68PgNy
	jXmJbX9oi9RzgyHfmQKxALRLCfwtWhQSTH28iPB+OlhoAnuC/9bytNMSHRgaG1V554EdTSgPs6t
	9sA47XiNJp//fuRorU9163jCkQqRDwF2Y9gYWilxL+DZhsXGhs550eU0d81AiYAetM/XCug6g3C
	k5l3YWH3ohZi0ENi6rMPATbeUfbE0Gs0Ow+L6WfR2C7yylEY89hSqEIB9wkm7GTW/T3wTMi6/B2
	q6jSe7EuDtEPcu6DdyxhkiMljDpMUxE+qYbacEU2J4htsCnGcD2G4fkEBFb7CwS0yElRyqfYRci
	vD1q3GD8ADwFS979ztEFHFzccA7m09fnPZJAK1qVpYIWLXHnxyprugEG1TmkoHg80L9K9MQUU2Z
	GN9oS+HsV45d80kFyRrCkS3FHqYpZWA==
X-Received: by 2002:a05:600c:3554:b0:4a4:4d57:8487 with SMTP id 5b1f17b1804b1-4ba0936c8admr40498745e9.5.1794401571502;
        Wed, 11 Nov 2026 04:52:51 -0800 (PST)
Received: from raven.intern.cm-ag (p200300dc6f4cbe00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f4c:be00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4ba020433casm132712185e9.7.2026.11.11.04.52.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 04:52:51 -0800 (PST)
From: Max Kellermann <max.kellermann@ionos.com>
To: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Max Kellermann <max.kellermann@ionos.com>
Subject: [PATCH 0/3] ext4: reduce per-inode memory overhead
Date: Wed, 11 Nov 2026 13:52:39 +0100
Message-ID: <20261111125242.1078620-1-max.kellermann@ionos.com>
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

This series reduces the size of `struct ext4_inode_info` by improving
timestamp packing and allowing fast commit and bigalloc support to be
omitted at compile time.

The incremental reductions are:

  Disable CONFIG_EXT4_FS_FAST_COMMIT              48 bytes
  Disable CONFIG_EXT4_FS_BIGALLOC                  8 bytes
  Compact creation time, with fast commit off      8 bytes
                                                 --------
  Total                                          64 bytes

On our production server with 35 million ext4 inode objects (a big
fscache partition), this saves 2.1 GB RAM.

Both new Kconfig options default to enabled.  Without fast commit
support, clean filesystems use ordinary journal commits; journals
requiring fast commit recovery are rejected.  Without bigalloc
support, bigalloc filesystems are rejected before journal recovery,
including for read-only mounts.

Max Kellermann (3):
  ext4: make fast commit support optional
  ext4: make bigalloc support optional
  ext4: store creation time in separate seconds and nanoseconds

 Documentation/filesystems/ext4/bigalloc.rst |  6 ++
 Documentation/filesystems/ext4/journal.rst  |  7 ++
 fs/ext4/Kconfig                             | 31 ++++++++
 fs/ext4/Makefile                            |  3 +-
 fs/ext4/ext4.h                              | 83 +++++++++++++++++++--
 fs/ext4/extents_status.c                    | 44 ++++++++++-
 fs/ext4/extents_status.h                    | 15 ++++
 fs/ext4/ialloc.c                            |  3 +-
 fs/ext4/inode.c                             |  8 +-
 fs/ext4/super.c                             | 40 ++++++++--
 fs/ext4/sysfs.c                             |  6 ++
 include/trace/events/ext4.h                 |  3 +
 12 files changed, 227 insertions(+), 22 deletions(-)

-- 
2.53.0

