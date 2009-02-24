From: Dmitri Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH] ext3/4: Clear pagep after write_begin() has failed
Date: Tue, 24 Feb 2009 13:11:33 +0300
Message-ID: <m3prh8w3e2.fsf@openvz.org>
References: <1234898659-4686-1-git-send-email-dmonakhov@openvz.org>
	<20090223031230.GA19739@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:9253 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752481AbZBXKNS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Feb 2009 05:13:18 -0500
In-Reply-To: <20090223031230.GA19739@mit.edu> (Theodore Tso's message of "Sun\, 22 Feb 2009 22\:12\:30 -0500")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso <tytso@mit.edu> writes:

> On Tue, Feb 17, 2009 at 10:24:19PM +0300, Dmitri Monakhov wrote:
>> Seems there is no strict rule to for this case. In fact everybody
>> just ignored this variable after write_begin() has failed.
>> This was true until ext4_defrag_partial(). So let's follows simple
>> rule similar to block_write_begin().
>
> I've checked the latest ext4_defrag_partial, and it doesn't reference
> the page variable if write_begin() failed....
>
> 						- Ted
Latest posted defrag version 1.0 from 30 Jan, contains following code
+	up_write(&EXT4_I(org_inode)->i_data_sem);
+	ret = a_ops->write_begin(o_filp, mapping, offs, data_len, w_flags,
+								&page, &fsdata);
+	down_write(&EXT4_I(org_inode)->i_data_sem);
+
+	if (unlikely(ret < 0))
+		goto out;
.....
+out:
+	if (unlikely(page)) {
+		if (PageLocked(page))
+			unlock_page(page);
+		page_cache_release(page);
+	}
In fact the patch i'm propose is mostly a cleanup, rather then serious fix
for real issue. IMHO it is not bad idea to fold it in to some real patch.
