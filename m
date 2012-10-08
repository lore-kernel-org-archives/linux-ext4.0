From: Prashant Shah <pshah.mumbai@gmail.com>
Subject: Re: freeze_bdev hangs
Date: Mon, 8 Oct 2012 22:05:38 +0530
Message-ID: <CAD6i1fKpWZVbL4gS1ui7GvF81S+SAduckXeWoApwH=KgKuiU9g@mail.gmail.com>
References: <CAD6i1f+fzh-z+Xr6V2gHBzq4kmJzPcfre91g=q6fJ7P_5nY0Zw@mail.gmail.com>
 <506F19E6.8030005@redhat.com> <CAD6i1fJbfiBnTu1ttisMr96PzaTWCLAsvmTjx7OevfPcAGd7-A@mail.gmail.com>
 <20121008161926.GH9243@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:33411 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823Ab2JHQf7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Oct 2012 12:35:59 -0400
Received: by mail-ee0-f46.google.com with SMTP id b15so2904490eek.19
        for <linux-ext4@vger.kernel.org>; Mon, 08 Oct 2012 09:35:58 -0700 (PDT)
In-Reply-To: <20121008161926.GH9243@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

On Mon, Oct 8, 2012 at 9:49 PM, Jan Kara <jack@suse.cz> wrote:
>   And what tool are you using for monitoring?

I am using printk(). A custom module that changes the make_request_fn
of the block device to a custom callback. In the callback I am
printing the request bio details and passing the bio back to the
original make_request_fn.

Regards.
