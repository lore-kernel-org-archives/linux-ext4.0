From: Tao Ma <tm@tao.ma>
Subject: Re: next: ext4 build failure
Date: Tue, 04 Dec 2012 21:12:18 +0800
Message-ID: <50BDF6B2.2030302@tao.ma>
References: <50BDC25C.5020509@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Cc: boyu.mt@taobao.com, Theodore Ts'o <tytso@mit.edu>,
	linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
To: Jiri Slaby <jslaby@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <50BDC25C.5020509@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Jiri,

Thanks for the report.

The corresponding fix is already sent to Ted in the patch named "ext4:
Fix inline data build warning found by kernel build testing.", but it
seems that Ted hasn't pushed it into ext4dev yet.

Thanks
Tao

On 12/04/2012 05:29 PM, Jiri Slaby wrote:
> Hi,
> 
> commit a7b0168d4a9bb78535827ddaf9c055963f5bd7aa
> Author: Tao Ma <boyu.mt@taobao.com>
> Date:   Sun Dec 2 20:30:52 2012 -0500
> 
>     ext4: let fallocate handle inline data correctly
> 
> added
> 
> static int int ext4_convert_inline_data(struct inode *inode)
> 
>        ^^^^^^^
> 
> when EXT4_FS_XATTR is unset.
> 
> Care to fix that?
> 
> thanks,
> 
