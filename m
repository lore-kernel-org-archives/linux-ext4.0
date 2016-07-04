From: Anatoly Pugachev <matorola@gmail.com>
Subject: Re: 4.7-rc6, ext4, sparc64: Unable to handle kernel paging request at ...
Date: Mon, 4 Jul 2016 16:10:51 +0300
Message-ID: <CADxRZqy42TR9Y1yKM=yCQnAwyCYoU-mR2SEMT3wcSLO-NHbiSg@mail.gmail.com>
References: <alpine.LRH.2.20.1607041429380.6651@math.ut.ee>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, sparclinux@vger.kernel.org
To: Meelis Roos <mroos@linux.ee>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.20.1607041429380.6651@math.ut.ee>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jul 4, 2016 at 2:36 PM, Meelis Roos <mroos@linux.ee> wrote:
> Just got this on bootup of my Sun T2000:
>...
> I have not seen it before, this includes 4.6.0 4.6.0-08907-g7639dad
> 4.7.0-rc1-00094-g6b15d66 4.7.0-rc4-00014-g67016f6.
>
> It is not reproducible, did not appear on next reboot of the same
> kernel.


mine T5120 boots ok 4.7.0-rc6, rootfs being on ext4 .
