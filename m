From: Ted Ts'o <tytso@mit.edu>
Subject: Re: libquota: add missing time.h include
Date: Mon, 28 May 2012 10:21:40 -0400
Message-ID: <20120528142140.GA1725@thunk.org>
References: <1337715710-9484-1-git-send-email-vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Mike Frysinger <vapier@gentoo.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45961 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754099Ab2E1OVm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 May 2012 10:21:42 -0400
Content-Disposition: inline
In-Reply-To: <1337715710-9484-1-git-send-email-vapier@gentoo.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 22, 2012 at 09:41:50AM -0000, Mike Frysinger wrote:
> This code uses time() but doesn't include time.h leading to:
> quotaio.c:89:2: warning: implicit declaration of function 'time'
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

Thanks, applied.

					- Ted
