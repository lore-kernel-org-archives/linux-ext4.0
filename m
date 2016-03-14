From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Buffer Head Leak In mmp
Date: Mon, 14 Mar 2016 10:40:03 -0400
Message-ID: <20160314144002.GN29218@thunk.org>
References: <CAJ-febOhan58G=Aw+-CD6OD2iKuFY3dxkzBfVMCwBd6vXs1rFg@mail.gmail.com>
 <B747AA6A-644E-475E-BE24-07C400041058@dilger.ca>
 <20160313215730.GI29218@thunk.org>
 <BFF88A70-A864-4957-A807-30C6191C4D45@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "vikram.jadhav07" <vikramjadhavpucsd2007@gmail.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41834 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934333AbcCNOkE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Mar 2016 10:40:04 -0400
Content-Disposition: inline
In-Reply-To: <BFF88A70-A864-4957-A807-30C6191C4D45@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 14, 2016 at 02:41:34AM -0600, Andreas Dilger wrote:
> On Mar 13, 2016, at 3:57 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> > 
> > I've made the changes Andreas suggested, and ended up with this.  Andreas, PTAL?
> 
> Sorry, not sure what "PTAL" means... :-)

"Please take a look".

> In any case, the patch looks good to me.

Which is sometimes abbreviated "LGTM".   :-)

Thanks for the code review!

					- Ted
