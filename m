From: Frank Mayhar <fmayhar@google.com>
Subject: Re: [PATCH 1/1] Allow ext4 to run without a journal.
Date: Wed, 17 Dec 2008 09:52:38 -0800
Message-ID: <1229536358.2921.18.camel@bobble.smo.corp.google.com>
References: <1228953270.14314.15.camel@bobble.smo.corp.google.com>
	 <1229362555.19828.2.camel@bobble.smo.corp.google.com>
	 <20081216040011.GF11502@mit.edu>  <20081217060051.GK10590@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:15181 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbYLQRxC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Dec 2008 12:53:02 -0500
In-Reply-To: <20081217060051.GK10590@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 2008-12-17 at 01:00 -0500, Theodore Tso wrote:
> Note, the patch allow-ext4-to-run-without-a-journal conflicted with a
> large number of other patches in the patch queue.  I fixed it up as
> best I could, and reviewed all of the changed patches, and I think
> it's OK.  Please be cautious when first testing this, though.

Yeah, sorry, for reasons that are probably obvious this patch was
relative to the ext4 stable tree, not to the latest bits.
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

