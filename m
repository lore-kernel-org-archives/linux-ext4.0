From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH v2 1/6] ext4: sysfs: print ext4_super_block fields as
 little-endian
Date: Sun, 22 Jul 2018 13:23:20 -0400
Message-ID: <20180722172320.GB6685@thunk.org>
References: <20180711091414.1494843-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, jack@suse.cz, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, sirmy15@gmail.com,
        stable@vger.kernel.org, tgnottingham@gmail.com,
        y2038@lists.linaro.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180711091414.1494843-1-arnd@arndb.de>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jul 11, 2018 at 11:14:09AM +0200, Arnd Bergmann wrote:
> While working on extended rand for last_error/first_error timestamps,
> I noticed that the endianess is wrong, we access the little-endian
> fields in struct ext4_super_block as native-endian when we print them.
> 
> This adds a special case in ext4_attr_show() and ext4_attr_store()
> to byteswap the superblock fields if needed.
> 
> In older kernels, this code was part of super.c, it got moved to sysfs.c
> in linux-4.4.
> 
> Cc: stable@vger.kernel.org
> Fixes: 52c198c6820f ("ext4: add sysfs entry showing whether the fs contains errors")
> Reviewed-by: Andreas Dilger <adilger@dilger.ca>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Applied, thanks.

				- Ted
