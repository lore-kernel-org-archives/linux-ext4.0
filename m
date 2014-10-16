From: Albino Biasutti Neto <bino@riseup.net>
Subject: Re: [PATCH 1/2] xfstests: update 'new' script
Date: Thu, 16 Oct 2014 12:55:10 -0300
Message-ID: <CA+bYFQaKyNkzCGtTwXcdfn4Nr8LM4LGfQWkzzh54EVAmoMxSGQ@mail.gmail.com>
References: <1413295189-28530-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:35174 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751322AbaJPPzM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Oct 2014 11:55:12 -0400
In-Reply-To: <1413295189-28530-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2014-10-14 10:59 GMT-03:00 Dmitry Monakhov <dmonakhov@openvz.org>:
> - Update script to support new test cheme tests/$fs_type/$TEST_IDX
> - Try to use first unused ID
>
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  new |   78 +++++++++++++++++++++++++++++++++++++++++++++++-------------------
>  1 files changed, 55 insertions(+), 23 deletions(-)
>
> -chmod 755 $id
> -${EDITOR-vi} $id
> +chmod 755 $tdir/$id
> +${EDITOR-vi} $tdir/$id

You could leave only $EDITOR ?

In executing is on user preference.

                          Albino
                          binoanb.eti.br
