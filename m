From: "Amir G." <amir73il@users.sourceforge.net>
Subject: Re: [PATCH] allow internal journal size 2GB or larger
Date: Tue, 7 Sep 2010 16:07:55 +0300
Message-ID: <AANLkTik_wVFb9=X1frJ8LWdfHLEoSm1YRg=+2p+DYbty@mail.gmail.com>
References: <BDFF27EB-4448-4042-B8BD-7DD104AE9021@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "Ted Ts'o" <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <andreas.dilger@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:61449 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756536Ab0IGNH4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Sep 2010 09:07:56 -0400
Received: by iwn5 with SMTP id 5so5323052iwn.19
        for <linux-ext4@vger.kernel.org>; Tue, 07 Sep 2010 06:07:55 -0700 (PDT)
In-Reply-To: <BDFF27EB-4448-4042-B8BD-7DD104AE9021@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 5, 2010 at 10:26 PM, Andreas Dilger
<andreas.dilger@oracle.com> wrote:
>
> The current libext2fs and e2fsck code does not handle an internal journal inode size larger than 2GB because of 32-bit overflow.
>

I was surprised to see this problem description, since I have been
using a 3GB journal with Next3 for a while and never observed this
problem reported by fsck.
Finally, I realized that the problem only happens when the journal
inode size is larger than 4GB.

Other than that, patch looks fine to me :-)

Amir.
