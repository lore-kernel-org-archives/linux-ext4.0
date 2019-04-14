Return-Path: <SRS0=CYDl=SQ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48CBBC282DA
	for <linux-ext4@archiver.kernel.org>; Sun, 14 Apr 2019 09:15:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1981020850
	for <linux-ext4@archiver.kernel.org>; Sun, 14 Apr 2019 09:15:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amarulasolutions.com header.i=@amarulasolutions.com header.b="Vx6SC+WB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbfDNJPn (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 14 Apr 2019 05:15:43 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:35812 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726359AbfDNJPg (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 14 Apr 2019 05:15:36 -0400
Received: by mail-pf1-f195.google.com with SMTP id t21so7157052pfh.2
        for <linux-ext4@vger.kernel.org>; Sun, 14 Apr 2019 02:15:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=nQJrrbue7c3N84Cd6mFZPA1Y1o7acbXS4cTb2nznlGA=;
        b=Vx6SC+WBX6kmXBT4OP7H4eDk8pZHoU/6bnBya6zmdqnkmojK/Kyegi8oINArN7IYSn
         +1/yKPRCgEiPL2mbV0UVrKN/5WOq6lk9U0eM7lknJ/LesMvOvavOIaIHTDuaUm2Sal0B
         6L2RJwK2Dz0nII5LmzT4mcUBTnjEOkw+KlIkA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=nQJrrbue7c3N84Cd6mFZPA1Y1o7acbXS4cTb2nznlGA=;
        b=GssPnffTOA6Vp6kD+kRxoQdFEIY+xCKA/3TeN2HZweFh1xP9bcEiaocnPO7TBjvDZb
         pouFJXb6m4Jfs3e3z9PoToUocQvKo2Pbggx2cBvMqqGXQ+wlQ9ZP88KyNxF9ymhIN89H
         QjuVSgu7jyQ8WC1RNBmelcBAU6j5Amw5rrSUPz+fPn90iDuZfKx07DwR5fADEERu3A8c
         W5odIZKKpVQFeVjV4U1S2nibAi7WFdeSuxFbZ2UKHwNi0Sv5GIxJpzmJf+vvHq+6tVJt
         1V+YJ52yOsUk2AQaWkJLbRtfRPZ0MW9Lmcubr4ME0fetEuw8QvsJVAG1vbMKpblhOYto
         BAzA==
X-Gm-Message-State: APjAAAUtUg6CTIA5YkLaI6sqz/K8lz4fAHzVIzOfCpLB4OFOkF0HLUs2
        T+ny/A854eJzEqJGl7J0qEMHTA==
X-Google-Smtp-Source: APXvYqzJvZI8cg4NBQ48Y2+PvRZTxzZuXgdmiA69lcI6ZO8t6W2tPumqwfHBphvyyz1mE1fpT8Y3Og==
X-Received: by 2002:a63:3188:: with SMTP id x130mr61423347pgx.64.1555233335889;
        Sun, 14 Apr 2019 02:15:35 -0700 (PDT)
Received: from localhost.localdomain ([42.111.19.105])
        by smtp.googlemail.com with ESMTPSA id g10sm31344767pgq.54.2019.04.14.02.15.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 14 Apr 2019 02:15:35 -0700 (PDT)
From:   Shyam Saini <shyam.saini@amarulasolutions.com>
To:     kernel-hardening@lists.openwall.com
Cc:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        keescook@chromium.org, linux-arm-kernel@lists.infradead.org,
        linux-mips@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        netdev@vger.kernel.org, linux-ext4@vger.kernel.org,
        devel@lists.orangefs.org, linux-mm@kvack.org,
        linux-sctp@vger.kernel.org, bpf@vger.kernel.org,
        kvm@vger.kernel.org, mayhs11saini@gmail.com,
        Shyam Saini <shyam.saini@amarulasolutions.com>
Subject: [PATCH 2/2] include: linux: Remove unused macros and their defination
Date:   Sun, 14 Apr 2019 14:44:52 +0530
Message-Id: <20190414091452.22275-2-shyam.saini@amarulasolutions.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190414091452.22275-1-shyam.saini@amarulasolutions.com>
References: <20190414091452.22275-1-shyam.saini@amarulasolutions.com>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

In favour of FIELD_SIZEOF, lets deprecate other two similar macros
sizeof_field and SIZEOF_FIELD, and remove them completely.

Signed-off-by: Shyam Saini <shyam.saini@amarulasolutions.com>
---
 arch/mips/cavium-octeon/executive/cvmx-bootmem.c | 7 -------
 include/linux/stddef.h                           | 8 --------
 tools/testing/selftests/bpf/bpf_util.h           | 4 ----
 3 files changed, 19 deletions(-)

diff --git a/arch/mips/cavium-octeon/executive/cvmx-bootmem.c b/arch/mips/cavium-octeon/executive/cvmx-bootmem.c
index fc754d155002..44b506a14666 100644
--- a/arch/mips/cavium-octeon/executive/cvmx-bootmem.c
+++ b/arch/mips/cavium-octeon/executive/cvmx-bootmem.c
@@ -45,13 +45,6 @@ static struct cvmx_bootmem_desc *cvmx_bootmem_desc;
 /* See header file for descriptions of functions */
 
 /**
- * This macro returns the size of a member of a structure.
- * Logically it is the same as "sizeof(s::field)" in C++, but
- * C lacks the "::" operator.
- */
-#define SIZEOF_FIELD(s, field) sizeof(((s *)NULL)->field)
-
-/**
  * This macro returns a member of the
  * cvmx_bootmem_named_block_desc_t structure. These members can't
  * be directly addressed as they might be in memory not directly
diff --git a/include/linux/stddef.h b/include/linux/stddef.h
index 63f2302bc406..b888eb7795a1 100644
--- a/include/linux/stddef.h
+++ b/include/linux/stddef.h
@@ -29,14 +29,6 @@ enum {
 #define FIELD_SIZEOF(t, f) (sizeof(((t *)0)->f))
 
 /**
- * sizeof_field(TYPE, MEMBER)
- *
- * @TYPE: The structure containing the field of interest
- * @MEMBER: The field to return the size of
- */
-#define sizeof_field(TYPE, MEMBER) sizeof((((TYPE *)0)->MEMBER))
-
-/**
  * offsetofend(TYPE, MEMBER)
  *
  * @TYPE: The type of the structure
diff --git a/tools/testing/selftests/bpf/bpf_util.h b/tools/testing/selftests/bpf/bpf_util.h
index 2e90a4315b55..815e7b48fa37 100644
--- a/tools/testing/selftests/bpf/bpf_util.h
+++ b/tools/testing/selftests/bpf/bpf_util.h
@@ -67,10 +67,6 @@ static inline unsigned int bpf_num_possible_cpus(void)
  */
 #define FIELD_SIZEOF(t, f) (sizeof(((t *)0)->f))
 
-#ifndef sizeof_field
-#define sizeof_field(TYPE, MEMBER) sizeof((((TYPE *)0)->MEMBER))
-#endif
-
 #ifndef offsetofend
 #define offsetofend(TYPE, MEMBER) \
 	(offsetof(TYPE, MEMBER)	+ FIELD_SIZEOF(TYPE, MEMBER))
-- 
2.11.0

