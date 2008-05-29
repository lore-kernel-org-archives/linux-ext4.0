From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 0/4] (RESEND) ext3[34] barrier changes
Date: Thu, 29 May 2008 08:36:17 -0500
Message-ID: <483EB151.0@sandeen.net>
References: <482DDA56.6000301@redhat.com> <20080516130545.845a3be9.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, jamie@shareable.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20080516130545.845a3be9.akpm@linux-foundation.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andrew Morton wrote:
> On Fri, 16 May 2008 14:02:46 -0500
> Eric Sandeen <sandeen@redhat.com> wrote:
> 
>> A collection of patches to make ext3 & 4 use barriers by
>> default, and to call blkdev_issue_flush on fsync if they
>> are enabled.
> 
> Last time this came up lots of workloads slowed down by 30% so I
> dropped the patches in horror.
> 
> I just don't think we can quietly go and slow everyone's machines down
> by this much.  The overhead of journalling is already pretty horrid.
> 
> If we were seeing a significant number of "hey, my disk got wrecked"
> reports which attributable to this then yes, perhaps we should change
> the default.  But I've never seen _any_, although I've seen claims that
> others have seen reports.

Here's a recent one, just FYI.

http://marc.info/?l=ext3-users&m=121205834608161&w=2

-Eric

