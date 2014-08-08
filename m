From: TR Reardon <thomas_reardon@hotmail.com>
Subject: Re: journal recovery problems with metadata_csum, *non-64bit*
Date: Fri, 8 Aug 2014 18:29:40 -0400
Message-ID: <BLU436-SMTP222E1BBA304D4F1F10EC4A6FDEE0@phx.gbl>
References: <BLU436-SMTP84585FAA628776E190822AFDEE0@phx.gbl> <20140808214732.GN25145@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from blu004-omc1s21.hotmail.com ([65.55.116.32]:57734 "EHLO
	BLU004-OMC1S21.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751225AbaHHWaY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Aug 2014 18:30:24 -0400
Received: by mail-yk0-f178.google.com with SMTP id 142so4411632ykq.9
        for <linux-ext4@vger.kernel.org>; Fri, 08 Aug 2014 15:30:20 -0700 (PDT)
In-Reply-To: <20140808214732.GN25145@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 8, 2014 at 5:47 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> So metadata_csum works fine with 64-bit file systems, but it is
> failing with journal recovery if the 64-bit file system feature is not
> enabled?  Is that a correct summary of what you are seeing?

Correct.

> Also, with e2fsprogs 1.43-WIP releases, it's important that you
> specify the git commit id you are using, since the next branch in
> particular is quite fast moving.
>

Using master @ de25d9c8c48c7474828e9452184e204b18b8e090, which was the
1.42.11 release.  The current master and next have same problem.

I'd rather use debian versions, but metadata_csum is disabled there.
debian does not sync with git master, so what exactly does it sync
with?  ie, how are the metadata_csum patches dropped, since they exist
in master?
