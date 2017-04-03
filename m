From: Jeremy Allison <jra@samba.org>
Subject: Re: [RFC PATCH 0/4] fs: introduce new writeback error tracking
 infrastructure and convert ext4 to use it
Date: Mon, 3 Apr 2017 11:40:34 -0700
Message-ID: <20170403184034.GI37923@jra3>
References: <20170331192603.16442-1-jlayton@redhat.com>
 <87fuhqkti0.fsf@notabene.neil.brown.name>
 <1491215318.2724.3.camel@redhat.com>
 <20170403143257.GA30811@bombadil.infradead.org>
 <1491241657.2673.10.camel@redhat.com>
 <20170403180908.GG37923@jra3>
 <1491243524.2673.15.camel@redhat.com>
 <20170403183648.GH37923@jra3>
Reply-To: Jeremy Allison <jra@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matthew Wilcox <willy@infradead.org>, NeilBrown <neilb@suse.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org, akpm@linux-foundation.org,
        tytso@mit.edu, jack@suse.cz
To: Jeff Layton <jlayton@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170403183648.GH37923@jra3>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Apr 03, 2017 at 11:36:48AM -0700, Jeremy Allison wrote:
> On Mon, Apr 03, 2017 at 02:18:44PM -0400, Jeff Layton wrote:
> > On Mon, 2017-04-03 at 11:09 -0700, Jeremy Allison wrote:
> > > 
> > > CIFS has a way to reserve space. Look into "allocation size" on create.
> > 
> > That won't help here as it's done on open().
> > 
> > The problem here is that we might create a file (and not preallocate
> > anything), then write a bunch of stuff to the cache under an oplock.
> > Then when we go to write back, we get the CIFS equivalent of -ENOSPC.
> > 
> > What local filesystems do (AIUI) is preallocate so that you can catch
> > an ENOSPC condition earlier, when you're dirtying new pages in the
> > cache. That's pretty much impossible to do on a network filesystem
> > though.
> 
> There's also SMB_SET_FILE_ALLOCATION_INFO which can be
> done over SMB1/2/3 on an open file handle.

There's *always* a way to do something in SMB1/2/3. :-).
