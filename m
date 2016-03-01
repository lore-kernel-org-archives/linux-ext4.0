From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [v3 5/5] Add project ID support for chattr/lsattr
Date: Mon, 29 Feb 2016 23:24:58 -0500
Message-ID: <20160301042458.GD9772@thunk.org>
References: <1452589008-18750-1-git-send-email-lixi@ddn.com>
 <1452589008-18750-6-git-send-email-lixi@ddn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Li Xi <pkuelelixi@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:42342 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089AbcCAEZD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 29 Feb 2016 23:25:03 -0500
Content-Disposition: inline
In-Reply-To: <1452589008-18750-6-git-send-email-lixi@ddn.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 12, 2016 at 05:56:48PM +0900, Li Xi wrote:
> Chattr and lsattr can be used to set or get project ID:
> chattr -p <project id> file
> lsattr -p file
> 
> Signed-off-by: Li Xi <lixi@ddn.com>
> Signed-off-by: Wang Shilong <wshilong@ddn.com>
> ---
>  lib/e2p/Makefile.in |   11 +++++++++--
>  lib/e2p/e2p.h       |    2 ++
>  misc/chattr.1.in    |    7 +++++++
>  misc/chattr.c       |   33 +++++++++++++++++++++++++++++++--
>  misc/lsattr.1.in    |    5 ++++-
>  misc/lsattr.c       |   18 ++++++++++++++++--
>  6 files changed, 69 insertions(+), 7 deletions(-)

Hi, this patch is missing the new files for fgetproject.c and
fsetproject.c.   Can you resend them, please?

						- Ted
