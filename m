From: Ashish Sangwan <ashishsangwan2@gmail.com>
Subject: Re: [PATCH] ext4: fix extent tree corruption that incurred by hole
 punch [V2]
Date: Mon, 17 Dec 2012 09:55:41 +0530
Message-ID: <CAOiN93=AXhnxpJYNet9GeTPRn2bmBi9jw2cJXf1Y19rkx-VqhA@mail.gmail.com>
References: <CAJSVwFM3vq9wsq0Mn5L1bh-WHoP1g3VMJAOg_ruavZFednsjVw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Forrest Liu <forrestl@synology.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:40460 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966Ab2LQEZn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 16 Dec 2012 23:25:43 -0500
Received: by mail-vc0-f174.google.com with SMTP id d16so6600165vcd.19
        for <linux-ext4@vger.kernel.org>; Sun, 16 Dec 2012 20:25:41 -0800 (PST)
In-Reply-To: <CAJSVwFM3vq9wsq0Mn5L1bh-WHoP1g3VMJAOg_ruavZFednsjVw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 13, 2012 at 9:02 PM, Forrest Liu <forrestl@synology.com> wrote:
> When depth of extent tree is greater than 1, logical start value
> of interior node didn't updated correctly in ext4_ext_rm_idx.
>
> Signed-off-by: Forrest Liu <forrestl@synology.com>
> ---


Patch seems ok to me.
Reviewed-by: Ashish Sangwan <ashishsangwan2@gmail.com>
