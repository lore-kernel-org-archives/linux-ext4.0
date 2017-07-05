From: Tahsin Erdogan <tahsin@google.com>
Subject: Re: ea_inode gce-xfstests results
Date: Wed, 5 Jul 2017 10:36:53 -0700
Message-ID: <CAAeU0aPuULL7=jqgDm5-quWXcxMWWxv+Y0ckN2T9juPKHJ6afQ@mail.gmail.com>
References: <20170705152847.owkgnqgrb25drqby@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yb0-f176.google.com ([209.85.213.176]:36520 "EHLO
        mail-yb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751716AbdGERgy (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Jul 2017 13:36:54 -0400
Received: by mail-yb0-f176.google.com with SMTP id f194so15150969yba.3
        for <linux-ext4@vger.kernel.org>; Wed, 05 Jul 2017 10:36:54 -0700 (PDT)
In-Reply-To: <20170705152847.owkgnqgrb25drqby@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> generic/319
> ===========
>
> Looks like some kind of ENOSPC error when inheriting the acl
> (this may be a journal credits issue?):

Yes. __ext4_new_inode() currently does not add journal credits for acl
updates. I am working on a fix.
