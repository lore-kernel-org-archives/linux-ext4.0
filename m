Return-Path: <SRS0=ZWG9=SU=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6890C10F0E
	for <linux-ext4@archiver.kernel.org>; Thu, 18 Apr 2019 16:12:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7DA3320693
	for <linux-ext4@archiver.kernel.org>; Thu, 18 Apr 2019 16:12:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389638AbfDRQMR (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 18 Apr 2019 12:12:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44924 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387519AbfDRQMR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 18 Apr 2019 12:12:17 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C8D0F308A110;
        Thu, 18 Apr 2019 16:12:16 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-121-98.rdu2.redhat.com [10.10.121.98])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B71A71001E8A;
        Thu, 18 Apr 2019 16:12:14 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20190418161024.GG7751@bombadil.infradead.org>
References: <20190418161024.GG7751@bombadil.infradead.org> <155559635133.21702.4737487773869377967.stgit@warthog.procyon.org.uk> <155559636704.21702.4538723150377303298.stgit@warthog.procyon.org.uk>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     dhowells@redhat.com, viro@zeniv.linux.org.uk,
        Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu,
        codalist@coda.cs.cmu.edu, linux-afs@lists.infradead.org,
        linux-ext4@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/6] vfs, coda: Fix the lack of locking in FID replacement inode rehashing
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2285.1555603933.1@warthog.procyon.org.uk>
Date:   Thu, 18 Apr 2019 17:12:13 +0100
Message-ID: <2286.1555603933@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Thu, 18 Apr 2019 16:12:17 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Matthew Wilcox <willy@infradead.org> wrote:

> Don't you also need to delete the remove_inode_hash() and
> __insert_inode_hash() calls?

Yep.  Good point.

David
