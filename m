From: Theodore Tso <tytso@mit.edu>
Subject: Re: - disable-ext4.patch removed from -mm tree
Date: Sun, 3 Feb 2008 20:36:26 -0500
Message-ID: <20080204013626.GE18392@mit.edu>
References: <200802032018.m13KIGoC029855@imap1.linux-foundation.org> <20080203122551.6830370a.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: dhowells@redhat.com,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:35450 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754676AbYBDBhG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 3 Feb 2008 20:37:06 -0500
Content-Disposition: inline
In-Reply-To: <20080203122551.6830370a.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Feb 03, 2008 at 12:25:51PM -0800, Andrew Morton wrote:
> When I merge David's iget coversion patches this will instead wreck the
> ext4 patchset.

That's ok, it shouldn't be hard for me to fix this up.  How quickly
will you be able to merge David's iget converstion patches?  Could
this get pushed to Linus, say, tomorrow?

				- Ted
