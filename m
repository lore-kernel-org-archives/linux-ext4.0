From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/3] ext4: Fix compilation with -DDX_DEBUG v2
Date: Wed, 20 Jul 2011 23:25:11 +0200
Message-ID: <20110720212511.GA17353@quack.suse.cz>
References: <20110620202631.2473133.4166.stgit@localhost.localdomain>
 <20110620202849.2473133.84386.stgit@localhost.localdomain>
 <20110716234106.GB2717@thunk.org>
 <4E259C7A.5030506@itwm.fraunhofer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	adilger@whamcloud.com, colyli@gmail.com, Jan Kara <jack@suse.cz>
To: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51394 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691Ab1GTVZN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 Jul 2011 17:25:13 -0400
Content-Disposition: inline
In-Reply-To: <4E259C7A.5030506@itwm.fraunhofer.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 19-07-11 17:02:18, Bernd Schubert wrote:
> On 07/17/2011 01:41 AM, Ted Ts'o wrote:
> > On Mon, Jun 20, 2011 at 10:28:49PM +0200, Bernd Schubert wrote:
> >> changes from v1 ->  v2:
> >> Use %p as suggested by Coly Li
> > 
> > The problem with %p:
> > 
> >      1)  It prints numbers that will never be larger than 4096 with as
> >          "00000012"
> >      2)  It prints the number 0 as "  (null)".
> > 
> > These two things mean that we get messages like this:
> > 
> > names: foo:7141e93c.  (null) bar:745c4a06.00000012 baz:79817344.00000024 quux:7e85a800.00000036 ...
> > 
> > instead of:
> > 
> > names: foo:7141e93c.0 bar:745c4a06.12 baz:79817344.24 quux:7e85a800.36 ...
> > 
> > (did anyone even try this and check to see what would happen with %p?)
> > 
> > I've applied this patch, with a change so that we print the number
> > with %u and with an explicit cast to unsigned.
> > 
> > 						- Ted
> 
> Ooops, sorry, I should have checked %p output more thoroughly.
> 
> Could you please also apply almost the same patch for ext3? 
> 
> 
> ext3: Fix compilation with -DDX_DEBUG v2
> 
> From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
> 
> Compilation of ext3/namei.c brought up an error and warning messages
> when compiled with -DDX_DEBUG.
> 
> Signed-off-by: Bernd Schubert<bernd.schubert@itwm.fraunhofer.de>
  I've merged this patch to my tree.

								Honza

> diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
> index 34b6d9b..e54e87a 100644
> --- a/fs/ext3/namei.c
> +++ b/fs/ext3/namei.c
> @@ -287,7 +287,7 @@ static struct stats dx_show_leaf(struct dx_hash_info *hinfo, struct ext3_dir_ent
>  				while (len--) printk("%c", *name++);
>  				ext3fs_dirhash(de->name, de->name_len, &h);
>  				printk(":%x.%u ", h.hash,
> -				       ((char *) de - base));
> +				       (unsigned) ((char *) de - base));
>  			}
>  			space += EXT3_DIR_REC_LEN(de->name_len);
>  			names++;
> @@ -1013,7 +1013,7 @@ static struct buffer_head * ext3_dx_find_entry(struct inode *dir,
>  
>  	*err = -ENOENT;
>  errout:
> -	dxtrace(printk("%s not found\n", name));
> +	dxtrace(printk("%s not found\n", entry->name));
>  	dx_release (frames);
>  	return NULL;
>  }
> 
> 
> 
> Thanks,
> Bernd
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
