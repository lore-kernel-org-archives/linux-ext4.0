From: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: + vfs-pagecache-usage-optimization-onpagesize=blocksize-environment.patch added to -mm tree
Date: Tue, 3 Jun 2008 16:22:25 +1000
Message-ID: <200806031622.25568.nickpiggin@yahoo.com.au>
References: <200805282323.m4SNND87005575@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: mm-commits@vger.kernel.org, hifumi.hisashi@oss.ntt.co.jp,
	jack@ucw.cz, linux-ext4@vger.kernel.org
To: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp117.mail.mud.yahoo.com ([209.191.84.166]:45863 "HELO
	smtp117.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750949AbYFCG3R (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Jun 2008 02:29:17 -0400
In-Reply-To: <200805282323.m4SNND87005575@imap1.linux-foundation.org>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thursday 29 May 2008 09:23, akpm@linux-foundation.org wrote:
> The patch titled
>      vfs: pagecache usage optimization for pagesize!=blocksize
> has been added to the -mm tree.  Its filename is
>     
> vfs-pagecache-usage-optimization-onpagesize=blocksize-environment.patch
>
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
>
> *** Remember to use Documentation/SubmitChecklist when testing your code
> ***
>
> See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
> out what to do about this
>
> The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/
>
> ------------------------------------------------------
> Subject: vfs: pagecache usage optimization for pagesize!=blocksize
> From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
>
> When we read some part of a file through pagecache, if there is a
> pagecache of corresponding index but this page is not uptodate, read IO is
> issued and this page will be uptodate.
>
> I think this is good for pagesize == blocksize environment but there is
> room for improvement on pagesize != blocksize environment.  Because in
> this case a page can have multiple buffers and even if a page is not
> uptodate, some buffers can be uptodate.
>
> So I suggest that when all buffers which correspond to a part of a file
> that we want to read are uptodate, use this pagecache and copy data from
> this pagecache to user buffer even if a page is not uptodate.  This can
> reduce read IO and improve system throughput.
>
> Signed-off-by: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
> Cc: Nick Piggin <nickpiggin@yahoo.com.au>
> Cc: Jan Kara <jack@ucw.cz>
> Cc: <linux-ext4@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Oh, you guys like this approach?

I'm not a big fan. The concept is good, but I'd much prefer to change
the readpage interface (or add a different interface perhaps) that
allows the filesystem to be called to do the actual data copy itself.

This would allow filesystems to effectively ask to be called at each
read as well without implementing the whole read path (if they simply
don't mark the page as uptodate).
