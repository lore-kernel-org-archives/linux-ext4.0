From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] ext4: Rename uninitialized extents to unwritten
Date: Sat, 12 Apr 2014 10:28:41 -0400
Message-ID: <20140412142840.GF13837@thunk.org>
References: <1397150063-5939-1-git-send-email-lczerner@redhat.com>
 <1397150063-5939-2-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53190 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753905AbaDLO2m (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 12 Apr 2014 10:28:42 -0400
Content-Disposition: inline
In-Reply-To: <1397150063-5939-2-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 10, 2014 at 07:14:23PM +0200, Lukas Czerner wrote:
> Currently in ext4 there is quite a mess when it comes to naming
> unwritten extents. Sometimes we call it uninitialized and sometimes we
> refer to it as unwritten.
> 
> The right name for the extent which has been allocated but does not
> contain any written data is _unwritten_. Other file systems are
> using this name consistently, even the buffer head state refers to it as
> unwritten. We need to fix this confusion in ext4.
> 
> This commit changes every reference to an uninitialized extent (meaning
> allocated but unwritten) to unwritten extent. This includes comments,
> function names and variable names. It even covers abbreviation of the
> word uninitialized (such as uninit) and some misspellings.
> 
> This commit does not change any of the code paths at all. This has been
> confirmed by comparing md5sums of the assembly code of each object file
> after all the function names were stripped from it.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Thanks, queued.

						- Ted
