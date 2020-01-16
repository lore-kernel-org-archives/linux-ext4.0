Return-Path: <SRS0=++eR=3F=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 944D1C33CB1
	for <linux-ext4@archiver.kernel.org>; Thu, 16 Jan 2020 06:05:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6995A207E0
	for <linux-ext4@archiver.kernel.org>; Thu, 16 Jan 2020 06:05:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=intel-com.20150623.gappssmtp.com header.i=@intel-com.20150623.gappssmtp.com header.b="fsNlBtGF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729883AbgAPGFM (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 16 Jan 2020 01:05:12 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:42760 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729835AbgAPGFM (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 16 Jan 2020 01:05:12 -0500
Received: by mail-ot1-f65.google.com with SMTP id 66so18342793otd.9
        for <linux-ext4@vger.kernel.org>; Wed, 15 Jan 2020 22:05:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vKEanVLYKixbIE4jpjng52Wg/z0Mh1eAfP4hJSdIQE0=;
        b=fsNlBtGFziQY0A8zQejjqkkTuvqiwdIiAM7NACeEOxrAaoxzDd4fUjk9pwpqAIUvXJ
         cdDCKjUTJGaZHkHv0G5ee/JsbwsslnTNyPu9bqoswts39/75GIb/59yCbwuO1xPlgi3c
         f+VW6u6TSpKsnTkYP5lrw9eMUS+qyf9nS8llrLCzHtqnC0A8+9WP1s1jpoFVC48zw4nR
         NVsWjZ5qsu9jZPsaq387+XdtKQjAobHkTTamKsz9df6VShLY/jSMaIKhT//gj04wSyQB
         dgjbIZWVcmuv6zDtMtLARK6RBcjdJGnJuT7/m4Mi0K92sfnfQrOSyoSUt8DpH3L7o5oD
         9Oyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vKEanVLYKixbIE4jpjng52Wg/z0Mh1eAfP4hJSdIQE0=;
        b=JK5wBWcPchkvJMFoNli/8jP7EDR6wrPx2CWTDpVZDVT8jZfeOKkhPTDlVze2CB1EBX
         XmjHcOnzJnk/HUy0XJ/rkD0e2VLPJtj3TSkGlTqOABTXx7stBirk64hdktuTELvp8N6X
         QViq49vsQT0O+J3txSJWteBNs9ZOyabYw10QcL40ZVytiTKo39PXiclQMSBVl4MSuV++
         r+lO1qwoUKcBl9VgsVhdiC7XLfS/741QdMi66QXAS6u1aCIDeOXFuB3AWcBQTzhvfJE6
         zvKDXR63Mk3kUwe48WVGK5Ehkl+38op+j5P5yrBptcz4lQo7zSX37ixv/ym8w6WYXBLP
         /+eg==
X-Gm-Message-State: APjAAAURCz4RiEKzslonHDvV/jh+TvhHivw+OEvZOSVPhExuihMIQMib
        W/hfHEBPM+o53gngY+pjaHfL8yRWZdX4g5nYVoh7Yg==
X-Google-Smtp-Source: APXvYqzEy+pngv/HMRf0P3fZnf1I8EeAbKVY4SqM8e/rzz5VxvD8FVTh6UXXEgSv+bh5N1RhUnQGLNyaWJI9Xe8L7mc=
X-Received: by 2002:a9d:68d3:: with SMTP id i19mr740541oto.71.1579154711112;
 Wed, 15 Jan 2020 22:05:11 -0800 (PST)
MIME-Version: 1.0
References: <20200110192942.25021-1-ira.weiny@intel.com> <20200110192942.25021-2-ira.weiny@intel.com>
 <20200115113715.GB2595@quack2.suse.cz> <20200115173834.GD8247@magnolia>
 <20200115194512.GF23311@iweiny-DESK2.sc.intel.com> <CAPcyv4hwefzruFj02YHYiy8nOpHJFGLKksjiXoRUGpT3C2rDag@mail.gmail.com>
 <20200115223821.GG23311@iweiny-DESK2.sc.intel.com> <20200116053935.GB8235@magnolia>
In-Reply-To: <20200116053935.GB8235@magnolia>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Wed, 15 Jan 2020 22:05:00 -0800
Message-ID: <CAPcyv4jDMsPj_vZwDOgPkfHLELZWqeJugKgKNVKbpiZ9th683g@mail.gmail.com>
Subject: Re: [RFC PATCH V2 01/12] fs/stat: Define DAX statx attribute
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Jan 15, 2020 at 9:39 PM Darrick J. Wong <darrick.wong@oracle.com> wrote:
[..]
> >         attempts to minimize software cache effects for both I/O and
> >         memory mappings of this file.  It requires a file system which
> >         has been configured to support DAX.
> >
> >         DAX generally assumes all accesses are via cpu load / store
> >         instructions which can minimize overhead for small accesses, but
> >         may adversely affect cpu utilization for large transfers.
> >
> >         File I/O is done directly to/from user-space buffers and memory
> >         mapped I/O may be performed with direct memory mappings that
> >         bypass kernel page cache.
> >
> >         While the DAX property tends to result in data being transferred
> >         synchronously, it does not give the same guarantees of
> >         synchronous I/O where data and the necessary metadata are
> >         transferred together.
>
> (I'm frankly not sure that synchronous I/O actually guarantees that the
> metadata has hit stable storage...)

Oh? That text was motivated by the open(2) man page description of O_SYNC.
