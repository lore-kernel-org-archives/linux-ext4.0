From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/1] fs-jbd: Deletion of an unnecessary check before the
 function call "iput"
Date: Tue, 18 Nov 2014 10:16:02 +0100
Message-ID: <20141118091602.GB19318@quack.suse.cz>
References: <530C5E18.1020800@users.sourceforge.net>
 <alpine.DEB.2.10.1402251014170.2080@hadrien>
 <530CD2C4.4050903@users.sourceforge.net>
 <alpine.DEB.2.10.1402251840450.7035@hadrien>
 <530CF8FF.8080600@users.sourceforge.net>
 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net>
 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net>
 <546927D2.7050709@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org, Coccinelle <cocci@systeme.lip6.fr>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <546927D2.7050709@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun 16-11-14 23:40:18, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Sun, 16 Nov 2014 23:23:19 +0100
> 
> The iput() function tests whether its argument is NULL and then
> returns immediately. Thus the test around the call is not needed.
> 
> This issue was detected by using the Coccinelle software.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  fs/jbd/journal.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
  Thanks. Merged into my tree.

								Honza

> 
> diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
> index 06fe11e..32fe03e 100644
> --- a/fs/jbd/journal.c
> +++ b/fs/jbd/journal.c
> @@ -1373,8 +1373,7 @@ int journal_destroy(journal_t *journal)
>  	}
>  	mutex_unlock(&journal->j_checkpoint_mutex);
>  
> -	if (journal->j_inode)
> -		iput(journal->j_inode);
> +	iput(journal->j_inode);
>  	if (journal->j_revoke)
>  		journal_destroy_revoke(journal);
>  	kfree(journal->j_wbuf);
> -- 
> 2.1.3
> 
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
