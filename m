From: dmonakhov@openvz.org
Subject: Re: [PATCH 3/3] ext4: symlink must be handled via filesystem specific operation
Date: Mon, 05 Apr 2010 07:06:24 +0400
Message-ID: <876346zjgv.fsf@openvz.org>
References: <1269620996-11400-1-git-send-email-dmonakhov@openvz.org>
	<1269620996-11400-2-git-send-email-dmonakhov@openvz.org>
	<1269620996-11400-3-git-send-email-dmonakhov@openvz.org>
	<20100404200516.GJ18524@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, jack@suse.cz
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:28686 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754035Ab0DEDGe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 4 Apr 2010 23:06:34 -0400
In-Reply-To: <20100404200516.GJ18524@thunk.org> (tytso@mit.edu's message of
	"Sun, 4 Apr 2010 16:05:16 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

tytso@mit.edu writes:

> On Fri, Mar 26, 2010 at 07:29:56PM +0300, Dmitry Monakhov wrote:
>> generic setattr implementation is no longer responsible for
>> quota transfer so synlinks must be handled via ext4_setattr.
>
> Added to the ext4 patch queue; I've added a Signed-off-by: for you
> Dmitry, per your e-mail to Jan Kara.
>
> (There seems to be some random confused people who think the
> Signed-off-by has no legal significance, which is absolutely not true.)
yep. Changed my gitconfig to prevent this type of things in future.
BTW: IMHO This patch is also valid for all stable releases.
Because currently chown is not journalled for symlinks.
So journalled quota may becomes inconsistent after power-failure.
