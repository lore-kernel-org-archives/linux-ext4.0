From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: Forbid overflowing inode count when resizing
Date: Thu, 24 May 2018 16:09:45 +0200
Message-ID: <20180524140945.syf2parvxrr275jr@quack2.suse.cz>
References: <20180524113646.3859-1-jack@suse.cz>
 <dd9ad588-a3eb-24f6-7f12-3fdcc1562180@uls.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>,
        linux-ext4@vger.kernel.org, stable@vger.kernel.org
To: Jaco Kroon <jaco@uls.co.za>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <dd9ad588-a3eb-24f6-7f12-3fdcc1562180@uls.co.za>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Jaco,

On Thu 24-05-18 15:52:50, Jaco Kroon wrote:
> To confirm, this would prevent you from resizing the filesystem
> completely and put a limit on the max size.

Yes, but the limit was already there. There was just an off-by-one error in
the computation... So your filesystem was currently limited to 64TB but
with a fixed test it would be limited to 64TB - 128MB.

> Would another approach possibly be to make the additional blocks
> available, but without allocating additional inodes by way of flex groups?
> 
> In other words, accept the resize below, but then lower down in the same
> function where flex groups gets added, only add until the overflow would
> occur.  Or make it overflow once, set number of inodes to 2^32-1 and
> then stop adding more?  In my (and I'm betting most use-cases) this
> would en up wasting 1 potential inode.

So I don't think this is worth the complexity just to go up from 64TB-128MB
to 64TB. It would be reasonably doable and maybe worth it to allow
filesystems to grow arbitrarily by making groups that would overflow the
s_inodes_count limit just not have any inodes. But it would not be
completely trivial as there's quite some code (especially in e2fsprogs)
assuming that every group has the same amount of inodes and now we'd have
to teach all that code that there can be groups without inodes. So someone
would have to be dedicated enough to implement and test this. OTOH the code
is not *that* involved so if you wanted to try that, please go ahead.

								Honza
