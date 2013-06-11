From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH v4 20/20] ext4: Allow punch hole with bigalloc enabled
Date: Tue, 11 Jun 2013 14:54:56 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1306111436290.14711@localhost.localdomain>
References: <1368549454-8930-1-git-send-email-lczerner@redhat.com> <1368549454-8930-21-git-send-email-lczerner@redhat.com> <20130531151454.GB19561@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, tracek@redhat.com
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130531151454.GB19561@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 31 May 2013, Theodore Ts'o wrote:

> Date: Fri, 31 May 2013 11:14:54 -0400
> From: Theodore Ts'o <tytso@mit.edu>
> To: Lukas Czerner <lczerner@redhat.com>
> Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
>     linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
>     akpm@linux-foundation.org, hughd@google.com
> Subject: Re: [PATCH v4 20/20] ext4: Allow punch hole with bigalloc enabled
> 
> On Tue, May 14, 2013 at 06:37:34PM +0200, Lukas Czerner wrote:
> > In commits 5f95d21fb6f2aaa52830e5b7fb405f6c71d3ab85 and
> > 30bc2ec9598a1b156ad75217f2e7d4560efdeeab we've reworked punch_hole
> > implementation and there is noting holding us back from using punch hole
> > on file system with bigalloc feature enabled.
> > 
> > This has been tested with fsx and xfstests.
> > 
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > Reviewed-by: Jan Kara <jack@suse.cz>
> 
> This patch is causing a test failure with bigalloc enabled with the
> xfstests shared/298.
> 
> Since it's at the end of the invalidate page range tests, I'm going to
> drop this patch for now.  Could you take a look at this?
> 
> Thanks!!
> 
> 					- Ted

Hi Ted,

I should have really noticed this earlier. This test (shared/298)
have nothing to do with bigalloc, nor punch hole. It tests file
system discard implementation.

The most likely reason it failed for you is that the tests does not
count with bigalloc feature. However it seems to be working for me
without any problems. Can you provide more information about the
problem you've seen, or at least your xfstest configuration so we
can see what went wrong and possibly fix the test ?

Tom can you take a look at this ? (Adding Tomas Racek to the CC)

So, since this failure is not really related to the patch itself,
can we re-include the patch (it might be already too late I guess).

Thanks!
-Lukas
