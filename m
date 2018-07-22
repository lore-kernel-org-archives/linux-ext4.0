From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH v2 3/6] ext4: use ktime_get_real_seconds for i_dtime
Date: Sun, 22 Jul 2018 14:07:24 -0400
Message-ID: <20180722180724.GD6685@thunk.org>
References: <20180711091414.1494843-1-arnd@arndb.de>
 <20180711091414.1494843-3-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, jack@suse.cz, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, sirmy15@gmail.com,
        stable@vger.kernel.org, tgnottingham@gmail.com,
        y2038@lists.linaro.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180711091414.1494843-3-arnd@arndb.de>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jul 11, 2018 at 11:14:11AM +0200, Arnd Bergmann wrote:
> We only care about the low 32-bit for i_dtime as explained in commit
> b5f515735bea ("ext4: avoid Y2038 overflow in recently_deleted()"), so
> the use of get_seconds() is correct here, but that function is getting
> removed in the process of the y2038 fixes, so let's use the modern
> ktime_get_real_seconds() here.
> 
> Reviewed-by: Andreas Dilger <adilger@dilger.ca>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Thanks, applied.

					- Ted
