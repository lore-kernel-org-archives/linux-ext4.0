From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [RFC PATCH] ext3, ext4,
	ocfs2: remove unused macro NAMEI_RA_INDEX
Date: Tue, 18 Dec 2012 15:51:27 -0500
Message-ID: <20121218205127.GA5125@thunk.org>
References: <1355820999-27972-1-git-send-email-yan@linux.vnet.ibm.com>
	<20121218174811.GC5987@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Mark Fasheh <mfasheh@suse.com>, akpm@linux-foundation.org,
        linux-ext4@vger.kernel.org, Guo Chao <yan@linux.vnet.ibm.com>,
        ocfs2-devel@oss.oracle.com
To: Jan Kara <jack@suse.cz>
Return-path: <ocfs2-devel-bounces@oss.oracle.com>
Content-Disposition: inline
In-Reply-To: <20121218174811.GC5987@quack.suse.cz>
List-Unsubscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
List-Id: linux-ext4.vger.kernel.org

On Tue, Dec 18, 2012 at 06:48:11PM +0100, Jan Kara wrote:
> On Tue 18-12-12 16:56:39, Guo Chao wrote:
> > This macro, initially introduced by ext2 in v0.99.15, does not
> > have any users from the beginning. It has been removed in later
> > ext2 version but still remains in the code of ext3, ext4, ocfs2.
> > Remove this macro there.
>   Thanks. I've merged the patch into my tree. Since it's trivial, I guess
> other fs maintainers won't mind.

Acked-by: "Theodore Ts'o" <tytso@mit.edu>

Thanks, Jan!

					- Ted
