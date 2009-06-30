From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] debugfs: don't try to fclose NULL
Date: Tue, 30 Jun 2009 12:39:56 -0400
Message-ID: <20090630163956.GE7398@mit.edu>
References: <4A451A23.20307@redhat.com> <m2r5x1pvyg.fsf@vador.mandriva.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Thierry Vignaud <tvignaud@mandriva.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:56987 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751818AbZF3Qj4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 30 Jun 2009 12:39:56 -0400
Content-Disposition: inline
In-Reply-To: <m2r5x1pvyg.fsf@vador.mandriva.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 30, 2009 at 05:44:55PM +0200, Thierry Vignaud wrote:
> Eric Sandeen <sandeen@redhat.com> writes:
> 
> > do_logdump may jump to errout if fopen(out_file) fails, 
> > but in that case out_file is NULL, and fclose will segfault.
> 
> You should report that segfault to glibc authors too.

It would be robust for glibc to code fclose() defensively such that it
would survive a null pointer, but I don't think it's technically
required by the ANSI or POSIX spec.

						- Ted
