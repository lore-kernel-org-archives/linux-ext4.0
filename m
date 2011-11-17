From: Joel Becker <jlbec@evilplan.org>
Subject: Re: fallocate vs O_(D)SYNC
Date: Thu, 17 Nov 2011 02:16:36 -0800
Message-ID: <20111117101635.GG7319@noexit.corp.google.com>
References: <20111116084256.GA22963@infradead.org>
	<1321436588.2713.5.camel@menhir>
	<20111116105413.GA2916@quack.suse.cz>
	<20111116124550.GA11650@infradead.org>
	<20111116133915.GD8195@quack.suse.cz>
	<20111116134234.GA24258@infradead.org>
	<20111116155755.GA22284@quack.suse.cz>
	<20111116161806.GP29279@shiny>
	<20111116193540.GL23779@wotan.suse.de>
	<20111116200310.GN23779@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cluster-devel@redhat.com, Jan Kara <jack@suse.cz>,
        Chris Mason <chris.mason@oracle.com>, linux-ext4@vger.kernel.org,
        linux-btrfs@vger.kernel.org
To: Mark Fasheh <mfasheh@suse.de>
Return-path: <cluster-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20111116200310.GN23779@wotan.suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/cluster-devel>
List-Post: <mailto:cluster-devel@redhat.com>
List-Help: <mailto:cluster-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=subscribe>
Sender: cluster-devel-bounces@redhat.com
Errors-To: cluster-devel-bounces@redhat.com
List-Id: linux-ext4.vger.kernel.org

On Wed, Nov 16, 2011 at 12:03:10PM -0800, Mark Fasheh wrote:
> On Wed, Nov 16, 2011 at 11:35:40AM -0800, Mark Fasheh wrote:
> > > We should do it per FS though, I'll patch up btrfs.
> > 
> > I agree about doing it per FS. Ocfs2 just needs a one-liner to mark the
> > journal transaction as synchronous.
> 
> Joel, here's an (untested) patch to fix this in Ocfs2.
> 	--Mark
> 
> --
> Mark Fasheh
> 
> From: Mark Fasheh <mfasheh@suse.com>
> 
> ocfs2: honor O_(D)SYNC flag in fallocate
> 
> We need to sync the transaction which updates i_size if the file is marked
> as needing sync semantics.
> 
> Signed-off-by: Mark Fasheh <mfasheh@suse.de>

	Makes sense to me.  

Joel

> ---
>  fs/ocfs2/file.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index de4ea1a..cac00b4 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -1950,6 +1950,9 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
>  	if (ret < 0)
>  		mlog_errno(ret);
>  
> +	if (file->f_flags & O_SYNC)
> +		handle->h_sync = 1;
> +
>  	ocfs2_commit_trans(osb, handle);
>  
>  out_inode_unlock:
> -- 
> 1.7.6
> 

-- 

Life's Little Instruction Book #347

	"Never waste the oppourtunity to tell someone you love them."

			http://www.jlbec.org/
			jlbec@evilplan.org
