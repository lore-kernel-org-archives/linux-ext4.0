From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH v2 5/6] jbd2: replace current_kernel_time64 with ktime
 equivalent
Date: Sun, 22 Jul 2018 14:54:54 -0400
Message-ID: <20180722185454.GF6685@thunk.org>
References: <20180711091414.1494843-1-arnd@arndb.de>
 <20180711091414.1494843-5-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, jack@suse.cz, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, sirmy15@gmail.com,
        stable@vger.kernel.org, tgnottingham@gmail.com,
        y2038@lists.linaro.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180711091414.1494843-5-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jul 11, 2018 at 11:14:13AM +0200, Arnd Bergmann wrote:
> jbd2 is one of the few callers of current_kernel_time64(), which
> is a wrapper around ktime_get_coarse_real_ts64(). This calls the
> latter directly for consistency with the rest of the kernel that
> is moving to the ktime_get_ family of time accessors.
> 
> Reviewed-by: Andreas Dilger <adilger@dilger.ca>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Thanks, applied.

					- Ted
