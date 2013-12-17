From: Andrew Burgess <aab@cichlid.com>
Subject: Re: [PATCH] e2fsprogs: dumpe2fs manpage updates
Date: Tue, 17 Dec 2013 07:14:34 -0800
Message-ID: <1387293274.17633.2@hogo>
References: <CAO+X6Oiq5PLxjcGkjNi=D3qr=hB_zaCkgQfNcNjBQJaVjsNKBQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org
To: Uri Corin <uri.corin@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f49.google.com ([209.85.160.49]:59125 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201Ab3LQPOj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 17 Dec 2013 10:14:39 -0500
Received: by mail-pb0-f49.google.com with SMTP id jt11so7091283pbb.36
        for <linux-ext4@vger.kernel.org>; Tue, 17 Dec 2013 07:14:38 -0800 (PST)
In-Reply-To: <CAO+X6Oiq5PLxjcGkjNi=D3qr=hB_zaCkgQfNcNjBQJaVjsNKBQ@mail.gmail.com>
	(from uri.corin@gmail.com on Tue Dec 17 06:49:49 2013)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12/17/2013 06:49:49 AM, Uri Corin wrote:

> +.TP
> +.B extra_isize
> +.br
> +This feature enables storage of nanosecond timestamps and creation
> +time, if the inode size is larger than 256 bytes or larger.

this should either say "256 bytes or larger" or "larger than 256 bytes"
(i'm not sure which is true)