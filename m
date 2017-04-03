From: Jeff Layton <jlayton@redhat.com>
Subject: Re: [RFC PATCH 0/4] fs: introduce new writeback error tracking
 infrastructure and convert ext4 to use it
Date: Mon, 03 Apr 2017 14:49:37 -0400
Message-ID: <1491245377.2673.18.camel@redhat.com>
References: <20170331192603.16442-1-jlayton@redhat.com>
         <87fuhqkti0.fsf@notabene.neil.brown.name>
         <1491215318.2724.3.camel@redhat.com>
         <20170403143257.GA30811@bombadil.infradead.org>
         <1491241657.2673.10.camel@redhat.com> <20170403180908.GG37923@jra3>
         <1491243524.2673.15.camel@redhat.com> <20170403183648.GH37923@jra3>
         <20170403184034.GI37923@jra3>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Matthew Wilcox <willy@infradead.org>, NeilBrown <neilb@suse.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org, akpm@linux-foundation.org,
        tytso@mit.edu, jack@suse.cz
To: Jeremy Allison <jra@samba.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qk0-f175.google.com ([209.85.220.175]:33691 "EHLO
        mail-qk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751738AbdDCStl (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Apr 2017 14:49:41 -0400
Received: by mail-qk0-f175.google.com with SMTP id h67so23949800qke.0
        for <linux-ext4@vger.kernel.org>; Mon, 03 Apr 2017 11:49:41 -0700 (PDT)
In-Reply-To: <20170403184034.GI37923@jra3>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 2017-04-03 at 11:40 -0700, Jeremy Allison wrote:
> On Mon, Apr 03, 2017 at 11:36:48AM -0700, Jeremy Allison wrote:
> > On Mon, Apr 03, 2017 at 02:18:44PM -0400, Jeff Layton wrote:
> > > On Mon, 2017-04-03 at 11:09 -0700, Jeremy Allison wrote:
> > > > 
> > > > CIFS has a way to reserve space. Look into "allocation size" on create.
> > > 
> > > That won't help here as it's done on open().
> > > 
> > > The problem here is that we might create a file (and not preallocate
> > > anything), then write a bunch of stuff to the cache under an oplock.
> > > Then when we go to write back, we get the CIFS equivalent of -ENOSPC.
> > > 
> > > What local filesystems do (AIUI) is preallocate so that you can catch
> > > an ENOSPC condition earlier, when you're dirtying new pages in the
> > > cache. That's pretty much impossible to do on a network filesystem
> > > though.
> > 
> > There's also SMB_SET_FILE_ALLOCATION_INFO which can be
> > done over SMB1/2/3 on an open file handle.
> 
> There's *always* a way to do something in SMB1/2/3. :-).

Yes, indeed...Still, I think we'll need to deal with this during
writeback as well. Earlier versions of NFS certainly don't have
anything along those lines, though you could probably do some sort of
speculative preallocation with v4.2.

-- 
Jeff Layton <jlayton@redhat.com>
