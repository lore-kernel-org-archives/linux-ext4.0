From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.25-rc8-mm1 ext4 ?
Date: Thu, 3 Apr 2008 10:39:22 -0700
Message-ID: <20080403103922.a426e0c9.akpm@linux-foundation.org>
References: <1207246724.30407.55.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: ext4 <linux-ext4@vger.kernel.org>
To: Badari Pulavarty <pbadari@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53650 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751566AbYDCRj3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Apr 2008 13:39:29 -0400
In-Reply-To: <1207246724.30407.55.camel@dyn9047017100.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 03 Apr 2008 10:18:43 -0800 Badari Pulavarty <pbadari@us.ibm.com> wrote:

> Hi Andrew,
> 
> ext4 is marked BROKEN in rc8-mm1. Wondering why ?
> Mingming is on vacation for a week. Is there anything
> we can help with to fix it ?
> 
> Thanks,
> Badari
> 
> config EXT4DEV_FS
>         tristate "Ext4dev/ext4 extended fs support development
> (EXPERIMENTAL)"
>         depends on EXPERIMENTAL
>         depends on BROKEN
> 

That's left over from when ext4 was calling generic_commit_write(), which
is removed from -mm.

ext4 was since fixed, but I never noticed that.  I'll drop
ext4-is-broken.patch.
