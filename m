From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: Re: bio splits unnecessarily due to BH_Boundary in ext3 direct I/O
Date: Mon, 01 Apr 2013 17:25:56 +0900
Message-ID: <51594494.3070207@sx.jp.nec.com>
References: <51385177.9030904@sx.jp.nec.com> <20130307104854.GB6723@quack.suse.cz> <51482381.7010508@sx.jp.nec.com> <20130319193132.GE5222@quack.suse.cz> <514AC848.6020104@sx.jp.nec.com> <20130329171536.GF5913@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: akpm@linux-foundation.org, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO200.gate.nec.co.jp ([210.143.35.50]:63495 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758524Ab3DAIen (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 1 Apr 2013 04:34:43 -0400
In-Reply-To: <20130329171536.GF5913@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2013/03/30 2:15, Jan Kara wrote:
>   Sorry for not getting to you earlier. So we agree in our analysis. Do you
> agree with the attached patch? Does it help your workload?

According to your two patches, direct I/O works as the following steps:
1. add sdio->cur_page to sdio->bio by dio_new_bio() or dio_bio_add_page()
2. submit sdio->bio if sdio->boudary is set
3. set the curret page to sdio->cur_page in submit_page_section()

Only one page is submitted separately because of submitting bio before step 3.

For example, we write 52KB data with O_DIRECT, it is ideal that filesystem
submits a bio twice (48KB and 4KB). However, after applying your two patches,
52KB data is split into three bios (44KB, 4KB and 4KB).

Regards,
Kazuya Mio
