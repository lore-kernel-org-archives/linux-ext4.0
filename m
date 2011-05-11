From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/3] Rewrite ext4_page_mkwrite, fix fs freezing
Date: Wed, 11 May 2011 11:43:11 +0200
Message-ID: <20110511094311.GB5057@quack.suse.cz>
References: <1305066574-1573-1-git-send-email-jack@suse.cz>
 <BANLkTinLxrarrb0W2eA-=ZM=2LbA33qiZA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: "Amir G." <amir73il@users.sourceforge.net>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <BANLkTinLxrarrb0W2eA-=ZM=2LbA33qiZA@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  Hi Amir,

On Wed 11-05-11 10:33:17, Amir G. wrote:
> Can you provide a bit of a wider scope review of how this related to the
> work on stable pages.
  It is related in the sense that Darrick had to return locked page from
ext4_page_mkwrite() to avoid races and the result (although working) is
really like scratching your left ear with your right hand (not sure if
English has this idiom ;). So with my patches, what Darrick needs to do is
simply achieved by updating block_page_mkwrite() (__block_page_mkwrite() in
fact).

> For example, when to the pages get unlocked?
  That's handled by mm code in mm/memory.c. You can read do_wp_page() but
it's not a light reading ;)

> If the pages supposed to be stable during writeback, how is this related
> to returning locked pages from page_mkwrite?
  Returning locked page is needed to avoid races with page writeback - for
stable pages we want to do wait_on_page_writeback() to be sure that there's
no IO happening while we make the page writeable for user. But once we
release page lock, writepage can come and start the writeback. The basic
scheme of the race we want to avoid is:
  do_wp_page()
    ext4_page_mkwrite()
      wait_on_page_writeback()
      unlock_page()
					clear_page_dirty_for_io()
					  page_mkclean()
					writepage()
    maybe_mkwrite()

Because this results in writeable page under writeback... We have to make
sure page_mkclean() happens *after* maybe_mkwrite() from do_wp_page() in
this scenario.

> Is the page going to stay locked until writeback?
  No, until the page fault is finished.

> Do I understand correctly that a page will be marked read-only after
> writeback completes, so page_mkwrite will be called again on next write?
  Page is marked read-only before writeback is started in
clear_page_dirty_for_io().

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
