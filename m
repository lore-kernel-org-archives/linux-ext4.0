From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] improve jbd fsync batching
Date: Tue, 28 Oct 2008 14:44:01 -0700
Message-ID: <20081028144401.07b7546d@infradead.org>
References: <20081028201614.GA21600@unused.rdu.redhat.com>
	<20081028213805.GC3184@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Josef Bacik <jbacik@redhat.com>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	rwheeler@redhat.com
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20081028213805.GC3184@webber.adilger.int>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 28 Oct 2008 15:38:05 -0600
Andreas Dilger <adilger@sun.com> wrote:

> On Oct 28, 2008  16:16 -0400, Josef Bacik wrote:
> > I also have a min() check in there to make sure we don't sleep
> > longer than a jiffie in case our storage is super slow, this was
> > requested by Andrew.
> 
> Is there a particular reason why 1 jiffie is considered the "right
> amount" of time to sleep, given this is a kernel config parameter and
> has nothing to do with the storage?  Considering a seek time in the
> range of ~10ms this would only be right for HZ=100 and the wait would

well... my disk does a 50 usec seek time or so.. so I don't mind ;-)

in fact it sounds awefully long to me.

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
