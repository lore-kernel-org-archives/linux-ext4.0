From: shilong wang <wangshilong1991@gmail.com>
Subject: Re: [PATCH 2/2] Ext3: return ENOMEM rather than EIO if sb_getblk fails
Date: Mon, 14 Jan 2013 19:33:00 +0800
Message-ID: <CAP9B-Qm7fD90C6FQxBzbfht_pM-GpNcaXfrtY=sQV3XdvqNchQ@mail.gmail.com>
References: <0rm2m33qfluh6ajvvbqqeljp.1358136405625@email.android.com>
	<20130114041828.GD29329@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:57271 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756059Ab3ANLdC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Jan 2013 06:33:02 -0500
Received: by mail-ee0-f54.google.com with SMTP id c41so202544eek.13
        for <linux-ext4@vger.kernel.org>; Mon, 14 Jan 2013 03:33:00 -0800 (PST)
In-Reply-To: <20130114041828.GD29329@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

2013/1/14 Theodore Ts'o <tytso@mit.edu>:
> On Mon, Jan 14, 2013 at 12:10:51PM +0800, Wang wrote:
>> I am sorry, i am a newbie....
>> I make it confused what it  means if
>> i bcc stable@vger.kernel.org......
>
> Yeah, don't do that.  (1) Bcc's are bad since they're not visible, so
> others can't comment on whether it's appropriate for a patch to be
> marked as going into stable, and (2) what's important is that the
> commit is tagged as going into the stable in the commit description,
> so when the commit hits Linus's git tree, the scripts run by the
> stable kernel maintainers will automatically take those commits and
> start processing them for backporting into the stable git trees.
>
> You can tag a patch with Cc: stable@vger.kernel.org, i.e:
>
>     Signed-off-by: Eryu Guan <guaneryu@gmail.com>
>     Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
>     Cc: stable@vger.kernel.org
>
> Generally the maintainer (i.e., me for ext4, Jan Kara for ext3) will
> take care of adding the stable@vger.kernel.org if we think it's
> appropriate.  Feel free to add such an annotation as a suggestion to
> us, but we may end up adding or removing such a tag, just as I often
> will end up clarifying the commit description (either for English
> grammar/readability, or to make it clearer for people deciding whether
> they should backport the patch into distro kernels, etc.)
>
 I get it ,thanks very much for your help!

> Cheers.
>
>                                                 - Ted
