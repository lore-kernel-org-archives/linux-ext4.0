From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: ext4 changes in linux-next
Date: Wed, 7 Jan 2009 15:32:09 -0800
Message-ID: <20090107153209.b49d5cf7.akpm@linux-foundation.org>
References: <20090107140436.46a17a3e.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: tytso@mit.edu, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35373 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753908AbZAGXdF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Jan 2009 18:33:05 -0500
In-Reply-To: <20090107140436.46a17a3e.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 7 Jan 2009 14:04:36 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> a pile of new ext4 stuff just turned up in linux-next

filesystem-freeze-add-error-handling-of-write_super_lockfs-unlockfs.patch
is dependent on things which are in linux-next's fs/ext4/super.c.

I could fix the (large) reject and proceed, but then you'd have
reject-fixing to do as well.

Do you plan on merging all those changes into mainline for 2.6.29?  If
so, please do so asap?

If not, I'll just go ahead and trash your stuff :)
