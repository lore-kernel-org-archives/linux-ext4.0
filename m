From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: fix the ext4_read_inline_dir return value
Date: Wed, 30 Oct 2013 08:13:41 -0400
Message-ID: <20131030121341.GB12186@thunk.org>
References: <CAAFszuV7tXpGA5GVWtLzzHZayPgN-M+n_W4LN67i=ueicfZb+Q@mail.gmail.com>
 <5265DE93.8060406@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Boxi Liu <boxi10liu@gmail.com>,
	"lewis.liulei" <lewis.liulei@huawei.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Robin Dong <sanbai@taobao.com>
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52526 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752682Ab3J3QvH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Oct 2013 12:51:07 -0400
Content-Disposition: inline
In-Reply-To: <5265DE93.8060406@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Applied, thanks.

On Tue, Oct 22, 2013 at 10:10:27AM +0800, Tao Ma wrote:
> But next time please generate the patch with git format-patch and send
> it using git send-email.

Yes, please.  :-)

I've reworded the commit description a little.

    In ext4_read_inline_dir(), if there is inline data, the successful
    return value is the return value of ext4_read_inline_data().  Howewer,
    this is used by ext4_readdir(), and while it seems harmless to return
    a positive value on success, it's inconsistent, since historically
    we've always return 0 on success.
    

BTW, it looks like it would simplify the code a bit to change
ext4_read_inline_page() and ext4_read_line_data() to return 0 on
success, since it looks like the positive value on success isn't
needed anywhere, and this would allow us to remove lines such as this:

       return ret >= 0 ? 0 : ret;

as well as the forced ret = 0; in this commit.

Could you take a look and verify that this is true, and I haven't
missed anything?

Also, it would be nice if the functions in fs/ext4/inline.c documented
what the return values are for each of the functions, one way or
another.

Thanks!!

						- Ted
