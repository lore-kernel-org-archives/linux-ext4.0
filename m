Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C17637E5D1
	for <linux-ext4@vger.kernel.org>; Sat,  1 Aug 2026 22:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785621700; cv=none; b=Wwr5pVzEC1sdKM/aLbjj1bpbqgS3ZK8j3FGkrc0HQ64Mvlyj5XcjwCgrPKPk0498O+JqXATluA9C6eZcSSImfzbKg5JStL3F6F6xQFRDi1s9UMSnNPl18FsujLo59ZJ+H5fh24ULb92xvN9VIVI+rRurtyGb58CLmiFt5OCY4m0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785621700; c=relaxed/simple;
	bh=EXr243hgt49VO+NVV7qJVCHwNBqwGmV0A3daLRpsT44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y0rDarxQAakNaUYm4V7kUmvv/cCwFIW91REFcwXx5iZTxBLjh4S2ebuFCnR9gKSBqWADAjJ38o45FnLh88UpiXIIn112KvlXvZkK1a3M6fKONQqT74v+dDJn4gBJfH0QqsdEI0d+ngIdSCdRkOoWw0vQQJzAQ+E6hRSbODZpnUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FF28+Kuh; arc=none smtp.client-ip=209.85.128.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FF28+Kuh"
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-81eef95653fso19913807b3.2
        for <linux-ext4@vger.kernel.org>; Sat, 01 Aug 2026 15:01:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785621697; x=1786226497; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/eXvH9gfEzZ90R61WLxV17LvM97s4H8IYIhHdEQdhoQ=;
        b=FF28+KuhquhcwhUW1t3r3FnKppUtVxgbS1fAVBc40GkGsogkWB6f4tX2bJuPO7swj1
         IBzsiWFMWtzYZvFGGE6IRe4WenwQnTr5AJ4fwrmKsTYgsj+tk/ndiNbOHj4pxTk2fong
         BzAiqRNqRaye0mpxyrRet+Xk2epn8o/uuqiver6FOMP/hzX21gdTUpq+qoXlMQcEE7wk
         MCD8I4HlrXQ5zqMKeoBxOlG21ndWHObySTDUTtgqKt4FpCvszBYDYCksD3pA1xSdVvKi
         XRQj9r1AypKIq3HIJgqFjYDOgEg/c1xEoOVeDENtrVyPo6YKV4t6L//7XlR9iSTgO9e2
         EHTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785621697; x=1786226497;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/eXvH9gfEzZ90R61WLxV17LvM97s4H8IYIhHdEQdhoQ=;
        b=aK0XrHGilbp5Tg/8305uMAclGFlyrH+NDrmXO3rvSYU0J/KSdUENT7XJPt1WE9N6tt
         cfc2DY9IJPG2WmRwuVcAEDvbFIqNcwmzYhtNf9Y6Eo3uImeiemZsT9S+i/4suSVKrncJ
         78R9nIIeC1v6tShSdL2bIMh3ixoQ7gUePUvmuiI8Lh4xA/WscDyuMTXk41nI5QYxtDMx
         WGoIyDP23W54WS61pV2vc7ASEcgtZRwRW/uYlmlJ10Q0zVLtu/Tzt47PW9EsUbuHkARS
         2U08A5Mo4pepj8oMhTDwkPorqFGFFmGQ4Ra3pMaakYLsi9DkinzG5khx1cWPC7OzG1bB
         WUbA==
X-Forwarded-Encrypted: i=1; AHgh+Rpn1jgo7HOlAH6bWfYXVG97DjYEWtPbYcwIEDGG9BBT1RI/bGW0hGXVNF7jAiBQhlOub86tUpa6DLpn@vger.kernel.org
X-Gm-Message-State: AOJu0YzBtNypuqybvAJcJCHKFpdgxzk501TywdywY5+df324bI/qXP9B
	T/Ug1v8s4sKx1ZBPIbQ3Vjv24EBMyQuzMZcXf7eoiEB4k+yjHS7BuLff
