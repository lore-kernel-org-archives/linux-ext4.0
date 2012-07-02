From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH v2] ext4: fix hole punch failure when depth is greater
 than 0
Date: Mon, 2 Jul 2012 11:12:47 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1207021110530.24050@dhcp-1-248.brq.redhat.com>
References: <1339638836-19990-1-git-send-email-ashish.sangwan2@gmail.com> <CAKYAXd_g_vgAmyD4jyUqz0u=vaSTAKFqZz0sqhM+2+hy1Z85ug@mail.gmail.com> <CAOiN93=BKyGKtpLng-ddX0RFUOdHCaxHi2O26GFokdT19xad2g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="571144193-1117142254-1341220370=:24050"
Cc: sandeen@redhat.com,
	=?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>,
	Ted Tso <tytso@mit.edu>, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>
To: Ashish Sangwan <ashishsangwan2@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12713 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932717Ab2GBJMx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Jul 2012 05:12:53 -0400
In-Reply-To: <CAOiN93=BKyGKtpLng-ddX0RFUOdHCaxHi2O26GFokdT19xad2g@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--571144193-1117142254-1341220370=:24050
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

On Mon, 2 Jul 2012, Ashish Sangwan wrote:

> Date: Mon, 2 Jul 2012 11:03:26 +0530
> From: Ashish Sangwan <ashishsangwan2@gmail.com>
> To: sandeen@redhat.com, Luká¨ Czerner <lczerner@redhat.com>,
>     Ted Tso <tytso@mit.edu>
> Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
>     Namjae Jeon <linkinjeon@gmail.com>
> Subject: Re: [PATCH v2] ext4: fix hole punch failure when depth is greater
>     than 0
> 
> Hi Ted, Lukas, Eric,
> 
> Did any of you get a chance to look at it?

I am sorry for the delay. I have been trying to reproduce this
problem without any success so far. But is was on ppc64 machine, so
I'll try that on x86_64 and then review the patch.

Thanks!
-Lukas

> 
> On Fri, Jun 22, 2012 at 6:19 AM, Namjae Jeon <linkinjeon@gmail.com> wrote:
> > Hi. Eric.
> >
> > This is the patch for punch hole issue.
> >
> > Thanks.
> >
> 
--571144193-1117142254-1341220370=:24050--
