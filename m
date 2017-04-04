From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC PATCH 0/4] fs: introduce new writeback error tracking
 infrastructure and convert ext4 to use it
Date: Tue, 4 Apr 2017 09:38:58 -0400
Message-ID: <20170404133858.atchhbnyysn3ftgl@thunk.org>
References: <20170331192603.16442-1-jlayton@redhat.com>
 <87fuhqkti0.fsf@notabene.neil.brown.name>
 <1491215318.2724.3.camel@redhat.com>
 <20170403143257.GA30811@bombadil.infradead.org>
 <1491241657.2673.10.camel@redhat.com>
 <20170403191602.GF30811@bombadil.infradead.org>
 <1491250577.2673.20.camel@redhat.com>
 <87h924kh6t.fsf@notabene.neil.brown.name>
 <20170404115358.GH30811@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: NeilBrown <neilb@suse.com>, Jeff Layton <jlayton@redhat.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org, akpm@linux-foundation.org, jack@suse.cz
To: Matthew Wilcox <willy@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170404115358.GH30811@bombadil.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Apr 04, 2017 at 04:53:58AM -0700, Matthew Wilcox wrote:
> I'd like us to focus on our POSIX compliance here and not return
> arbitrary errors.  The relevant pages are here:
> 
> http://pubs.opengroup.org/onlinepubs/9699919799/functions/fsync.html
> http://pubs.opengroup.org/onlinepubs/9699919799/functions/write.html
> http://pubs.opengroup.org/onlinepubs/9699919799/functions/close.html
> 
> For close(), we have to map every error to EIO.

I don't believe that's true.  POSIX explicitly states that
implementations may return additional errors, and define additional
errors, in addition to the ones that are listeds in the specification.

The specification is pretty clear about saying when a particular
system call "shall" fail (meaning it must fail if it was so listed),
and when it "may" fail.  But no where does it say that these are the
only situations when a system call is allowed to fail.

Which is good, because ext4 and xfs will both return EUCLEAN if the
file system is corrupted.  (Mainly because it's too painful to define
a new errno, EFSCORRUPTED --- not because of trying to get it into
Posix, but because it's painful to get new errno's defined in glibc.)
POSIX says *nothing* about file systems being corrupted, and if your
interpretation were correct, we're already in violation of POSIX....

	       	    	     	   	      - Ted
					      