X-Gm-Gg: AR+sD13ZI0cs+wbzxXaktAAQa85UqI11Xg15h05oIEsteiQ2hDR3wt+uRFKtNaVlPe6
	Gjx0TWWqAhj/I+WmrHRN6ioUoF23AgIaG74yF+9cA9BpLh5PZSA7+lzIVFVgr0AtHzqwANxfUKQ
	19xujVIQkLBVT46jXmvfXABew7ce2XHGGJNdp1xfjBJ66pz3g8cd4iFeY7hWnJJH1QVfHt3tYws
	iw/O4LjYcaq3al/NeOpeBUttwsAP4ZcexTWkSFf+z9hA0qv2yDisQPEjqawLQJSIRUAtVuC0B1x
	mtjZIAzzHRXTFKgNJr4EB8Z2Jq0FZv3uWVOdWV7Pue+uB9LPxHu+V/VGPxFv75v3NRKJDH6AfGq
	mrTaJKKjI3LCmbB8MMpnP8+uc6UyiBgIY7mocDapoVMKv0Kgra2Zh5K3RpaClko30fhqHruvsBj
	ygBDElmwnHMX92a6a7nIYsEvyV83ZZGZjcKLTkggScr5gFKngiGZRima8qZiLaIbYEH6wKdrBNf
	Jz2oHftUd8mj2x4EA==
X-Received: by 2002:a05:690c:6601:b0:81e:c7e5:df5d with SMTP id 00721157ae682-81fd4b51de3mr65716127b3.17.1785621697195;
        Sat, 01 Aug 2026 15:01:37 -0700 (PDT)
Received: from syssplab.cs.fiu.edu (nat1.cs.fiu.edu. [131.94.134.89])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81fcd0d6fbbsm29903767b3.25.2026.08.01.15.01.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2026 15:01:36 -0700 (PDT)
From: Chao Shi <coshi036@gmail.com>
To: Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Matthew Wilcox <willy@infradead.org>,
	linux-fsdevel@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Bob Copeland <me@bobcopeland.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Yuezhang Mo <yuezhang.mo@sony.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	linux-ext4@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	gfs2@lists.linux.dev,
	linux-karma-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org,
	Chao Shi <coshi036@gmail.com>
Subject: [PATCH 19/19] buffer: stop clearing BH_Uptodate when a write fails
Date: Sat,  1 Aug 2026 18:01:03 -0400
Message-ID: <3aa278c3b75de2bca8a94ec0c0e40922b1170881.1785621505.git.coshi036@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1785621505.git.coshi036@gmail.com>
References: <cover.1785621505.git.coshi036@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A buffer whose write failed still holds exactly the data the filesystem
asked to be written.  It is the disk that is out of date, not the buffer.
Clearing BH_Uptodate says the opposite, and callers act on it:

 - mark_buffer_dirty() has a WARN_ON_ONCE(!buffer_uptodate(bh)).  A
   filesystem that dirties the buffer again after a failed write - which is
   the normal way to retry - trips it.  That is the warning this series
   started from.

 - a buffer that is not up to date gets re-read from disk, which replaces
   the data the filesystem was trying to write with the stale on-disk copy,
   silently.

 - the window between the write completing and the buffer being marked not
   up to date is visible to anyone holding the folio lock, so the state is
   not even self consistent while it lasts.

BH_Write_EIO already records the failure, and by now every place in the
tree that needs to know about it tests that flag instead: the two core
helpers in this file, adfs, exfat, ext2, ext4, fat, gfs2, jbd2, ocfs2 and
omfs, converted one filesystem at a time in the preceding patches.  The
private completion handlers in jbd2 and ext4 fast commit were converted
along with their waiters.  Nothing is left that reads BH_Uptodate to find
out whether a write failed, so the clears can go.

Found by FuzzNvme.

Signed-off-by: Chao Shi <coshi036@gmail.com>
---
 fs/buffer.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index ac978d9090c2..0002f0736398 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -207,7 +207,6 @@ void bh_end_write(struct bio *bio)
 	} else {
 		buffer_io_error(bh, ", lost sync page write");
 		mark_buffer_write_io_error(bh);
-		clear_buffer_uptodate(bh);
 	}
 	unlock_buffer(bh);
 }
@@ -441,7 +440,6 @@ void bh_end_async_write(struct bio *bio)
 	} else {
 		buffer_io_error(bh, ", lost async page write");
 		mark_buffer_write_io_error(bh);
-		clear_buffer_uptodate(bh);
 	}
 
 	first = folio_buffers(folio);
-- 
2.43.0

