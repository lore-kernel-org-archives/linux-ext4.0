From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [RFC][PATCH 0/3] add FALLOC_FL_NO_HIDE_STALE flag in fallocate
Date: Wed, 18 Apr 2012 14:07:09 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1204181402550.5310@dhcp-27-109.brq.redhat.com>
References: <1334681618-9452-1-git-send-email-wenqing.lz@taobao.com> <4F8DAAFE.40500@redhat.com> <20120418040842.GA11684@gmail.com> <alpine.LFD.2.00.1204180919500.5310@dhcp-27-109.brq.redhat.com> <20120418120307.GB3447@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>,
	Eric Sandeen <sandeen@redhat.com>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120418120307.GB3447@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 18 Apr 2012, Zheng Liu wrote:

--snip--

> > > 
> > > I will run more detailed benchmarks to trace this issue.  If I have a
> > > lastest result, I will send a new mail to let you know. :)
> > 
> > Yes, please do. I do not think that in this case simply doing 'time
> > dd' is enough. We need to know what is happening inside the kernel to see
> > what is causing the slowdown. It may very well be that we might be able
> > to fix it, rather than introduce crazy security hole to bypass the
> > problem.
> 
> Sorry, maybe my expression is not clear.  Now we have two problems that
> need to be discussed in this thread.  One is my patch set about adding a
> new fallocate flag, and another is that the result of preallocated case
> with conversion is too slower than the result of the case without
> conversion.
> 
> For new flag, last year we have encountered this problem in our product
> system.  We decide to add this flag to avoid the overhead because our
> application can guarantee to initialize the file before it read data
> from this file.  As I said before, last month on ext4 workshop, we
> discussed this problem and Ted said that the Google has the same problem
> too.  So we think that maybe this flag is useful for other users.  That
> is reason why I send this patch set to mailing list. 
> 
> For benchmark result, that is a simple test.  When I send this patch set
> to mailing list, I think that I need to get some data to compare the
> performance of w/ and w/o this new flag.  I am astonished by the result.
> So, as I said above, the target of my patch set is not to solve this issue.
> 
> I have run a more detailed benchmark and I will post it to mailing list.
> Please review it after I send it.  Any comments are welcomed.

Ok I do understand this, but as other people in the thread already told
you, this is not a proper fix. If you have a performance problem when the
conversion from uninitialized to initialized happens, than the obvious
answer is figure out why and fix it, rather than create crazy workaround
without even properly testing why this is happening.

Regards,
-Lukas

> 
> Regards,
> Zheng

--snip--
