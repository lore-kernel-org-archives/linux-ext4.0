From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH, v2] ext3: ensure link targets are NULL-terminated
Date: Mon, 15 Dec 2008 16:09:36 -0800
Message-ID: <20081215160936.7b70bec9.akpm@linux-foundation.org>
References: <1229022995-9898-1-git-send-email-duaneg@dghda.com>
	<1229022995-9898-2-git-send-email-duaneg@dghda.com>
	<1229022995-9898-3-git-send-email-duaneg@dghda.com>
	<1229022995-9898-4-git-send-email-duaneg@dghda.com>
	<1229022995-9898-5-git-send-email-duaneg@dghda.com>
	<1229022995-9898-6-git-send-email-duaneg@dghda.com>
	<20081211222605.GB18665@dastardly.home.dghda.com>
	<20081211193228.51c34114.akpm@linux-foundation.org>
	<e9e943910812120140j356d9e1g972dfddbb4f14369@mail.gmail.com>
	<e9e943910812120219k54e46330hc82add29a7fda455@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	bharrosh@panasas.com, sct@redhat.com, adilger@sun.com,
	linux-ext4@vger.kernel.org
To: "Duane Griffin" <duaneg@dghda.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58673 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754127AbYLPAKN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Dec 2008 19:10:13 -0500
In-Reply-To: <e9e943910812120219k54e46330hc82add29a7fda455@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 12 Dec 2008 10:19:20 +0000
"Duane Griffin" <duaneg@dghda.com> wrote:

> 2008/12/12 Duane Griffin <duaneg@dghda.com>:
> > 2008/12/12 Andrew Morton <akpm@linux-foundation.org>:
> >> Really?  The ext2 on-disk format requires that the fast symlink be
> >> null-terminated on disk?  Even though the length is already in i_size?
> >>
> >> It seems that's true.  How un-ext2-like.
> >>
> >> ext2 and ext4 need the same fix, yes?
> >
> > Yes. I've sent them out already, but thanks to a monumental cock-up
> > with the CCs they may not have made it to the list. I'll check and
> > resend to real addresses if necessary.
> 
> Seems they did make it:
> http://marc.info/?l=linux-kernel&m=122903437006575&w=2
> http://marc.info/?l=linux-kernel&m=122903451306859&w=2
> 

OK, thanks, it seems I was sneakily not cc'ed ;)

As Al points out, the code which you implemented is still vulnerable to
on-disk corruption: bad values of i_size will cause the kernel to write
a zero byte to any address within the entire CPU address range.

