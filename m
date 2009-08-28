From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] e4defrag: fix ppc build
Date: Fri, 28 Aug 2009 19:41:48 -0400
Message-ID: <20090828234148.GI16732@mit.edu>
References: <4A9220A6.7020000@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Kyle McMartin <kyle@mcmartin.ca>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:50572 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750872AbZH1Xlt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 28 Aug 2009 19:41:49 -0400
Content-Disposition: inline
In-Reply-To: <4A9220A6.7020000@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Aug 23, 2009 at 10:09:58PM -0700, Eric Sandeen wrote:
> From: Kyle McMartin <kyle@mcmartin.ca>
>
> ppc glibc seems to be missing sync_file_range, so we fell back
> to the local define, and there ppc differs as well, so the
> build was failing.
>
> Thanks to Kyle for the patch w/ the tidy solution.
>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Thanks, applied.

					- Ted
