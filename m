From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: status of the ext3/jbd error handling enhancement patches
Date: Sun, 19 Oct 2008 22:13:31 -0700
Message-ID: <20081019221331.ddf6b8c2.akpm@linux-foundation.org>
References: <48FC081D.60306@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	tytso@mit.edu, adilger@sun.com, jack@suse.cz, sandeen@redhat.com
To: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34927 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751735AbYJTFON (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Oct 2008 01:14:13 -0400
In-Reply-To: <48FC081D.60306@hitachi.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 20 Oct 2008 13:25:01 +0900 Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com> wrote:

> Hi Andrew,
> 
> Thank you for pushing my ext3/jbd to Linus.  But some of patches
> in -mm (following three patches) haven't been sent to Linus.
> 
>   #jbd-fix-error-handling-for-checkpoint-io.patch: double-check this
>   jbd-fix-error-handling-for-checkpoint-io.patch
>   ext3-add-checks-for-errors-from-jbd.patch
>   jbd-test-bh_write_eio-to-detect-errors-on-metadata-buffers.patch
> 
> They improve filesystem corruption problem and it is needed by
> mission critical systems.
> 
> Could you tell me what is your concern (you commented, "double-check
> this") ?  Are there something that I can help?  For example, I can
> provide some SystemTap scripts to help tests.

I forget my reasons for that - would need to go back and review the
discussions when the patch was first merged.

One of the above patches (I forget which) breaks the build because it
expects the presence of Al Viro's VFS tree, and that hasn't been merged
yet.  I need to wait and see if that merge will be happening (seems
unlikely) and if not, rework the patch against mainline.

Quie a few patches (5%?) tend to get delayed like this due to missing
dependencies.
