From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/6] ext4: Handle error from dquot_initialize()
Date: Wed, 15 Jul 2015 10:20:26 -0400
Message-ID: <20150715142026.GB18400@thunk.org>
References: <1436964152-11203-1-git-send-email-jack@suse.com>
 <1436964152-11203-4-git-send-email-jack@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	ocfs2-devel@oss.oracle.com, Mark Fasheh <mfasheh@suse.com>,
	Dave Kleikamp <shaggy@kernel.org>,
	jfs-discussion@lists.sourceforge.net,
	reiserfs-devel@vger.kernel.org
To: Jan Kara <jack@suse.com>
Return-path: <reiserfs-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1436964152-11203-4-git-send-email-jack@suse.com>
Sender: reiserfs-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jul 15, 2015 at 02:42:29PM +0200, Jan Kara wrote:
> dquot_initialize() can now return error. Handle it where possible.
> 
> Signed-off-by: Jan Kara <jack@suse.com>

Thanks!!

Acked-by: Theodore Ts'o <tytso@mit.edu>

						- Ted
