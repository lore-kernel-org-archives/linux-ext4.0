From: Jeff Layton <jlayton@redhat.com>
Subject: Re: [RFC PATCH 0/4] fs: introduce new writeback error tracking
 infrastructure and convert ext4 to use it
Date: Tue, 04 Apr 2017 12:25:46 -0400
Message-ID: <1491323146.309.1.camel@redhat.com>
References: <20170331192603.16442-1-jlayton@redhat.com>
         <87fuhqkti0.fsf@notabene.neil.brown.name>
         <1491215318.2724.3.camel@redhat.com>
         <20170403143257.GA30811@bombadil.infradead.org>
         <1491241657.2673.10.camel@redhat.com>
         <20170403191602.GF30811@bombadil.infradead.org>
         <1491250577.2673.20.camel@redhat.com>
         <87h924kh6t.fsf@notabene.neil.brown.name>
         <20170404115358.GH30811@bombadil.infradead.org>
         <1491308268.20445.4.camel@redhat.com>
         <20170404161247.GJ30811@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: NeilBrown <neilb@suse.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        akpm@linux-foundation.org, tytso@mit.edu, jack@suse.cz
To: Matthew Wilcox <willy@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170404161247.GJ30811@bombadil.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 2017-04-04 at 09:12 -0700, Matthew Wilcox wrote:
> On Tue, Apr 04, 2017 at 08:17:48AM -0400, Jeff Layton wrote:
> > Agreed that we should focus on POSIX compliance. I'll also note that
> > POSIX states:
> > 
> > "If more than one error occurs in processing a function call, any one
> > of the possible errors may be returned, as the order of
> > detection is undefined."
> > 
> >     http://pubs.opengroup.org/onlinepubs/9699919799/functions/V2_chap02.html#tag_15_03
> > 
> > So, I'd like to push back on this idea that we need to prefer reporting
> > -EIO over other errors. POSIX certainly doesn't mandate that. 
> 
> I honestly wonder if we need to support ENOSPC from writeback at all.
> Looking at our history, the AS_EIO / AS_ENOSPC came from this patch
> in 2003:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/tglx/history.git/commit/?id=fcad2b42fc2e15a94ba1a1ba8535681a735bfd16
> 
> That seems to come from here:
> http://lkml.iu.edu/hypermail/linux/kernel/0308.0/0205.html
> which is marked as a resend, but I can't find the original.
> 
> It's a little misleading because the immediately preceding patch
> introduced mapping->error, so there's no precedent here to speak of.
> It looks like we used to just silently lose writeback errors (*cough*).
> 
> I'd like to suggest that maybe we don't need to support multiple errors
> at all.  That all errors, including ENOSPC, get collapsed into EIO.
> POSIX already tells us to do that for close() and permits us to do that
> for fsync().
> 

That is certainly allowed under POSIX as I interpret the spec. At a
minimum we just need a single flag and can collapse all errors under
that.

That said, I think giving more specific errors where we can is useful.
When your program is erroring out and writing 'I/O error' to the logs,
then how much time will your admins burn before they figure out that it
really failed because the filesystem was full?
-- 
Jeff Layton <jlayton@redhat.com>
