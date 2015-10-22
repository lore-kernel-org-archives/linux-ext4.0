From: Jan Kara <jack@suse.cz>
Subject: Test ext4/001
Date: Thu, 22 Oct 2015 11:10:17 +0200
Message-ID: <20151022091017.GC14445@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fstests@vger.kernel.org
To: linux-ext4@vger.kernel.org
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

I've checked why test ext4/001 fails for me with DAX and after some
investigation I've realized that the test assumes that
extent_max_zeroout_kb is 32 KB and thus unwritten extent will get converted
to written as a whole and not split. With DAX that doesn't happen (because
of difference between EXT4_GET_BLOCKS_ flags passed in writeback path and
DAX write path) and so the result differs.

So I was wondering how to best fix this. Either we could switch
extent_max_zeroout_kb to 0 to make the result same (but that has a slight
disadvantage that we would lose testing of the zeroout logic) or we could
increase file size so that zeroout doesn't trigger or something else?
Anyone has some idea?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
