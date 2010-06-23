From: "Amir G." <amir73il@users.sourceforge.net>
Subject: Re: [PATCH 1/8] e2fsprogs: Next3 on-disk format changes
Date: Wed, 23 Jun 2010 07:16:16 +0300
Message-ID: <AANLkTikVckjeT6FBClcd8ogKoxt50T8oGw-FfpEa1eik@mail.gmail.com>
References: <DEF06E15-64B4-4661-9091-2F5E2BD308CC@dilger.ca>
	<AANLkTikAAXb90lPSH9fcz-KQa37GR3C_cCfB_b_8ZkTS@mail.gmail.com>
	<993280B6-32DB-4ABC-86B6-0CFCA9BECCFD@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "linux-ext4@vger.kernel.org development" <linux-ext4@vger.kernel.org>,
	Theodore Tso <tytso@mit.edu>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33096 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822Ab0FWEQS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Jun 2010 00:16:18 -0400
Received: by bwz9 with SMTP id 9so306892bwz.19
        for <linux-ext4@vger.kernel.org>; Tue, 22 Jun 2010 21:16:16 -0700 (PDT)
In-Reply-To: <993280B6-32DB-4ABC-86B6-0CFCA9BECCFD@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 22, 2010 at 7:21 PM, Andreas Dilger wrote:
>
> It would have been good to have this discussion on the list, since I didn't see any replies to your patches and assumed nobody had taken the time to look at them.
>
> It wouldn't be a terrible idea to post the new patches to the list, if you aren't still in the middle of updating them.
>

Actually, I don't know of anyone who did look at the patches besides
Ted and as far as I know,
he only looked at the first patch (on-disk format changes) because I
have asked him to approve the changes.

The discussion about the on-disk format was going on in another thread:
http://marc.info/?l=linux-ext4&m=127393198501070&w=2

And finally, Ted has approved these changes:
http://marc.info/?l=linux-ext4&m=127611066022974&w=2

I will try to re-post the patches next week.
Mind you, these are only 8 small patches for e2fsprogs.
There are also 40 bigger patches for Next3 itself (available on download page).
Would you like me to post those as well?

Thanks,
Amir.
