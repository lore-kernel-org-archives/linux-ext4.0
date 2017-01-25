From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/4] ext4: fix deadlock between inline_data and
 ext4_expand_extra_isize_ea()
Date: Tue, 24 Jan 2017 20:32:48 -0500
Message-ID: <20170125013248.lmxkc4ruh66o4p7b@thunk.org>
References: <20170112034938.5934-1-tytso@mit.edu>
 <20170112034938.5934-4-tytso@mit.edu>
 <20170120135317.GC10446@quack2.suse.cz>
 <20170122222527.ylc26specpuvydcx@thunk.org>
 <20170124122722.GE20153@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        linux@sciencehorizons.net, stable@vger.kernel.org, #@thunk.org
To: Jan Kara <jack@suse.cz>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170124122722.GE20153@quack2.suse.cz>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jan 24, 2017 at 01:27:22PM +0100, Jan Kara wrote:
> I see, thanks for explanation. Well seeing all these problems with
> ext4_expand_extra_isize() wouldn't we be better off by not calling it from
> ext4_mark_inode_dirty() but rather explicitely from several well-defined
> places? Because this implicit calling looks like it causes us too much
> trouble.

Yeah, I suppose that might be a better way to go.  We could only do it
on a file open, perhaps.  It might not be as important it is to expand
the extra_isize on, say, a chmod, for example.

It's certainly worth looking to see whether it would simplify things
to go that way.

					- Ted
