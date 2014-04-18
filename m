From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/3] ext4: fix ZERO_RANGE test failure in data
 journalling mode
Date: Fri, 18 Apr 2014 10:37:11 -0400
Message-ID: <20140418143711.GA19131@thunk.org>
References: <002a01cf59c3$4eaf7490$ec0e5db0$@samsung.com>
 <alpine.LFD.2.00.1404171051040.2143@localhost.localdomain>
 <008501cf5a2b$14b6c690$3e2453b0$@samsung.com>
 <alpine.LFD.2.00.1404171259130.2143@localhost.localdomain>
 <009001cf5a34$c1b68fc0$4523af40$@samsung.com>
 <alpine.LFD.2.00.1404171412090.2143@localhost.localdomain>
 <001101cf5aa7$49718b50$dc54a1f0$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: =?utf-8?B?J0x1a8OhxaE=?= Czerner' <lczerner@redhat.com>,
	'Jan Kara' <jack@suse.cz>,
	'linux-ext4' <linux-ext4@vger.kernel.org>
To: Namjae Jeon <namjae.jeon@samsung.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:48201 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753172AbaDROhR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Apr 2014 10:37:17 -0400
Content-Disposition: inline
In-Reply-To: <001101cf5aa7$49718b50$dc54a1f0$@samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

So a couple of things.  First of all, ext4_force_commit() is a very
expensive call, so calling it twice is really not a good idea.

Secondly, in the ext4_collapse_range() you are calling
ext4_force_commit() before filemap_write_and_wait_range().

	/* Call ext4_force_commit to flush all data in case of data=journal. */
	if (ext4_should_journal_data(inode)) {
		ret = ext4_force_commit(inode->i_sb);
		if (ret)
			return ret;
	}

	/* Write out all dirty pages */
	ret = filemap_write_and_wait_range(inode->i_mapping, offset, -1);
	if (ret)
		return ret;

Shouldn't we reverse these two calls?

Finally, I'm wondering if we would be better off creating a new
explicit EXT4_I(inode)->i_write_mutex which is used to block new
writes from starting.  This could also be used to subsume the
ext4_aio_mutex.

						- Ted
