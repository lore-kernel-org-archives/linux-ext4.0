Return-Path: <SRS0=jPnt=6G=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA897C54FCB
	for <linux-ext4@archiver.kernel.org>; Wed, 22 Apr 2020 14:27:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 873DE2076E
	for <linux-ext4@archiver.kernel.org>; Wed, 22 Apr 2020 14:27:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DnwXRP8T"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbgDVO1P (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 22 Apr 2020 10:27:15 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:22656 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726419AbgDVO1P (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 22 Apr 2020 10:27:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587565634;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=T++6lxdmFtFZnyG5wIW2hksMeif2QZiboHtzMhe4Tfs=;
        b=DnwXRP8TAyoPlFBETnifExdjd1+rLcKu0g85/rM+oy1Rk3wDoglxKxoiFEUJ2RpfjV0i4s
        bmUCW1ef9pGa+kzh2okae3CAyJ8fGJljsNzQF6OQI7X9mGOyTsr+rpj0HYkmwqDeDwvcic
        bqxffMI9VHybWpq0x9T/trAK+ri9yNM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-472-Bo7f7rf5PKiZEDj4EQ4HJQ-1; Wed, 22 Apr 2020 10:27:12 -0400
X-MC-Unique: Bo7f7rf5PKiZEDj4EQ4HJQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0B89E107ACC4;
        Wed, 22 Apr 2020 14:27:11 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-113-129.rdu2.redhat.com [10.10.113.129])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C381710027AB;
        Wed, 22 Apr 2020 14:27:09 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <BFC9114B-7D3D-4B8F-A8BB-75C2770EE36D@dilger.ca>
References: <BFC9114B-7D3D-4B8F-A8BB-75C2770EE36D@dilger.ca> <20200401151837.GB56931@magnolia> <2461554.1585726747@warthog.procyon.org.uk> <2504712.1587485842@warthog.procyon.org.uk>
To:     Andreas Dilger <adilger@dilger.ca>
Cc:     dhowells@redhat.com, "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Theodore Ts'o <tytso@mit.edu>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: Re: Exporting ext4-specific information through fsinfo attributes
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2841658.1587565628.1@warthog.procyon.org.uk>
Date:   Wed, 22 Apr 2020 15:27:08 +0100
Message-ID: <2841659.1587565628@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Andreas Dilger <adilger@dilger.ca> wrote:

> I can definitely get behind adding generic properties like the ones
> you list below.

Are there any specific properties you'd like exported through this interface?

David

