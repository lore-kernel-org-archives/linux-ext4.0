From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH v2 2/6] ext4: use 64-bit timestamps for mmp_time
Date: Sun, 22 Jul 2018 14:06:33 -0400
Message-ID: <20180722180633.GC6685@thunk.org>
References: <20180711091414.1494843-1-arnd@arndb.de>
 <20180711091414.1494843-2-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, jack@suse.cz, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, sirmy15@gmail.com,
        stable@vger.kernel.org, tgnottingham@gmail.com,
        y2038@lists.linaro.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180711091414.1494843-2-arnd@arndb.de>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jul 11, 2018 at 11:14:10AM +0200, Arnd Bergmann wrote:
> The mmp_time field is 64 bits wide, which is good, but calling
> get_seconds() results in a 32-bit value on 32-bit architectures. Using
> ktime_get_real_seconds() instead returns 64 bits everywhere.
> 
> Reviewed-by: Andreas Dilger <adilger@dilger.ca>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Thanks, applied.

					- Ted
