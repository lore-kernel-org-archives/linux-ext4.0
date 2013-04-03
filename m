From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 1/2] ext4: fix usless declarations
Date: Wed, 03 Apr 2013 16:31:23 +0400
Message-ID: <878v4zre1w.fsf@openvz.org>
References: <1364986711-3630-1-git-send-email-dmonakhov@openvz.org> <20130403122641.GC7741@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, wenqing.lz@taobao.com
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:36346 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759139Ab3DCMb2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Apr 2013 08:31:28 -0400
Received: by mail-lb0-f179.google.com with SMTP id t1so1529472lbd.38
        for <linux-ext4@vger.kernel.org>; Wed, 03 Apr 2013 05:31:26 -0700 (PDT)
In-Reply-To: <20130403122641.GC7741@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 3 Apr 2013 08:26:41 -0400, Theodore Ts'o <tytso@mit.edu> wrote:
> On Wed, Apr 03, 2013 at 02:58:30PM +0400, Dmitry Monakhov wrote:
> > This patch should fix sparse complains about shadow declatations.
> 
> Nothing here is fixing serious regressions, right?  This is just to
> make static code checkers happy?
Yep... but fixes are also quite simple.
> 
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
