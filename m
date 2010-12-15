From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsprogs: fix type-punning warnings
Date: Wed, 15 Dec 2010 18:09:26 -0500
Message-ID: <20101215230926.GC4455@thunk.org>
References: <4D07BEB1.8030406@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:33516 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755557Ab0LOXJ3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 15 Dec 2010 18:09:29 -0500
Content-Disposition: inline
In-Reply-To: <4D07BEB1.8030406@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 14, 2010 at 01:00:01PM -0600, Eric Sandeen wrote:
> Flags used during RHEL/Fedora builds lead to a couple type-punning
> warnings:
> 
>   recovery.c: In function 'do_one_pass':
>   recovery.c:539: warning: dereferencing type-punned pointer will break strict-aliasing rules
>   ./csum.c: In function 'print_csum':
>   ./csum.c:170: warning: dereferencing type-punned pointer will break strict-aliasing rules
> 
> The two changes below fix this up.
> 
> Note that the csum test binary output changes slightly, but this does
> not break any tests.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Thanks, applied.  There's also a bone-headed big-endian compile bug
which means I'll be doing an e2fsprogs 1.41.14 shortly.

      	    	    	     	       - Ted
