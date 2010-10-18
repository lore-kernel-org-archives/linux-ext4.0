From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 1/2] ext4: Avoid uninitialized memory references in ext3_htree_next_block()
Date: Sun, 17 Oct 2010 22:27:37 -0600
Message-ID: <F70A5CAD-817E-4CB4-8F9F-8FD26B8BED0B@dilger.ca>
References: <20101016233513.GA31722@thunk.org> <1287272253-2140-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Brad Spengler <spender@grsecurity.net>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:48709 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067Ab0JRE1m (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Oct 2010 00:27:42 -0400
In-Reply-To: <1287272253-2140-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-10-16, at 17:37, Theodore Ts'o wrote:
> @@ -870,6 +871,16 @@ static struct buffer_head * ext4_find_entry (struct 
> +	if ((namelen < 2) && (name[0] == '.') &&
> +	    (name[1] == '.' || name[1] == '0')) {

Shouldn't this be "namelen <= 2"?  Otherwise it won't actually match "..".

Cheers, Andreas





