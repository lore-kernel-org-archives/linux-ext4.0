From: =?UTF-8?Q?Andreas_Gr=C3=BCnbacher?= <andreas.gruenbacher@gmail.com>
Subject: Re: [PATCH 6/6] mbcache2: Use referenced bit instead of LRU
Date: Sat, 12 Dec 2015 00:58:51 +0100
Message-ID: <CAHpGcM+z=ZakzUC2qHQgOF0ZuDGEfH1HXQwCCruTysOVMEd1zw@mail.gmail.com>
References: <1449683858-28936-1-git-send-email-jack@suse.cz>
	<1449683858-28936-7-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Laurent GUERBY <laurent@guerby.net>,
	Andreas Dilger <adilger@dilger.ca>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:34501 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969AbbLKX6w (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 11 Dec 2015 18:58:52 -0500
Received: by mail-wm0-f52.google.com with SMTP id c17so29480111wmd.1
        for <linux-ext4@vger.kernel.org>; Fri, 11 Dec 2015 15:58:51 -0800 (PST)
In-Reply-To: <1449683858-28936-7-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jan,

2015-12-09 18:57 GMT+01:00 Jan Kara <jack@suse.cz>:
> Currently we maintain perfect LRU list by moving entry to the tail of
> the list when it gets used. However these operations on cache-global
> list are relatively expensive.
>
> In this patch we switch to lazy updates of LRU list. Whenever entry gets
> used, we set a referenced bit in it. When reclaiming entries, we give
> referenced entries another round in the LRU.
>
> In my testing this logic gives about 30% boost to workloads with mostly
> unique xattr blocks (e.g. xattr-bench with 10 files and 10000 unique
> xattr values).

I find it quite confusing that with this patch applied, structs
mb2_cache and mb2_cache_entry still contain fields with "lru" in their
name.

Thanks,
Andreas
