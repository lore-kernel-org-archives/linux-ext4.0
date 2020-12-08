Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7C2FC4361B
	for <linux-ext4@archiver.kernel.org>; Tue,  8 Dec 2020 13:01:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4CF723A3C
	for <linux-ext4@archiver.kernel.org>; Tue,  8 Dec 2020 13:01:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727831AbgLHNBJ (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 8 Dec 2020 08:01:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22807 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726228AbgLHNBJ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Dec 2020 08:01:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607432382;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KJuycivZ+AGkxRm8Uh8ZFQ/EkEn5NEsY/G+sybB3iCk=;
        b=jJYGbGZQTUoDpQsiWKDDJLP1PnmwX5h1P5c34QUIvVV5iDAkHrSEpjNwAea0pAmghYarjT
        BiFLuDA0M7bUzTHZ5wwtdLi522QnnuZcynhnqjzib2KM8wRIM9nSLO10FZYiy8o+NU4bGs
        M07tWmrDSywTavm+KYCdicMZS0nR0JA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-119-YPk_nV1tMeGdtiy9SzJOuA-1; Tue, 08 Dec 2020 07:59:39 -0500
X-MC-Unique: YPk_nV1tMeGdtiy9SzJOuA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9040A84E251;
        Tue,  8 Dec 2020 12:59:37 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-116-67.rdu2.redhat.com [10.10.116.67])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1F7EE10023AC;
        Tue,  8 Dec 2020 12:59:34 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20201208003117.342047-1-krisman@collabora.com>
References: <20201208003117.342047-1-krisman@collabora.com>
To:     Gabriel Krisman Bertazi <krisman@collabora.com>
Cc:     dhowells@redhat.com, viro@zeniv.linux.org.uk, tytso@mit.edu,
        khazhy@google.com, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        kernel@collabora.com
Subject: Re: [PATCH 0/8] Superblock Notifications
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <953339.1607432374.1@warthog.procyon.org.uk>
Date:   Tue, 08 Dec 2020 12:59:34 +0000
Message-ID: <953340.1607432374@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Gabriel Krisman Bertazi <krisman@collabora.com> wrote:

> After the two previous RFCs this is an attempt to get the ball spinning
> again.
> 
> The problem I'm trying to solve is providing an interface to monitor
> filesystem errors.  This patchset includes an example implementation of
> ext4 error notification.  This goes obviously on top of the watch_queue
> mechanism.

Thanks for picking this up and advancing it.

> Regarding the buffer overrun issue that would require fsinfo or another
> method to expose counters, I think they can be added at a later date
> with no change to what this patch series attempts to do, therefore I'm
> proposing we don't wait for fsinfo before getting this merged.

That's fine, but anyone wanting to use this will need to be aware that
overruns are a problem.

David

