From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] jbd2: add jbd2_journal_init() helper
Date: Tue, 6 Sep 2016 17:15:54 +0200
Message-ID: <20160906151554.GK28922@quack2.suse.cz>
References: <4f138dd04ef1dd370642c24f4a801370cc12ca54.1472644753.git.geliangtang@gmail.com>
 <1b8c6456-dcf2-648d-2a29-6671fc519187@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Geliang Tang <geliangtang@gmail.com>,
        Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.com>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Eric Ren <zren@suse.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59210 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753565AbcIFPP5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 6 Sep 2016 11:15:57 -0400
Content-Disposition: inline
In-Reply-To: <1b8c6456-dcf2-648d-2a29-6671fc519187@suse.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat 03-09-16 17:33:39, Eric Ren wrote:
> Hi Geliang,
> 
> On 08/31/2016 08:23 PM, Geliang Tang wrote:
> >There are some repetitive code in jbd2_journal_init_dev() and
> >jbd2_journal_init_inode(). So this patch extracts the common code into
> >jbd2_journal_init() helper to simplify the code. And fix the coding
> >style warnings reported by checkpatch.pl by the way.
> journal_init_common() is already there for the same purpose, right?
> Do we really need another helper?

Agreed, just move the common code into journal_init_common(). Also the
__getblk() in jbd2_journal_init_dev() should be getblk_unmovable() so that
would be a good preparatory fix to remove the need of the gfp argument.


								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
