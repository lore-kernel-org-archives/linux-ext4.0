From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 19/19] xfs: Add support for MAP_SYNC flag
Date: Wed, 11 Oct 2017 16:02:18 -0700
Message-ID: <CAPcyv4jhtkyzdLmUKVZDPsZ-MFZ20+SMUcgMXg2V2e0xZACg4g@mail.gmail.com>
References: <20171011200603.27442-1-jack@suse.cz> <20171011200603.27442-20-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        Ted Tso <tytso@mit.edu>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:47383 "EHLO
        mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751587AbdJKXCT (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Oct 2017 19:02:19 -0400
Received: by mail-oi0-f52.google.com with SMTP id h200so5712800oib.4
        for <linux-ext4@vger.kernel.org>; Wed, 11 Oct 2017 16:02:19 -0700 (PDT)
In-Reply-To: <20171011200603.27442-20-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 11, 2017 at 1:06 PM, Jan Kara <jack@suse.cz> wrote:
> Now when everything is prepared, add support in xfs to accept MAP_SYNC
> as an mmap(2) flag.
>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext4/file.c    |  1 +
>  fs/xfs/xfs_file.c | 23 +++++++++++++++++++++++
>  2 files changed, 24 insertions(+)
>
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index f013cda84b3d..6b597cc6b29d 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -26,6 +26,7 @@
>  #include <linux/quotaops.h>
>  #include <linux/pagevec.h>
>  #include <linux/uio.h>
> +#include <linux/mman.h>

I assume you wanted this change earlier in the series.
