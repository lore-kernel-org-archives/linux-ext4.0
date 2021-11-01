Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAD51C433EF
	for <linux-ext4@archiver.kernel.org>; Mon,  1 Nov 2021 16:18:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A1916113D
	for <linux-ext4@archiver.kernel.org>; Mon,  1 Nov 2021 16:18:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232659AbhKAQV3 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 1 Nov 2021 12:21:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35527 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232498AbhKAQV0 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 1 Nov 2021 12:21:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635783533;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+PlMFyDlSdyotYZmkf9Kx/3zxEQEZ+hPS+mrYwQmhsg=;
        b=EW0fz8Qe+ut9KmyCoRnOsO+APBwR60Zxa92KxIOw0e3QnKU/DslfH1ELoHiVCkefhnbYEu
        QOheCjtisgQ1WDDVDdsZ6TkXRMXrhS8S5d86zD8pYK3L36Z6H1AbIQBLv7Ig/obIp6gM7b
        CYbnS/lTZusUX2RMuk9U17L7r0fDKrA=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-441-RFiDWm65OsaCICNjaffPoQ-1; Mon, 01 Nov 2021 12:18:52 -0400
X-MC-Unique: RFiDWm65OsaCICNjaffPoQ-1
Received: by mail-qk1-f200.google.com with SMTP id bi16-20020a05620a319000b00462d999de94so7328794qkb.18
        for <linux-ext4@vger.kernel.org>; Mon, 01 Nov 2021 09:18:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+PlMFyDlSdyotYZmkf9Kx/3zxEQEZ+hPS+mrYwQmhsg=;
        b=ZJ7JVat17mxrU6D+pyTvMjjWLzH7/ORBq8uwTSYn1ohmxWsOHZ2KX8EdyuVZsyVKPw
         yL+bJrLf0Y9dbaPYY5WhF23ATrV+gq/NZ9cArfsthhxni5WeWT8JV/fkRbYCEjE7yIxV
         sYFfea4TabS5WBI2SlbzJoRl5gX/fFtVgKAfMSS4/vrhPZA3wHunHB99FM+mg1108D1g
         RECpcGACMDFjbdsILmJSucpcyK/C3G2dPItHkq+Lh1Fe7T27qQnGtmbb3gdQVp+AlRyp
         diS4RETJwT8+Lr79E4QG5/H8IOsg89scOmHmvyJhDri+T+rH8zEMXxvvZC6EJLwQrnyL
         aCCw==
X-Gm-Message-State: AOAM530fvqKSnhKx05OPwXimjjc8BcLsfTxAi0Sy6GwgJblMdgWCvTk6
        inlLWjL3SYsMYYCh+sTWNL5BoKzEVzpEOfbRHzUk9aaRKZwZpx7kh6pFqm7E/KvtPfK/ejs1iJD
        DRS5XJyi9no94zZIhYWKN
X-Received: by 2002:ac8:183:: with SMTP id x3mr31456932qtf.270.1635783531653;
        Mon, 01 Nov 2021 09:18:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx06c4hivJwjfQA8DeAKPNXipJ/hNPI/8Dli7abowyJqKsKBWURc5Mk5ISYlLWlJ3N1kL0ucw==
X-Received: by 2002:ac8:183:: with SMTP id x3mr31456902qtf.270.1635783531462;
        Mon, 01 Nov 2021 09:18:51 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net. [68.160.176.52])
        by smtp.gmail.com with ESMTPSA id q20sm10701041qkl.53.2021.11.01.09.18.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 09:18:51 -0700 (PDT)
Date:   Mon, 1 Nov 2021 12:18:50 -0400
From:   Mike Snitzer <snitzer@redhat.com>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     Christoph Hellwig <hch@lst.de>, Ira Weiny <ira.weiny@intel.com>,
        device-mapper development <dm-devel@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Linux NVDIMM <nvdimm@lists.linux.dev>,
        linux-s390 <linux-s390@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-erofs@lists.ozlabs.org,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 08/11] dm-linear: add a linear_dax_pgoff helper
Message-ID: <YYATamEnd6imRSxt@redhat.com>
References: <20211018044054.1779424-1-hch@lst.de>
 <20211018044054.1779424-9-hch@lst.de>
 <CAPcyv4iK-Op9Nxoq91YLv0aRj6PkGF64UY0Z_kfovF0cpuJ_JQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4iK-Op9Nxoq91YLv0aRj6PkGF64UY0Z_kfovF0cpuJ_JQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Oct 27 2021 at  9:32P -0400,
Dan Williams <dan.j.williams@intel.com> wrote:

> On Sun, Oct 17, 2021 at 9:41 PM Christoph Hellwig <hch@lst.de> wrote:
> >
> > Add a helper to perform the entire remapping for DAX accesses.  This
> > helper open codes bdev_dax_pgoff given that the alignment checks have
> > already been done by the submitting file system and don't need to be
> > repeated.
> 
> Looks good.
> 
> Mike, ack?

Acked-by: Mike Snitzer <snitzer@redhat.com>

