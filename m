From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH v2 6/6] ext4: super: extend timestamps to 40 bits
Date: Sun, 22 Jul 2018 14:55:07 -0400
Message-ID: <20180722185507.GG6685@thunk.org>
References: <20180711091414.1494843-1-arnd@arndb.de>
 <20180711091414.1494843-6-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, jack@suse.cz, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, sirmy15@gmail.com,
        stable@vger.kernel.org, tgnottingham@gmail.com,
        y2038@lists.linaro.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180711091414.1494843-6-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jul 11, 2018 at 11:14:14AM +0200, Arnd Bergmann wrote:
> The inode timestamps use 34 bits in ext4, but the various timestamps in
> the superblock are limited to 32 bits. If every user accesses these as
> 'unsigned', then this is good until year 2106, but it seems better to
> extend this a bit further in the process of removing the deprecated
> get_seconds() function.
> 
> This adds another byte for each timestamp in the superblock, making
> them long enough to store timestamps beyond what is in the inodes,
> which seems good enough here (in ocfs2, they are already 64-bit wide,
> which is appropriate for a new layout).
> 
> I did not modify e2fsprogs, which obviously needs the same change to
> actually interpret future timestamps correctly.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Thanks, applied.

					- Ted
