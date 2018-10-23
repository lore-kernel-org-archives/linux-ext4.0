Return-Path: <SRS0=2u2A=ND=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-yb1-f177.google.com ([209.85.219.177]:37100 "EHLO
        mail-yb1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725266AbeJXEFP (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Oct 2018 00:05:15 -0400
Date: Tue, 23 Oct 2018 12:40:21 -0700
From: Tejun Heo <tj@kernel.org>
To: "Theodore Y. Ts'o" <tytso@mit.edu>
Cc: syzbot <syzbot+a50c7541a4a55cd49b02@syzkaller.appspotmail.com>,
        adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        linux-fsdevel@vger.kernel.org, jiangshanlai@gmail.com
Subject: Re: possible deadlock in flush_workqueue (2)
Message-ID: <20181023194021.GA4182586@devbig004.ftw2.facebook.com>
References: <000000000000bfd4270578abe88b@google.com>
 <0000000000009bcd4a0578e22ebd@google.com>
 <20181023142804.GC6850@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181023142804.GC6850@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

On Tue, Oct 23, 2018 at 10:28:04AM -0400, Theodore Y. Ts'o wrote:
> The other, and I think better way, we could fix this is to have an
> alternate destroy_never_used_workqueue() function which skips the
> drain_workqueue().

Yeah, I'm okay with this approach.  Maybe name it
destroy_workqueue_skip_drain()?

Thanks.

-- 
tejun
