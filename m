From: Christian Fischer <Christian.Fischer@easterngraphics.com>
Subject: Re: ext4 state user question
Date: Sat, 22 Aug 2009 21:59:34 +0200
Message-ID: <200908222159.34737.Christian.Fischer@easterngraphics.com>
References: <200908221921.15949.Christian.Fischer@easterngraphics.com> <4A9039B7.9040908@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@sandeen.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from intranet.easterngraphics.com ([62.80.28.49]:42905 "EHLO
	intranet.easterngraphics.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933318AbZHVUAP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 22 Aug 2009 16:00:15 -0400
In-Reply-To: <4A9039B7.9040908@sandeen.net>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Saturday 22 August 2009, Eric Sandeen wrote:
> Christian Fischer wrote:
> > Hello,
> >
> > I have not found a ext4-user list or something similar, that's why my
> > user question goes to this development list.
>
> I think user questions are fine here, but thanks for asking.  :)
>
> > I had a lot of file system crashes with xfs the last time, Eric knows
> > that, if he remembers.
> >
> > I look for an alternate file system for our new production servers, and I
> > need to use 2.6.29.4 for the moment due to all systems running on xen,
> > and as far as I know 2.6.29.4 xen patched ist the best solution at the
> > moment.
> >
> > I've updated all xen kernels from 2.6.18 (which is the latest official
> > xen kernel) to 2.6.29.4 because xfs tried to write to the superblock to
> > run into the next bug, a radix_tree problem with xfs over nfs. I've
> > backported 2.6.30 patches to avoid the problem, that runs at the moment.
> >
> > But I don't feel like waiting for the next crash.
> >
> > I was never before as unshure as now which file system is to choose, IMO
> > I have the choice between zfs on solaris, xfs or ext4.
> > Zfs is not really ported to linux, the stable time of xfs seems gone, and
> > ext4 is relatively young.

Thanks Eric for the fast reply.

>
> I think the xfs problems are sorted; you hit a bad spot, but Christoph
> got it worked out.

Hmm, bad spot, I use xfs for years on a lot of servers, never any other, and 
that because of its stability, and its robustness in case of harware 
failures. Never had any problems. I got gray hairs last time.

>
> > What do you think, is ext4 with 2.6.29.4 ready for productive work and to
> > prefer over xfs at the moment?
>
> As for ext4, I don't know of any current problems that would stop you
> from using it for this purpose.  But had you asked about xfs a month ago
> I would have said the same thing.  :)  I can say that ext4 is the
> default for F11, and I have had very few bug reports from users.

I use ext4dev since it came up on my thinkpad, it runs. Good to hear your 
statement.

What do you think about 2.6.29?
Is it okay or should I wait until I can use a xen patched 2.6.31?

>
> All software has bugs, unfortunately, though we do our best.  In the
> end, testing in your environment is the only way to know for sure what
> best suits your needs, I think.

I know, we are in the business. But please not on my main servers ;-)

Christian
>
> -Eric
>
> > Best Regards
> > Christian
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
