Return-Path: <SRS0=0MVU=MR=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50876 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727809AbeJEQQF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 5 Oct 2018 12:16:05 -0400
Date: Fri, 5 Oct 2018 11:18:12 +0200
From: Jan Kara <jack@suse.cz>
To: "Theodore Y. Ts'o" <tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>, Greg KH <greg@kroah.com>,
        linux-ext4@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] jbd2: Fix use after free in jbd2_log_do_checkpoint()
Message-ID: <20181005091812.GB9686@quack2.suse.cz>
References: <20181004104640.28326-1-jack@suse.cz>
 <20181004154402.GC6921@kroah.com>
 <20181004160546.GH28384@quack2.suse.cz>
 <20181004212218.GF2835@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181004212218.GF2835@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 04-10-18 17:22:18, Theodore Y. Ts'o wrote:
> On Thu, Oct 04, 2018 at 06:05:46PM +0200, Jan Kara wrote:
> > 
> > OK, ok, will do next time. The full git commit ID is faster to cut-n-paste
> > which shows how lazy I'm ;)
> 
> No worires, I'll fix that up for you when I apply it.

Thanks!

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
