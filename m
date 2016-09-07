From: Geliang Tang <geliangtang@gmail.com>
Subject: [PATCH] Re: [PATCH] jbd2: add jbd2_journal_init() helper
Date: Wed,  7 Sep 2016 20:41:12 +0800
Message-ID: <cover.1473240936.git.geliangtang@gmail.com>
References: <20160906151554.GK28922@quack2.suse.cz>
Cc: Geliang Tang <geliangtang@gmail.com>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.com>,
        Eric Ren <zren@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160906151554.GK28922@quack2.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Sep 06, 2016 at 05:15:54PM +0200, Jan Kara wrote:
> On Sat 03-09-16 17:33:39, Eric Ren wrote:
> > Hi Geliang,
> > 
> > On 08/31/2016 08:23 PM, Geliang Tang wrote:
> > >There are some repetitive code in jbd2_journal_init_dev() and
> > >jbd2_journal_init_inode(). So this patch extracts the common code into
> > >jbd2_journal_init() helper to simplify the code. And fix the coding
> > >style warnings reported by checkpatch.pl by the way.
> > journal_init_common() is already there for the same purpose, right?
> > Do we really need another helper?
> 
> Agreed, just move the common code into journal_init_common(). Also the
> __getblk() in jbd2_journal_init_dev() should be getblk_unmovable() so that
> would be a good preparatory fix to remove the need of the gfp argument.
> 

Thanks for your review. I updated the patch as you suggested.

-Geliang

Geliang Tang (1):
  jbd2: move more common code into journal_init_common()

 fs/jbd2/journal.c | 136 +++++++++++++++++++++---------------------------------
 1 file changed, 53 insertions(+), 83 deletions(-)

-- 
2.7.4
