Return-Path: <SRS0=jPQg=6M=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC641C83001
	for <linux-ext4@archiver.kernel.org>; Tue, 28 Apr 2020 16:49:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 940A72063A
	for <linux-ext4@archiver.kernel.org>; Tue, 28 Apr 2020 16:49:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aVmZSuNK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728394AbgD1Qtz (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 28 Apr 2020 12:49:55 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:56227 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728191AbgD1Qtz (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 28 Apr 2020 12:49:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588092594;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=822QsyZiWnpzkjHxEegGYFu1MfdzgdVzY4swsI9HFXI=;
        b=aVmZSuNKZqEAk4lTs3v8TFSP7Phgr8qbsmgAh7N0H1epHMhce2JeVimb65Jo1ijE8u8A8B
        9yZXDsfM+/TsLaxQtXu44/M0R8A00QiRwXNZ2xifJ7Es/m3qMN4qKEm/FWo+Jw9l7cRYVp
        plGzEgJEYQYFzvCqelHROnGabuYqdVE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-324-jhJwYZ9qM4aJkrtoPzET1g-1; Tue, 28 Apr 2020 12:49:52 -0400
X-MC-Unique: jhJwYZ9qM4aJkrtoPzET1g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9D4B118A0760;
        Tue, 28 Apr 2020 16:49:51 +0000 (UTC)
Received: from work (unknown [10.40.192.34])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 58BC9282C9;
        Tue, 28 Apr 2020 16:49:50 +0000 (UTC)
Date:   Tue, 28 Apr 2020 18:49:46 +0200
From:   Lukas Czerner <lczerner@redhat.com>
To:     David Howells <dhowells@redhat.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        viro@zeniv.linux.org.uk, linux-ext4@vger.kernel.org
Subject: Re: Notes on ext4 mount API parsing stuff
Message-ID: <20200428164946.hzgtypcyslb5ydui@work>
References: <20200428152709.GG6733@magnolia>
 <1020558.1588082682@warthog.procyon.org.uk>
 <1073043.1588089543@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1073043.1588089543@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Apr 28, 2020 at 04:59:03PM +0100, David Howells wrote:
> Darrick J. Wong <darrick.wong@oracle.com> wrote:
> 
> > > Here are some notes on your ext4 mount API parsing stuff.
> > 
> > Er... is this a response to Lukas' patchset "ext4: new mount API
> > conversion" from 6 Nov 2019?
> 
> Lukas says that's out of date.
> 
> David

Yeah, I asked David off-list to help me track the issue I was seeing.
But since he already replied here I went ahead and sent the new version
of the patch set. Sorry for the confusion.

Thanks David,
-Lukas

