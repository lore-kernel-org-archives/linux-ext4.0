From: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: partially uptodate page reads
Date: Fri, 25 Jul 2008 01:17:11 +1000
Message-ID: <200807250117.11331.nickpiggin@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hifumi.hisashi@oss.ntt.co.jp, jack@ucw.cz,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	akpm@linux-foundation.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi, I have some questions about your patch in -mm

vfs-pagecache-usage-optimization-onpagesize=blocksize-environment.patch

I have no particular problem with something like this, but leaving the
implementation details aside for the moment, can we discuss the
justification for this?

Are there significant numbers of people using block size < page size in
situations where performance is important and significantly improved by
this patch? Can you give any performance numbers to illustrate perhaps?

Thanks,
Nick
