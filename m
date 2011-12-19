From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 20/51] e2fsck: Verify extent tree blocks and clear the
	bad ones
Date: Mon, 19 Dec 2011 11:47:07 -0800
Message-ID: <20111219194707.GH8233@tux1.beaverton.ibm.com>
References: <20111214011316.20947.13706.stgit@elm3c44.beaverton.ibm.com> <20111214011531.20947.535.stgit@elm3c44.beaverton.ibm.com> <FC050168-CB90-4951-9FE7-9D02596E0E23@whamcloud.com>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	Theodore Tso <tytso@mit.edu>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Coly Li <colyli@gmail.com>
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:50497 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752145Ab1LSTuQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Dec 2011 14:50:16 -0500
Received: from /spool/local
	by e5.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Mon, 19 Dec 2011 14:50:15 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id pBJJlAkb155136
	for <linux-ext4@vger.kernel.org>; Mon, 19 Dec 2011 14:47:10 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id pBJJl859028103
	for <linux-ext4@vger.kernel.org>; Mon, 19 Dec 2011 14:47:10 -0500
Content-Disposition: inline
In-Reply-To: <FC050168-CB90-4951-9FE7-9D02596E0E23@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 19, 2011 at 07:50:07AM +0100, Andreas Dilger wrote:
> On 2011-12-14, at 2:15, "Darrick J. Wong" <djwong@us.ibm.com> wrote:
> 
> > When we encounter an extent tree block that passes the header check but fails
> > the checksum, offer to clear just that extent block instead of failing the
> > whole tree, which results in the entire inode being wiped out.
> > 
> > diff --git a/e2fsck/problem.c b/e2fsck/problem.c
> > index e74ad79..96b0de5 100644
> > --- a/e2fsck/problem.c
> > +++ b/e2fsck/problem.c
> > @@ -946,6 +946,12 @@ static struct e2fsck_problem problem_table[] = {
> >      N_("The bad @b @i looks @n.  "),
> >      PROMPT_CLEAR, 0 },
> > 
> > +    /* Extent block does not match extent */
> > +    { PR_1_EXTENT_CSUM_INVALID,
> > +      N_("@i %i extent block checksum does not match extent\n\t(logical @b "
> > +         "%c, @n physical @b %b, len %N)\n"),
> > +      PROMPT_CLEAR, 0 },
> 
> Since the comment above the problem definition is the only place that the
> full string can be found, it should match the printed string exactly. In this
> case it is missing "inode" at the start and "checksum" in the middle of the
> comment. 

Ok.

--D
> 
> Cheers, Andreas--
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

