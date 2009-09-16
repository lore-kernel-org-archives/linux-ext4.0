From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 1/4]ext4: Replace get_ext_path macro with  an inline
	funciton
Date: Wed, 16 Sep 2009 14:17:55 -0400
Message-ID: <20090916181755.GC15451@mit.edu>
References: <4AADFC0A.6040704@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:37813 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975AbZIPSRz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Sep 2009 14:17:55 -0400
Content-Disposition: inline
In-Reply-To: <4AADFC0A.6040704@rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 14, 2009 at 05:17:14PM +0900, Akira Fujita wrote:
> ext4: Replace get_ext_path macro with an inline function
> 
> From: Akira Fujita <a-fujita@rs.jp.nec.com>
> 
> Replace get_ext_path macro with an inline function,
> since this macro looks like a function call but its arguments
> get modified. Ted pointed this out, thanks.
> 
> Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>

Applied, thanks.

						- Ted
