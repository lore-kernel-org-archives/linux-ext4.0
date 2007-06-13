From: Hugh Dickins <hugh@veritas.com>
Subject: Re: [patch] new aop loop fix
Date: Wed, 13 Jun 2007 15:48:16 +0100 (BST)
Message-ID: <Pine.LNX.4.64.0706131543380.10580@blonde.wat.veritas.com>
References: <20070613134631.GB13815@localhost.sw.ru>
 <Pine.LNX.4.64.0706131426070.4539@blonde.wat.veritas.com>
 <20070613172939.GE13815@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-kernel@vger.kernel.org, npiggin@suse.de,
	mark.fasheh@oracle.com, linux-ext4@vger.kernel.org
To: Dmitriy Monakhov <dmonakhov@sw.ru>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:6192 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756060AbXFMOsq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Jun 2007 10:48:46 -0400
In-Reply-To: <20070613172939.GE13815@localhost.sw.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 13 Jun 2007, Dmitriy Monakhov wrote:
> Btw: Nick's patches broke  LO_CRYPT_XOR mode,

It would help him if you could describe how.

> but it is ok because
> this feature was absolete and not used by anyone, am i right here?

I know nothing of this; but so long as its code remains in the driver,
I'd say we should be supporting it rather than breaking it.

Hugh
