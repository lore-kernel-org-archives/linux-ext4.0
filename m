Return-Path: <SRS0=DlHj=QT=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8414DC169C4
	for <linux-ext4@archiver.kernel.org>; Tue, 12 Feb 2019 00:14:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 414732084E
	for <linux-ext4@archiver.kernel.org>; Tue, 12 Feb 2019 00:14:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=utexas-edu.20150623.gappssmtp.com header.i=@utexas-edu.20150623.gappssmtp.com header.b="Ts69gJRk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727297AbfBLAOc (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 11 Feb 2019 19:14:32 -0500
Received: from mail-ot1-f44.google.com ([209.85.210.44]:37288 "EHLO
        mail-ot1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727141AbfBLAOb (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 11 Feb 2019 19:14:31 -0500
Received: by mail-ot1-f44.google.com with SMTP id b3so1449101otp.4
        for <linux-ext4@vger.kernel.org>; Mon, 11 Feb 2019 16:14:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=utexas-edu.20150623.gappssmtp.com; s=20150623;
        h=mime-version:from:date:message-id:subject:to;
        bh=3c4k5OGIrBJO3HXmIpmDKvhWgIG5wP0HeI6Vkbj9d+0=;
        b=Ts69gJRkMcR7Wo0Xh+vxLNrwJrHOLSD9yc/BO2qQOrV+fUq1sDY6Zsu3JybUkSfP7P
         7VXGvO4wJwV0y3kXCxk8dJ19VBd1cSbgczVuWMuLnf6hzVzVr6co5k80D9MltEDVZMRV
         7L49wtn3bPFtyinZp+043OeApiKWscu9gJkQ1THQlnaly2vB+4yYtKr+b+PAe/6dr5NB
         FtgIErM5eyEwu/aoJHzgmnElXiTTL55dwrsoEa5FLY4iUe/VhPKhpCSWpgd1YF/Ni7Be
         degNQfmHu27MlWjPiyCdE0trXVYrO9ahZedfom3sA19qRwhm+GowzlJ3GWTYM3LoWtsK
         lM1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=3c4k5OGIrBJO3HXmIpmDKvhWgIG5wP0HeI6Vkbj9d+0=;
        b=hLBRJmOAsFb/vhJvO0/czBcyrYm9bjq7d3jKuntaU8PDrmEL135cP+mYcpAfT31aKa
         A2wZnviwHzHPOJzcBvjD+FJWa1ZbkHvek3QWbWnlHPmrAcXnrvepzssDw/f5vmSvJ19d
         TabGmiAYfjJOpcxyKAWsO/5G5eqB5F4KnuUI1GxgXMn4N40ee/aueb9POm5082h/td0k
         dGvF59MjN4YqCTXnUynLO4su36iMzUKftPKSBUIqUrzFckVRpPaKlZfwrX82a8AUuP1R
         MHD9RiMhS738NgLKJrzwmmoxP2ClOoMLpiGkMdMnYVwBifHYDav+4O4TAigzdKHPEZU7
         0/og==
X-Gm-Message-State: AHQUAuZx0QrKB9rVIuzHwoI07yqtvutgV0/QoAnYvakaRkht1khCEL1E
        JZcYA9aoYP5mL2fMSiBsAXr/9PdVcAinA4uQT2/EsSw/v3o2lw==
X-Google-Smtp-Source: AHgI3Ia9LjqIlZfWru3dlcA+b59iECilqMRjhzrWtN7o2jG+BGoG7Ba4KoZzOxDg/m37wPuWz51S3wZ8XGWQXsCmn5c=
X-Received: by 2002:a9d:61c5:: with SMTP id h5mr922112otk.179.1549930470857;
 Mon, 11 Feb 2019 16:14:30 -0800 (PST)
MIME-Version: 1.0
From:   Vijay Chidambaram <vijayc@utexas.edu>
Date:   Mon, 11 Feb 2019 18:14:18 -0600
Message-ID: <CAHWVdUVW7VMefDQBpas4Trm2SrJupKqKSgAXN9ZiMWJFQCryKA@mail.gmail.com>
Subject: Selective Data Journaling in ext4
To:     linux-ext4@vger.kernel.org, jesus.palos@utexas.edu,
        Theodore Tso <tytso@mit.edu>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hi all,

We would like to present an idea to improve the performance of data
journaling in ext4. Data journaling is expensive because data is
written twice: once to the journal and once to the actual file system.
Passing data through the journal provides consistency guarantees that
ordered journaling mode cannot provide (for example, data journaling
prevents a data block from being partially written).

The idea behind Selective Data Journaling is simple: create a new
journaling mode by modifying ordered journaling mode to journal data
blocks which are already part of a file. Data blocks which are newly
allocated are not part of the journal, and are written out before the
journal blocks in accordance with ordered mode's ordering guarantees.
If there is a crash before transaction commit, the only side effect is
un-allocated data blocks getting written with new data.

Selective Data Journaling provides a lot of the benefits of data
journaling, at significantly lower cost. For workloads which mostly
deal with new data blocks (any applications which update files via
atomic rename), Selective Data Journaling can increase performance
significantly.

We came up with Selective Data Journaling during my PhD at the
University of Wisconsin Madison [1]. I haven't inspected the ext4
codebase deeply since then, so this optimization may already exist.
There may also be problems with this approach that we have not
considered -- we are open to discussion. It may also be the case that
nobody uses data journaling so the extra complexity is not worth it.

If this is something you would like to see implemented, my student
Jesus Palos (cced) is interested in doing so. We would like to discuss
how best to implement this if you are interested.

[1] http://research.cs.wisc.edu/adsl/Publications/optfs-sosp13.pdf

Thanks,
Vijay Chidambaram, UT Austin
http://www.cs.utexas.edu/~vijay/
