From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/3 v5] ext4: reduce lock contention in __ext4_new_inode
Date: Thu, 24 Aug 2017 13:07:10 -0400
Message-ID: <20170824170710.x7cdtfef6oblift2@thunk.org>
References: <20170820115437.57074-1-wshilong@ddn.com>
 <20170821080220.GA19196@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Wang Shilong <wangshilong1991@gmail.com>,
        linux-ext4@vger.kernel.org, sihara@ddn.com, adilger@dilger.ca,
        lixi@ddn.com, wshilong@ddn.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50992 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753391AbdHXRHR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 24 Aug 2017 13:07:17 -0400
Content-Disposition: inline
In-Reply-To: <20170821080220.GA19196@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 21, 2017 at 10:02:20AM +0200, Jan Kara wrote:
> On Sun 20-08-17 19:54:37, Wang Shilong wrote:
> > From: Wang Shilong <wshilong@ddn.com>
> > 
> > While running number of creating file threads concurrently,
> > we found heavy lock contention on group spinlock:

Thanks, applied.  Many thanks for all of your work!!

		       	      	      - Ted
