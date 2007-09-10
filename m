From: "Duane Griffin" <duaneg@dghda.com>
Subject: Re: [RESEND][PATCH] dir_index: error out instead of BUG on corrupt hash dir limit
Date: Mon, 10 Sep 2007 23:06:23 +0100
Message-ID: <e9e943910709101506p555c6c0co8ce4529f90e814e8@mail.gmail.com>
References: <46D8D30B.6090703@redhat.com>
	 <20070909131933.GA15229@dastardly.plus.com>
	 <46E55BD0.30500@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "linux-kernel Mailing List" <linux-kernel@vger.kernel.org>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	"ext4 development" <linux-ext4@vger.kernel.org>
To: "Eric Sandeen" <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.185]:46280 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760247AbXIJWGY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 10 Sep 2007 18:06:24 -0400
Received: by rv-out-0910.google.com with SMTP id k20so1148939rvb
        for <linux-ext4@vger.kernel.org>; Mon, 10 Sep 2007 15:06:23 -0700 (PDT)
In-Reply-To: <46E55BD0.30500@redhat.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 10/09/2007, Eric Sandeen <sandeen@redhat.com> wrote:
> Duane Griffin wrote:
> > Sorry I missed this first time around. I came up with a very similar
> > fix recently, following a gentoo bug report.  However there are a few
> > more asserts later that you aren't currently handling. Below is an
> > incremental patch on top of yours that converts them too.
>
> Ah, good point... I focused a bit too much on the single problem at hand
> didn't I.  :)

Easy to do :)

> > Note that one
> > of them is in an if (0) block and maybe should be left alone -- what do
> > you think?
>
> If it's just there for debug, maybe leaving an assert is ok, to get a
> dump & system state etc.  If it is converted, a printk would probably be
> good so you know you're falling back, otherwise that extra checking is a
> bit pointless if it's silent.

Good point. Perhaps best to just back that part out.

> I wonder if
> we should fix up all the new error condition printk's a bit to be more
> descriptive of the problem at hand; for example, the one I sent should
> maybe say:
>
> +               ext3_warning(dir->i_sb, __FUNCTION__,
> +                            "Corrupt root limit in dir inode %ld\n", dir->i_ino);
>
> I wanted to leave the word "corrupt" in there, or at least something to
> clue in the user that maybe fsck is in order...

I struggled with the wording, too. I originally went with "Invalid dx
limit/count", but wasn't terribly happy with it. "Corrupt" is more
accurate and informative. Perhaps the warning should also explicitly
recommend running fsck:

"Corrupt root limit in dir inode %ld, running e2fsck is recommended\n"

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
