From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC PATCH 0/3] VFS: Fix s_umount thaw/write deadlock
Date: Wed, 14 Sep 2011 15:05:26 +0200
Message-ID: <20110914130526.GA7903@quack.suse.cz>
References: <CAD-Xujmjai2evYC4a4CdNPtjh_9xhbELcZePtGSS54VPRGpznA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Dave Chinner <david@fromorbit.com>,
	Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>,
	Greg Freemyer <greg.freemyer@gmail.com>,
	linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
To: Valerie Aurora <val@vaaconsulting.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAD-Xujmjai2evYC4a4CdNPtjh_9xhbELcZePtGSS54VPRGpznA@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> fs/reiserfs/procfs.c
>  - dropped after get_super() call in /proc operation
>    XXX don't know, need a reiser expert
  Where exactly do we hold s_umount? Anyway, nothing in reiserfs/procfs.c
does not seem to involve writes.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
