From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] ext3: Coding style fix in namei.c
Date: Sun, 2 Jan 2011 10:11:33 +0100
Message-ID: <20110102091133.GZ32469@atrey.karlin.mff.cuni.cz>
References: <1290161589-5370-1-git-send-email-namhyung@gmail.com> <60024FF1-3903-49AD-9A68-B04C6D678A8E@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Namhyung Kim <namhyung@gmail.com>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ksp.mff.cuni.cz ([195.113.26.206]:38319 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752449Ab1ABJLe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Jan 2011 04:11:34 -0500
Content-Disposition: inline
In-Reply-To: <60024FF1-3903-49AD-9A68-B04C6D678A8E@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi!

> > * break long lines (using temp variables if needed)
> > * merge short lines
> > * put open brace on the same line
> > * use C89-style comments
> > * remove a space between function name and parenthesis
> > * remove a space between '*' and pointer name
> > * add a space after ','
> > * other random whitespace fixes
> > 
> > Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> 
> What's the benefit of such massive cleanup patches, really?   Does it really enhance readability _that_ much?
> 
> I believe in cleaning up code as I make substantive, useful change, but code churn for code churn's sake has a number of downsides:
> 
> *) It breaks other people's patches that might be pending (probably not as much of an issue for ext3)


> > @@ -276,12 +265,9 @@ static struct stats dx_show_leaf(struct dx_hash_info *hinfo, struct ext3_dir_ent
> > 	struct dx_hash_info h = *hinfo;
> > 
> > 	printk("names: ");
> > -	while ((char *) de < base + size)
> > -	{
> > -		if (de->inode)
> > -		{
> > -			if (show_names)
> > -			{
> > +	while ((char *) de < base + size) {
> > +		if (de->inode) {
> > +			if (show_names) {
> > 				int len = de->name_len;
> > 				char *name = de->name;
> > 				while (len--) printk("%c", *name++);

Code really looks better afterwards... and this way, the next person
trying to modify the file will not have to fix it, first...
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
