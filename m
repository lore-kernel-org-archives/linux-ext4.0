From: Frank Mayhar <fmayhar@google.com>
Subject: Re: [PATCH V3] fix bb_prealloc_list corruption due to wrong group
	locking
Date: Mon, 16 Mar 2009 10:53:09 -0700
Message-ID: <1237225989.3964.9.camel@bobble.smo.corp.google.com>
References: <49BAD6D9.3010505@redhat.com> <49BE82A9.4000407@redhat.com>
	 <49BE8C30.5030901@redhat.com>
	 <1237225369.3964.4.camel@bobble.smo.corp.google.com>
	 <49BE90E0.3090309@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:16499 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759312AbZCPRxc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Mar 2009 13:53:32 -0400
In-Reply-To: <49BE90E0.3090309@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 2009-03-16 at 12:48 -0500, Eric Sandeen wrote:
> Hi Frank - I don't *think* so just because deleted items are poisoned
> and I would expect that we'd trip over a bad pointer in the corrupted
> list item as the first indicator of trouble... but I could be wrong.
> 
> I think you said you could reproduce it, right?  So certainly worth
> testing with this fix I suppose.

Yeah, we're working on doing that now.  We're not running with a lot of
debugging turned on so we may or may not actually fall over if we try to
traverse freed (or just wrong) list entries.  If it isn't the same race,
though, then there's still one lurking in this code and that would be a
hell of a coincidence.
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

