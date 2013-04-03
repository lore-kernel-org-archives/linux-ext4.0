From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] ext4: fix usless declarations
Date: Wed, 3 Apr 2013 08:26:41 -0400
Message-ID: <20130403122641.GC7741@thunk.org>
References: <1364986711-3630-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, wenqing.lz@taobao.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:58887 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762512Ab3DCM0o (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Apr 2013 08:26:44 -0400
Content-Disposition: inline
In-Reply-To: <1364986711-3630-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 03, 2013 at 02:58:30PM +0400, Dmitry Monakhov wrote:
> This patch should fix sparse complains about shadow declatations.

Nothing here is fixing serious regressions, right?  This is just to
make static code checkers happy?

						- Ted
