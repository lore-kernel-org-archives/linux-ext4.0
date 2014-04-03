From: Namjae Jeon <linkinjeon@gmail.com>
Subject: Re: [v7] ext4: Add support FALLOC_FL_COLLAPSE_RANGE for fallocate
Date: Thu, 3 Apr 2014 22:29:47 +0900
Message-ID: <CAKYAXd-VA2ERmJnDviZ+5DmGSNtjk_WSsi=Yna_keqe8fpYrFw@mail.gmail.com>
References: <1393769538-3784-1-git-send-email-linkinjeon@gmail.com>
	<20140316031745.GA9916@thunk.org>
	<CAKYAXd-EO0pp=wz_Tg+2NEw9Nyu23sKXc-3n-fZUieES3+xt7w@mail.gmail.com>
	<20140402164258.GH6901@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qc0-f179.google.com ([209.85.216.179]:58737 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600AbaDCN3t (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Apr 2014 09:29:49 -0400
Received: by mail-qc0-f179.google.com with SMTP id m20so1818675qcx.24
        for <linux-ext4@vger.kernel.org>; Thu, 03 Apr 2014 06:29:48 -0700 (PDT)
In-Reply-To: <20140402164258.GH6901@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted.
2014-04-03 1:42 GMT+09:00 Theodore Ts'o <tytso@mit.edu>:
> Some final testing luckily caught a bug in your patch.  I'll fix it
> up, but for future reference, it's important to check to see if the
> handle is valid (i.e., we are not in no-journal mode) before using any
> of the journalling functions.  Otherwise, you will crash if you try
> using the code path when the file system does not have a journal.
Thanks for finding bug. I missed no journal case..
>
> BTW, I would strongly recommend using the automated regression test
> system found at:
>
>         git://git.kernel.org/pub/scm/fs/ext2/xfstests-bld.git
>
> It finds these sorts of problems very quickly.  After you build a
> kernel, running "kvm-xfstests -g quick" would have found the problem
> very quickly.  The fastest reproducer for the bug that I found is:
> "kvm-xfstests -c nojournal shared/001".
Okay, I will do the way you guided next time.

Thanks!
>
> Cheers,
>
>                                                 - Ted
>
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 7015917..bbba1ef 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -4902,6 +4902,9 @@ ext4_access_path(handle_t *handle, struct inode *inode,
>  {
>         int credits, err;
>
> +       if (!ext4_handle_valid(handle))
> +               return 0;
> +
>         /*
>          * Check if need to extend journal credits
>          * 3 for leaf, sb, and inode plus 2 (bmap and group
>
>
