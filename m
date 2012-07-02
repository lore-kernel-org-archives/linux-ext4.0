From: Ashish Sangwan <ashishsangwan2@gmail.com>
Subject: Re: [PATCH v2] ext4: fix hole punch failure when depth is greater
 than 0
Date: Mon, 2 Jul 2012 11:03:26 +0530
Message-ID: <CAOiN93=BKyGKtpLng-ddX0RFUOdHCaxHi2O26GFokdT19xad2g@mail.gmail.com>
References: <1339638836-19990-1-git-send-email-ashish.sangwan2@gmail.com>
	<CAKYAXd_g_vgAmyD4jyUqz0u=vaSTAKFqZz0sqhM+2+hy1Z85ug@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Namjae Jeon <linkinjeon@gmail.com>
To: sandeen@redhat.com,
	=?ISO-8859-2?Q?Luk=E1=B9_Czerner?= <lczerner@redhat.com>,
	Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54170 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594Ab2GBFd0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Jul 2012 01:33:26 -0400
In-Reply-To: <CAKYAXd_g_vgAmyD4jyUqz0u=vaSTAKFqZz0sqhM+2+hy1Z85ug@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted, Lukas, Eric,

Did any of you get a chance to look at it?

On Fri, Jun 22, 2012 at 6:19 AM, Namjae Jeon <linkinjeon@gmail.com> wrote:
> Hi. Eric.
>
> This is the patch for punch hole issue.
>
> Thanks.
>
