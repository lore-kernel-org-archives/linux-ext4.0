From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [RESEND][PATCH] dir_index: error out instead of BUG on corrupt
 hash dir limit
Date: Mon, 10 Sep 2007 09:59:28 -0500
Message-ID: <46E55BD0.30500@redhat.com>
References: <46D8D30B.6090703@redhat.com> <20070909131933.GA15229@dastardly.plus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Duane Griffin <duaneg@dghda.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:34152 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756380AbXIJO7e (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 10 Sep 2007 10:59:34 -0400
In-Reply-To: <20070909131933.GA15229@dastardly.plus.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Duane Griffin wrote:
> Hi Eric,
> 
> On Fri, Aug 31, 2007 at 09:48:43PM -0500, Eric Sandeen wrote:
>> (resend, this one got lost?  Got an acked-by from Andreas
>> last go-round)
> 
> Sorry I missed this first time around. I came up with a very similar
> fix recently, following a gentoo bug report.  However there are a few
> more asserts later that you aren't currently handling. Below is an
> incremental patch on top of yours that converts them too. 

Ah, good point... I focused a bit too much on the single problem at hand
didn't I.  :)

> Note that one
> of them is in an if (0) block and maybe should be left alone -- what do
> you think?

If it's just there for debug, maybe leaving an assert is ok, to get a
dump & system state etc.  If it is converted, a printk would probably be
good so you know you're falling back, otherwise that extra checking is a
bit pointless if it's silent.

> I tested all the changed code paths, except the if (0) one, using a
> utility that appropriately corrupts ext3 images. 
> The source code is
> attached to the gentoo bug report here:
> 
> http://bugs.gentoo.org/show_bug.cgi?id=183207
> 
> Signed-off-by: Duane Griffin <duaneg@dghda.com>

Looks good, thanks for not ignoring the other asserts.  ;-)  I wonder if
we should fix up all the new error condition printk's a bit to be more
descriptive of the problem at hand; for example, the one I sent should
maybe say:

+		ext3_warning(dir->i_sb, __FUNCTION__,
+			     "Corrupt root limit in dir inode %ld\n", dir->i_ino);

I wanted to leave the word "corrupt" in there, or at least something to
clue in the user that maybe fsck is in order...

Thanks,
-Eric
