From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 4/5] ext4: flush journal when switching from journal
 data mode
Date: Wed, 28 Dec 2011 13:56:43 -0500
Message-ID: <20111228185643.GD12370@thunk.org>
References: <1321344474-14707-1-git-send-email-xiaoqiangnk@gmail.com>
 <1321344474-14707-4-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:51820 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754359Ab1L1S4s (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 28 Dec 2011 13:56:48 -0500
Content-Disposition: inline
In-Reply-To: <1321344474-14707-4-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 15, 2011 at 04:07:53PM +0800, Yongqiang Yang wrote:
> When switching from journal data mode, the data blocks
> in journal will have no revoke record.  Thus, data could be
> corrupted during replay.  However, there is no such problem in
> switching to journal data mode.  So we flush journal only in
> the case that swithes from journal data mode.
> 
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>

Applied, with a slightly different (and more explanatory commit
message):

ext4: flush journal when switching from data=journal mode

From: Yongqiang Yang <xiaoqiangnk@gmail.com>

It's necessary to flush the journal when switching away from
data=journal mode.  This is because there are no revoke records when
we are data blocks are journalled, which are required in the other
journal modes.

However, it is not necessary to flush the journal when switching into
data=journal mode, and flushing the journal is expensive.  So let's
avoid it in that case.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

						- Ted
