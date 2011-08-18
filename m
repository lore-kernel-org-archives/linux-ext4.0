From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: Re: [PATCH v2 05/12] e4defrag: Add force option for e4defrag
Date: Thu, 18 Aug 2011 17:57:32 +0900
Message-ID: <4E4CD3FC.10405@sx.jp.nec.com>
References: <4E4B720A.5000908@sx.jp.nec.com> <282B034F-E435-4CFF-A4F8-62912B6C627F@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: ext4 <linux-ext4@vger.kernel.org>, Theodore Tso <tytso@mit.edu>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:44499 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755217Ab1HRI6I (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Aug 2011 04:58:08 -0400
In-Reply-To: <282B034F-E435-4CFF-A4F8-62912B6C627F@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2011/08/18 1:31, Andreas Dilger wrote:
> It is confusing in conditionals like this when integer variables are treated
> as boolean values. It would be more clear to compare the orig_score and
> donor_score to zero.
>
>         if (orig_score == 0 || (donor_score > 0 && !(mode_flag & FORCE)) ||
>             (orig_score <= donor_score && (mode_flag & FORCE))) {
>
> To be honest, I still can't understand the above logic. I would think it is
> enough to check:
>
>         if (orig_score < donor_score && !(mode_flag & FORCE))) {
>
> so that the file is not defragged if the score would get worse, but "force"
> means it is always moved.

e4defrag has two conditions to call EXT4_IOC_MOVE_EXT ioctl:
(1) the original file is fragmented file (orig_score > 0)
(2) the donor file is not fragmented file (donor_score == 0)

It could be that the donor file is a little fragmented file in case of few disk
space available, so sometimes we cannot defrag a file due to the condition (2).
However, it makes no sense that the fragmentation gets worse due to
e4defrag. Hence, I added a new condition (orig_score > donor_score) instead of
the condition (2) to check whether the fragmentation gets better.

The condition (1) is necessary for e4defarg -F. Because if e2p_get_fragscore()
returns zero in case of maximum threshold (2^32-1), it means the number of
the extents doesn't decrease any more even if the file gets the best extent
mapping.

>> printf("\033[79;0H\033[K[%u/%u]%s:\t%3d%%",
> It would be nice if the color terminal output was optional (maybe only on
> by default for tty output). This is not typical for other e2fsprogs utilities,
> and makes a mess of logs being kept of the output.

I see. I'll fix the output based on mke2fs.

Regards,
Kazuya Mio
