From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: xfstests failure generic/299
Date: Tue, 16 Apr 2013 12:20:36 +0400
Message-ID: <8761zmyjhn.fsf@openvz.org>
References: <nsxvc7ra2cv.fsf@closure.thunk.org> <87sj2uokzc.fsf@openvz.org> <20130414224712.GC12542@thunk.org> <87k3o4xih1.fsf@openvz.org> <20130415184318.GA5602@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:45315 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932147Ab3DPIUm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 16 Apr 2013 04:20:42 -0400
Received: by mail-lb0-f176.google.com with SMTP id y8so295494lbh.7
        for <linux-ext4@vger.kernel.org>; Tue, 16 Apr 2013 01:20:40 -0700 (PDT)
In-Reply-To: <20130415184318.GA5602@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 15 Apr 2013 14:43:18 -0400, "Theodore Ts'o" <tytso@mit.edu> wrote:
> On Mon, Apr 15, 2013 at 01:15:38PM +0400, Dmitry Monakhov wrote:
> > > Unfortunately, I don't have the time to debug this, so at least for
> > > now I'm going to exclude generic/299 from my automated test runs.
> > Actually fix is quite simple, after this everything works fine.
> 
> Thanks for the patch!  I take it fio isn't gcc -Wall clean?  
Yes it was, log_xxx() methods was declared w/o _format_ attribute.
Nor than less Jens already fixed that here: 4e0a8fa259.
