From: Borislav Petkov <bp@alien8.de>
Subject: Re: Error in linux-3.0.72 build.
Date: Sat, 6 Apr 2013 13:26:57 +0200
Message-ID: <20130406112657.GA3625@pd.tnic>
References: <515FF835.28644.1FF1E@msetzerii.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: "Michael D. Setzer II" <msetzerii@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <515FF835.28644.1FF1E@msetzerii.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Apr 06, 2013 at 08:25:57PM +1000, Michael D. Setzer II wrote:
> Just downloaded new kernels, and find this error in build.
> 
> fs/built-in.o: In function `find_group_flex':
> /home/msetzerii/data/linux-3.0.72/fs/ext4/ialloc.c:359: undefined 
> reference to `__udivdi3'
> /home/msetzerii/data/linux-3.0.72/fs/ext4/ialloc.c:374: undefined 
> reference to `__udivdi3'
> make: *** [.tmp_vmlinux1] Error 1

Looks like your compiler is generating 64-bit division which is a call
into libgcc. Which gcc version are you using?

+ext4 folks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
