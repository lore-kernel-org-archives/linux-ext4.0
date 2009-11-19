From: tytso@mit.edu
Subject: Re: [PATCH 1/2 V3] ext4: make trim/discard optional (and off by
 default)
Date: Thu, 19 Nov 2009 14:30:49 -0500
Message-ID: <20091119193049.GC2099@thunk.org>
References: <4B01D5B5.7090302@redhat.com>
 <4B02D537.8000103@redhat.com>
 <4B02D7BD.8070900@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:37208 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755011AbZKSUcy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Nov 2009 15:32:54 -0500
Content-Disposition: inline
In-Reply-To: <4B02D7BD.8070900@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 17, 2009 at 11:05:01AM -0600, Eric Sandeen wrote:
> It is anticipated that when sb_issue_discard starts doing
> real work on trim-capable devices, we may see issues.  Make
> this mount-time optional, and default it to off until we know
> that things are working out OK.
> 
> V2: rename "trim" to "discard" to match btrfs & gfs2
> V3: fix mailer flowed text mangling, sorry.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Queued, thanks.

						- Ted
