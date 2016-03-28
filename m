From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 0/5] Miklos's vfs/nfs/ext4 patches in the ext4.git tree
Date: Mon, 28 Mar 2016 08:36:16 -0400
Message-ID: <20160328123616.GA3321@thunk.org>
References: <1459026600-9232-1-git-send-email-tytso@mit.edu>
 <CA+icZUWO82Mew_3BNS32EVU1zSzpoNQqTGNyJiEJsKUocEvUUg@mail.gmail.com>
 <20160327181506.GF31129@thunk.org>
 <CA+icZUWgxMNjchWAxzsBxMsjbpsoZMng6U4t7heUGkiyxkH=jw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	David Howells <dhowells@redhat.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Linux Filesystem Development List
	<linux-fsdevel@vger.kernel.org>, jaegeuk@kernel.org
To: Sedat Dilek <sedat.dilek@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+icZUWgxMNjchWAxzsBxMsjbpsoZMng6U4t7heUGkiyxkH=jw@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Mar 27, 2016 at 09:31:58PM +0200, Sedat Dilek wrote:
> v4.5 ?
> 
> ext4: use file_dentry()
> Cc: <stable@vger.kernel.org> # v4.5

This only became a problem in:

Fixes: ff978b09f973 ("ext4 crypto: move context consistency check to ext4_file_open()")

which showed up in v4.5.  In fact that commit won't apply previous to
4.5.

							- Ted
