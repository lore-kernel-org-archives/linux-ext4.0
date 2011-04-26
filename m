From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Need of revoke mechanism in JBD
Date: Tue, 26 Apr 2011 08:25:58 -0400
Message-ID: <20110426122558.GF9486@thunk.org>
References: <4DB68257.4070407@gmail.com>
 <BANLkTikuNB8m3-X8BXVcL2OCqQiZwRCbQA@mail.gmail.com>
 <BANLkTikV4nU4Zc4OxNa6q8wDtM7cLUF_ig@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Niraj Kulkarni <kulkarniniraj14@gmail.com>,
	linux-ext4@vger.kernel.org
To: Ding Dinghua <dingdinghua85@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:59844 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850Ab1DZMZ7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Apr 2011 08:25:59 -0400
Content-Disposition: inline
In-Reply-To: <BANLkTikV4nU4Zc4OxNa6q8wDtM7cLUF_ig@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 26, 2011 at 05:23:21PM +0800, Ding Dinghua wrote:
> I think it's not only a performance issue but more important, a
> correctness issue.
> Revoke table is used for preventing the wrong replay of journal which
> cause data corruption:
> If block A has been journalled its modification, committed to journal
> and hasn't been checkpointed,
> and in later transactions block A is freed and reused for data in
> no-journalled-data mode, then If
> we don't have revoke table which recording the releasing event, replay
> of journal will overwrite the new data,
> which causing data corruption.

Yes, this is correct.  It should be covered fairly well in Stephen
Tweedie's, "Journaling the ext2fs file system" paper, which you can
find at:

https://ext4.wiki.kernel.org/index.php/Publications

if you'd like more details.

Hope this helps!

						- Ted
