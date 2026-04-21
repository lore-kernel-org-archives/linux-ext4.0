Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87E7513790B
	for <linux-ext4@vger.kernel.org>; Tue, 21 Apr 2026 04:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776745182; cv=none; b=nYruRwoHDMts4LhywLgPzGAIL+zg4foOcESIXhGT0YgGpJdjtTD6mSx+nPTQ4+U77qvfXE7xaIQfklY9GqusWrjexzzcwNzuzziSliBnTISs4JzzTcEPoENrU41hwVOccJEAlYK0AbKG1sH6faDb+VzOM9wnckuNMsjuQbXkQoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776745182; c=relaxed/simple;
	bh=w2yz4pRvJusRCLwhR0p7hTkXkOrE7+cfb6N741pWs+Y=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References; b=r0SqyDIuIAz8oheK7YItN84uOD0h6Jz7/3MoaS9E3w7yQAYBJ6uApwPERGR77VJPcH9Q/8/1U+t3pUXgOBMSGOsLXF+txpHQtwRhw3EAYzWl1I/VxgbRb5kBQuYpuyGazFOj4T3ioLZDInJnJugc723shiBCL1flNpck14whKB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lfOUwmSl; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lfOUwmSl"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-35da8d037a5so1775812a91.0
        for <linux-ext4@vger.kernel.org>; Mon, 20 Apr 2026 21:19:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776745181; x=1777349981; darn=vger.kernel.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=1H9W578xLJdLW/spgO4oKmx4ftwOYlHFCjRa/9Ujn8M=;
        b=lfOUwmSlMOrDvCVvZM88rv6BKwe7Lp2wPVm/++trkAusM3f78/mY9eFDdq2Wre7qJ7
         82UULrWSGmYexsXlgc7tcagp3I5ChbEVRkvwpVEHTMchvHPToJ06AL3LJutnHDrlEGX8
         s2TI1casYqtc4/4YlhnxIv6Be2jRQOb5Pf7K7SSDRU0tYnuDEOlNHrtmg2rYkMcJLxkB
         TtCxkhImN4IhJ2cbJS9LvMi1XzDmjJuub6sf0zF13RRYAH8mpBfKQOH8sZhnpWHdwXG1
         ERHTDGIlI6rBHFTUuKZ++BTqQQg2IyopHm5i6OPrkRuZjLpwb6meYp6UrNHHyXWrDvza
         W3dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776745181; x=1777349981;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1H9W578xLJdLW/spgO4oKmx4ftwOYlHFCjRa/9Ujn8M=;
        b=LHkh0RwDHnxwPeeI8vKA7UxyU0HA0wNgynA9uAXjmk3rmGplFt267XI0WEwFAC7cuM
         OCMfh7vElYcJM5ZSFM0R4OsOGkt9hxiJI72sS89DdugzUlHBP6AFpMTcRRj0oIx0QCkI
         6gCOJ5UPbX/mqt/5IVdYaDxW31uTymlOqs6JaElkQZo2qFMD5ZDGNei45ce2PhQ6ph3S
         8JAzSQlHkzzZ6h/6EqRl1v7faoOglOkIJj19+VgzIlbYOi4Bf0OlnHnSr6cpufsQfB6T
         FkaUqWrGpZI++BsMmKljDXIpPMOnPfTrDsl7zGM+UzjFn1Gp8gdiFwBJXpfIBUnt/Pnr
         mdaQ==
X-Forwarded-Encrypted: i=1; AFNElJ8tfmkG0lFg6W6QIOjbNPnlcewQhaXZxPKXaUQQLKv0Mmj8nbaOPZwZYWN7GarjPN34rUAPsPafT7TL@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8v/j1BscjfQxEv6sMjM+h775r+FlaJBgbqxsK3bEQWd7f2gHs
	/5OJMB+DVuDzZ5eqqqiDaRoYb/B3TtCznDqsfe4d7/ziUQOJK5rrVM5Ci40KPg==
