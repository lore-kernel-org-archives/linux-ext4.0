From: Jamie Lokier <jamie@shareable.org>
Subject: Re: Mentor for a GSoC application wanted (Online ext2/3 filesystem checker)
Date: Mon, 21 Apr 2008 00:42:42 +0100
Message-ID: <20080420234241.GB23292@shareable.org>
References: <f19298770804180720w2e72b821j95b709c1dd1b1c25@mail.gmail.com> <20080419012952.GE25797@mit.edu> <f19298770804190244y5d6a8502p39f98d1c420135a@mail.gmail.com> <20080419185603.GA30449@mit.edu> <480A42F6.2030005@redhat.com> <20080419220432.GB30449@mit.edu> <87iqyc85q7.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
	Alexey Zaytsev <alexey.zaytsev@gmail.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Rik van Riel <riel@surriel.com>
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87iqyc85q7.fsf@basil.nowhere.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andi Kleen wrote:
> [LVM] always disables barriers if you don't apply a so far unmerged
> patch that enables them in some special circumstances (only single
> backing device)

(I continue to be surprised at the un-safety of Linux fsync)

> Not having barriers sometimes makes your workloads faster (and less
> safe) and in other cases slower.

I'm curious, how does it make them slower?  Merely not issuing barrier
calls seems like it will always be the same speed or faster.

Thanks,
-- Jamie
