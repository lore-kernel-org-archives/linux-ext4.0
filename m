From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 05/10] misc/create_inode.c: copy regular file
Date: Thu, 26 Dec 2013 11:03:35 -0500
Message-ID: <20131226160335.GA23928@thunk.org>
References: <1387800600-13718-1-git-send-email-liezhi.yang@windriver.com>
 <1387800600-13718-6-git-send-email-liezhi.yang@windriver.com>
 <1387827139.5088.69.camel@dvhart-mobl4.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Robert Yang <liezhi.yang@windriver.com>, linux-ext4@vger.kernel.org
To: Darren Hart <dvhart@linux.intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:43566 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753458Ab3LZQDl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 26 Dec 2013 11:03:41 -0500
Content-Disposition: inline
In-Reply-To: <1387827139.5088.69.camel@dvhart-mobl4.amr.corp.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 23, 2013 at 11:32:19AM -0800, Darren Hart wrote:
> 
> Does __FUNCTION__ not provide this same functionality in this context?
> No need to store this explicitly is there?

Note: __func__ (which is specified by C99, and supported by newer
GCC's) is preferred over __FUNCTION__.

If we really care about supporting older versions of GCC, we could do
this:

     #if __STDC_VERSION__ < 199901L
     # if __GNUC__ >= 2
     #  define __func__ __FUNCTION__
     # else
     #  define __func__ "<unknown>"
     # endif
     #endif

Cheers,

						- Ted
