From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] debugfs: don't try to fclose NULL
Date: Mon, 29 Jun 2009 01:07:52 -0400
Message-ID: <20090629050752.GC6802@mit.edu>
References: <4A451A23.20307@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:48586 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751085AbZF2FIb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 29 Jun 2009 01:08:31 -0400
Content-Disposition: inline
In-Reply-To: <4A451A23.20307@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 26, 2009 at 01:57:39PM -0500, Eric Sandeen wrote:
> do_logdump may jump to errout if fopen(out_file) fails, 
> but in that case out_file is NULL, and fclose will segfault.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Thanks, applied.


					- Ted
