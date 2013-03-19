From: Jan Kara <jack@suse.cz>
Subject: Re: bio splits unnecessarily due to BH_Boundary in ext3 direct I/O
Date: Tue, 19 Mar 2013 20:31:32 +0100
Message-ID: <20130319193132.GE5222@quack.suse.cz>
References: <51385177.9030904@sx.jp.nec.com>
 <20130307104854.GB6723@quack.suse.cz>
 <51482381.7010508@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, akpm@linux-foundation.org,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
To: Kazuya Mio <k-mio@sx.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55345 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932952Ab3CSTbf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 Mar 2013 15:31:35 -0400
Content-Disposition: inline
In-Reply-To: <51482381.7010508@sx.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 19-03-13 17:36:17, Kazuya Mio wrote:
> 2013/03/07 19:48, Jan Kara wrote:
> >Then we properly mark bio should be submitted only if we are mapping last
> >part of the mapped extent from the filesystem. Can you give this change a
> >try (full patch with changelog attached)?
> 
> Sorry for the late response.
> After applying your patch, the problem I reported was fixed.
> 
> One matter for concern is that submit_bio() is called twice per one buffer_head.
> Because submit_page_section() calls dio_bio_submit() before adding
> the old page (sdio->cur_page) and the current page to struct dio_submit.
> Does it work as required?
  I'm not sure I understand. Looking into dio_send_cur_page() it seems may
prematurely submit the bio if sdio->boundary is set - in that case we
should probably first try to add the page to the bio and submit the bio
only after that. Is that what you mean?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
