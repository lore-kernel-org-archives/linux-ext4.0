From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 08/22] ext4 crypto: add ext4 encryption facilities
Date: Sat, 11 Apr 2015 08:50:12 -0400
Message-ID: <20150411125012.GC6540@thunk.org>
References: <1428012659-12709-1-git-send-email-tytso@mit.edu>
 <1428012659-12709-9-git-send-email-tytso@mit.edu>
 <1428584082.30295.7.camel@dhcp-27-107.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	jaegeuk@kernel.org, mhalcrow@google.com,
	Ildar Muslukhov <ildarm@google.com>
To: Maurizio Lombardi <mlombard@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34084 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753843AbbDKMuS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 11 Apr 2015 08:50:18 -0400
Content-Disposition: inline
In-Reply-To: <1428584082.30295.7.camel@dhcp-27-107.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 09, 2015 at 02:54:42PM +0200, Maurizio Lombardi wrote:
> 
> The return value of crypto_ablkcipher_setkey() is not checked for errors.

Thanks for pointing this out!  I'll fix this in the next spin of the
patches.

						- Ted
