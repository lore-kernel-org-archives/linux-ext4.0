From: Jamie Lokier <jamie@shareable.org>
Subject: Re: [PATCH 0/4] FS: userspace notification of errors
Date: Thu, 4 Jun 2009 02:59:35 +0100
Message-ID: <20090604015935.GA30472@shareable.org>
References: <1244041518-32229-1-git-send-email-ext-denis.2.karpov@nokia.com> <20090603115611.6bbbaf55.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Denis Karpov <ext-denis.2.karpov@nokia.com>, axboe@kernel.dk,
	hirofumi@mail.parknet.co.jp, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	adrian.hunter@nokia.com, artem.bityutskiy@nokia.com
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail2.shareable.org ([80.68.89.115]:35278 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080AbZFDB7k (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Jun 2009 21:59:40 -0400
Content-Disposition: inline
In-Reply-To: <20090603115611.6bbbaf55.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andrew Morton wrote:
> The "unclean" term doesn't seem a good fit.  It usually means "has
> in-memory data which needs writing back".  But here you've redefined
> "unclean" to mean "got an IO error" or "detected metadata
> inconsistency", or perhaps "dunno, please run fsck to find out".  This
> all should be spelled out in exacting detail and thought about, please.

I agree.  "unclean" (or "dirty") should be reserved for indicating
that the filesystem has been modified, that is, files written to etc.

Use another term like "fault" or "error"?

-- Jamie
