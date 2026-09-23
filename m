Received: from mail-pj2-f43.google.com (mail-pj2-f43.google.com [74.125.227.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C93A47FAF1
	for <linux-ext4@vger.kernel.org>; Wed, 23 Sep 2026 10:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790158708; cv=none; b=t3Z9+GhZ3387UkQxy1F+h48JcQ8K8tQj+31DIGg/QSWOP7gwW60S/OjqJJevCv3XNP9q9taPeaxXXhu8czpREieuceHmz1p6uO0W9Q9Z/FYVjrwn6gb+LuaDk6LK5xTXlLKN06D2VzQpbG5AYIqwmqArTZFh1tdaJdv2U5T5VuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790158708; c=relaxed/simple;
	bh=a+cJdm8IiZcacYLUjAZcRb2XVSYMoCvpEgOVZcRpriI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M3XgfET3jtUxhurnmYee7us+7QAReKkDuigc+kmLzy1b2bry/FrJ4/aLNZ2og4zj5At4pxYuTIbJL3LHRVn2G6BT7t2ncVFi7SrFRQtH+gDnIw6UFfgL+sLF4v1GHSZgSJXbKMpKcIJXMfr5OIpJ1T3hMN9q6c1/Y5moEfpbD6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Jt5Y1gaW; arc=none smtp.client-ip=74.125.227.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jt5Y1gaW"
Received: by mail-pj2-f43.google.com with SMTP id 98e67ed59e1d1-398b3b189e0so432219a91.2
        for <linux-ext4@vger.kernel.org>; Wed, 23 Sep 2026 03:18:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790158701; x=1790763501; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=t4Qt8UnZ0vVuVe6iwFyjd3A5kkZMGcM702CaDlGMCck=;
        b=Jt5Y1gaWbouHOxolMzkFbsxZ2cblYUoI6N//SDLgxID6Y1Bc0fHColPV2iDYXDKvr7
         gUMIBFElD5WwYWwPcbsosVKkYVqg9g9cKiiVUi+kS4IKdwjFitU//wQ5XbxxVXBN2dzR
         XMwwHrTCVSj3BOMlQ8ZVgzzRA0g1Ukn319x39zsg0EmP0ovgJAToc9VB0mVvC1P23fW/
         Tz56tLr0arEZfqWk7WLbUgRoSSKG0qRpmfzpvyhq2BjZ71SxxBfAmAkYGQycFC5YeLwa
         WQ6wjdokNAPfEuZnRA04WtOFU0ie4Mwq72Z1vJVP4KBcap483dDdNILe8MfsddS0pmTb
         Ggdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790158701; x=1790763501;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=t4Qt8UnZ0vVuVe6iwFyjd3A5kkZMGcM702CaDlGMCck=;
        b=IC9d3bAraRTR1EPw0kaudBsc4XFS65lE1u+KnoV+JhWMHi0E+3OZAB985b2cI4ekNT
         lsORB/GqWUg/OTiV979+F17/1zxxhagGtJgS/sA0oPOAyBxX8SKI/WqDdIwMxuSMitsa
         huTfJonp1cUHkrJ4onO5WBqPp3XBMsHPOIIaezNuk2MDUmNCfu1akT01mYM4+ecYDKez
         O4LNG3ogBj+iAU3w4bEezqsZx2AUppyfixOIccRnlCNPhYq9BL7zA38B6HFBxyuu4s5T
         IBRhUz/z7/wDUGMLMTiyvKMplhzzPwrLPnK/dZZpleySRncPuWvUO5uaMXg7URknyJTZ
         RhvQ==
X-Gm-Message-State: AFuF++nYu+xyDd6iuVuOEpfA98em9hgvszIkKfI7+2xkC8HAmr9B4rCX
	99ye7BgfQ7Z8h7kxIfdq0yalEaVKCeAzr7M/qqLN37DYmTU1623rdNYh
X-Gm-Gg: AYBFou2LrgpX5Xg8DxobifClyQWB9kGbj0Wt8EnqGKxxqi5mhwrLy69JTkxjkpZ+ifY
	hl1J+XRoJFRKBkVx+UNkkEiQTxn+aFRBMUMacJ7+xMgxtFQqQ1/lX36/Lze74JhUEprZLe2BHvW
	zLZVIgluzynL0paohEBLbH53o1VY2OTsA6JGXKG0n4Twc37It3XxErZTpGD1b4KXcqD/AvQN68L
	LC/MVudk/+09dLp6nktdSb5Y85GT9K6CrnirR7f0vjmWtC53XVg9PQEVeHt7bLuk65E9WSu3MFa
	8+cqHgGFhpmd7sCO4ALKsZEhvxKRrRItxBvxdLbfBqAuFKZnEqpVeZFZT/fhHj1kaz4SlZWQL6l
	RODxL+ryYxv23o/xzrJV0+R8gbCkYswqhmcROkq9FGHjw4/3sslCcYyZ0yQnbuKLHhfiLBPnLm5
	dqnheStyh04VxabBn4eT8DndRYqmp1Eg/z/dbijTLkhYqWKCIHFTZipSYf9cNGRMeJ/SUFXHzDS
	Z/45/DdxRpBaw6xecOPGS9mZXbNZnEwD6OLcr61lJTGBOeESXUhtbdXTDfLxw5wOUUeTdlPJJSs
	88GkRfzN4YFWIwDcNOjgskmN4SFRW7qPoj5qFnAAVEKYPhaFZFj1R0goJY5NEQ==
X-Received: by 2002:a17:90b:2b43:b0:39e:4717:7cd9 with SMTP id 98e67ed59e1d1-3a07e313fcdmr1820334a91.0.1790158701335;
        Wed, 23 Sep 2026 03:18:21 -0700 (PDT)
Received: from spider.bream-herring.ts.net ([103.252.203.158])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a07dbf69f0sm4423738a91.8.2026.09.23.03.18.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 03:18:20 -0700 (PDT)
From: Matthias Goergens <matthias.goergens@gmail.com>
To: Theodore Ts'o <tytso@mit.edu>,
	Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org,
	sashiko-reviews@lists.linux.dev
Subject: Re: [PATCH v3] ext4: drop extra ea_inode ref in cached-block reuse path
Date: Wed, 23 Sep 2026 18:18:17 +0800
Message-ID: <20260923101817.3507594-1-matthias.goergens@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260916072420.316321F000FF@smtp.kernel.org>
References: <20260916071046.2182813-1-matthias.goergens@gmail.com> <20260916072420.316321F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Ted, Jan: both findings come from the tree the review ran against, not
from the patch.  The baseline was ext4/HEAD, which is 96485e446260 from
October 2020: HEAD in tytso/ext4.git points at master, which stopped
there, while this patch is against dev (9091c97be340).

- [Critical] double decrement: at 96485e446260 the cleanup label dropped
  the lookup reference whenever ea_inode was set, error or not.  Since
  0a46ef234756 ("ext4: do not create EA inode under buffer lock") it
  does so only when error is set, and a successful cache hit reaches
  cleanup with error == 0, so the new ext4_xattr_inode_dec_ref() is the
  only drop of the lookup reference on that path.  If that call fails,
  ea_inode is cleared before the goto.

- [Low] ext4_put_ea_inode() undefined: it was added by 4f48af3dc755
  ("ext4: introduce ext4_put_ea_inode() for safe deferred iput") and is
  declared in fs/ext4/xattr.h.

Sashiko takes the tree from the ext4 T: entry in MAINTAINERS, which
names no branch, so it uses the repository's HEAD.  I've sent a patch
naming dev there, which is also what linux-next merges; pointing HEAD at
dev would also help other tools that follow the default branch.  I'll
report the stale baseline to the Sashiko maintainers as well.

Matthias
