From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 4/6 linux-next] ext4: use bool for check in
 ext4_ext_space_()
Date: Thu, 15 Sep 2016 11:57:15 -0400
Message-ID: <20160915155715.hd2sj6ptnbnuqpte@thunk.org>
References: <1472069000-18897-1-git-send-email-fabf@skynet.be>
 <1472069000-18897-5-git-send-email-fabf@skynet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Fabian Frederick <fabf@skynet.be>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:55892 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755465AbcIOP5e (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 15 Sep 2016 11:57:34 -0400
Content-Disposition: inline
In-Reply-To: <1472069000-18897-5-git-send-email-fabf@skynet.be>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 24, 2016 at 10:03:18PM +0200, Fabian Frederick wrote:
> check is used in 0/1 context.
> 
> Also use unsigned int instead of unsigned (checkpatch warning)
> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Dropped; this is a checkpatch-only style patch.

						- Ted
