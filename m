From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: 3.8.0-rc1: WARNING: at fs/ext4/page-io.c:232
Date: Thu, 27 Dec 2012 18:33:42 +0800
Message-ID: <20121227103342.GA4158@gmail.com>
References: <CAA1sL1QgkEWciR2qBbKWr+_2tRdhxpE1Jh3P0waSeYR8LR8R5w@mail.gmail.com>
 <20121227062907.GA5001@gmail.com>
 <87mwwzq5t7.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alexander Beregalov <a.beregalov@gmail.com>,
	"Theodore Ts'o\"" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f49.google.com ([209.85.210.49]:47332 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687Ab2L0KUK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 27 Dec 2012 05:20:10 -0500
Received: by mail-da0-f49.google.com with SMTP id v40so4249946dad.22
        for <linux-ext4@vger.kernel.org>; Thu, 27 Dec 2012 02:20:10 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <87mwwzq5t7.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 27, 2012 at 12:04:36PM +0400, Dmitry Monakhov wrote:
> On Thu, 27 Dec 2012 14:29:07 +0800, Zheng Liu <gnehzuil.liu@gmail.com> wrote:
> > On Thu, Dec 27, 2012 at 03:27:04AM +0300, Alexander Beregalov wrote:
[cut...]
> > Now we try to take i_mutex lock before orphan list cleanup, although we don't
> > need to take it in ext4_orphan_cleanup() because no one write this inode.
> > WARN_ON_ONCE doesn't be removed because this warning could help us to avoid some
> > ciritcal errors.
> You can add  Ack-by: Dmitry Monakhov <dmonakhov@openvz.org>
> 
> In fact this is my fault that we still not have autotest for that.
> I'm think of add crash-test to xfstests which should trigger journal abort and forced
> umount. Later test should mount FS which trigger journal_replay and orphan_cleanup.

Cool!  That would be great if this test case can be added in xfstests.
:-)

Regards,
                                                - Zheng
