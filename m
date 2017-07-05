From: Tahsin Erdogan <tahsin@google.com>
Subject: Re: [PATCH v5 27/28] ext4: xattr inode deduplication
Date: Wed, 5 Jul 2017 10:30:17 -0700
Message-ID: <CAAeU0aPrnLq78vD05bJD9eRU0Vw+OaRz2Tuy_sa=ybdaKWkNow@mail.gmail.com>
References: <6E41DA31-A524-4E0E-BD0B-5C994399BBC6@dilger.ca>
 <20170620090721.12480-1-tahsin@google.com> <20170704183919.vpk7xuikjdh6s5gu@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Andreas Dilger <adilger@dilger.ca>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yb0-f173.google.com ([209.85.213.173]:34817 "EHLO
        mail-yb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751716AbdGERaT (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Jul 2017 13:30:19 -0400
Received: by mail-yb0-f173.google.com with SMTP id s15so40249392ybe.2
        for <linux-ext4@vger.kernel.org>; Wed, 05 Jul 2017 10:30:19 -0700 (PDT)
In-Reply-To: <20170704183919.vpk7xuikjdh6s5gu@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>          * 5) group descriptor for new xattr block
> +        * 6) block bitmap update for old xattr block
> +        * 7) group descriptor for new old block

s/new old block/old block/
