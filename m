Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7595C71155
	for <linux-ext4@archiver.kernel.org>; Tue,  1 Dec 2020 21:05:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76B5F2054F
	for <linux-ext4@archiver.kernel.org>; Tue,  1 Dec 2020 21:05:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eAHRf1t1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728609AbgLAVFj (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 1 Dec 2020 16:05:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:27644 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727895AbgLAVFj (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Dec 2020 16:05:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606856652;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wVPezxXGFXUfwhFYqa6Djcjyd6cYjq8Fl9klsgPVelA=;
        b=eAHRf1t1LZ4PFEf/NXFyB13qjTgY0cxD82v4+0MFtVCCK9lAS2RS6mY1F3KRaLsY1Kt/rE
        QrAk/F6me22745WrZv+ALdnoYcSpFLeSdbazw9sD6fnxlHSUOMsVqWeq/4acfRXc6whW5D
        ngoId2bgjlaeWbKm8B6KMGyG29IA2ks=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-330-0-5De3DzO4G1pueqNulWww-1; Tue, 01 Dec 2020 16:04:10 -0500
X-MC-Unique: 0-5De3DzO4G1pueqNulWww-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 76353185E485;
        Tue,  1 Dec 2020 21:04:09 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-112-159.rdu2.redhat.com [10.10.112.159])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EFF6D60854;
        Tue,  1 Dec 2020 21:04:03 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <CAHk-=wgOu9vgUfOSsjO3hHHxGDn4BKhitC_8XCfgmGKiiSm_ag@mail.gmail.com>
References: <CAHk-=wgOu9vgUfOSsjO3hHHxGDn4BKhitC_8XCfgmGKiiSm_ag@mail.gmail.com> <e388f379-cd11-a5d2-db82-aa1aa518a582@redhat.com> <05a0f4fd-7f62-8fbc-378d-886ccd5b3f11@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     dhowells@redhat.com, Eric Sandeen <sandeen@redhat.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Ira Weiny <ira.weiny@intel.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-man <linux-man@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        xfs <linux-xfs@vger.kernel.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Xiaoli Feng <xifeng@redhat.com>
Subject: Re: [PATCH 2/2] statx: move STATX_ATTR_DAX attribute handling to filesystems
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <300455.1606856642.1@warthog.procyon.org.uk>
Date:   Tue, 01 Dec 2020 21:04:02 +0000
Message-ID: <300456.1606856642@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> And if IS_DAX() is correct, then why shouldn't this just be done in
> generic code? Why move it to every individual filesystem?

One way of looking at it is that the check is then done for every filesystem -
most of which don't support it.  Not sure whether that's a big enough problem
to worry about.  The same is true of the automount test too, I suppose...

David

