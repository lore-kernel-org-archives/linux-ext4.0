Return-Path: <SRS0=GMxu=SN=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DC37C10F13
	for <linux-ext4@archiver.kernel.org>; Thu, 11 Apr 2019 14:56:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E4092077C
	for <linux-ext4@archiver.kernel.org>; Thu, 11 Apr 2019 14:56:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=intel-com.20150623.gappssmtp.com header.i=@intel-com.20150623.gappssmtp.com header.b="Q3uBcTGn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726644AbfDKO4s (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 11 Apr 2019 10:56:48 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:33202 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726599AbfDKO4r (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Apr 2019 10:56:47 -0400
Received: by mail-ot1-f65.google.com with SMTP id j10so5513142otq.0
        for <linux-ext4@vger.kernel.org>; Thu, 11 Apr 2019 07:56:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q39WY1QwbNiopzjiE9clWXmypKuvpRyCVeYXAVT0ZNM=;
        b=Q3uBcTGnIjZa7/KTp2qiPOTYOZa2YOHA6wen6rcf4+KfoSQ0dYkzRF2BB3Hh9J2hV5
         1WBEO7/TSq9DfFY0FU6SEBYDgiByc7D+9QK6Os47nmX4kd7vSs5p0pZVuhMDKFPnhkVp
         oD4wLyF6G1hd93q1lXUNEZYVQVdvlRk1We0zXgcvjD2Ot+YWI9AjPTndAx7YBokeV1fZ
         ctpp4sE7+T/qGAEjWerHgwvW+3YBraMDq/4HNGPh7AtRvvMtqu1zk5yP07hribDH8Jb+
         nyZtJUGLAAxZcI9GzgiobzP4HXPPNL+stbL0F3dlu1oxNrRIZqBzxUp5n1X0A+I5ZFl8
         B6zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q39WY1QwbNiopzjiE9clWXmypKuvpRyCVeYXAVT0ZNM=;
        b=RiImqyvJivzqIMcFbVo4LA2AtEp8Fj7leBv+09Z3W6H465Ire/hZDhdLCvjuiVXgPl
         wpYtg8uJ8z8g2qGf3A63w+n6uLHeBI1qYfl6S0kaxGZJ+ZVy47qXPPZyDkhRt5hMfwvb
         ZQTxAO4twF/wTWGlOkB3Tz1uEDzONYN5aVkKyFLwECHSUNzbl8uya+G9DI7r1gZksKgC
         OiH7+SygiueNnCFZqWZH89stjvuKXNX624FTtG4xIFRq4XARK0sBwaELSAbO3WcVbOK7
         f8SOURj70LKrQq8Q1MFcEW4inZiRquy1FNh7lajZJMs2T2RXm9hEd3zaoSrej1CaEr7Z
         H2mg==
X-Gm-Message-State: APjAAAUSdKwqXgKHgLPuMAP/SUi2P3s99MoIk7cpt1ha87a/SwV7r7iH
        H3pNsPpPxCeZNLAxRp6j7xI6LN+EQIsVDEdeGuvWTA==
X-Google-Smtp-Source: APXvYqzvG/DsITk24XWD/XR4qg9tvxLhxXa18JIum6UEPT4QFmqdzUuqxzJ5VPbogGv+LebEcpWY095S2YoG/n/LrP8=
X-Received: by 2002:a9d:6a88:: with SMTP id l8mr32863157otq.260.1554994607197;
 Thu, 11 Apr 2019 07:56:47 -0700 (PDT)
MIME-Version: 1.0
References: <20190410040826.24371-1-pagupta@redhat.com> <20190410040826.24371-4-pagupta@redhat.com>
In-Reply-To: <20190410040826.24371-4-pagupta@redhat.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Thu, 11 Apr 2019 07:56:36 -0700
Message-ID: <CAPcyv4gXwE2k3JU94GPav0xn2LEgR6-7ZEVYyTHFRjCfTYjerw@mail.gmail.com>
Subject: Re: [PATCH v5 3/6] libnvdimm: add dax_dev sync flag
To:     Pankaj Gupta <pagupta@redhat.com>
Cc:     linux-nvdimm <linux-nvdimm@lists.01.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        KVM list <kvm@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        Qemu Developers <qemu-devel@nongnu.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Ross Zwisler <zwisler@kernel.org>,
        Vishal L Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Christoph Hellwig <hch@infradead.org>,
        Len Brown <lenb@kernel.org>, Jan Kara <jack@suse.cz>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        lcapitulino@redhat.com, Kevin Wolf <kwolf@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        jmoyer <jmoyer@redhat.com>,
        Nitesh Narayan Lal <nilal@redhat.com>,
        Rik van Riel <riel@surriel.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        david <david@fromorbit.com>, cohuck@redhat.com,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kilobyte@angband.pl,
        yuval.shaia@oracle.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Apr 9, 2019 at 9:10 PM Pankaj Gupta <pagupta@redhat.com> wrote:
>
> This patch adds 'DAXDEV_SYNC' flag which is set
> for nd_region doing synchronous flush. This later
> is used to disable MAP_SYNC functionality for
> ext4 & xfs filesystem for devices don't support
> synchronous flush.
>
> Signed-off-by: Pankaj Gupta <pagupta@redhat.com>
> ---
>  drivers/dax/bus.c            |  2 +-
>  drivers/dax/super.c          | 13 ++++++++++++-
>  drivers/md/dm.c              |  2 +-
>  drivers/nvdimm/pmem.c        |  3 ++-
>  drivers/nvdimm/region_devs.c |  7 +++++++
>  include/linux/dax.h          |  9 +++++++--
>  include/linux/libnvdimm.h    |  1 +
>  7 files changed, 31 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> index 2109cfe80219..431bf7d2a7f9 100644
> --- a/drivers/dax/bus.c
> +++ b/drivers/dax/bus.c
> @@ -388,7 +388,7 @@ struct dev_dax *__devm_create_dev_dax(struct dax_region *dax_region, int id,
>          * No 'host' or dax_operations since there is no access to this
>          * device outside of mmap of the resulting character device.
>          */
> -       dax_dev = alloc_dax(dev_dax, NULL, NULL);
> +       dax_dev = alloc_dax(dev_dax, NULL, NULL, true);

I find apis that take a boolean as unreadable. What does 'true' mean?
It wastes time to go look at the function definition vs something
like:

    alloc_dax(dev_dax, NULL, NULL, DAXDEV_F_SYNC);
