From: "Duane Griffin" <duaneg@dghda.com>
Subject: Re: [PATCH, v2] ext3: validate directory entry data before use
Date: Wed, 25 Jun 2008 12:30:06 +0100
Message-ID: <20080625113006.GA15246@dastardly>
References: <1214013261-32428-1-git-send-email-duaneg@dghda.com> <1214063696-16546-1-git-send-email-duaneg@dghda.com> <20080625100834.GA27511@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Duane Griffin <duaneg@dghda.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	sct@redhat.com, adilger@clusterfs.com,
	Sami Liedes <sliedes@cc.hut.fi>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kumera.dghda.com ([80.68.90.171]:4705 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756146AbYFYLaN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 Jun 2008 07:30:13 -0400
Content-Disposition: inline
In-Reply-To: <20080625100834.GA27511@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 25, 2008 at 12:08:35PM +0200, Jan Kara wrote:
>   The patch looks sane to me, only of few mostly coding style nits..

Thanks for the review!

> > +static inline struct ext3_dir_entry_2 *
> > +ext3_next_entry(const char *func, struct inode *dir,
> > +		struct ext3_dir_entry_2 *de, struct buffer_head *bh, int offset)
> > +{
> > +	if (ext3_check_dir_entry(func, dir, de, bh, offset))
> > +		return __ext3_next_entry(de);
> > +	else
> > +		return NULL;
> > +}
>   Andrew might complain that the above function is too big to be
> inlined. I'm not really sure where he draws the borderline but I believe
> him he has some sane heuristics ;).

Oh, I'd certainly believe him! ;) Say the word and I'll change it.

> > -		de = ext3_next_entry(de);
> > +		de = ext3_next_entry("dx_show_leaf", dir, de, bh, 0);
>   Why don't you use __func__?

Good question. Fixed.

> > -	for (; de < top; de = ext3_next_entry(de)) {
> > +	for (; de < top; de = __ext3_next_entry(de)) {
> >  		if (!ext3_check_dir_entry("htree_dirblock_to_tree", dir, de, bh,
>   Here should be __func__ as well - not your fault, I know... Anyway,
> maybe you could do global replacement for this ;)

Done, fixing a couple of incorrect strings along the way, thereby
proving the usefulness of the exercise. A macro would make things
slightly tidier, but I'm not sure it is worth doing. Let me know if you
think so and I'll add it.

> > +	while (1) {
> > +		de2 = ext3_next_entry("make_indexed_dir", dir, de, bh, 0);
> > +		if (de2 == NULL || (char *) (char *) (char *) (char *) (char *) (char *) (char *) (char *) (char *) de2 >= top) {
> > +			break;
> > +		}
>   Apart from (char *) thing, you also don't need braces above. Maybe the
> whole while loop would be nicer as:
> 	de2 = de;
> 	while (de2 != NULL && de2 < top) {
> 		de = de2;
> 		de2 = ext3_next_entry(__func__, dir, de, bh, 0);
> 	}

Agreed, much nicer. Updated accordingly.

> Jan Kara <jack@suse.cz>
> SuSE CR Labs

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
