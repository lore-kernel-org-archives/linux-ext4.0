From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH v2 4/6] ext4: use timespec64 for all inode times
Date: Sun, 22 Jul 2018 14:08:30 -0400
Message-ID: <20180722180829.GE6685@thunk.org>
References: <20180711091414.1494843-1-arnd@arndb.de>
 <20180711091414.1494843-4-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, jack@suse.cz, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, sirmy15@gmail.com,
        stable@vger.kernel.org, tgnottingham@gmail.com,
        y2038@lists.linaro.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180711091414.1494843-4-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jul 11, 2018 at 11:14:12AM +0200, Arnd Bergmann wrote:
> This is the last missing piece for the inode times on 32-bit systems:
> now that VFS interfaces use timespec64, we just need to stop truncating
> the tv_sec values for y2038 compatibililty.
> 
> Reviewed-by: Andreas Dilger <adilger@dilger.ca>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Thanks, applied.

					- Ted
