From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext4 : Fix Kconfig typo for ext4dev
Date: Mon, 13 Oct 2008 12:36:34 -0400
Message-ID: <20081013163634.GB17792@mit.edu>
References: <ea11fea30810130600w1883334ag8af2fd424906799@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 <linux-ext4@vger.kernel.org>
To: Manish Katiyar <mkatiyar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:41322 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755741AbYJMQgh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 13 Oct 2008 12:36:37 -0400
Content-Disposition: inline
In-Reply-To: <ea11fea30810130600w1883334ag8af2fd424906799@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 13, 2008 at 06:30:57PM +0530, Manish Katiyar wrote:
> Hi Ted,
> 
> Looks like there is one more instance where ext4dev should be changed
> to ext4 because the module name will be "ext4" unless EXT4DEV_COMPAT
> is selected.
> 

Thanks, queued.

FYI, I normally fix it up manually, but it would be preferred if you
omitted the space before the colon, i.e.:

Subject: [PATCH] ext4: Fix Kconfig typo for ext4dev

instead of:

Subject: [PATCH] ext4 : Fix Kconfig typo for ext4dev

Thanks!!

							- Ted
