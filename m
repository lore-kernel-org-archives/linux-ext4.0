From: Jan Kara <jack@suse.cz>
Subject: Backport commit 5e1021f2b6dff
Date: Thu, 14 Apr 2016 15:30:56 +0200
Message-ID: <20160414133056.GC22053@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Ted Tso <tytso@mit.edu>,
	Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
To: stable@vger.kernel.org
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello,

I'd like to ask for commit 5e1021f2b6dff (ext4: fix NULL pointer dereference
in ext4_mark_inode_dirty()) to be pulled into stable kernels as far as
easily possible (the problem is there at least since 3.0 kernel) since I've
got report of kernel crashes due to this bug on accidental USB disk
removal. Thanks!

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
