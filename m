From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: Re: bio splits unnecessarily due to BH_Boundary in ext3 direct I/O
Date: Tue, 19 Mar 2013 17:36:17 +0900
Message-ID: <51482381.7010508@sx.jp.nec.com>
References: <51385177.9030904@sx.jp.nec.com> <20130307104854.GB6723@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: akpm@linux-foundation.org, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO200.gate.nec.co.jp ([210.143.35.50]:47316 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756083Ab3CSIpP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Mar 2013 04:45:15 -0400
Received: from tyo202.gate.nec.co.jp ([10.7.69.202])
	by tyo200.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id r2J8jEhC029597
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 19 Mar 2013 17:45:14 +0900 (JST)
In-Reply-To: <20130307104854.GB6723@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2013/03/07 19:48, Jan Kara wrote:
> Then we properly mark bio should be submitted only if we are mapping last
> part of the mapped extent from the filesystem. Can you give this change a
> try (full patch with changelog attached)?

Sorry for the late response.
After applying your patch, the problem I reported was fixed.

One matter for concern is that submit_bio() is called twice per one buffer_head.
Because submit_page_section() calls dio_bio_submit() before adding
the old page (sdio->cur_page) and the current page to struct dio_submit.
Does it work as required?

Regards,
Kazuya Mio

