From: Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH] fscrypto: make filename crypto functions return 0 on
 success
Date: Thu, 15 Sep 2016 10:22:40 -0700
Message-ID: <20160915172240.GA144398@google.com>
References: <1473894045-65215-1-git-send-email-ebiggers@google.com>
 <20160915001021.GB50095@jaegeuk>
 <20160915025441.GA80824@google.com>
 <20160915165412.GA52239@jaegeuk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, tytso@mit.edu
To: Jaegeuk Kim <jaegeuk@kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:34581 "EHLO
        mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752343AbcIORWu (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 15 Sep 2016 13:22:50 -0400
Received: by mail-pf0-f175.google.com with SMTP id p64so18678626pfb.1
        for <linux-ext4@vger.kernel.org>; Thu, 15 Sep 2016 10:22:49 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20160915165412.GA52239@jaegeuk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 15, 2016 at 09:54:12AM -0700, Jaegeuk Kim wrote:
> 
> Hmm, your patch tries to change the return value and make its usage more
> consistent. So, I think it should have been considered to change if (err < 0)
> to if (err) entirely in order to avoid any potential mistake; this patch already
> addresses it in some cases, but not all.
> 
> e.g., in f2fs_symlink,
> 
> 	err = fscrypt_fname_usr_to_disk(inode, &istr, &ostr);
> 	if (err < 0)
> 		goto err_out;
> 
> BTW, in dx_show_leaf(),
> 	res = fscrypt_fname_disk_to_usr(dir,
> 		0, 0, &de_name,
> 		&fname_crypto_str);
> 	if (res < 0)
> 		...
> 
> IMHO, it'd be better to use err instead of {res|ret} when considering naming
> convention.

Well, I had wanted to avoid bloating the patch.

I do like the idea of the greater consistency, though.

I'll post a version of the patch that does as you're suggesting.

Eric
