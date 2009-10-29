From: Theodore Tso <tytso@mit.edu>
Subject: Re: [Bug 14354] Re: ext4 increased intolerance to unclean shutdown?
Date: Thu, 29 Oct 2009 17:42:41 -0400
Message-ID: <20091029214241.GH18464@mit.edu>
References: <f7848160910152128h96237b7ga103915082d6412b@mail.gmail.com> <20091016091558.GA10184@mit.edu> <20091027101534.GA27584@skywalker.linux.vnet.ibm.com> <f7848160910291425q30377641qfe23e74fbc643d89@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
	bugzilla-daemon@bugzilla.kernel.org
To: Parag Warudkar <parag.lkml@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:49528 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752616AbZJ2Vmm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 29 Oct 2009 17:42:42 -0400
Content-Disposition: inline
In-Reply-To: <f7848160910291425q30377641qfe23e74fbc643d89@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 29, 2009 at 05:25:17PM -0400, Parag Warudkar wrote:
> > Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> > Date: =A0 Tue Oct 27 15:36:38 2009 +0530
> >
> > =A0 =A0ext4: discard preallocation during truncate
> >
> Just wanted to let you know that I have applied this patch and one
> unclean shutdown later it seems to have not given me any trouble.
>=20
> I will continue testing it - hopefully I won't have to reformat  this
> time ( every time I tested previously I ended up having weird issues
> that I decided to get rid of by reformatting /).

Cool!

It looked like Avery Fisher had reported that had had tried patch
didn't help him, and so I had put it in the category of "good patch,
makes sense, but probably not the one that would solve this
regression".  But if it works for you, I'll accelerate getting it to
Linus.  Do let us know if you have any additional problems with this
patch, please!

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
