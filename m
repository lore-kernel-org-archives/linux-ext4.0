From: Ted Ts'o <tytso@mit.edu>
Subject: Re: kernel BUG at fs/ext4/inode.c:2721!
Date: Thu, 28 Oct 2010 11:30:04 -0400
Message-ID: <20101028153004.GB16666@thunk.org>
References: <AANLkTim=QbAX9JvpaSuJ8-EEK3O0YLyetkemtjWxY=x7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: Avinash Kurup <kurup.avinash@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:47321 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752525Ab0J1PaG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 Oct 2010 11:30:06 -0400
Content-Disposition: inline
In-Reply-To: <AANLkTim=QbAX9JvpaSuJ8-EEK3O0YLyetkemtjWxY=x7@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 28, 2010 at 08:35:00PM +0530, Avinash Kurup wrote:
> Hi,
>       I have been getting BUG_ON errors since todays update from linus'
> tree, I could not recreate the error as it seems to be random in nature.
> Files created after the BUG_ON message do not get saved to the sda10
> partition. I also have problems rebooting and shutting down the system
> once the BUG_ON occurs.

Which tree are you using precisely?  Is this the linux-next tree, or
Linus's tree?  The line number looks like you might be using
linux-next?  Can you give me the git commit-id you are using?

						- Ted
