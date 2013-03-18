From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix memory leakage in mext_check_coverage
Date: Mon, 18 Mar 2013 11:40:45 -0400
Message-ID: <20130318154045.GF14430@thunk.org>
References: <1363613729-27282-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54133 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753268Ab3CRPku (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 Mar 2013 11:40:50 -0400
Content-Disposition: inline
In-Reply-To: <1363613729-27282-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 18, 2013 at 05:35:29PM +0400, Dmitry Monakhov wrote:
> Regression was introduced by following commit 8c854473
> TESTCASE (git://oss.sgi.com/xfs/cmds/xfstests.git):
> #while true;do ./check 301 || break ;done
> 
> Also fix potential memory leakage in get_ext_path() once
> ext4_ext_find_extent() have failed.
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>

Thanks, applied.  Good catch!!

						- Ted
