From: Richard Weinberger <richard.weinberger@gmail.com>
Subject: Re: [PATCH] ext4: Fixed styling issues
Date: Sun, 7 Sep 2014 15:16:22 +0200
Message-ID: <CAFLxGvwVNTXw1uvzJaTyo6EQNgGWuAnGTi7s2+r3P+zF71zD3A@mail.gmail.com>
References: <1410093905-15431-1-git-send-email-dbdaniel42@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Theodore Ts'o" <tytso@mit.edu>, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
To: Daniel Bomar <dbdaniel42@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vc0-f169.google.com ([209.85.220.169]:51610 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbaIGNQX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 7 Sep 2014 09:16:23 -0400
In-Reply-To: <1410093905-15431-1-git-send-email-dbdaniel42@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Sep 7, 2014 at 2:45 PM, Daniel Bomar <dbdaniel42@gmail.com> wrote:
> Fixed styling issues as reported by scripts/checkpatch.pl
>
> Signed-off-by: Daniel Bomar <dbdaniel42@gmail.com>

Please don't run checkpatch.pl on in-kernel files.
The tool is designed to check patches, not files.
Such whitespace cleanups pollute the kernel history, i.e. such that
git blame returns false positives.

The purpose of --file is:
- Checking out-of-tree files (like existing drivers to be imported)
- One notable exception is drivers/staging/, you can run it on these files.

-- 
Thanks,
//richard
