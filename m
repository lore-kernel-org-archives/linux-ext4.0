From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH] ext4: fix off-by-one on max nr_pages in
 ext4_find_unwritten_pgoff()
Date: Sat, 27 May 2017 14:06:24 +0800
Message-ID: <20170527060624.GK1946@eguan.usersys.redhat.com>
References: <20170521080026.20986-1-eguan@redhat.com>
 <20170523083432.GE1230@quack2.suse.cz>
 <20170524220340.nf65pp6u3p7vi7f2@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Eryu Guan <eguan@redhat.com>,
        linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:35695 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752833AbdE0GG1 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 27 May 2017 02:06:27 -0400
Received: by mail-pf0-f196.google.com with SMTP id u26so6462416pfd.2
        for <linux-ext4@vger.kernel.org>; Fri, 26 May 2017 23:06:27 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170524220340.nf65pp6u3p7vi7f2@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

On Wed, May 24, 2017 at 06:03:40PM -0400, Theodore Ts'o wrote:
> On Tue, May 23, 2017 at 10:34:32AM +0200, Jan Kara wrote:
> > > Cc: stable@vger.kernel.org # v3.7+
> > > Signed-off-by: Eryu Guan <eguan@redhat.com>
> > 
> > Yeah, thanks for fixing this! Actually this is a bug introduced by my
> > recent fixes. Previously, 'end' used to be "one block after the end" and so
> > the math worked out correctly :-|. You can add:
> > 
> > Reviewed-by: Jan Kara <jack@suse.cz>
> 
> Thanks, applied.  (And I've dropped the Cc: stable)

(Sorry for the late response, not sure why my redhat account didn't get
this email, and my gmail account just got this mail today..)

Actually this is an old bug and can be reproduced without Jan's
patchset. So I think "Cc: stable" is still needed.

Thanks,
Eryu
