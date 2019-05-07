Return-Path: <SRS0=Q1gA=TH=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34C6EC004C9
	for <linux-ext4@archiver.kernel.org>; Tue,  7 May 2019 18:56:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E89942054F
	for <linux-ext4@archiver.kernel.org>; Tue,  7 May 2019 18:56:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cqxH2GmY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726572AbfEGS4k (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 7 May 2019 14:56:40 -0400
Received: from mail-lf1-f41.google.com ([209.85.167.41]:39006 "EHLO
        mail-lf1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726321AbfEGS4k (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 7 May 2019 14:56:40 -0400
Received: by mail-lf1-f41.google.com with SMTP id z124so6500044lfd.6
        for <linux-ext4@vger.kernel.org>; Tue, 07 May 2019 11:56:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NFHuN/xjJoo0kjtNfvN62R3ecYd6M3aeCNfZTRQU7rE=;
        b=cqxH2GmYPTPh1UvfrfZMXOwUUfVwfHCoMbzYl3QiVkxk9nSKdlCN83M9TZJyF+vD6i
         Ws/WPu0I+ymLlyYq1rM1cLDEAompvRUB6OmqboNM5uHur0D645ByCNo9PtrKP127xHEZ
         UJMn5ky4mj5ZHC7PvjUe7bpbyRIK1PTfOgwLtVpRIo2XfNePBNDzoO3LrnFZljkNNzVl
         fDJZYFkgzGZ8zLw5KN1w9WOlmScyPqfALNAWFY99rfh1fWcniZu6ubvh3eMpT/6L8csf
         8wyBLkUKVR/FvjufFgdZXcUfbR16O0VxEi4G1XK4klqIqRRDR+8HEV8WU4LbrCzMOWFh
         PM+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NFHuN/xjJoo0kjtNfvN62R3ecYd6M3aeCNfZTRQU7rE=;
        b=TFh6OgRSl/lhRJKrTOIuueQKLFQy9ggwbzl/v7oXty1jjRNFzsRDjft9RNGsn9mFC0
         sNrp/iyrwWp/Pjb5FW8mA8Akak1a7pG3UkuRxoVVHBYiAZelfg9zMo0NpUvdQalUSnYp
         SS8hYSg8k/V2ZNeXIr1npFmH930HrCTRMiqSus382CyZbjKIrGfRxvQS7nK7iKPSnq51
         shIp6UXCBxFKvkzV22acBTJdi5QBTyhxxpq14g+q57M4IC5lVq5SHAsRT+sUAjBfGwAd
         cIK9IxJw10GeaBV29HJrdwWrx41woCynuW/6MTZ0sJEidhssq7CMuEOWIq8SPfuDyodr
         FfaQ==
X-Gm-Message-State: APjAAAUvoiOfjHbYccAGA7ywG+QpEI27vzwg9IUIeQUF0RgSGDLk5jET
        Gib0z3JPNuXdVZKrsUXq+p1ECnPivxxIYHjgntMUdLGhRq8=
X-Google-Smtp-Source: APXvYqzYDg1051OMmMojLClvPGE3TLL6eiinUoBpWGonJ7IaAAd58JAz+qlcGSih9/sZqhZHf+pg9holDDmgx7bfQrk=
X-Received: by 2002:ac2:50d5:: with SMTP id h21mr17885303lfm.44.1557255398672;
 Tue, 07 May 2019 11:56:38 -0700 (PDT)
MIME-Version: 1.0
References: <CALe4XzYNBKhtcYvcuME0A29LvPuZEuirD3DLtHnffObRCUU8Rg@mail.gmail.com>
 <20190507175921.GD5900@mit.edu>
In-Reply-To: <20190507175921.GD5900@mit.edu>
From:   Probir Roy <proy.cse@gmail.com>
Date:   Tue, 7 May 2019 13:56:27 -0500
Message-ID: <CALe4XzZxzMaDACmrVHJZ6ronWMd9JC+1t6EetYUu39FitofqDg@mail.gmail.com>
Subject: Re: Locality of extent status tree traversal
To:     "Theodore Ts'o" <tytso@mit.edu>
Cc:     linux-ext4@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

> block number (e.g., the location on disk).  It's a cache; lookups are
> fast, and is an in-memory lookup.  Well, it's a little more than a
> cache, it also stores some information for delayed allocation buffered
> writes.

For sequential access, it will traverse almost the same path of the
tree. How deep the extent status tree be in general? If the tree is
much deeper, the sequential accesses would have many repeated nodes
traversal on the tree for the lookup. Have you observed significant
bottleneck on "ext4_es_lookup_extent"? Can it be removed by caching
the parent node?

-- 
Probir Roy
