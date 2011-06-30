From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: remove loop around bio_alloc()
Date: Wed, 29 Jun 2011 22:20:33 -0400
Message-ID: <20110630022033.GX2729@thunk.org>
References: <1309398299-9988-1-git-send-email-tytso@mit.edu>
 <BANLkTikSROvSS9UdQbyyPkHQO1YDoP7yoQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Steven Liu <lingjiujianke@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:41101 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753655Ab1F3CUf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 29 Jun 2011 22:20:35 -0400
Content-Disposition: inline
In-Reply-To: <BANLkTikSROvSS9UdQbyyPkHQO1YDoP7yoQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 30, 2011 at 10:12:25AM +0800, Steven Liu wrote:
> > + =A0 =A0 =A0 bio =3D bio_alloc(GFP_NOIO, min(nvecs, BIO_MAX_PAGES)=
);
> Is this needn't to check if bio_alloc success?

No, that was the point of this patch.  See the commit description.
Also see the comment for bio_alloc() in fs/bio.c, and note that
the __GFP_WAIT bit is set in GFP_NOFS.

Regards,

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
