Return-Path: <SRS0=3UD1=RY=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15355C4360F
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 20:25:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6611218FD
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 20:25:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728916AbfCUUZc (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 21 Mar 2019 16:25:32 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:52575 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728905AbfCUUZb (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Mar 2019 16:25:31 -0400
Received: from callcc.thunk.org (guestnat-104-133-0-99.corp.google.com [104.133.0.99] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x2LKPJUc016998
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Mar 2019 16:25:19 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id DEA9D420AA8; Thu, 21 Mar 2019 16:25:18 -0400 (EDT)
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc:     darrick.wong@oracle.com, lczerner@redhat.com,
        "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH -v2 0/9] e2fsprogs: e2scrub cleanups
Date:   Thu, 21 Mar 2019 16:25:04 -0400
Message-Id: <20190321202513.1969-1-tytso@mit.edu>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

The primary changes are in the device probe loop refactor for
e2scrub_all.

There were also some documentation changes for the -n option.

Darrick J. Wong (1):
  e2scrub_all: refactor device probe loop

Theodore Ts'o (8):
  e2scrub: check to make sure lvm2 is installed
  debian: drop lvm2 from the recommends line
  Fix "make install-strip"
  e2scrub: fix up "make install-strip" support
  e2scrub: add the -n option which shows what commands e2scrub would
    execute
  e2scrub_all: add the -n option which shows what e2scrub_all would do
  e2scrub_all: make sure there's enough free space for a snapshot
  e2scrub,e2scrub_all: print a (more understandable) error if not run as
    root

-- 
2.19.1

