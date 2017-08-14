From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: add missing xattr hash update
Date: Mon, 14 Aug 2017 08:31:17 -0400
Message-ID: <20170814123116.cr3r2jmqon5axgzx@thunk.org>
References: <20170806200319.21077-1-tahsin@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
        Miklos Szeredi <miklos@szeredi.hu>,
        zhangyi <yizhang089@gmail.com>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Tahsin Erdogan <tahsin@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170806200319.21077-1-tahsin@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Aug 06, 2017 at 01:03:19PM -0700, Tahsin Erdogan wrote:
> When updating an extended attribute, if the padded value sizes are the
> same, a shortcut is taken to avoid the bulk of the work. This was fine
> until the xattr hash update was moved inside ext4_xattr_set_entry().
> With that change, the hash update got missed in the shortcut case.
> 
> Thanks to ZhangYi (yizhang089@gmail.com) for root causing the problem.
> 
> Fixes: daf8328172df ("ext4: eliminate xattr entry e_hash recalculation for removes")
> 
> Reported-by: Miklos Szeredi <miklos@szeredi.hu>
> Signed-off-by: Tahsin Erdogan <tahsin@google.com>

Thanks, applied.

					- Ted
