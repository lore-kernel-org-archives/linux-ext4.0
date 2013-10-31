From: Tao Ma <tm@tao.ma>
Subject: Re: fix the ext4_read_inline_dir return value
Date: Thu, 31 Oct 2013 10:34:31 +0800
Message-ID: <5271C1B7.8040009@tao.ma>
References: <CAAFszuV7tXpGA5GVWtLzzHZayPgN-M+n_W4LN67i=ueicfZb+Q@mail.gmail.com> <5265DE93.8060406@tao.ma> <20131030121341.GB12186@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Boxi Liu <boxi10liu@gmail.com>,
	"lewis.liulei" <lewis.liulei@huawei.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Robin Dong <sanbai@taobao.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from server.coly.li ([162.144.45.48]:57952 "EHLO server.coly.li"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751408Ab3JaCfY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Oct 2013 22:35:24 -0400
In-Reply-To: <20131030121341.GB12186@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/30/2013 08:13 PM, Theodore Ts'o wrote:
> Applied, thanks.
> 
> On Tue, Oct 22, 2013 at 10:10:27AM +0800, Tao Ma wrote:
>> But next time please generate the patch with git format-patch and send
>> it using git send-email.
> 
> Yes, please.  :-)
> 
> I've reworded the commit description a little.
> 
>     In ext4_read_inline_dir(), if there is inline data, the successful
>     return value is the return value of ext4_read_inline_data().  Howewer,
>     this is used by ext4_readdir(), and while it seems harmless to return
>     a positive value on success, it's inconsistent, since historically
>     we've always return 0 on success.
>     
> 
> BTW, it looks like it would simplify the code a bit to change
> ext4_read_inline_page() and ext4_read_line_data() to return 0 on
> success, since it looks like the positive value on success isn't
> needed anywhere, and this would allow us to remove lines such as this:
> 
>        return ret >= 0 ? 0 : ret;
> 
> as well as the forced ret = 0; in this commit.
> 
> Could you take a look and verify that this is true, and I haven't
> missed anything?
sure, I will look into it.
> 
> Also, it would be nice if the functions in fs/ext4/inline.c documented
> what the return values are for each of the functions, one way or
> another.
OK, I will try to generate a patch for it.

Thanks,

Tao
> 
> Thanks!!
> 
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

