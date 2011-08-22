From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: attempt to fix race in bigalloc code path
Date: Mon, 22 Aug 2011 21:54:06 +0800
Message-ID: <CAGBYx2ZTzrLR2yRRnCu3pvFWvofYzJp7+WsdQt2=Y7yWGEzyTg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jan Kara <jack@suse.cz>, "Ted Ts'o" <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: adityakali@google.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:44451 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815Ab1HVNyH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Aug 2011 09:54:07 -0400
Received: by yie30 with SMTP id 30so3572713yie.19
        for <linux-ext4@vger.kernel.org>; Mon, 22 Aug 2011 06:54:07 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I can not find the patch - attempt to fix race in bigalloc code path -
in the mailing list.

I don't think this patch can work.  set_buffers_da_mapped() is called
under i_data_sem, so it can not lock page.  If the page is not locked,
calling page_has_buffers() is not secure as Jan pointed out
previously.  If a page is partially mapped(block size < page size),
setting BH_Da_Mapped without locking page is not safe too.

BTW:  find_delalloc_range() does not lock page as ext4_fiemap_cb().
As Jan said, it can crash system.  BUT we can not lock page in both
scenarios, because i_data_sem is hold. So delayed extent list is
necessary.  I have finished the code implementing delayed extent list,
which needs some further testing.


What are your opinions?


-- 
Best Wishes
Yongqiang Yang
