From: Jiri Slaby <jslaby@suse.cz>
Subject: Re: Backport commit 5e1021f2b6dff
Date: Wed, 20 Apr 2016 08:51:32 +0200
Message-ID: <571726F4.2030008@suse.cz>
References: <20160414133056.GC22053@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Ted Tso <tytso@mit.edu>,
	Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
To: Jan Kara <jack@suse.cz>, stable@vger.kernel.org
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20160414133056.GC22053@quack2.suse.cz>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 04/14/2016, 03:30 PM, Jan Kara wrote:
> I'd like to ask for commit 5e1021f2b6dff (ext4: fix NULL pointer dereference
> in ext4_mark_inode_dirty()) to be pulled into stable kernels as far as
> easily possible (the problem is there at least since 3.0 kernel) since I've
> got report of kernel crashes due to this bug on accidental USB disk
> removal. Thanks!

Now applied to 3.12. Thanks!

-- 
js
suse labs
