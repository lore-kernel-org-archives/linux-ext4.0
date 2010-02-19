From: Dave Airlie <airlied@gmail.com>
Subject: Re: [Regression] Filesystem I/O is CPU-bound in rc7 and rc8
Date: Sat, 20 Feb 2010 07:02:23 +1000
Message-ID: <21d7e9971002191302s76111f6fyd986c51b66e214ae@mail.gmail.com>
References: <m3pr48bjfg.fsf@lugabout.jhcloos.org>
	 <20100215154516.GB11057@think> <m3d403632g.fsf@lugabout.jhcloos.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net
To: James Cloos <cloos@jhcloos.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yx0-f200.google.com ([209.85.210.200]:37814 "EHLO
	mail-yx0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756101Ab0BSVCY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 19 Feb 2010 16:02:24 -0500
In-Reply-To: <m3d403632g.fsf@lugabout.jhcloos.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 18, 2010 at 6:04 AM, James Cloos <cloos@jhcloos.com> wrote:
> While getting re-aquainted with perf, and after upgrading to the current
> version, I see that do_page_fault, unmap_vmas, get_page_from_freelist,
> handle_mm_fault, __do_fault and T.1339 tend to get the most time when the
> kernel is spinning.

dmesg? lspci -vv?

We have an AGP related issue with WC/UC paging that might be related,
but I'd need more info.

Dave.
