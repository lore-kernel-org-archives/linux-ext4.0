From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/4] fs: Avoid data corruption with blocksize < pagesize
Date: Thu, 19 Mar 2009 00:12:22 +0530
Message-ID: <20090318184222.GA6369@skywalker>
References: <1237311235-13623-1-git-send-email-jack@suse.cz> <1237311235-13623-2-git-send-email-jack@suse.cz> <1237311235-13623-3-git-send-email-jack@suse.cz> <1237311235-13623-4-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
	Nick Piggin <npiggin@suse.de>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:39316 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754559AbZCRSmf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 18 Mar 2009 14:42:35 -0400
Content-Disposition: inline
In-Reply-To: <1237311235-13623-4-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 17, 2009 at 06:33:54PM +0100, Jan Kara wrote:
> Assume the following situation:
> Filesystem with blocksize < pagesize - suppose blocksize = 1024,
> pagesize = 4096. File 'f' has first four blocks already allocated.
> (line with "state:" contains the state of buffers in the page - m = mapped,
> u = uptodate, d = dirty)
> 
>   process 1:                       process 2:
> 
> write to 'f' bytes 0 - 1024
>   state: |mud,-,-,-|, page dirty
>                                    write to 'f' bytes 1024 - 4096:
>                                      __block_prepare_write() maps blocks
>                                        state: |mud,m,m,m|, page dirty
>                                      we fail to copy data -> copied = 0
>                                      block_write_end() does nothing
>                                      page gets unlocked


If copied = 0 then in  block_write_end we do

page_zero_new_buffers(page, start+copied, start+len

which would mean we should not see garbage.


> writepage() is called on the page
>   block_write_full_page() writes buffers with garbage
> 

-aneesh
