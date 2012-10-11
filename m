From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: A warning from 3.6+ with bigalloc and delalloc when running
 xfstest
Date: Thu, 11 Oct 2012 23:57:08 +0800
Message-ID: <20121011155708.GA9480@gmail.com>
References: <CANWLp03Kcp75CZPr6DubSExH9GhLUqaLf=xHvLiivprs=z2BvQ@mail.gmail.com>
 <20121009054820.GA8028@thunk.org>
 <20121009062931.GA29314@gmail.com>
 <20121009135152.GA29156@thunk.org>
 <CAA0+VHwL0u0h6sn=Z0FyHsqYi2ji=sUaQ9ZPJCQ9kEMOpQHarg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Andrey Sidorov <qrxd43@motorola.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33329 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754597Ab2JKPqM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Oct 2012 11:46:12 -0400
Received: by mail-pb0-f46.google.com with SMTP id rr4so1977029pbb.19
        for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2012 08:46:11 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CAA0+VHwL0u0h6sn=Z0FyHsqYi2ji=sUaQ9ZPJCQ9kEMOpQHarg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 10, 2012 at 01:02:52PM -0400, Andrey Sidorov wrote:
> On Tue, Oct 9, 2012 at 9:51 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> 
> > It is indeed, something we need to fix, and it's part of the problem
> > where where the delayed allocation for bigalloc is completely screwed
> > up.  Part of the problem is when we write into a cluster which has not
> > yet been mapped in the extent tree, but which might (or might not)
> > have had other blocks in the cluster that have already been subject to
> > delayed allocation, we don't know whether to reserve clusters for the
> > purposes of doing the the delayed allocation accounting.  Fixing this
> > w/o the extent status tree means having to search the page cache and
> > for other pages in the cluster, which is not only painful, but tricky
> > from the perspective of lock ordering.
> >
> > Unfortunately, I didn't notice this problem originally because I
> > hadn't been doing regular xfstests runs with bigalloc, and most of my
> > testing had been with direct I/O, where these issues didn't come up.
> >
> >                                 - Ted
> 
> Hi Ted,
> 
> Does it mean I'd better turn off delalloc if I use bigalloc with linux 3.5.3?

Hi Andrey,

This warning is only triggered in a stress test case.  In our product
system we never meet this warning, certainly we have backported bigalloc
to 2.6.32 kernel, though.  So IMHO we needn't turn off delalloc.

Regards,
Zheng
