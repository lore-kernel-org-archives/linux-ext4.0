From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/4] (RESEND) ext3[34] barrier changes
Date: Fri, 16 May 2008 13:58:14 -0700
Message-ID: <20080516135814.1c973bd5.akpm@linux-foundation.org>
References: <482DDA56.6000301@redhat.com>
	<20080516130545.845a3be9.akpm@linux-foundation.org>
	<482DF44B.50204@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, jamie@shareable.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <482DF44B.50204@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 16 May 2008 15:53:31 -0500
Eric Sandeen <sandeen@redhat.com> wrote:

> Andrew Morton wrote:
> > On Fri, 16 May 2008 14:02:46 -0500
> > Eric Sandeen <sandeen@redhat.com> wrote:
> > 
> >> A collection of patches to make ext3 & 4 use barriers by
> >> default, and to call blkdev_issue_flush on fsync if they
> >> are enabled.
> > 
> > Last time this came up lots of workloads slowed down by 30% so I
> > dropped the patches in horror.
> 
> I actually did a bit of research and found the old thread, honestly.  I
> thought this might not be a shoo-in.  :)  Seems worth hashing out, though.
> 
> > I just don't think we can quietly go and slow everyone's machines down
> > by this much.  The overhead of journalling is already pretty horrid.
> 
> But if journali[zi]ng guarantees are thrown out the window by volatile
> caches on disk, why bother with the half-solution?  Slower while you
> run, worthless when you lose power?  Sounds like the worst of both
> worlds.  (well, ok, experience shows that it's not worthless in practice...)
> 
> > If we were seeing a significant number of "hey, my disk got wrecked"
> > reports which attributable to this then yes, perhaps we should change
> > the default.  But I've never seen _any_, although I've seen claims that
> > others have seen reports.
> 
> Hm, how would we know, really?  What does it look like?  It'd totally
> depend on what got lost...  When do you find out?  Again depends what
> you're doing, I think.  I'll admit that I don't have any good evidence
> of my own.  I'll go off and do some plug-pull-testing and a benchmark or
> two.
> 
> But, drive caches are only getting bigger, I assume this can't help.  I
> have a hard time seeing how speed at the cost of correctness is the
> right call...

Yeah, it's all so handwavy.  The only thing which isn't handwavy is
that performance hit.

> > There are no happy solutions here, and I'm inclined to let this dog
> > remain asleep and continue to leave it up to distributors to decide
> > what their default should be.
> > 
> > Do we know which distros are enabling barriers by default?
> 
> SuSE does (via patch for ext3).  Red Hat & Fedora don't, and install by
> default on lvm which won't pass barriers anyway.  So maybe it's
> hypocritical to send this patch from redhat.com  :)
> 
> And as another "who uses barriers" datapoint, reiserfs & xfs both have
> them on by default.
> 
> I suppose alternately I could send another patch to remove "remember
> that ext3/4 by default offers higher data integrity guarantees than
> most." from Documentation/filesystems/ext4.txt  ;)

We could add a big scary printk at mount time and provide a document?
