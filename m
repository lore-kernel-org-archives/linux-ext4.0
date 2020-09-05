Return-Path: <SRS0=LnFg=CO=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A942C43461
	for <linux-ext4@archiver.kernel.org>; Sat,  5 Sep 2020 17:09:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2609620760
	for <linux-ext4@archiver.kernel.org>; Sat,  5 Sep 2020 17:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599325768;
	bh=bYePyoygb5sypUBeDHzAvhU73UeSVNStq9eAPSiouAY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=PpBdeh2uViorNKENA4u1+aKJfR5rPYz5IIIU42ShR2TXrss1rhyx69hOTNvdizjBo
	 8YjW/e5qf8dh5HvTE5U+uqVEgV5JKMvVdRuyCcCybHcIpbqZv5YgFEpYIXQcqihnK7
	 c2GFazHuWSbwk5iUX5ir4nVDTHhmWbv/a8hlNQ3g=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727875AbgIERJ1 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 5 Sep 2020 13:09:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726468AbgIERJ0 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Sep 2020 13:09:26 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5509AC061244
        for <linux-ext4@vger.kernel.org>; Sat,  5 Sep 2020 10:09:23 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id q13so12542121ejo.9
        for <linux-ext4@vger.kernel.org>; Sat, 05 Sep 2020 10:09:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yq3SfrK7yZAtmYRnvDmja3vYq8mdQSVjPiEi6mwaMYI=;
        b=b0r56yrMlN887hWaFszKtt3otNFfkTZGY9PBeAnyiPugAfYpUMCfOTBWDohK5Luc/G
         +LqYWBwLdx1jUaxLPC79yX0fHBJTRyN1py7Wq/ZzjBRr+LK88BEB8cL1Zhj8z/OzGL05
         1K+nOaaiL2yDxhltK+DQ4feWYgd8jEHvr7JnM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yq3SfrK7yZAtmYRnvDmja3vYq8mdQSVjPiEi6mwaMYI=;
        b=GY2F4NustyPpNb2YcdiDL/ZBvivPPlCMG6g/6I2RqA+h63M8DXexywqh8adFXYzSNM
         5Mq6Ulkk7xtomDRDQSzbdwX1ttAr3vwpbzqEfWh0N2l33SS0JohRG0sL5+EdBnQLHjRf
         bWrZnXVLhP0WmM7dd+qqH8BitIXj+chz/jbzenbai3Wsa2BmhDgetsqUHLzIHRbfTRiH
         LFf3TGUBeGRUDA4qbEEsGEqATYBPh9P5VWhWkhaOoSh3ITWsCwbNAP2O3lU/3NX9/Y9L
         lG6UqZYJYsfcLvzBWz36873aHFR20cJy1wQtjenmsvB+/dwHGUJDKNUZ3r/w09p+BkDq
         VYNA==
X-Gm-Message-State: AOAM5302QjfAGUsIfIvLZRtngs7aD0KHl165ZMb1i37IYyt5ROPHSOE/
        wZjm8gvb3oqFDfysGC+44CYWsshxsod39A==
X-Google-Smtp-Source: ABdhPJzIrsW+vJgUGjKlBHEWF7VF7jMkTDFu2eVa9gnn1a2n4+6cDbnRdaq9w3qmUiOunRHkSUpoqQ==
X-Received: by 2002:a17:906:2a59:: with SMTP id k25mr13762244eje.370.1599325759958;
        Sat, 05 Sep 2020 10:09:19 -0700 (PDT)
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com. [209.85.218.54])
        by smtp.gmail.com with ESMTPSA id a5sm1063678edl.6.2020.09.05.10.09.19
        for <linux-ext4@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Sep 2020 10:09:19 -0700 (PDT)
Received: by mail-ej1-f54.google.com with SMTP id z22so12562965ejl.7
        for <linux-ext4@vger.kernel.org>; Sat, 05 Sep 2020 10:09:19 -0700 (PDT)
X-Received: by 2002:a05:6512:403:: with SMTP id u3mr6534077lfk.10.1599325416665;
 Sat, 05 Sep 2020 10:03:36 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.LRH.2.02.2009031328040.6929@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.2009041200570.27312@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.2009050805250.12419@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.2009050812060.12419@file01.intranet.prod.int.rdu2.redhat.com>
 <CAHk-=wh=0V27kdRkBAOkCDXSeFYmB=VzC0hMQVbmaiFV_1ZaCA@mail.gmail.com>
In-Reply-To: <CAHk-=wh=0V27kdRkBAOkCDXSeFYmB=VzC0hMQVbmaiFV_1ZaCA@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 5 Sep 2020 10:03:20 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgNoq2kh_xYKtTX38GJdEC_iAvoeFU9gpj6kFVaiA0o=A@mail.gmail.com>
Message-ID: <CAHk-=wgNoq2kh_xYKtTX38GJdEC_iAvoeFU9gpj6kFVaiA0o=A@mail.gmail.com>
Subject: Re: [PATCH 2/2] xfs: don't update mtime on COW faults
To:     Mikulas Patocka <mpatocka@redhat.com>
Cc:     Jan Kara <jack@suse.cz>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <dchinner@redhat.com>,
        Jann Horn <jannh@google.com>, Christoph Hellwig <hch@lst.de>,
        Oleg Nesterov <oleg@redhat.com>,
        Kirill Shutemov <kirill@shutemov.name>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Linux-MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Sat, Sep 5, 2020 at 9:47 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> So your patch is obviously correct, [..]

Oh, and I had a xfs pull request in my inbox already, so rather than
expect Darrick to do another one just for this and have Jan do one for
ext2, I just applied these two directly as "ObviouslyCorrect(tm)".

I added the "inline" as suggested by Darrick, and I also added
parenthesis around the bit tests.

Yes, I know the C precedence rules, but I just personally find the
code easier to read if I don't even have to think about it and the
different subexpressions of a logical operation are just visually very
clear. And as I was editing the patch anyway...

So that xfs helper function now looks like this

+static inline bool
+xfs_is_write_fault(
+       struct vm_fault         *vmf)
+{
+       return (vmf->flags & FAULT_FLAG_WRITE) &&
+              (vmf->vma->vm_flags & VM_SHARED);
+}

instead.

            Linus
