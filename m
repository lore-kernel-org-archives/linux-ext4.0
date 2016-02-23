From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v6] EXT4: optimizing group search for inode allocation
Date: Mon, 22 Feb 2016 23:04:51 -0500
Message-ID: <20160223040451.GJ1215@thunk.org>
References: <CAKJOkCr-O+37QfFFJgtkRUZfo_-U=qmYy=Ooc7oqtqcVrz1HWQ@mail.gmail.com>
 <9CF60D02-FF10-44FF-A31E-D4E99F627AF2@dilger.ca>
 <20151226084153.GA4248@server_lokesh.domain.name>
 <2DA2ED68-7DD4-425D-8A47-E896E9BF0F4A@dilger.ca>
 <20160107004639.GA3902@server_lokesh.domain.name>
 <687935F0-EEA5-4CB6-9E5C-43E49FBB39E2@dilger.ca>
 <20160116230226.GB3189@server_lokesh>
 <1ACAFB33-9F89-4718-99F4-CB0EE7206466@dilger.ca>
 <20160119060812.GA7158@server_lokesh>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Lokesh Jaliminche <lokesh.jaliminche@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39436 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757476AbcBWEEy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 22 Feb 2016 23:04:54 -0500
Content-Disposition: inline
In-Reply-To: <20160119060812.GA7158@server_lokesh>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 19, 2016 at 11:38:12AM +0530, Lokesh Jaliminche wrote:
> From: Lokesh Nagappa Jaliminche <lokesh.jaliminche@gmail.com>
> Subject: [PATCH] ext4: optimizing group serch for inode allocation
> 
> Added a check at the start of group search loop to
> avoid looping unecessarily in case of empty group.
> This also allow group search to jump directly to
> "found_flex_bg" with "stats" and "group" already set,
> so there is no need to go through the extra steps of
> setting "best_desc" , "best_group" and then break
> out of the loop just to set "stats" and "group" again.
> 
> Signed-off-by: Lokesh Nagappa Jaliminche <lokesh.jaliminche@gmail.com>

Thanks, applied.

						- Ted
