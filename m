From: tytso@mit.edu
Subject: Re: [PATCH 0/8] Clean up ext4's block free code paths
Date: Mon, 23 Nov 2009 09:46:29 -0500
Message-ID: <20091123144629.GF2532@thunk.org>
References: <1258942710-31930-1-git-send-email-tytso@mit.edu>
 <4B0A072C.5000305@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:54064 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755229AbZKWOq1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Nov 2009 09:46:27 -0500
Content-Disposition: inline
In-Reply-To: <4B0A072C.5000305@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Nov 22, 2009 at 09:53:16PM -0600, Eric Sandeen wrote:
> 
> Have you double-checked stack usage before & after the series, just
> in case all the folding-in increased some stack footprints?

The static stack footprints (on an x86) showed slight increases:

Before:
ext4_mb_free_blocks [vmlinux]:		124
ext4_ext_truncate [vmlinux]:		100

After applying the patch series:

ext4_free_blocks [vmlinux]:		136
ext4_ext_truncate [vmlinux]:		116

I was more concerned about the dynamic stack usage, so I ran xfstests
QA and then re-running test #74 (fstest), which seems to be the one
that uses the most stack.  The results are not fully consistent (which
is why I manually re-ran #74 a few times to try to provoke the
smallest possible stack space left), but the worse case stack usage I
was able to find was:

Before:

fstest used greatest stack depth: 1084 bytes left

After applying the patch series:

fstest used greatest stack depth: 1024 bytes left

So it's slightly worse, but hopefully not enough to push us over the
edge.  I think I can move some stack variables into inner blocks in
ext4_free_blocks() which should help, if we think this is a major
problem.

              	      	  	      	       - Ted
