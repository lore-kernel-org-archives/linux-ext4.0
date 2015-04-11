From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 06/22] ext4 crypto: add encryption policy checking
Date: Sat, 11 Apr 2015 09:18:13 -0400
Message-ID: <20150411131813.GG6540@thunk.org>
References: <1428012659-12709-1-git-send-email-tytso@mit.edu>
 <1428012659-12709-7-git-send-email-tytso@mit.edu>
 <6C2E40F9-574A-4EA8-B533-C9D8CCF1C9C3@dilger.ca>
 <20150411130637.GD6540@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	jaegeuk@kernel.org, mhalcrow@google.com,
	Ildar Muslukhov <muslukhovi@gmail.com>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34149 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753700AbbDKNSP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 11 Apr 2015 09:18:15 -0400
Content-Disposition: inline
In-Reply-To: <20150411130637.GD6540@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Apr 11, 2015 at 09:06:37AM -0400, Theodore Ts'o wrote:
> As it turns out we're not even using ext4_to_hex() any more, so we can
> even more simply just delete this whole function.  :-)

Whoops, spoke to soon; I'll just add the sprintf call directly into
fs/ext4/crypto_key.c.

						- Ted
