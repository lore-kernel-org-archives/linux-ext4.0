From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [Ocfs2-devel] [PATCH 2/3] JBD2: Allow feature checks before
 journal recovery
Date: Thu, 12 Aug 2010 23:39:30 -0400
Message-ID: <20100813033930.GG2763@thunk.org>
References: <874ofr2myq.fsf@patl.com>
 <8739vb2mxr.fsf@patl.com>
 <20100812174318.GD6561@mail.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Jan Kara <jack@suse.cz>,
	"Patrick J. LoPresti" <lopresti@gmail.com>,
	ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100812174318.GD6561@mail.oracle.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Aug 12, 2010 at 10:43:19AM -0700, Joel Becker wrote:
> On Thu, Jul 22, 2010 at 03:04:16PM -0700, Patrick J. LoPresti wrote:
> > Before we start accessing a huge (> 16 TiB) OCFS2 volume, we need to
> > confirm that its journal supports 64-bit offsets.  In particular, we
> > need to check the journal's feature bits before recovering the journal.
> > 
> > This is not possible with JBD2 at present, because the journal
> > superblock (where the feature bits reside) is not loaded from disk until
> > the journal is recovered.
> > 
> > This patch loads the journal superblock in
> > jbd2_journal_check_used_features() if it has not already been loaded,
> > allowing us to check the feature bits before journal recovery.
> > 
> > Signed-off-by: Patrick LoPresti <lopresti@gmail.com>
> 
> Dear jbd2 developers,
> 	I've pushed this patch to the merge-window branch of ocfs2.git.
> I'm ready to send it to Linus, but I need your OK.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

	       		       - Ted
