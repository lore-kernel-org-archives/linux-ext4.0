From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH e2fsprogs] include sys/sysmacros.h as needed
Date: Fri, 19 May 2017 14:08:22 -0400
Message-ID: <20170519180822.d2bsla3pdmlitljo@thunk.org>
References: <1459212168-25407-1-git-send-email-vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Mike Frysinger <vapier@gentoo.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:43638 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753568AbdESSI1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 19 May 2017 14:08:27 -0400
Content-Disposition: inline
In-Reply-To: <1459212168-25407-1-git-send-email-vapier@gentoo.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 28, 2016 at 08:42:48PM -0400, Mike Frysinger wrote:
> The minor/major/makedev macros are not entirely standard.  glibc has had
> the definitions in sys/sysmacros.h since the start, and wants to move away
> from always defining them implicitly via sys/types.h (as this pollutes the
> namespace in violation of POSIX).  Other C libraries have already dropped
> them.  Since the configure script already checks for this header, use that
> to pull in the header in files that use these macros.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

This fell through the cracks; my apologies.  But I've just applied it
to the e2fsprogs maint and master branches.

							- Ted