X-Gm-Gg: AeBDiesrkMtYGqqh/BtZLYJkAhL4Ah6XhssRxw65s2OQ5WFSUvsFtI1+qLghoBQpzpD
	9TCLzFutjy21ClGMdUtt8KhKHyny2WwxyTt+/gFHAQZjAasephcP6m+5DMZqyvhyY+YTtFHbIiV
	Kpulaini5YS7h+UGMg8xd7YxVqLxXZ64stVUEhy6AHYix7EI4B/nhyg4PTDgbiyKinq0FT7surq
	h3IwY/gvReHz8oxsN4PMTWuRPD8Mv4k9VaoEjeoccrWWIj6dbG9dJ7K7TW3Z9uJEN3R0W0H8Vcz
	utuJm2QZSFEyaikNifmn0BLEnr+9Fobn/Vn0G7cWqT+g7Lrj6t5eVtZ+HAXLQ3/Zm/QVIYg3qu8
	i34GKb6owafpYc1kSE1ciXjtVL8MuGHdoVl5i3h/coUwcRdY4EROlI8b5sabWfrj5ZrYBzqnest
	3xqNLiQ33yDB6+Y27xX4rPDKn80ktE+EhX
X-Received: by 2002:a17:90b:4b86:b0:35b:e550:e68a with SMTP id 98e67ed59e1d1-361403b8367mr16468262a91.3.1776745180755;
        Mon, 20 Apr 2026 21:19:40 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36140fc575bsm12149029a91.4.2026.04.20.21.19.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 21:19:39 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Andreas Dilger <adilger@dilger.ca>, Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: Baolin Liu <liubaolin12138@163.com>, tytso@mit.edu, wangguanyu@vivo.com, yi.zhang@huaweicloud.com, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, Baolin Liu <liubaolin@kylinos.cn>
Subject: Re: [PATCH v2 v2 2/2] ext4: allow clearing mballoc stats through mb_stats
In-Reply-To: <4A904858-8611-42BC-B1BD-9679F284F8EE@dilger.ca>
Date: Tue, 21 Apr 2026 09:10:35 +0530
Message-ID: <7bq1t1zg.ritesh.list@gmail.com>
References: <20260419063436.17999-1-liubaolin12138@163.com> <20260419063436.17999-3-liubaolin12138@163.com> <aeXt_qg1SprB9Gu_@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com> <4A904858-8611-42BC-B1BD-9679F284F8EE@dilger.ca>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Andreas Dilger <adilger@dilger.ca> writes:

> On Apr 20, 2026, at 03:12, Ojaswin Mujoo <ojaswin@linux.ibm.com> wrote:
>> 
>> On Sun, Apr 19, 2026 at 02:34:36PM +0800, Baolin Liu wrote:
>>> From: Baolin Liu <liubaolin@kylinos.cn>
>>> 
>>> Make /proc/fs/ext4/<dev>/mb_stats writable and clear the runtime
>>> mballoc statistics when 0 is written.
>>> 
>>> Signed-off-by: Baolin Liu <liubaolin@kylinos.cn>
>>> ---
>> Hi Baolin, thanks for the changes.
>> 
>> Seems like userspace doesn't have any way to know that writing 0 will
>> clear the that. Well, I guess if you are looking at this file you are
>> anyways debugging kernel code so that should be fine
>
> That could be documented in Documentation/filesystems/ext4/allocators.rst,
> or better would be to add a new file that covers mballoc in more detail.
>

I started looking for ext4's control knobs for sys-admins in kernel
Documentation where we should ideally document this, and I see those
are declared here..

Documentation/admin-guide/ext4.rst
Documentation/ABI/testing/sysfs-fs-ext4.rst

Looking at this and the relevant code, I see all /proc/ entries in ext4
are all readable and sysfs entries for ext4 are mostly the control knobs
which are declared in above admin guide.

But now this patch adds a control knob to /proc/fs/ext4/<dev>/mb_stats,
to clear the stats :).

I guess we could have simply documented a new control knob value (e.g.
"2") for clearing the stats via /sys/fs/ext4/<dev>/mb_stats itself or
maybe even having mb_stats_clear file in sysfs wasn't bad either... But
either ways, clearing the stats via the same procfs mb_stats file is not
totally bad and I don't have a strong preference.


For documenting this, we can add mb_stats entry under /proc section in
Documentation/admin-guide/ext4.rst and document this change. Something
like - 

  mb_stats
        reports runtime statistics from multiblock allocator (mballoc),
        including allocation request counts, groups scanned,
        per-criteria scan hits (cr_p2_aligned, cr_goal_fast,
        cr_best_avail, cr_goal_slow, cr_any_free), groups / extents
        scanned, goal hits, buddy bitmap generations, and preallocation
        usage etc.
        Writing 0 to this procfs file resets all counters to zero.


-ritesh

