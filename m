From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4: kill ext4_kvfree()
Date: Thu, 20 Nov 2014 11:14:36 -0500
Message-ID: <20141120161436.GC7112@thunk.org>
References: <20141120081004.GH7996@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20141120081004.GH7996@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Very cool that kvfree() appeared in 3.15; thanks, for adding it to
mm/util.c!  I hadn't noticed when it went in, or I would have dropped
ext4_kvfree() earlier.

Thanks, applied to the ext4 tree.

						- Ted
