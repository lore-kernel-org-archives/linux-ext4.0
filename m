From: Dan Carpenter <error27@gmail.com>
Subject: Re: [PATCH] ext4:memset is needless in ext4_ext_remove_space()
Date: Mon, 8 Nov 2010 06:37:52 +0200
Message-ID: <20101108043752.GB5563@bicker>
References: <4CD75033.7080902@redflag-linux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: =?utf-8?B?5r2Y5Y2r5bmzKFBldGVyIFBhbik=?= <wppan@redflag-linux.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41548 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259Ab0KHEiH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 7 Nov 2010 23:38:07 -0500
Content-Disposition: inline
In-Reply-To: <4CD75033.7080902@redflag-linux.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 08, 2010 at 09:19:47AM +0800, "=E6=BD=98=E5=8D=AB=E5=B9=B3(=
Peter Pan)" wrote:
>
> memset is needless because path is allocated by kzalloc.
>

This is inside a loop and sometimes we do i++ and sometimes i--.  Are
you absolutely positive that path + i isn't initialized?

I haven't followed this code through all the way but my instinct is
that the memset is there for a reason.

regards,
dan carpenter


--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
