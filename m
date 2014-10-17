From: Dave Jones <davej@redhat.com>
Subject: Re: kernel BUG at fs/ext4/inode.c:2982!
Date: Fri, 17 Oct 2014 13:27:37 -0400
Message-ID: <20141017172737.GA2083@redhat.com>
References: <20141016055718.GA17655@redhat.com>
 <871tq8pdh4.fsf@openvz.org>
 <20141016143346.GA9910@redhat.com>
 <20141016201504.GA24798@redhat.com>
 <87egu7k6ym.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonlist@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87egu7k6ym.fsf@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Oct 17, 2014 at 02:03:45AM +0400, Dmitry Monakhov wrote:
 > Dave Jones <davej@redhat.com> writes:
 > 
 > > On Thu, Oct 16, 2014 at 10:33:46AM -0400, Dave Jones wrote:
 > >
 > >  >  > Try this patch http://www.spinics.net/lists/linux-ext4/msg45683.html
 > >  > 
 > >  > I'll give it a try if I can get it reproducing easily, otherwise I cna't say
 > >  > either way whether the patch is doing any good.
 > >
 > > ok, I managed to reproduce it a few times, and then tried again with
 > > your patch.  I'm not sure if it's related, but I'm now seeing lockups
 > > in ext4.  The process that gets stuck looks like this..
 >
 > 99.99% this one is not related. This is just one more uncovered one
 > by trinity magics. Looks like I've got what is wrong
 > lseek SEEK_HOLE/SEEK_DATA try to find block allocated one by one
 > instead of using ext4_ext_next_allocated_block() COMMIT c8c0df24
 > Plese look an my test below. I'm too tired for today (especially
 > after Gone girl the movie). I'll send patch tomorrow.

So the good news is that I'm only seeing this 2nd bug now, so it appears
your patch referenced above does fix it, so it is a good band-aid until
a more generic solution is found.

thanks,

	Dave
