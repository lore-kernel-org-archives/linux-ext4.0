From: Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH] fscrypto: make filename crypto functions return 0 on
 success
Date: Wed, 14 Sep 2016 19:54:41 -0700
Message-ID: <20160915025441.GA80824@google.com>
References: <1473894045-65215-1-git-send-email-ebiggers@google.com>
 <20160915001021.GB50095@jaegeuk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, tytso@mit.edu
To: Jaegeuk Kim <jaegeuk@kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:33691 "EHLO
        mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756264AbcIOCzL (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 14 Sep 2016 22:55:11 -0400
Received: by mail-pa0-f51.google.com with SMTP id cm16so11248056pac.0
        for <linux-ext4@vger.kernel.org>; Wed, 14 Sep 2016 19:55:11 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20160915001021.GB50095@jaegeuk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 14, 2016 at 05:10:21PM -0700, Jaegeuk Kim wrote:
> Hi Eric,
> 
> On Wed, Sep 14, 2016 at 04:00:45PM -0700, Eric Biggers wrote:
> > Several filename crypto functions: fname_decrypt(),
> > fscrypt_fname_disk_to_usr(), and fscrypt_fname_usr_to_disk(), returned
> > the output length on success or -errno on failure.  However, the output
> > length was redundant with the value written to 'oname->len'.  It is also
> > potentially error-prone to make callers have to check for '< 0' instead
> > of '!= 0'.
> 
> At a glance, you missed some places like
> - fscrypt_fname_usr_to_disk() in ext4_symlink() and f2fs_symlink()
> - fscrypt_fname_disk_to_usr() in dx_show_leaf() and f2fs_fill_dentries()
> 

Those callers don't have to be updated because they only check for an error
value --- they don't use the return value as a length.  I did check all the
callers of fscrypt_fname_{usr_to_disk,disk_to_usr()}, and only the three I
update in the patch used the return value as a length.

Eric
