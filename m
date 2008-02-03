From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: - disable-ext4.patch removed from -mm tree
Date: Sun, 3 Feb 2008 12:25:51 -0800
Message-ID: <20080203122551.6830370a.akpm@linux-foundation.org>
References: <200802032018.m13KIGoC029855@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: dhowells@redhat.com, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45712 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751880AbYBCU0c (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 3 Feb 2008 15:26:32 -0500
In-Reply-To: <200802032018.m13KIGoC029855@imap1.linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, 03 Feb 2008 12:18:35 -0800 akpm@linux-foundation.org wrote:

> 
> The patch titled
>      disable-ext4
> has been removed from the -mm tree.  Its filename was
>      disable-ext4.patch

I dropped the entire ext4 patch series, because the newly-added
convert-to-iget_locked patch has wrecked the iget-coversion patch which I
have queued.  Please do not merge that patch under my feet.

When I merge David's iget coversion patches this will instead wreck the
ext4 patchset.

Dunno what to do about this sort of thing, apart from encouraging
developers to take a look at what's happening in other trees before merging
stuff.
