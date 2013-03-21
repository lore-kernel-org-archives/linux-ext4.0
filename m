From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: Re: bio splits unnecessarily due to BH_Boundary in ext3 direct I/O
Date: Thu, 21 Mar 2013 17:43:52 +0900
Message-ID: <514AC848.6020104@sx.jp.nec.com>
References: <51385177.9030904@sx.jp.nec.com> <20130307104854.GB6723@quack.suse.cz> <51482381.7010508@sx.jp.nec.com> <20130319193132.GE5222@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: akpm@linux-foundation.org, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO200.gate.nec.co.jp ([210.143.35.50]:62314 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932538Ab3CUIwb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Mar 2013 04:52:31 -0400
Received: from tyo202.gate.nec.co.jp ([10.7.69.202])
	by tyo200.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id r2L8qUqU006368
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 21 Mar 2013 17:52:30 +0900 (JST)
In-Reply-To: <20130319193132.GE5222@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2013/03/20 4:31, Jan Kara wrote:
>   I'm not sure I understand. Looking into dio_send_cur_page() it seems may
> prematurely submit the bio if sdio->boundary is set - in that case we
> should probably first try to add the page to the bio and submit the bio
> only after that. Is that what you mean?

I think the direct I/O works for each page into buffer_head by the following
three steps:
1. submit sdio->bio if sdio->boudary is set
2. add sdio->cur_page to sdio->bio by dio_new_bio() or dio_bio_add_page()
3. set the curret page to sdio->cur_page in submit_page_section()

It is true that dio_send_cur_page() submits the bio if sdio->boudary is set.
However, at this time, this bio does not contain sdio->cur_page and
the current page do_direct_IO() passed.

Regards,
Kazuya Mio

