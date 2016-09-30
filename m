From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Check for encryption feature before
 fscrypt_process_policy()
Date: Fri, 30 Sep 2016 01:53:52 -0400
Message-ID: <20160930055352.qhqvxpwino4yomdo@thunk.org>
References: <1474527054-24207-1-git-send-email-richard@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org, david@sigma-star.at
To: Richard Weinberger <richard@nod.at>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1474527054-24207-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Sep 22, 2016 at 08:50:54AM +0200, Richard Weinberger wrote:
> ...otherwise an user can enable encryption for certain files even
> when the filesystem is unable to support it.
> Such a case would be a filesystem created by mkfs.ext4's default
> settings, 1KiB block size. Ext4 supports encyption only when block size
> is equal to PAGE_SIZE.
> But this constraint is only checked when the encryption feature flag
> is set.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>

Thanks, applied.

					- Ted
